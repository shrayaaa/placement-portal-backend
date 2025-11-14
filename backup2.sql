-- Corrected SQL Dump (MySQL-Compatible for older versions)
-- TIMESTAMP rules fixed: only one TIMESTAMP per table
-- Secondary timestamp fields converted to DATETIME
-- Data preserved exactly

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

############################################################
# TABLE: admin_emails
############################################################

DROP TABLE IF EXISTS admin_emails;
CREATE TABLE admin_emails (
  id int NOT NULL AUTO_INCREMENT,
  email varchar(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO admin_emails VALUES
(1,'admin1@cumminscollege.edu.in'),
(2,'admin2@cumminscollege.edu.in'),
(3,'admin3@cumminscollege.edu.in'),
(4,'admin4@cumminscollege.edu.in');

############################################################
# TABLE: admins
############################################################

DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL DEFAULT 'Admin',
  email varchar(100) NOT NULL,
  password varchar(255) NOT NULL,

  -- ONE allowed TIMESTAMP
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO admins VALUES
(1,'Admin','admin1@cumminscollege.edu.in','$2b$10$5ujON9S00UG2aXnG6BeUR.lVXzifoo9K4aCeQn3YBnurVzp3c2Zyy','2025-08-30 16:46:42'),
(2,'Admin','admin2@cumminscollege.edu.in','$2b$10$O2GwynIDuF3fCRkhWHZ9N.JxHtxMa.ycgs/WPen4ysBeVnMVE2xsy','2025-09-01 09:58:17'),
(3,'Admin','admin3@cumminscollege.edu.in','$2b$10$pX8yAItqsrPe6NZqpPRo2.bc.xxJU3pGkVeIPZhQSlnFXlnq3YmEm','2025-09-01 11:11:23');

############################################################
# TABLE: announcements
############################################################

DROP TABLE IF EXISTS announcements;
CREATE TABLE announcements (
  id int NOT NULL AUTO_INCREMENT,
  title varchar(255) NOT NULL,
  content text NOT NULL,
  priority enum('normal','high','urgent') DEFAULT 'normal',
  expiry_date date DEFAULT NULL,

  -- ONE TIMESTAMP allowed
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- secondary must be DATETIME
  updated_at DATETIME DEFAULT NULL,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO announcements VALUES
(9,'Welcome to Placement Portal','All students are requested to update their profiles and upload resumes for the upcoming placement season.','high','2025-09-20','2025-09-14 03:19:42','2025-09-14 03:19:42'),
(13,'demo','xyz','high','2025-09-15','2025-09-14 07:07:44','2025-09-14 07:07:44'),
(14,'job drive for infosys','soft eng','urgent','2025-10-22','2025-10-05 08:03:49','2025-10-05 08:03:49');

############################################################
# TABLE: contact_messages
############################################################

DROP TABLE IF EXISTS contact_messages;
CREATE TABLE contact_messages (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  subject varchar(500) NOT NULL,
  message text NOT NULL,

  -- ONE timestamp allowed
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  status enum('new','read','replied') DEFAULT 'new',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO contact_messages VALUES
(4,'Shraya','shrayachoudhary@gmail.com','demo','demo','2025-09-14 07:09:45','new'),
(5,'maitheli','maithelibokde@gmail.com','hello','inquiry','2025-10-05 08:05:39','read');

############################################################
# TABLE: drives
############################################################

DROP TABLE IF EXISTS drives;
CREATE TABLE drives (
  id int NOT NULL AUTO_INCREMENT,
  company_name varchar(255) NOT NULL,
  drive_date date NOT NULL,
  drive_time time DEFAULT NULL,
  venue varchar(255) DEFAULT NULL,
  description text,
  eligibility_criteria text,
  registration_deadline date DEFAULT NULL,
  contact_info varchar(255) DEFAULT NULL,
  result_pdf varchar(500) DEFAULT NULL,
  announcement text,

  -- one timestamp allowed
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- second time field becomes DATETIME
  updated_at DATETIME DEFAULT NULL,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- No data in drives table
############################################################
# TABLE: job_applications
############################################################

DROP TABLE IF EXISTS job_applications;
CREATE TABLE job_applications (
  id int NOT NULL AUTO_INCREMENT,
  roll_number varchar(50) NOT NULL,
  job_id int NOT NULL,
  status enum('applied','shortlisted','rejected','selected') DEFAULT 'applied',

  -- ONE TIMESTAMP allowed
  applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- secondary becomes DATETIME
  updated_at DATETIME DEFAULT NULL,

  PRIMARY KEY (id),
  UNIQUE KEY unique_application (roll_number,job_id),
  KEY job_id (job_id),
  CONSTRAINT job_applications_ibfk_1 FOREIGN KEY (job_id) REFERENCES job_listings (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO job_applications VALUES
(10,'3BCE56',4,'shortlisted','2025-09-13 20:38:59','2025-09-13 20:39:10'),
(11,'3BCE56',5,'selected','2025-09-13 21:00:59','2025-09-13 21:01:14'),
(12,'3BCE55',5,'rejected','2025-09-13 21:02:41','2025-09-13 21:02:55'),
(14,'3BCE50',5,'shortlisted','2025-09-14 03:45:47','2025-09-14 03:46:43'),
(15,'3BCE50',7,'selected','2025-09-14 07:05:44','2025-09-14 07:05:59'),
(16,'3BCE50',8,'shortlisted','2025-10-05 08:01:51','2025-10-05 08:02:50'),
(17,'3AETC30',8,'applied','2025-10-05 08:08:40','2025-10-05 08:08:40');

############################################################
# TABLE: job_listings
############################################################

DROP TABLE IF EXISTS job_listings;
CREATE TABLE job_listings (
  id int NOT NULL AUTO_INCREMENT,
  company_name varchar(100) NOT NULL,
  role varchar(100) NOT NULL,
  ctc varchar(50) DEFAULT NULL,
  eligibility varchar(200) DEFAULT NULL,
  deadline date DEFAULT NULL,
  description text,

  -- ONE timestamp allowed
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO job_listings VALUES
(4,'WebX','Web Developer','7 LPA','CGPA > 7','2025-09-30','Full stack web development','2025-09-13 20:38:25'),
(5,'Company 2','Software developer','10 LPA','CGPA > 7.0','2025-09-30','Programming in c++','2025-09-13 21:00:05'),
(7,'company 1','aa','4','CGPA> 6.5','2025-09-18','WEB DEVELOPMENT','2025-09-14 07:04:46'),
(8,'xyz','software eng','5 lpa','CGPA>7.5','2025-10-21','software eng with web dev skills','2025-10-05 08:01:33');

############################################################
# TABLE: jobs
############################################################

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs (
  id int NOT NULL AUTO_INCREMENT,
  title varchar(255) NOT NULL,
  company varchar(255) NOT NULL,
  location varchar(255) DEFAULT NULL,
  salary varchar(100) DEFAULT NULL,
  description text,
  posted_by varchar(255) DEFAULT NULL,

  -- ONE timestamp allowed
  posted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO jobs VALUES
(1,'Software engineer','Company 1','Not specified','5-7 LPA',
 'Modify software to fix errors, adapt it to new hardware and improve its performance.',
 'admin','2025-09-13 19:24:40'),

(2,'Software engineer','Company 2','Not specified','9 LPA','Programming',
 'admin','2025-09-13 19:28:39');

############################################################
# TABLE: registered_students
############################################################

DROP TABLE IF EXISTS registered_students;
CREATE TABLE registered_students (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  roll_number varchar(50) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY email (email),
  UNIQUE KEY roll_no (roll_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO registered_students VALUES
(1,'Shraya Chaudhary','shraya.chaudhary@cumminscollege.edu.in','3BCE50'),
(2,'Vaishnavi Dharmadhikari','vaishnavi.dharmadhikari@cumminscollege.edu.in','3BCE61'),
(3,'Falguni Katekar','falguni.katekar@cumminscollege.edu.in','3A12'),
(4,'Student1','student.1@cumminscollege.edu.in','3BCE56'),
(5,'Student2','student.2@cumminscollege.edu.in','3BCE55'),
(6,'Student3','student.3@cumminscollege.edu.in','4BME30'),
(9,'Student 4','student.4@cumminscollege.edu.in','4BCE40'),
(11,'student 5','student.5@cumminscollege.edu.in','5BME50'),
(12,'Student 6','stu.6@ccoew.edu.in','2BETC12'),
(13,'student 7','stu7@ccoew.edu.in','7ACE14'),
(15,'maitheli','maitheli@cumminscollege.edu.in','3AETC30');

############################################################
# TABLE: student_accounts
############################################################

DROP TABLE IF EXISTS student_accounts;
CREATE TABLE student_accounts (
  id int NOT NULL AUTO_INCREMENT,
  email varchar(100) NOT NULL,
  password_hash varchar(255) NOT NULL,

  -- ONE timestamp allowed
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  roll_number varchar(50) NOT NULL,
  name varchar(100) DEFAULT NULL,

  PRIMARY KEY (id),
  UNIQUE KEY email (email),
  CONSTRAINT student_accounts_ibfk_1 FOREIGN KEY (email)
    REFERENCES registered_students (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO student_accounts VALUES
(1,'shraya.chaudhary@cumminscollege.edu.in',
 '$2b$10$4E6jdggCETuPcZQbYNhUr.0CbI3Mi2YrEHTpJTSpLiaPKlIarlY2.',
 '2025-08-30 14:57:17','3BCE50','Shraya Chaudhary'),

(2,'vaishnavi.dharmadhikari@cumminscollege.edu.in',
 '$2b$10$ILPlFINAGQwzHiEi/KV/EenyizNsrLRTxiHS.iHQBVzkrykGGAaSS',
 '2025-08-30 15:25:42','3BCE61','Vaishnavi Dharmadhikari'),

(3,'student.1@cumminscollege.edu.in',
 '$2b$10$eo393FZVDbQP8um08QAQReQOjgZkLwb1qhOk/h.g/b6P36Qa5Og0a',
 '2025-09-01 10:57:56','3BCE56','Student1'),

(4,'student.2@cumminscollege.edu.in',
 '$2b$10$qZWi0StXyOT51vcUcKF4cu2pe3p1rx6UE1O1QWiXensIOpNLsvWDy',
 '2025-09-01 11:10:17','3BCE55','Student2'),

(5,'student.3@cumminscollege.edu.in',
 '$2b$10$ms64vhpsA.mCttvbZmHuR.5B9UGUmJMndN4pXb/SpP6PVkZeONM1u',
 '2025-09-13 12:57:53','4BME30','Student3'),

(6,'maitheli@cumminscollege.edu.in',
 '$2b$10$uLRuF76.qmz1ER/jsDl1XuHBmpJ8ni5wXg8la6OzqnDe2biwwJi9S',
 '2025-10-05 08:07:32','3AETC30','Maitheli Bokde');
 ############################################################
# TABLE: student_profiles
############################################################

DROP TABLE IF EXISTS student_profiles;
CREATE TABLE student_profiles (
  id int NOT NULL AUTO_INCREMENT,
  roll_number varchar(20) NOT NULL,
  phone varchar(15) DEFAULT NULL,
  skills text,
  cgpa decimal(3,2) DEFAULT NULL,
  resume_url varchar(255) DEFAULT NULL,

  -- converted to DATETIME (no auto-update) to keep ONE TIMESTAMP rule per table
  updated_at DATETIME DEFAULT NULL,

  name varchar(100) DEFAULT NULL,
  department varchar(50) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY roll_number (roll_number),
  CONSTRAINT student_profiles_ibfk_1 FOREIGN KEY (roll_number) REFERENCES registered_students (roll_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO student_profiles VALUES
(1,'3BCE55','9876543321','web dev, cloud computing',8.10,'http://localhost:5000/uploads/1757789357026-dec-ews.pdf','2025-09-13 18:49:17','shraya','Computer Engineering'),
(3,'3BCE56','1234567888','cloud computing',7.50,'http://localhost:5000/uploads/1757788617673-WebWay 2025- Final Round Participants List.pdf','2025-09-13 18:36:57','Student1','Mechanical Engineering'),
(12,'4BME30','9234567899','Communication skills',6.90,NULL,'2025-09-13 12:59:13','Student 3','Mechanical Engineering'),
(26,'3BCE50','8329747852','web dev, python programming',8.02,'http://localhost:5000/uploads/1759651208090-dsco - Google Docs.pdf','2025-10-05 08:00:08','Shraya Chaudhary','CE'),
(32,'3AETC30','8754390056','web dev',7.90,'http://localhost:5000/uploads/1759651687722-coverpg.pdf','2025-10-05 08:08:10','Maitheli Bokde','ETC');

############################################################
# TABLE: students
############################################################

DROP TABLE IF EXISTS students;
CREATE TABLE students (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(100) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO students VALUES
(1,'Shraya','shraya@example.com','$2b$10$SI5PDu6G6f3SZk8mUikwPueOTTzlVhyUdlDds0Z2AJpSTj82bR0Ly');

############################################################
# FINAL FOOTER: restore settings
############################################################

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-13 15:14:22