require("dotenv").config();
const fs = require("fs");

const express = require("express");
const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(bodyParser.json());


const multer = require("multer");
const path = require("path");


const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, "uploads")); // Ensure uploads folder exists
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + "-" + file.originalname;
    cb(null, uniqueName);
  },
});

const upload = multer({ storage });
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Serve static HTML files
app.use(express.static(__dirname));
// ==================== MySQL CONNECTION ====================
const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
  ssl: {
    ca: fs.readFileSync("./ca.pem")
  }
});



// Test DB connection
(async () => {
  try {
    const conn = await db.getConnection();
    console.log("MySQL Connected...");
    conn.release();
  } catch (err) {
    console.error("MySQL Connection Failed:", err.message);
  }
})();

// ==================== DATABASE TABLES SETUP ====================
// Create drives table
(async () => {
  try {
    await db.execute(`
      CREATE TABLE IF NOT EXISTS drives (
        id INT AUTO_INCREMENT PRIMARY KEY,
        company_name VARCHAR(255) NOT NULL,
        drive_date DATE NOT NULL,
        drive_time TIME,
        venue VARCHAR(255),
        description TEXT,
        eligibility_criteria TEXT,
        registration_deadline DATE,
        contact_info VARCHAR(255),
        result_pdf VARCHAR(500),
        announcement TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      )
    `);
    console.log("Drives table ready");
  } catch (err) {
    console.error("Error creating drives table:", err.message);
  }
})();

// Create contact_messages table
(async () => {
  try {
    await db.execute(`
      CREATE TABLE IF NOT EXISTS contact_messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        subject VARCHAR(500) NOT NULL,
        message TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status ENUM('new', 'read', 'replied') DEFAULT 'new'
      )
    `);
    console.log("Contact messages table ready");
  } catch (err) {
    console.error("Error creating contact_messages table:", err.message);
  }
})();

// ==================== ROOT TEST ====================
app.get("/", (req, res) => {
  res.send("API is working 🚀");
});

/* ===========================
   CONTACT FORM SUBMISSION
   =========================== */
app.post("/api/contact", async (req, res) => {
  const { name, email, subject, message } = req.body;

  if (!name || !email || !subject || !message) {
    return res.status(400).json({ message: "All fields are required" });
  }

  // Basic email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ message: "Please enter a valid email address" });
  }

  try {
    await db.execute(
      "INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)",
      [name, email, subject, message]
    );

    res.status(201).json({ message: "Message sent successfully! We will get back to you soon." });
  } catch (err) {
    console.error("Contact form error:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   GET CONTACT MESSAGES (Admin)
   =========================== */
app.get("/api/admin/contact-messages", async (req, res) => {
  try {
    const { status } = req.query;
    let query = "SELECT * FROM contact_messages";
    let params = [];
    
    if (status) {
      query += " WHERE status = ?";
      params.push(status);
    }
    
    query += " ORDER BY created_at DESC";
    
    const [messages] = await db.execute(query, params);
    res.json(messages);
  } catch (err) {
    console.error("Error fetching contact messages:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   UPDATE MESSAGE STATUS (Admin)
   =========================== */
app.put("/api/admin/contact-messages/:id/status", async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  const validStatuses = ['new', 'read', 'replied'];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  try {
    const result = await db.execute(
      "UPDATE contact_messages SET status = ? WHERE id = ?",
      [status, id]
    );

    if (result[0].affectedRows === 0) {
      return res.status(404).json({ message: "Message not found" });
    }

    res.json({ message: "Message status updated" });
  } catch (err) {
    console.error("Error updating message status:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   DELETE CONTACT MESSAGE (Admin)
   =========================== */
app.delete("/api/admin/contact-messages/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const result = await db.execute(
      "DELETE FROM contact_messages WHERE id = ?",
      [id]
    );

    if (result[0].affectedRows === 0) {
      return res.status(404).json({ message: "Message not found" });
    }

    res.json({ message: "Message deleted successfully" });
  } catch (err) {
    console.error("Error deleting message:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   STUDENT SIGNUP
   =========================== */
app.post("/api/signup", async (req, res) => {
  const { name, email, rollNumber, password } = req.body;

  if (!name || !email || !rollNumber || !password) {
    return res.status(400).json({ message: "Email, roll number, and password are required" });
  }

  try {
    // Step 1: Check if email & rollNumber exist in registered_students
    const [registered] = await db.execute(
      "SELECT * FROM registered_students WHERE email = ? AND roll_number = ?",
      [email, rollNumber]
    );

    if (registered.length === 0) {
      return res
        .status(400)
        .json({ message: "Email and Roll Number do not match our college records" });
    }

    // Step 2: Check if student already has an account
    const [existing] = await db.execute(
      "SELECT * FROM student_accounts WHERE email = ?",
      [email]
    );

    if (existing.length > 0) {
      return res
        .status(400)
        .json({ message: "Account already exists for this email" });
    }

    // Step 3: Hash password and create account
    const hashedPassword = await bcrypt.hash(password, 10);

   await db.execute(
  "INSERT INTO student_accounts (name, email, roll_number, password_hash) VALUES (?, ?, ?, ?)",
  [name, email, rollNumber, hashedPassword]
);


    res.status(201).json({ message: "Account created successfully", email: email, roll_number: rollNumber });
  } catch (err) {
    console.error("Signup error:", err);
    res.status(500).json({ message: "Server error" });
  }
});


/* ===========================
   STUDENT LOGIN
   =========================== */
app.post("/api/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }

  try {
    const [results] = await db.execute(
      "SELECT * FROM student_accounts WHERE email = ?",
      [email]
    );

    if (results.length === 0) {
      return res.status(400).json({
        message: "Account does not exist. Please sign up first.",
      });
    }

    const user = results[0];
    const isMatch = await bcrypt.compare(password, user.password_hash);

    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    res.status(200).json({ message: "Login successful", email: user.email, roll_number: user.roll_number });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   ADMIN SIGNUP
   =========================== */
app.post("/api/admin/signup", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }

  try {
    // Step 1: Check if email is in registered admin emails
    const [registered] = await db.execute(
      "SELECT * FROM admin_emails WHERE email = ?",
      [email]
    );

    if (registered.length === 0) {
      return res.status(400).json({ message: "Email not registered as admin" });
    }

    // Step 2: Check if account already exists
    const [existing] = await db.execute(
      "SELECT * FROM admins WHERE email = ?",
      [email]
    );

    if (existing.length > 0) {
      return res.status(400).json({ message: "Account already exists" });
    }

    // Step 3: Hash password and insert
    const hashedPassword = await bcrypt.hash(password, 10);
    await db.execute("INSERT INTO admins (email, password) VALUES (?, ?)", [
      email,
      hashedPassword,
    ]);

    res.status(201).json({ message: "Admin registered successfully" });
  } catch (err) {
    console.error("Admin signup error:", err);
    res.status(500).json({ error: err.message });
  }
});

/* ===========================
   ADMIN LOGIN
   =========================== */
app.post("/api/admin/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }

  try {
    const [rows] = await db.execute(
      "SELECT * FROM admins WHERE email = ?",
      [email]
    );

    if (!rows || rows.length === 0) {
    return res.status(400).json({ message: "Account does not exist. Please sign up first." });
}

    const admin = rows[0];
    const isMatch = await bcrypt.compare(password, admin.password);

    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    res.json({ message: "Admin login successful" });
  } catch (err) {
    console.error("Admin login error:", err);
    res.status(500).json({ error: err.message });
  }
});

// ================== Student Profile APIs ==================

// This handler was removed - using the more comprehensive one below

// This handler was removed - using the more comprehensive one below





// Get combined profile: registered_students + student_profiles
app.get('/api/student/:roll_number', async (req, res) => {
  const { roll_number } = req.params;
  try {
    // basic student info from registered_students
    const [reg] = await db.execute(
      'SELECT name, email, roll_number FROM registered_students WHERE roll_number = ?',
      [roll_number]
    );
    if (reg.length === 0) {
      return res.status(404).json({ message: 'Student not found in registered list' });
    }
    const basic = reg[0];

    // profile details (may be empty)
    const [prof] = await db.execute(
      'SELECT name, phone, department, cgpa, skills, resume_url FROM student_profiles WHERE roll_number = ?',
      [roll_number]
    );

    const profile = prof.length ? prof[0] : { name: null, phone: null, department: null, cgpa: null, skills: null, resume_url: null };

    const response = { ...basic, ...profile };
    console.log('Profile GET response:', response); // Debug log
    res.json(response);
  } catch (err) {
    console.error('Profile GET error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Create / Update profile (upsert)
app.put('/api/student/:roll_number', async (req, res) => {
  const { roll_number } = req.params;
  const { name, phone, department, cgpa, skills, resume_url } = req.body;

  console.log('Profile PUT request:', { roll_number, body: req.body }); // Debug log

  try {
    // optional: ensure the student exists in registered_students
    const [reg] = await db.execute('SELECT roll_number FROM registered_students WHERE roll_number = ?', [roll_number]);
    if (reg.length === 0) {
      console.log('Student not found in registered_students:', roll_number);
      return res.status(400).json({ message: 'Student not registered' });
    }

    console.log('Student found in registered_students, updating profile...');
    
    await db.execute(
      `INSERT INTO student_profiles (roll_number, name, phone, department, cgpa, skills, resume_url)
       VALUES (?, ?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
         name = VALUES(name),
         phone = VALUES(phone),
         department = VALUES(department),
         cgpa = VALUES(cgpa),
         skills = VALUES(skills),
         resume_url = COALESCE(VALUES(resume_url), resume_url)`,
      [roll_number, name || null, phone || null, department || null, cgpa || null, skills || null, resume_url || null]
    );

    console.log('Profile updated successfully for roll:', roll_number);
    res.json({ message: 'Profile updated successfully' });
  } catch (err) {
    console.error('Profile PUT error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Resume upload
app.post('/api/student/:roll_number/resume', upload.single('resume'), async (req, res) => {
  const { roll_number } = req.params;
  if (!req.file) return res.status(400).json({ message: 'No file uploaded' });

  try {
    const resumeUrl = `http://placement-portal-ccoewn.onrender.com/uploads/${req.file.filename}`; // absolute URL
    // Upsert resume_url
    await db.execute(
      `INSERT INTO student_profiles (roll_number, resume_url)
       VALUES (?, ?)
       ON DUPLICATE KEY UPDATE resume_url = VALUES(resume_url)`,
      [roll_number, resumeUrl]
    );
    res.json({ message: 'Resume uploaded', resume_url: resumeUrl });
  } catch (err) {
    console.error('Resume upload error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});


/* ===========================
   GET ALL JOBS
   =========================== */
   app.get("/api/jobs", async (req, res) => {
    try {
      const [jobs] = await db.execute("SELECT * FROM job_listings ORDER BY created_at DESC");
      res.status(200).json(jobs);
    } catch (err) {
      console.error("Error fetching jobs:", err);
      res.status(500).json({ message: "Server error" });
    }
  });
  
  

 /* ===========================
   ADMIN POST JOB
   =========================== */
app.post("/api/admin/jobs", async (req, res) => {
  const { title, company, location, salary, description, posted_by, eligibility, deadline } = req.body;

  console.log("Received job data:", req.body); // Debug log
  console.log("Eligibility:", eligibility, "Deadline:", deadline); // Debug log

  if (!title || !company || !description) {
    return res.status(400).json({ message: "Title, company, and description are required" });
  }

  try {
    const result = await db.execute(
      "INSERT INTO job_listings (company_name, role, ctc, eligibility, deadline, description) VALUES (?, ?, ?, ?, ?, ?)",
      [company, title, salary, eligibility, deadline, description]
    );

    console.log("Job inserted successfully with ID:", result[0].insertId); // Debug log
    res.status(201).json({ message: "Job posted successfully" });
  } catch (err) {
    console.error("Job posting error:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   DELETE JOB
   =========================== */
app.delete("/api/admin/jobs/:id", async (req, res) => {
  console.log("DELETE route hit!"); // Debug log
  const { id } = req.params;
  
  console.log("DELETE request received for job ID:", id); // Debug log
  console.log("Request params:", req.params); // Debug log

  if (!id) {
    console.log("No job ID provided"); // Debug log
    return res.status(400).json({ message: "Job ID is required" });
  }

  try {
    console.log("Executing DELETE query for job ID:", id); // Debug log
    const result = await db.execute("DELETE FROM job_listings WHERE id = ?", [id]);
    
    console.log("Delete query result:", result[0]); // Debug log
    
    if (result[0].affectedRows === 0) {
      console.log("No job found with ID:", id); // Debug log
      return res.status(404).json({ message: "Job not found" });
    }

    console.log("Job deleted successfully, ID:", id, "Affected rows:", result[0].affectedRows);
    res.status(200).json({ message: "Job deleted successfully" });
  } catch (err) {
    console.error("Job deletion error:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   APPLY FOR JOB
   =========================== */
app.post("/api/student/:roll_number/apply/:job_id", async (req, res) => {
  const { roll_number, job_id } = req.params;

  console.log("Job application request:", { roll_number, job_id });

  try {
    // Check if student exists and get profile
    const [student] = await db.execute(
      "SELECT * FROM student_profiles WHERE roll_number = ?",
      [roll_number]
    );

    if (student.length === 0) {
      return res.status(404).json({ message: "Student profile not found" });
    }

    // Check if job exists and get eligibility
    const [job] = await db.execute(
      "SELECT * FROM job_listings WHERE id = ?",
      [job_id]
    );

    if (job.length === 0) {
      return res.status(404).json({ message: "Job not found" });
    }

    // Check eligibility
    const studentCgpa = parseFloat(student[0].cgpa) || 0;
    const eligibilityText = job[0].eligibility || '';
    const cgpaMatch = eligibilityText.match(/(\d+(?:\.\d+)?)\s*(?:cgpa|CGPA|gpa|GPA)/i);
    const requiredCgpa = cgpaMatch ? parseFloat(cgpaMatch[1]) : 0;

    if (requiredCgpa > 0 && studentCgpa < requiredCgpa) {
      return res.status(400).json({ 
        message: `Not eligible. Required CGPA: ${requiredCgpa}, Your CGPA: ${studentCgpa}` 
      });
    }

    // Check if already applied and what status
    const [existing] = await db.execute(
      "SELECT id, status FROM job_applications WHERE roll_number = ? AND job_id = ?",
      [roll_number, job_id]
    );

    if (existing.length > 0) {
      const currentStatus = existing[0].status;
      
      // Only allow reapplication if rejected and eligible
      if (currentStatus === 'rejected') {
        // Delete the old rejected application to allow new one
        await db.execute(
          "DELETE FROM job_applications WHERE roll_number = ? AND job_id = ?",
          [roll_number, job_id]
        );
      } else {
        // Don't allow reapplication for applied, shortlisted, or selected
        const statusMessages = {
          'applied': 'Your application is pending review',
          'shortlisted': 'You have been shortlisted for this position',
          'selected': 'You have been selected for this position'
        };
        return res.status(400).json({ 
          message: statusMessages[currentStatus] || "Already applied for this job" 
        });
      }
    }

    // Create application
    await db.execute(
      "INSERT INTO job_applications (roll_number, job_id, status, applied_at) VALUES (?, ?, 'applied', NOW())",
      [roll_number, job_id]
    );

    console.log("Job application created successfully");
    res.status(201).json({ message: "Application submitted successfully" });
  } catch (err) {
    console.error("Job application error:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   GET STUDENT APPLICATIONS
   =========================== */
app.get("/api/student/:roll_number/applications", async (req, res) => {
  const { roll_number } = req.params;

  try {
    const [applications] = await db.execute(
      `SELECT ja.*, jl.company_name, jl.role, jl.ctc, jl.deadline
       FROM job_applications ja
       JOIN job_listings jl ON ja.job_id = jl.id
       WHERE ja.roll_number = ?
       ORDER BY ja.applied_at DESC`,
      [roll_number]
    );

    res.status(200).json(applications);
  } catch (err) {
    console.error("Error fetching applications:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   GET ALL APPLICATIONS (Admin)
   =========================== */
app.get("/api/admin/applications", async (req, res) => {
  try {
    const [applications] = await db.execute(
      `SELECT ja.*, jl.company_name, jl.role, jl.ctc, jl.deadline, sp.name as student_name, sp.department, sp.cgpa
       FROM job_applications ja
       JOIN job_listings jl ON ja.job_id = jl.id
       LEFT JOIN student_profiles sp ON ja.roll_number = sp.roll_number
       ORDER BY ja.status, ja.applied_at DESC`
    );

    res.status(200).json(applications);
  } catch (err) {
    console.error("Error fetching all applications:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   GET APPLICATIONS BY STATUS (Admin)
   =========================== */
app.get("/api/admin/applications/:status", async (req, res) => {
  const { status } = req.params;
  const validStatuses = ['applied', 'shortlisted', 'rejected', 'selected'];
  
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  try {
    const [applications] = await db.execute(
      `SELECT ja.*, jl.company_name, jl.role, jl.ctc, jl.deadline, sp.name as student_name, sp.department, sp.cgpa
       FROM job_applications ja
       JOIN job_listings jl ON ja.job_id = jl.id
       LEFT JOIN student_profiles sp ON ja.roll_number = sp.roll_number
       WHERE ja.status = ?
       ORDER BY ja.applied_at DESC`,
      [status]
    );

    res.status(200).json(applications);
  } catch (err) {
    console.error("Error fetching applications by status:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   UPDATE APPLICATION STATUS (Admin)
   =========================== */
app.put("/api/admin/applications/:id/status", async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  const validStatuses = ['applied', 'shortlisted', 'rejected', 'selected'];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ message: "Invalid status" });
  }

  try {
    // Update the status instead of deleting - keep records for tracking
    const result = await db.execute(
      "UPDATE job_applications SET status = ?, updated_at = NOW() WHERE id = ?",
      [status, id]
    );

    if (result[0].affectedRows === 0) {
      return res.status(404).json({ message: "Application not found" });
    }

    res.status(200).json({ message: "Application status updated" });
  } catch (err) {
    console.error("Error updating application status:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// ===================== START SERVER =====================
// ==================== STUDENT MANAGEMENT API ====================

// Get all students (admin only) - Only from registered_students table
app.get("/api/admin/students", async (req, res) => {
  try {
    const [students] = await db.execute(`
      SELECT name, email, roll_number
      FROM registered_students
      ORDER BY name
    `);
    res.json(students);
  } catch (err) {
    console.error("Error fetching students:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Add student (admin only) - Only to registered_students table
app.post("/api/admin/students", async (req, res) => {
  console.log("POST /api/admin/students called");
  console.log("Request body:", req.body);
  
  const { name, email, roll_number } = req.body;

  if (!name || !email || !roll_number) {
    console.log("Missing required fields");
    return res.status(400).json({ message: "Name, email, and roll number are required" });
  }

  try {
    console.log("Checking for existing student...");
    // Check if student already exists
    const [existing] = await db.execute(
      "SELECT roll_number FROM registered_students WHERE roll_number = ? OR email = ?",
      [roll_number, email]
    );

    if (existing.length > 0) {
      console.log("Student already exists");
      return res.status(400).json({ message: "Student with this roll number or email already exists" });
    }

    console.log("Inserting new student...");
    // Add to registered_students only
    await db.execute(
      "INSERT INTO registered_students (name, email, roll_number) VALUES (?, ?, ?)",
      [name, email, roll_number]
    );

    console.log("Student added successfully");
    res.status(201).json({ message: "Student added successfully" });
  } catch (err) {
    console.error("Error adding student:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Update student - Only registered_students table
app.put("/api/admin/students/:roll_number", async (req, res) => {
  const rollNumber = req.params.roll_number;
  const { name, email, roll_number: newRollNumber } = req.body;

  if (!name || !email || !newRollNumber) {
    return res.status(400).json({ message: "Name, email, and roll number are required" });
  }

  try {
    // Check if new roll number or email already exists (excluding current student)
    const [existing] = await db.execute(
      "SELECT roll_number FROM registered_students WHERE (roll_number = ? OR email = ?) AND roll_number != ?",
      [newRollNumber, email, rollNumber]
    );

    if (existing.length > 0) {
      return res.status(400).json({ message: "Student with this roll number or email already exists" });
    }

    // Update registered_students
    const [result] = await db.execute(
      "UPDATE registered_students SET name = ?, email = ?, roll_number = ? WHERE roll_number = ?",
      [name, email, newRollNumber, rollNumber]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Student not found" });
    }

    res.json({ message: "Student updated successfully" });
  } catch (err) {
    console.error("Error updating student:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Delete student - Only from registered_students table
app.delete("/api/admin/students/:roll_number", async (req, res) => {
  const roll_number = req.params.roll_number;

  try {
    const [result] = await db.execute("DELETE FROM registered_students WHERE roll_number = ?", [roll_number]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Student not found" });
    }
    
    res.json({ message: "Student deleted successfully" });
  } catch (err) {
    console.error("Error deleting student:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// ==================== DRIVES MANAGEMENT ====================

// Get all jobs
app.get("/api/jobs", async (req, res) => {
  try {
    const [rows] = await db.execute("SELECT * FROM jobs ORDER BY created_at DESC");
    res.json(rows);
  } catch (err) {
    console.error("Error fetching jobs:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Delete job (admin only)
app.delete("/api/admin/jobs/:id", async (req, res) => {
  const jobId = req.params.id;
  
  try {
    const [result] = await db.execute("DELETE FROM jobs WHERE id = ?", [jobId]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Job not found" });
    }
    
    res.json({ message: "Job deleted successfully" });
  } catch (err) {
    console.error("Error deleting job:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Get all drives
app.get("/api/drives", async (req, res) => {
  try {
    const [drives] = await db.execute(
      "SELECT * FROM drives ORDER BY drive_date ASC"
    );
    res.json(drives);
  } catch (err) {
    console.error("Error fetching drives:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Add new drive
app.post("/api/admin/drives", upload.single('result_pdf'), async (req, res) => {
  const { 
    company_name, 
    drive_date, 
    drive_time, 
    venue, 
    description, 
    eligibility_criteria, 
    registration_deadline, 
    contact_info,
    announcement 
  } = req.body;

  if (!company_name || !drive_date) {
    return res.status(400).json({ message: "Company name and drive date are required" });
  }

  try {
    const result_pdf = req.file ? `/uploads/${req.file.filename}` : null;
    
    await db.execute(`
      INSERT INTO drives (
        company_name, drive_date, drive_time, venue, description, 
        eligibility_criteria, registration_deadline, contact_info, 
        result_pdf, announcement
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      company_name, drive_date, drive_time, venue, description,
      eligibility_criteria, registration_deadline, contact_info,
      result_pdf, announcement
    ]);

    res.status(201).json({ message: "Drive added successfully" });
  } catch (err) {
    console.error("Error adding drive:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Update drive
app.put("/api/admin/drives/:id", upload.single('result_pdf'), async (req, res) => {
  const { id } = req.params;
  const { 
    company_name, 
    drive_date, 
    drive_time, 
    venue, 
    description, 
    eligibility_criteria, 
    registration_deadline, 
    contact_info,
    announcement 
  } = req.body;

  try {
    let result_pdf = req.body.existing_result_pdf; // Keep existing if no new file
    if (req.file) {
      result_pdf = `/uploads/${req.file.filename}`;
    }

    await db.execute(`
      UPDATE drives SET 
        company_name = ?, drive_date = ?, drive_time = ?, venue = ?, 
        description = ?, eligibility_criteria = ?, registration_deadline = ?, 
        contact_info = ?, result_pdf = ?, announcement = ?
      WHERE id = ?
    `, [
      company_name, drive_date, drive_time, venue, description,
      eligibility_criteria, registration_deadline, contact_info,
      result_pdf, announcement, id
    ]);

    res.json({ message: "Drive updated successfully" });
  } catch (err) {
    console.error("Error updating drive:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// Delete drive
app.delete("/api/admin/drives/:id", async (req, res) => {
  const { id } = req.params;

  try {
    await db.execute("DELETE FROM drives WHERE id = ?", [id]);
    res.json({ message: "Drive deleted successfully" });
  } catch (err) {
    console.error("Error deleting drive:", err);
    res.status(500).json({ message: "Server error" });
  }
});

// ==================== ANNOUNCEMENTS API ====================

// Get all announcements
app.get('/api/admin/announcements', async (req, res) => {
  const query = 'SELECT * FROM announcements ORDER BY created_at DESC';
  
  try {
    const [results] = await db.execute(query);
    res.json(results);
  } catch (err) {
    console.error('Error fetching announcements:', err);
    res.status(500).json({ message: 'Error fetching announcements' });
  }
});

// Create new announcement
app.post('/api/admin/announcements', async (req, res) => {
  const { title, content, priority, expiry_date } = req.body;
  
  if (!title || !content) {
    return res.status(400).json({ message: 'Title and content are required' });
  }
  
  const query = 'INSERT INTO announcements (title, content, priority, expiry_date, created_at) VALUES (?, ?, ?, ?, NOW())';
  
  try {
    const [result] = await db.execute(query, [title, content, priority || 'normal', expiry_date]);
    res.json({ message: 'Announcement created successfully', id: result.insertId });
  } catch (err) {
    console.error('Error creating announcement:', err);
    res.status(500).json({ message: 'Error creating announcement' });
  }
});

// Update announcement
app.put('/api/admin/announcements/:id', async (req, res) => {
  const { id } = req.params;
  const { title, content, priority, expiry_date } = req.body;
  
  if (!title || !content) {
    return res.status(400).json({ message: 'Title and content are required' });
  }
  
  const query = 'UPDATE announcements SET title = ?, content = ?, priority = ?, expiry_date = ? WHERE id = ?';
  
  try {
    const [result] = await db.execute(query, [title, content, priority || 'normal', expiry_date, id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Announcement not found' });
    }
    
    res.json({ message: 'Announcement updated successfully' });
  } catch (err) {
    console.error('Error updating announcement:', err);
    res.status(500).json({ message: 'Error updating announcement' });
  }
});

// Delete announcement
app.delete('/api/admin/announcements/:id', async (req, res) => {
  const { id } = req.params;
  
  const query = 'DELETE FROM announcements WHERE id = ?';
  
  try {
    const [result] = await db.execute(query, [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Announcement not found' });
    }
    
    res.json({ message: 'Announcement deleted successfully' });
  } catch (err) {
    console.error('Error deleting announcement:', err);
    res.status(500).json({ message: 'Error deleting announcement' });
  }
});

// Get announcements for students (public endpoint)
app.get('/api/announcements', async (req, res) => {
  const query = 'SELECT * FROM announcements WHERE expiry_date IS NULL OR expiry_date >= CURDATE() ORDER BY priority DESC, created_at DESC';
  
  try {
    const [results] = await db.execute(query);
    res.json(results);
  } catch (err) {
    console.error('Error fetching announcements for students:', err);
    res.status(500).json({ message: 'Error fetching announcements' });
  }
});

// ==================== REPORTS API ====================

// Student statistics report
app.get('/api/admin/reports/students', async (req, res) => {
  try {
    const [totalStudents] = await db.execute('SELECT COUNT(*) as count FROM registered_students');
    const [activeStudents] = await db.execute('SELECT COUNT(*) as count FROM registered_students WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)');
    const [avgCGPA] = await db.execute('SELECT AVG(CAST(cgpa AS DECIMAL(3,2))) as avg_cgpa FROM student_profiles WHERE cgpa IS NOT NULL AND cgpa != ""');
    const [recentStudents] = await db.execute('SELECT name, email, roll_number FROM registered_students ORDER BY created_at DESC LIMIT 10');
    
    const results = {
      totalStudents: totalStudents[0].count,
      activeStudents: activeStudents[0].count,
      averageCGPA: avgCGPA[0].avg_cgpa ? parseFloat(avgCGPA[0].avg_cgpa).toFixed(2) : 'N/A',
      recentStudents: recentStudents
    };
    
    res.json(results);
  } catch (err) {
    console.error('Error in student statistics query:', err);
    res.status(500).json({ message: 'Error fetching student statistics' });
  }
});

// Applications statistics report
app.get('/api/admin/reports/applications', async (req, res) => {
  try {
    const [totalApplications] = await db.execute('SELECT COUNT(*) as count FROM job_applications');
    const [successfulApplications] = await db.execute('SELECT COUNT(*) as count FROM job_applications WHERE status = "selected"');
    const [pendingApplications] = await db.execute('SELECT COUNT(*) as count FROM job_applications WHERE status = "applied"');
    
    const results = {
      totalApplications: totalApplications[0].count,
      successfulApplications: successfulApplications[0].count,
      pendingApplications: pendingApplications[0].count
    };
    
    res.json(results);
  } catch (err) {
    console.error('Error in applications statistics query:', err);
    res.status(500).json({ message: 'Error fetching applications statistics' });
  }
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
