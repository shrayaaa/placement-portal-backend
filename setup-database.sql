-- =============================================
-- Webway Placement Portal - Database Setup
-- =============================================

-- Create database
CREATE DATABASE IF NOT EXISTS placement_portal;
USE placement_portal;

-- =============================================
-- STUDENT MANAGEMENT TABLES
-- =============================================

-- Registered students table
CREATE TABLE IF NOT EXISTS registered_students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Student profiles table
CREATE TABLE IF NOT EXISTS student_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100),
    phone VARCHAR(15),
    department VARCHAR(50),
    cgpa DECIMAL(3,2),
    skills TEXT,
    resume_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (roll_number) REFERENCES registered_students(roll_number) ON DELETE CASCADE
);

-- =============================================
-- JOB MANAGEMENT TABLES
-- =============================================

-- Job drives table
CREATE TABLE IF NOT EXISTS drives (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    job_description TEXT,
    requirements TEXT,
    location VARCHAR(100),
    salary_range VARCHAR(50),
    application_deadline DATE,
    drive_date DATE,
    status ENUM('active', 'inactive', 'completed') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Job applications table
CREATE TABLE IF NOT EXISTS job_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_roll VARCHAR(20) NOT NULL,
    drive_id INT NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('applied', 'shortlisted', 'selected', 'rejected') DEFAULT 'applied',
    notes TEXT,
    FOREIGN KEY (student_roll) REFERENCES registered_students(roll_number) ON DELETE CASCADE,
    FOREIGN KEY (drive_id) REFERENCES drives(id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (student_roll, drive_id)
);

-- =============================================
-- COMMUNICATION TABLES
-- =============================================

-- Contact messages table
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('new', 'read', 'replied') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Announcements table
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    target_audience ENUM('all', 'students', 'admin') DEFAULT 'all',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Student tables indexes
CREATE INDEX IF NOT EXISTS idx_student_roll ON student_profiles(roll_number);
CREATE INDEX IF NOT EXISTS idx_student_email ON registered_students(email);

-- Job tables indexes
CREATE INDEX IF NOT EXISTS idx_drive_status ON drives(status);
CREATE INDEX IF NOT EXISTS idx_drive_deadline ON drives(application_deadline);
CREATE INDEX IF NOT EXISTS idx_application_status ON job_applications(status);
CREATE INDEX IF NOT EXISTS idx_application_student ON job_applications(student_roll);
CREATE INDEX IF NOT EXISTS idx_application_drive ON job_applications(drive_id);

-- Message tables indexes
CREATE INDEX IF NOT EXISTS idx_message_status ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_message_created ON contact_messages(created_at);
CREATE INDEX IF NOT EXISTS idx_announcement_active ON announcements(is_active);
CREATE INDEX IF NOT EXISTS idx_announcement_audience ON announcements(target_audience);

-- =============================================
-- SAMPLE DATA (Optional - for testing)
-- =============================================

-- Insert sample admin user (password: admin123)
INSERT IGNORE INTO registered_students (name, email, roll_number, password) VALUES
('Admin User', 'admin@webway.com', 'ADMIN001', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Insert sample student (password: student123)
INSERT IGNORE INTO registered_students (name, email, roll_number, password) VALUES
('John Doe', 'john.doe@student.com', 'STU001', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Insert sample job drive
INSERT IGNORE INTO drives (company_name, job_title, job_description, requirements, location, salary_range, application_deadline, drive_date) VALUES
('Tech Corp', 'Software Engineer', 'We are looking for a talented software engineer to join our team.', 'B.Tech in Computer Science, 7+ CGPA', 'Mumbai', '6-10 LPA', DATE_ADD(CURDATE(), INTERVAL 30 DAY), DATE_ADD(CURDATE(), INTERVAL 35 DAY));

-- Insert sample announcement
INSERT IGNORE INTO announcements (title, content, priority, target_audience) VALUES
('Welcome to Webway Placement Portal', 'Welcome to our placement portal! Please complete your profile and start applying for jobs.', 'high', 'all');

-- =============================================
-- USER PERMISSIONS (Production Setup)
-- =============================================

-- Create application user (replace with your credentials)
-- CREATE USER IF NOT EXISTS 'webway_user'@'localhost' IDENTIFIED BY 'your_secure_password';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON placement_portal.* TO 'webway_user'@'localhost';
-- FLUSH PRIVILEGES;

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- Verify tables were created
SHOW TABLES;

-- Check table structures
DESCRIBE registered_students;
DESCRIBE student_profiles;
DESCRIBE drives;
DESCRIBE job_applications;
DESCRIBE contact_messages;
DESCRIBE announcements;

-- Check indexes
SHOW INDEX FROM student_profiles;
SHOW INDEX FROM job_applications;
SHOW INDEX FROM contact_messages;

-- =============================================
-- MAINTENANCE QUERIES
-- =============================================

-- Check database size
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'placement_portal'
GROUP BY table_schema;

-- Check table sizes
SELECT 
    table_name AS 'Table',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'placement_portal'
ORDER BY (data_length + index_length) DESC;

-- =============================================
-- BACKUP COMMANDS (Run these separately)
-- =============================================

-- Full database backup
-- mysqldump -u root -p placement_portal > backup_$(date +%Y%m%d_%H%M%S).sql

-- Structure only backup
-- mysqldump -u root -p --no-data placement_portal > structure_backup.sql

-- Data only backup
-- mysqldump -u root -p --no-create-info placement_portal > data_backup.sql



