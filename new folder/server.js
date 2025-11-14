const express = require("express");
const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ==================== MySQL CONNECTION ====================
const db = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "", // change to your actual password
  database: "placement_portal",
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

// ==================== ROOT TEST ====================
app.get("/", (req, res) => {
  res.send("API is working 🚀");
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


    res.status(201).json({ message: "Account created successfully" });
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

    res.status(200).json({ message: "Login successful", email: user.email });
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

// ===================== START SERVER =====================
app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});
