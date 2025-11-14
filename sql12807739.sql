-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: sql12.freesqldatabase.com
-- Generation Time: Nov 14, 2025 at 11:16 AM
-- Server version: 5.5.62-0ubuntu0.14.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql12807739`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Admin',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `created_at`) VALUES
(1, 'Admin', 'admin1@cumminscollege.edu.in', '$2b$10$5ujON9S00UG2aXnG6BeUR.lVXzifoo9K4aCeQn3YBnurVzp3c2Zyy', '2025-08-30 16:46:42'),
(2, 'Admin', 'admin2@cumminscollege.edu.in', '$2b$10$O2GwynIDuF3fCRkhWHZ9N.JxHtxMa.ycgs/WPen4ysBeVnMVE2xsy', '2025-09-01 09:58:17'),
(3, 'Admin', 'admin3@cumminscollege.edu.in', '$2b$10$pX8yAItqsrPe6NZqpPRo2.bc.xxJU3pGkVeIPZhQSlnFXlnq3YmEm', '2025-09-01 11:11:23');

-- --------------------------------------------------------

--
-- Table structure for table `admin_emails`
--

CREATE TABLE `admin_emails` (
  `id` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_emails`
--

INSERT INTO `admin_emails` (`id`, `email`) VALUES
(1, 'admin1@cumminscollege.edu.in'),
(2, 'admin2@cumminscollege.edu.in'),
(3, 'admin3@cumminscollege.edu.in'),
(4, 'admin4@cumminscollege.edu.in');

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('normal','high','urgent') COLLATE utf8mb4_unicode_ci DEFAULT 'normal',
  `expiry_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `content`, `priority`, `expiry_date`, `created_at`, `updated_at`) VALUES
(9, 'Welcome to Placement Portal', 'All students are requested to update their profiles and upload resumes for the upcoming placement season.', 'high', '2025-09-20', '2025-09-14 03:19:42', '2025-09-14 03:19:42'),
(13, 'demo', 'xyz', 'high', '2025-09-15', '2025-09-14 07:07:44', '2025-09-14 07:07:44'),
(14, 'job drive for infosys', 'soft eng', 'urgent', '2025-10-22', '2025-10-05 08:03:49', '2025-10-05 08:03:49');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('new','read','replied') COLLATE utf8mb4_unicode_ci DEFAULT 'new'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `name`, `email`, `subject`, `message`, `created_at`, `status`) VALUES
(4, 'Shraya', 'shrayachoudhary@gmail.com', 'demo', 'demo', '2025-09-14 07:09:45', 'new'),
(5, 'maitheli', 'maithelibokde@gmail.com', 'hello', 'inquiry', '2025-10-05 08:05:39', 'read');

-- --------------------------------------------------------

--
-- Table structure for table `drives`
--

CREATE TABLE `drives` (
  `id` int(11) NOT NULL,
  `company_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `drive_date` date NOT NULL,
  `drive_time` time DEFAULT NULL,
  `venue` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `eligibility_criteria` text COLLATE utf8mb4_unicode_ci,
  `registration_deadline` date DEFAULT NULL,
  `contact_info` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result_pdf` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `announcement` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salary` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `posted_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `posted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `title`, `company`, `location`, `salary`, `description`, `posted_by`, `posted_at`) VALUES
(1, 'Software engineer', 'Company 1', 'Not specified', '5-7 LPA', 'Modify software to fix errors, adapt it to new hardware and improve its performance.', 'admin', '2025-09-13 19:24:40'),
(2, 'Software engineer', 'Company 2', 'Not specified', '9 LPA', 'Programming', 'admin', '2025-09-13 19:28:39');

-- --------------------------------------------------------

--
-- Table structure for table `job_applications`
--

CREATE TABLE `job_applications` (
  `id` int(11) NOT NULL,
  `roll_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_id` int(11) NOT NULL,
  `status` enum('applied','shortlisted','rejected','selected') COLLATE utf8mb4_unicode_ci DEFAULT 'applied',
  `applied_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `job_applications`
--

INSERT INTO `job_applications` (`id`, `roll_number`, `job_id`, `status`, `applied_at`, `updated_at`) VALUES
(10, '3BCE56', 4, 'shortlisted', '2025-09-13 20:38:59', '2025-09-13 20:39:10'),
(11, '3BCE56', 5, 'selected', '2025-09-13 21:00:59', '2025-09-13 21:01:14'),
(12, '3BCE55', 5, 'rejected', '2025-09-13 21:02:41', '2025-09-13 21:02:55'),
(14, '3BCE50', 5, 'shortlisted', '2025-09-14 03:45:47', '2025-09-14 03:46:43'),
(15, '3BCE50', 7, 'selected', '2025-09-14 07:05:44', '2025-09-14 07:05:59'),
(16, '3BCE50', 8, 'shortlisted', '2025-10-05 08:01:51', '2025-10-05 08:02:50'),
(17, '3AETC30', 8, 'applied', '2025-10-05 08:08:40', '2025-10-05 08:08:40');

-- --------------------------------------------------------

--
-- Table structure for table `job_listings`
--

CREATE TABLE `job_listings` (
  `id` int(11) NOT NULL,
  `company_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `eligibility` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `job_listings`
--

INSERT INTO `job_listings` (`id`, `company_name`, `role`, `ctc`, `eligibility`, `deadline`, `description`, `created_at`) VALUES
(4, 'WebX', 'Web Developer', '7 LPA', 'CGPA > 7', '2025-09-30', 'Full stack web development', '2025-09-13 20:38:25'),
(5, 'Company 2', 'Software developer', '10 LPA', 'CGPA > 7.0', '2025-09-30', 'Programming in c++', '2025-09-13 21:00:05'),
(7, 'company 1', 'aa', '4', 'CGPA> 6.5', '2025-09-18', 'WEB DEVELOPMENT', '2025-09-14 07:04:46'),
(8, 'xyz', 'software eng', '5 lpa', 'CGPA>7.5', '2025-10-21', 'software eng with web dev skills', '2025-10-05 08:01:33');

-- --------------------------------------------------------

--
-- Table structure for table `registered_students`
--

CREATE TABLE `registered_students` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roll_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `registered_students`
--

INSERT INTO `registered_students` (`id`, `name`, `email`, `roll_number`) VALUES
(1, 'Shraya Chaudhary', 'shraya.chaudhary@cumminscollege.edu.in', '3BCE50'),
(2, 'Vaishnavi Dharmadhikari', 'vaishnavi.dharmadhikari@cumminscollege.edu.in', '3BCE61'),
(3, 'Falguni Katekar', 'falguni.katekar@cumminscollege.edu.in', '3A12'),
(4, 'Student1', 'student.1@cumminscollege.edu.in', '3BCE56'),
(5, 'Student2', 'student.2@cumminscollege.edu.in', '3BCE55'),
(6, 'Student3', 'student.3@cumminscollege.edu.in', '4BME30'),
(9, 'Student 4', 'student.4@cumminscollege.edu.in', '4BCE40'),
(11, 'student 5', 'student.5@cumminscollege.edu.in', '5BME50'),
(12, 'Student 6', 'stu.6@ccoew.edu.in', '2BETC12'),
(13, 'student 7', 'stu7@ccoew.edu.in', '7ACE14'),
(15, 'maitheli', 'maitheli@cumminscollege.edu.in', '3AETC30');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `email`, `password`) VALUES
(1, 'Shraya', 'shraya@example.com', '$2b$10$SI5PDu6G6f3SZk8mUikwPueOTTzlVhyUdlDds0Z2AJpSTj82bR0Ly');

-- --------------------------------------------------------

--
-- Table structure for table `student_accounts`
--

CREATE TABLE `student_accounts` (
  `id` int(11) NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `roll_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_accounts`
--

INSERT INTO `student_accounts` (`id`, `email`, `password_hash`, `created_at`, `roll_number`, `name`) VALUES
(1, 'shraya.chaudhary@cumminscollege.edu.in', '$2b$10$4E6jdggCETuPcZQbYNhUr.0CbI3Mi2YrEHTpJTSpLiaPKlIarlY2.', '2025-08-30 14:57:17', '3BCE50', 'Shraya Chaudhary'),
(2, 'vaishnavi.dharmadhikari@cumminscollege.edu.in', '$2b$10$ILPlFINAGQwzHiEi/KV/EenyizNsrLRTxiHS.iHQBVzkrykGGAaSS', '2025-08-30 15:25:42', '3BCE61', 'Vaishnavi Dharmadhikari'),
(3, 'student.1@cumminscollege.edu.in', '$2b$10$eo393FZVDbQP8um08QAQReQOjgZkLwb1qhOk/h.g/b6P36Qa5Og0a', '2025-09-01 10:57:56', '3BCE56', 'Student1'),
(4, 'student.2@cumminscollege.edu.in', '$2b$10$qZWi0StXyOT51vcUcKF4cu2pe3p1rx6UE1O1QWiXensIOpNLsvWDy', '2025-09-01 11:10:17', '3BCE55', 'Student2'),
(5, 'student.3@cumminscollege.edu.in', '$2b$10$ms64vhpsA.mCttvbZmHuR.5B9UGUmJMndN4pXb/SpP6PVkZeONM1u', '2025-09-13 12:57:53', '4BME30', 'Student3'),
(6, 'maitheli@cumminscollege.edu.in', '$2b$10$uLRuF76.qmz1ER/jsDl1XuHBmpJ8ni5wXg8la6OzqnDe2biwwJi9S', '2025-10-05 08:07:32', '3AETC30', 'Maitheli Bokde');

-- --------------------------------------------------------

--
-- Table structure for table `student_profiles`
--

CREATE TABLE `student_profiles` (
  `id` int(11) NOT NULL,
  `roll_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `skills` text COLLATE utf8mb4_unicode_ci,
  `cgpa` decimal(3,2) DEFAULT NULL,
  `resume_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_profiles`
--

INSERT INTO `student_profiles` (`id`, `roll_number`, `phone`, `skills`, `cgpa`, `resume_url`, `updated_at`, `name`, `department`) VALUES
(1, '3BCE55', '9876543321', 'web dev, cloud computing', '8.10', 'http://localhost:5000/uploads/1757789357026-dec-ews.pdf', '2025-09-13 18:49:17', 'shraya', 'Computer Engineering'),
(3, '3BCE56', '1234567888', 'cloud computing', '7.50', 'http://localhost:5000/uploads/1757788617673-WebWay 2025- Final Round Participants List.pdf', '2025-09-13 18:36:57', 'Student1', 'Mechanical Engineering'),
(12, '4BME30', '9234567899', 'Communication skills', '6.90', NULL, '2025-09-13 12:59:13', 'Student 3', 'Mechanical Engineering'),
(26, '3BCE50', '8329747852', 'web dev, python programming', '8.02', 'http://localhost:5000/uploads/1759651208090-dsco - Google Docs.pdf', '2025-10-05 08:00:08', 'Shraya Chaudhary', 'CE'),
(32, '3AETC30', '8754390056', 'web dev', '7.90', 'http://localhost:5000/uploads/1759651687722-coverpg.pdf', '2025-10-05 08:08:10', 'Maitheli Bokde', 'ETC');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `admin_emails`
--
ALTER TABLE `admin_emails`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drives`
--
ALTER TABLE `drives`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `job_applications`
--
ALTER TABLE `job_applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_application` (`roll_number`,`job_id`),
  ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `job_listings`
--
ALTER TABLE `job_listings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `registered_students`
--
ALTER TABLE `registered_students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `roll_no` (`roll_number`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `student_accounts`
--
ALTER TABLE `student_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roll_number` (`roll_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `admin_emails`
--
ALTER TABLE `admin_emails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `drives`
--
ALTER TABLE `drives`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `job_applications`
--
ALTER TABLE `job_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `job_listings`
--
ALTER TABLE `job_listings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `registered_students`
--
ALTER TABLE `registered_students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `student_accounts`
--
ALTER TABLE `student_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `job_applications`
--
ALTER TABLE `job_applications`
  ADD CONSTRAINT `job_applications_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `job_listings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_accounts`
--
ALTER TABLE `student_accounts`
  ADD CONSTRAINT `student_accounts_ibfk_1` FOREIGN KEY (`email`) REFERENCES `registered_students` (`email`);

--
-- Constraints for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD CONSTRAINT `student_profiles_ibfk_1` FOREIGN KEY (`roll_number`) REFERENCES `registered_students` (`roll_number`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
