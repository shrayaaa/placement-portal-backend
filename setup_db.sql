USE placement_portal;

CREATE TABLE IF NOT EXISTS job_applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  roll_number VARCHAR(50) NOT NULL,
  job_id INT NOT NULL,
  status ENUM('applied', 'shortlisted', 'rejected', 'selected') DEFAULT 'applied',
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_application (roll_number, job_id)
);

SHOW TABLES;
DESCRIBE job_applications;
