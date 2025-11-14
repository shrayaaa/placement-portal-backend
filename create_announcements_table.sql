-- Create announcements table for admin portal
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    priority ENUM('normal', 'high', 'urgent') DEFAULT 'normal',
    expiry_date DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample announcements for testing
INSERT INTO announcements (title, content, priority, expiry_date) VALUES
('Welcome to Placement Portal', 'All students are requested to update their profiles and upload resumes for the upcoming placement season.', 'high', '2025-12-31'),
('Microsoft Campus Drive', 'Microsoft will be conducting a campus drive on March 15th. Eligible students with CGPA > 7.5 can apply.', 'urgent', '2025-03-10'),
('Resume Writing Workshop', 'A resume writing workshop will be conducted on February 20th in the main auditorium.', 'normal', '2025-02-18');
