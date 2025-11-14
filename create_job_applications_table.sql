-- Create job_applications table for the placement portal
USE placement_portal;

CREATE TABLE IF NOT EXISTS job_applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  roll_number VARCHAR(50) NOT NULL,
  job_id INT NOT NULL,
  status ENUM('applied', 'shortlisted', 'rejected', 'selected') DEFAULT 'applied',
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (job_id) REFERENCES job_listings(id) ON DELETE CASCADE,
  UNIQUE KEY unique_application (roll_number, job_id)
);

-- Show tables to confirm creation
SHOW TABLES;

-- Show the structure of the new table
DESCRIBE job_applications;
