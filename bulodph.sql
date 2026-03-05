-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 05, 2026 at 02:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hpa_plus`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `affiliate_applications`
--

CREATE TABLE `affiliate_applications` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `company` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `notes` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` char(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `body` longtext DEFAULT NULL,
  `recipient_type` varchar(255) NOT NULL DEFAULT 'all',
  `recipient_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`recipient_ids`)),
  `created_by` char(36) DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` char(36) NOT NULL,
  `organization_id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `request_id` char(36) DEFAULT NULL,
  `auditable_type` varchar(255) NOT NULL,
  `auditable_id` char(36) NOT NULL,
  `event` varchar(50) NOT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `organization_id`, `user_id`, `request_id`, `auditable_type`, `auditable_id`, `event`, `old_values`, `new_values`, `ip_address`, `user_agent`, `created_at`) VALUES
('a12535dd-20e5-4b16-88ce-639ad4fffca0', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, NULL, 'App\\Models\\Client', 'a12535dd-1b6f-4774-99aa-35309e8a17b9', 'created', NULL, '{\"organization_id\":\"a12535db-c0bd-4cc5-97be-a851a378fc84\",\"ndis_number\":\"400000001\",\"first_name\":\"John\",\"last_name\":\"Smith\",\"date_of_birth\":\"1990-05-14T14:00:00.000000Z\",\"address_line_1\":\"123 Main Street\",\"address_line_2\":\"Apt. 833\",\"suburb\":\"Sydney\",\"state\":\"NSW\",\"postcode\":\"2000\",\"latitude\":\"-33.8688000\",\"longitude\":\"151.2093000\",\"emergency_contact_name\":\"Jane Smith\",\"emergency_contact_phone\":\"0400111222\",\"id\":\"a12535dd-1b6f-4774-99aa-35309e8a17b9\",\"updated_at\":\"2026-02-23T01:58:15.000000Z\",\"created_at\":\"2026-02-23T01:58:15.000000Z\"}', '127.0.0.1', 'Symfony', '2026-02-23 04:58:15'),
('a12535dd-2310-4370-8c59-b2d74f9f7c28', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, NULL, 'App\\Models\\Client', 'a12535dd-21f8-41a6-9033-15ff6efdc133', 'created', NULL, '{\"organization_id\":\"a12535db-c0bd-4cc5-97be-a851a378fc84\",\"ndis_number\":\"400000002\",\"first_name\":\"Sarah\",\"last_name\":\"Johnson\",\"date_of_birth\":\"1985-08-21T14:00:00.000000Z\",\"address_line_1\":\"456 Park Avenue\",\"address_line_2\":\"Apt. 938\",\"suburb\":\"Melbourne\",\"state\":\"VIC\",\"postcode\":\"3000\",\"latitude\":\"-37.8136000\",\"longitude\":\"144.9631000\",\"emergency_contact_name\":\"Michael Johnson\",\"emergency_contact_phone\":\"0400333444\",\"id\":\"a12535dd-21f8-41a6-9033-15ff6efdc133\",\"updated_at\":\"2026-02-23T01:58:15.000000Z\",\"created_at\":\"2026-02-23T01:58:15.000000Z\"}', '127.0.0.1', 'Symfony', '2026-02-23 04:58:15'),
('a12535dd-27f2-4fc0-891f-57c4b18e8dc6', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, NULL, 'App\\Models\\NDISPlan', 'a12535dd-2580-4127-a507-c8ef432a41ae', 'created', NULL, '{\"client_id\":\"a12535dd-1b6f-4774-99aa-35309e8a17b9\",\"plan_number\":\"PLAN-2024-001\",\"start_date\":\"2025-12-22T13:00:00.000000Z\",\"end_date\":\"2026-12-22T13:00:00.000000Z\",\"plan_management_type\":\"SELF_MANAGED\",\"is_active\":true,\"id\":\"a12535dd-2580-4127-a507-c8ef432a41ae\",\"updated_at\":\"2026-02-23T01:58:15.000000Z\",\"created_at\":\"2026-02-23T01:58:15.000000Z\"}', '127.0.0.1', 'Symfony', '2026-02-23 04:58:15'),
('a12535dd-2da5-44dd-9167-70017d3b4df8', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, NULL, 'App\\Models\\NDISPlan', 'a12535dd-2c95-4022-8ff6-ba86dbf913e1', 'created', NULL, '{\"client_id\":\"a12535dd-21f8-41a6-9033-15ff6efdc133\",\"plan_number\":\"PLAN-2024-002\",\"start_date\":\"2026-01-22T13:00:00.000000Z\",\"end_date\":\"2027-01-22T13:00:00.000000Z\",\"plan_management_type\":\"PLAN_MANAGED\",\"is_active\":true,\"id\":\"a12535dd-2c95-4022-8ff6-ba86dbf913e1\",\"updated_at\":\"2026-02-23T01:58:15.000000Z\",\"created_at\":\"2026-02-23T01:58:15.000000Z\"}', '127.0.0.1', 'Symfony', '2026-02-23 04:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `blog_posts`
--

CREATE TABLE `blog_posts` (
  `id` char(36) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `budget_categories`
--

CREATE TABLE `budget_categories` (
  `id` char(36) NOT NULL,
  `ndis_plan_id` char(36) NOT NULL,
  `category_type` enum('CORE','CAPITAL','CAPACITY_BUILDING') NOT NULL,
  `total_budget_cents` bigint(20) UNSIGNED NOT NULL,
  `spent_cents` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `committed_cents` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `budget_categories`
--

INSERT INTO `budget_categories` (`id`, `ndis_plan_id`, `category_type`, `total_budget_cents`, `spent_cents`, `committed_cents`, `created_at`, `updated_at`) VALUES
('a12535dd-28f0-4e4b-b5f4-80a268d7879e', 'a12535dd-2580-4127-a507-c8ef432a41ae', 'CORE', 5000000, 68064, 62718, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-2e85-4d2b-87d9-93ab747ccd71', 'a12535dd-2c95-4022-8ff6-ba86dbf913e1', 'CORE', 4000000, 23333, 29048, '2026-02-23 04:58:15', '2026-02-23 04:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('5c785c036466adea360111aa28563bfd556b5fba', 'i:1;', 1772639447),
('5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1772639447;', 1772639447),
('6a19ebaf51b0c87fa6e02db5278e7119916d1e22', 'i:2;', 1772639404),
('6a19ebaf51b0c87fa6e02db5278e7119916d1e22:timer', 'i:1772639404;', 1772639404),
('email_verification_otp:a12535dd-84fe-436e-b02e-a83a458891f1', 's:6:\"579566\";', 1772639944),
('email_verification_sent_at:a12535dd-84fe-436e-b02e-a83a458891f1', 's:10:\"1772639344\";', 1772639404);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cancellation_requests`
--

CREATE TABLE `cancellation_requests` (
  `id` char(36) NOT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `user_id` char(36) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'requested',
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `vehicle_id` varchar(64) NOT NULL,
  `vehicle_name` varchar(255) DEFAULT NULL,
  `vehicle_image` varchar(255) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `price_per_day` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `quantity_days` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `meet_up` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `user_id`, `vehicle_id`, `vehicle_name`, `vehicle_image`, `start_date`, `end_date`, `price_per_day`, `quantity_days`, `meet_up`, `created_at`, `updated_at`) VALUES
('a12f8c11-1a06-4a37-b113-4058fa2031d3', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'a12f63f5-6328-4a38-af15-91e067b7b463', 'JAJA', 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop', '2026-02-28', '2026-03-02', 2500, 3, NULL, '2026-02-28 08:17:34', '2026-02-28 08:17:34'),
('a130174a-ad6d-4991-8c74-4190d9edb377', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'a12e1fa7-a325-4521-ab42-56e92b14dc3b', 'testingers', 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop', '2026-02-28', '2026-03-09', 2500, 10, NULL, '2026-02-28 14:46:52', '2026-02-28 14:46:52'),
('a1315d06-f0c9-4174-91e8-f8d1da6c481e', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'demo-1', 'Toyota Innova 2022', 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop', '2026-03-01', '2026-03-04', 2500, 4, NULL, '2026-03-01 05:57:42', '2026-03-01 05:57:42'),
('a133519a-dc54-4de8-9c99-7eed74925bfb', 'a12535dd-84fe-436e-b02e-a83a458891f1', '1', 'XLE RAV4', 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800&q=80&fit=crop', '2026-03-02', '2026-03-25', 3200, 24, NULL, '2026-03-02 05:17:25', '2026-03-02 05:17:25');

-- --------------------------------------------------------

--
-- Table structure for table `car_rental_profiles`
--

CREATE TABLE `car_rental_profiles` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `business_name` varchar(255) NOT NULL,
  `logo_url` text DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `business_permit_number` varchar(100) DEFAULT NULL,
  `business_address` varchar(500) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `car_rental_profiles`
--

INSERT INTO `car_rental_profiles` (`id`, `user_id`, `business_name`, `logo_url`, `bio`, `city`, `province`, `address`, `phone`, `email`, `business_permit_number`, `business_address`, `slug`, `verified_at`, `created_at`, `updated_at`) VALUES
('a12878b0-46f5-4923-aa8c-a994b5a64b24', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'Demo Car Owner', 'data:image/jpeg;base64,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', 'dasdas', 'dasdasd', 'dasd', 'dasdas', '639171234569', 'carowner@bulodph.demo', 'dasda', NULL, 'demo-car-owner', NULL, '2026-02-24 19:52:35', '2026-02-28 06:23:59'),
('a1382248-2e85-4302-a803-260bb640431a', 'a1382248-28ea-4159-b91c-258cd1eb71b5', 'Teos car rental', NULL, 'dasdas', 'Cauayan City', 'Manila', '10', '639263091135', 'maylinpaet19@gmail.com', 'qwtqwtqw', 'qwtqwtq, tqwtqw', 'teos-car-rental', NULL, '2026-03-04 14:44:13', '2026-03-04 14:44:13');

-- --------------------------------------------------------

--
-- Table structure for table `certifications`
--

CREATE TABLE `certifications` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `certification_type` enum('FIRST_AID','CPR','NDIS_WORKER_SCREENING','WWCC','MANUAL_HANDLING','MEDICATION_ADMINISTRATION') NOT NULL,
  `certification_number` varchar(255) NOT NULL,
  `issued_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `document_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `certifications`
--

INSERT INTO `certifications` (`id`, `user_id`, `certification_type`, `certification_number`, `issued_date`, `expiry_date`, `document_path`, `created_at`, `updated_at`) VALUES
('a12535dd-1611-4e0f-a9f8-7972c249398e', 'a12535dc-bf38-4d5e-a496-701886110452', 'FIRST_AID', 'FA-2024-001', '2025-08-23', '2028-08-23', 'certifications/db93a4c9-45c4-3b20-a820-1cf38478146d.pdf', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-176b-4b83-ae4f-f8dfb6966422', 'a12535dc-bf38-4d5e-a496-701886110452', 'CPR', 'CPR-2024-001', '2025-11-23', '2026-11-23', 'certifications/19abddc5-c68f-3ad0-9f53-3e880f87d9de.pdf', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-17f9-4340-b6c3-32df8afcf8ef', 'a12535dc-bf38-4d5e-a496-701886110452', 'NDIS_WORKER_SCREENING', 'NDIS-WS-2024-001', '2025-02-23', '2030-02-23', 'certifications/cdafccf2-d252-3f07-83f8-97eca30180f4.pdf', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-18c3-4449-9392-8139dd1bc552', 'a12535dd-120d-4b81-8b89-d8610b7fba74', 'FIRST_AID', 'FA-2024-002', '2025-10-23', '2028-10-23', 'certifications/c98590d8-9989-3d63-86d1-cc11a028148a.pdf', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-1993-4fec-91f5-3d059da2632a', 'a12535dd-120d-4b81-8b89-d8610b7fba74', 'CPR', 'CPR-2024-002', '2025-12-23', '2026-12-23', 'certifications/820e6605-8652-34aa-a62b-359d351f85b6.pdf', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-1a37-48eb-8b6e-0345569319b1', 'a12535dd-120d-4b81-8b89-d8610b7fba74', 'NDIS_WORKER_SCREENING', 'NDIS-WS-2024-002', '2025-06-23', '2030-06-23', 'certifications/24dadf41-418e-3cab-9b65-3c1aa4f2bca6.pdf', '2026-02-23 04:58:15', '2026-02-23 04:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `city_pages`
--

CREATE TABLE `city_pages` (
  `id` char(36) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'draft',
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` char(36) NOT NULL,
  `organization_id` char(36) NOT NULL,
  `ndis_number` varchar(9) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `address_line_1` varchar(255) NOT NULL,
  `address_line_2` varchar(255) DEFAULT NULL,
  `suburb` varchar(255) NOT NULL,
  `state` enum('NSW','VIC','QLD','SA','WA','TAS','NT','ACT') NOT NULL,
  `postcode` varchar(4) NOT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `emergency_contact_name` varchar(255) NOT NULL,
  `emergency_contact_phone` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `organization_id`, `ndis_number`, `first_name`, `last_name`, `date_of_birth`, `address_line_1`, `address_line_2`, `suburb`, `state`, `postcode`, `latitude`, `longitude`, `emergency_contact_name`, `emergency_contact_phone`, `created_at`, `updated_at`) VALUES
('a12535dd-1b6f-4774-99aa-35309e8a17b9', 'a12535db-c0bd-4cc5-97be-a851a378fc84', '400000001', 'John', 'Smith', '1990-05-15', '123 Main Street', 'Apt. 833', 'Sydney', 'NSW', '2000', -33.8688000, 151.2093000, 'Jane Smith', '0400111222', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-21f8-41a6-9033-15ff6efdc133', 'a12535db-c0bd-4cc5-97be-a851a378fc84', '400000002', 'Sarah', 'Johnson', '1985-08-22', '456 Park Avenue', 'Apt. 938', 'Melbourne', 'VIC', '3000', -37.8136000, 144.9631000, 'Michael Johnson', '0400333444', '2026-02-23 04:58:15', '2026-02-23 04:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `client_profiles`
--

CREATE TABLE `client_profiles` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `avatar_url` text DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `id_number` varchar(100) DEFAULT NULL,
  `emergency_contact_name` varchar(255) DEFAULT NULL,
  `emergency_contact_phone` varchar(30) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `client_profiles`
--

INSERT INTO `client_profiles` (`id`, `user_id`, `display_name`, `avatar_url`, `phone`, `city`, `province`, `address`, `id_number`, `emergency_contact_name`, `emergency_contact_phone`, `slug`, `verified_at`, `created_at`, `updated_at`) VALUES
('a1322a10-f976-4cd3-b50c-527df1bc1b0d', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'Demo Client', 'http://localhost:8000/storage/avatars/a12535dd-84fe-436e-b02e-a83a458891f1/69a43fa90b9259.21989620.png', '639171234567', NULL, NULL, NULL, NULL, NULL, NULL, 'demo-client', NULL, '2026-03-01 15:31:01', '2026-03-01 16:31:21');

-- --------------------------------------------------------

--
-- Table structure for table `disputes`
--

CREATE TABLE `disputes` (
  `id` char(36) NOT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `opened_by_user_id` char(36) NOT NULL,
  `against_user_id` char(36) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'filed',
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dispute_evidence`
--

CREATE TABLE `dispute_evidence` (
  `id` char(36) NOT NULL,
  `dispute_id` char(36) NOT NULL,
  `uploaded_by_user_id` char(36) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `mime` varchar(255) DEFAULT NULL,
  `size` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE `email_templates` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `vehicle_id` varchar(64) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fraud_risk_flags`
--

CREATE TABLE `fraud_risk_flags` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `severity` varchar(255) NOT NULL DEFAULT 'medium',
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_claims`
--

CREATE TABLE `insurance_claims` (
  `id` char(36) NOT NULL,
  `insurance_selection_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `description` longtext DEFAULT NULL,
  `claim_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` varchar(255) NOT NULL DEFAULT 'submitted',
  `evidence_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_plans`
--

CREATE TABLE `insurance_plans` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(8) NOT NULL DEFAULT 'PHP',
  `coverage_details` longtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_selections`
--

CREATE TABLE `insurance_selections` (
  `id` char(36) NOT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `user_id` char(36) NOT NULL,
  `insurance_plan_id` char(36) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'selected',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` char(36) NOT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `user_id` char(36) DEFAULT NULL,
  `owner_id` char(36) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `taxes` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(8) NOT NULL DEFAULT 'PHP',
  `status` varchar(255) NOT NULL DEFAULT 'issued',
  `paid_at` timestamp NULL DEFAULT NULL,
  `pdf_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kyc_submissions`
--

CREATE TABLE `kyc_submissions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `id_type` varchar(255) DEFAULT NULL,
  `id_number` varchar(255) DEFAULT NULL,
  `id_front_path` varchar(255) DEFAULT NULL,
  `id_back_path` varchar(255) DEFAULT NULL,
  `license_path` varchar(255) DEFAULT NULL,
  `selfie_path` varchar(255) DEFAULT NULL,
  `reviewed_by_user_id` char(36) DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` char(36) NOT NULL,
  `thread_id` char(36) NOT NULL,
  `sender_id` char(36) NOT NULL,
  `body` longtext DEFAULT NULL,
  `attachment_path` varchar(255) DEFAULT NULL,
  `attachment_mime` varchar(255) DEFAULT NULL,
  `attachment_size` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `message_threads`
--

CREATE TABLE `message_threads` (
  `id` char(36) NOT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `client_id` char(36) NOT NULL,
  `owner_id` char(36) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2024_01_01_000000_create_cache_table', 1),
(2, '2024_01_01_000001_create_organizations_table', 1),
(3, '2024_01_01_000002_create_users_table', 1),
(4, '2024_01_01_000003_create_clients_table', 1),
(5, '2024_01_01_000004_create_ndis_plans_table', 1),
(6, '2024_01_01_000005_create_budget_categories_table', 1),
(7, '2024_01_01_000006_create_ndis_support_items_table', 1),
(8, '2024_01_01_000007_create_plan_line_items_table', 1),
(9, '2024_01_01_000008_create_shifts_table', 1),
(10, '2024_01_01_000009_create_shift_lines_table', 1),
(11, '2024_01_01_000010_create_certifications_table', 1),
(12, '2024_01_01_000011_create_audit_logs_table', 1),
(13, '2024_01_01_000012_create_jobs_table', 1),
(14, '2025_02_20_000001_add_name_to_users_table', 1),
(15, '2026_01_31_004110_create_personal_access_tokens_table', 1),
(16, '2026_01_31_004115_create_permission_tables', 1),
(17, '2026_02_20_000001_create_platform_missing_features_tables', 1),
(18, '2026_02_22_120000_add_marketing_consent_to_users', 1),
(19, '2026_02_23_000001_update_personal_access_tokens_for_uuid', 2),
(20, '2026_02_23_000002_add_avatar_url_to_users_table', 3),
(21, '2026_02_25_000001_create_car_rental_profiles_table', 4),
(22, '2026_02_25_100000_change_car_rental_profiles_logo_url_to_text', 5),
(23, '2026_02_25_200000_create_rental_bookings_table', 6),
(24, '2026_02_25_210000_create_platform_settings_table', 7),
(25, '2026_02_26_000001_platform_settings_value_longtext', 8),
(26, '2026_02_27_000001_create_vehicles_table', 9),
(27, '2026_02_27_000002_add_date_columns_for_booking_vehicle_dispute_review', 10),
(28, '2026_02_27_000003_add_invoice_paid_at_and_profile_verified_at', 11),
(29, '2026_02_28_000001_create_payouts_table', 12),
(30, '2026_02_27_000004_add_hidden_from_listing_to_vehicles', 13),
(31, '2026_02_26_000001_add_profile_fields_to_users_table', 14),
(32, '2026_02_28_000002_create_announcements_table', 15),
(33, '2026_02_28_000003_create_favorites_table', 15),
(34, '2026_02_28_000004_create_cart_items_table', 15),
(35, '2026_02_28_000001_add_car_owner_seen_at_to_rental_bookings', 16),
(36, '2026_02_28_000005_create_support_tickets_table', 17),
(37, '2026_02_28_000006_create_promo_codes_table', 18),
(38, '2026_03_01_000001_update_bulod10_min_rental_days', 19),
(39, '2026_03_01_000005_add_rental_mode_and_min_rental_hours_to_vehicles', 20),
(40, '2026_03_01_000001_create_client_profiles_table', 21),
(41, '2026_03_02_000001_add_previous_status_to_rental_bookings', 22),
(42, '2026_03_05_000001_add_email_verified_at_to_users_table', 23);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` char(36) NOT NULL,
  `organization_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` char(36) NOT NULL,
  `organization_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`, `organization_id`) VALUES
(1, 'App\\Models\\User', 'a12535dc-6af8-4f9d-b3bf-2add879ea5ba', 'a12535db-c0bd-4cc5-97be-a851a378fc84'),
(2, 'App\\Models\\User', 'a12535dc-bf38-4d5e-a496-701886110452', 'a12535db-c0bd-4cc5-97be-a851a378fc84'),
(2, 'App\\Models\\User', 'a12535dd-120d-4b81-8b89-d8610b7fba74', 'a12535db-c0bd-4cc5-97be-a851a378fc84'),
(4, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'a12535dd-31f1-401c-b249-1ecbe48ac575'),
(5, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'a12535dd-31f1-401c-b249-1ecbe48ac575'),
(6, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'a12535dd-31f1-401c-b249-1ecbe48ac575'),
(7, 'App\\Models\\User', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'a12535dd-31f1-401c-b249-1ecbe48ac575'),
(8, 'App\\Models\\User', 'a1382248-28ea-4159-b91c-258cd1eb71b5', 'a1382247-be19-49da-9a83-dcab372c5657');

-- --------------------------------------------------------

--
-- Table structure for table `ndis_plans`
--

CREATE TABLE `ndis_plans` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `plan_number` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `plan_management_type` enum('SELF_MANAGED','PLAN_MANAGED','NDIA_MANAGED') NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ndis_plans`
--

INSERT INTO `ndis_plans` (`id`, `client_id`, `plan_number`, `start_date`, `end_date`, `plan_management_type`, `is_active`, `created_at`, `updated_at`) VALUES
('a12535dd-2580-4127-a507-c8ef432a41ae', 'a12535dd-1b6f-4774-99aa-35309e8a17b9', 'PLAN-2024-001', '2025-12-23', '2026-12-23', 'SELF_MANAGED', 1, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-2c95-4022-8ff6-ba86dbf913e1', 'a12535dd-21f8-41a6-9033-15ff6efdc133', 'PLAN-2024-002', '2026-01-23', '2027-01-23', 'PLAN_MANAGED', 1, '2026-02-23 04:58:15', '2026-02-23 04:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `ndis_support_items`
--

CREATE TABLE `ndis_support_items` (
  `id` char(36) NOT NULL,
  `support_item_number` varchar(20) NOT NULL,
  `support_item_name` varchar(255) NOT NULL,
  `category_type` enum('CORE','CAPITAL','CAPACITY_BUILDING') NOT NULL,
  `unit_of_measure` enum('HOUR','EACH','WEEK','MONTH') NOT NULL,
  `price_cents` bigint(20) UNSIGNED NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ndis_support_items`
--

INSERT INTO `ndis_support_items` (`id`, `support_item_number`, `support_item_name`, `category_type`, `unit_of_measure`, `price_cents`, `effective_from`, `effective_to`, `created_at`, `updated_at`) VALUES
('a12535db-a649-4445-a01e-45e0eefa2e72', '01_011_0107_1_1', 'Assistance with Self-Care Activities - Standard - Weekday Daytime', 'CORE', 'HOUR', 6854, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-af13-422e-8014-106a035ac932', '01_011_0107_1_1_T', 'Assistance with Self-Care Activities - Standard - Weekday Evening', 'CORE', 'HOUR', 9596, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-afa2-4a5b-9641-d89e6a3eca7a', '01_011_0107_1_1_S', 'Assistance with Self-Care Activities - Standard - Saturday', 'CORE', 'HOUR', 10281, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-aff8-4425-97bf-f6a1e6200648', '01_011_0107_1_1_P', 'Assistance with Self-Care Activities - Standard - Sunday/Public Holiday', 'CORE', 'HOUR', 13708, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b047-4c34-9eaa-f7605b184657', '01_012_0106_1_1', 'Assistance with Social and Community Participation - Standard - Weekday Daytime', 'CORE', 'HOUR', 6854, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b0ab-48ad-a99c-ead25cf5e072', '01_012_0106_1_1_T', 'Assistance with Social and Community Participation - Standard - Weekday Evening', 'CORE', 'HOUR', 9596, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b129-45dc-b2b1-8c54f17ad0e2', '01_013_0107_1_1', 'Assistance with Self-Care Activities - High Intensity - Weekday Daytime', 'CORE', 'HOUR', 8568, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b19e-41f2-b217-b19c524b5fbb', '07_001_0106_8_3', 'Support Coordination', 'CAPACITY_BUILDING', 'HOUR', 19386, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b1ff-4e14-a2f4-0a94ffaf8ef6', '07_002_0106_8_3', 'Specialist Support Coordination', 'CAPACITY_BUILDING', 'HOUR', 22143, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b24e-4fa4-bac7-341da2ad2498', '15_037_0128_1_3', 'Therapeutic Supports - Allied Health Assistant', 'CAPACITY_BUILDING', 'HOUR', 6854, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535db-b29c-4d34-a570-f3e5ec61f3ae', '15_038_0128_1_3', 'Therapeutic Supports - Occupational Therapist', 'CAPACITY_BUILDING', 'HOUR', 19386, '2024-07-01', NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14');

-- --------------------------------------------------------

--
-- Table structure for table `organizations`
--

CREATE TABLE `organizations` (
  `id` char(36) NOT NULL,
  `abn` varchar(11) NOT NULL,
  `trading_name` varchar(255) NOT NULL,
  `ndis_registration_number` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `organizations`
--

INSERT INTO `organizations` (`id`, `abn`, `trading_name`, `ndis_registration_number`, `is_active`, `settings`, `created_at`, `updated_at`) VALUES
('a12535db-c0bd-4cc5-97be-a851a378fc84', '12345678901', 'HPA Plus Demo Provider', 'NDIS-REG-001', 1, '{\"shift_approval_required\":false,\"geofence_radius_meters\":100,\"auto_invoice_generation\":true}', '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535dd-31f1-401c-b249-1ecbe48ac575', '99999999999', 'BulodPH Demo', NULL, 1, NULL, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a1382247-be19-49da-9a83-dcab372c5657', '11111111111', 'BulodPH Platform', NULL, 1, NULL, '2026-03-04 14:44:13', '2026-03-04 14:44:13');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_webhook_logs`
--

CREATE TABLE `payment_webhook_logs` (
  `id` char(36) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `event` varchar(255) NOT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `status` varchar(255) NOT NULL DEFAULT 'received',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payouts`
--

CREATE TABLE `payouts` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `type` varchar(32) NOT NULL DEFAULT 'car_owner',
  `payee_name` varchar(255) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `method` varchar(64) NOT NULL DEFAULT 'GCash',
  `status` varchar(32) NOT NULL DEFAULT 'pending',
  `requested_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `reject_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payouts`
--

INSERT INTO `payouts` (`id`, `user_id`, `type`, `payee_name`, `amount`, `method`, `status`, `requested_at`, `paid_at`, `rejected_at`, `reject_reason`, `created_at`, `updated_at`) VALUES
('a12e0db7-70d0-498c-9519-cb26fef39517', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'car_owner', 'Demo Car Owner', 7500, 'GCash', 'pending', '2026-02-25 14:28:26', NULL, NULL, NULL, '2026-02-27 14:28:26', '2026-02-27 14:28:26'),
('a12e0db7-7ac6-4247-a379-05a278a887e2', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'car_owner', 'Demo Car Owner', 5000, 'GCash', 'paid', '2026-02-17 14:28:26', '2026-02-19 14:28:26', NULL, NULL, '2026-02-27 14:28:26', '2026-02-27 14:28:26'),
('a12e0db7-7c5f-46e7-8324-1caade1dc00d', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'marketing', 'Demo Marketing', 3200, 'GCash', 'pending', '2026-02-26 14:28:26', NULL, NULL, NULL, '2026-02-27 14:28:26', '2026-02-27 14:28:26'),
('a12e0db7-7d6e-439e-aaf6-6414a5d4d35c', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'marketing', 'Demo Marketing', 1500, 'GCash', 'paid', '2026-02-12 14:28:26', '2026-02-15 14:28:26', NULL, NULL, '2026-02-27 14:28:26', '2026-02-27 14:28:26');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` varchar(36) NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'a45c1446b30d9bbd0fcc57b8a3033efabe4c770a1af2ecd3c8a552b72b725d39', '[\"*\"]', '2026-02-23 05:20:03', NULL, '2026-02-23 05:10:45', '2026-02-23 05:20:03'),
(2, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '0d5d8c0dde976d85c9aee8cf589ae05540c90979841910ae7e2d36e2b940c02e', '[\"*\"]', '2026-02-23 05:23:04', NULL, '2026-02-23 05:20:08', '2026-02-23 05:23:04'),
(3, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'c58ef87a33acf053ddb571417a40f5dd04cdfec2f405a0c58da6951920b44ead', '[\"*\"]', '2026-02-23 06:00:21', NULL, '2026-02-23 05:23:12', '2026-02-23 06:00:21'),
(4, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '30d92a7dca354d0f0b29cf985ca2e3ed64ef4333d99e5258144d8b56b1862d66', '[\"*\"]', '2026-02-23 07:26:09', NULL, '2026-02-23 06:53:38', '2026-02-23 07:26:09'),
(5, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ea3ccbd620d430845184020510400251c04450c3ef538df7d8e4d3538d27c906', '[\"*\"]', '2026-02-23 07:36:14', NULL, '2026-02-23 07:35:39', '2026-02-23 07:36:14'),
(6, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '991c1fd0c8ce830a3022e52453b143818af89fbb9086d69ea4a7aac8943cd60c', '[\"*\"]', '2026-02-23 08:00:02', NULL, '2026-02-23 07:36:18', '2026-02-23 08:00:02'),
(7, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '3a85196470d8a1023ff946af54ab27d59856747c2c93f4ff5fa7a2f0c2d6bcaa', '[\"*\"]', '2026-02-23 18:31:20', NULL, '2026-02-23 18:30:31', '2026-02-23 18:31:20'),
(8, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'b07adb703fe5f9b0ddeb2add8eee6ee36a9132fc8280d8c82575399d0fc3735f', '[\"*\"]', '2026-02-23 18:44:12', NULL, '2026-02-23 18:31:31', '2026-02-23 18:44:12'),
(9, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'f21bdbe3b8c2aa0e7c00f0f71126c3da9859ee9d67c348eb5f5607efbe27edc4', '[\"*\"]', '2026-02-23 18:48:49', NULL, '2026-02-23 18:48:47', '2026-02-23 18:48:49'),
(10, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '3ec022a248f90e0699fe8d3ba5b14d2f1e73f5acd85210442cc13b01199e0abd', '[\"*\"]', '2026-02-24 15:52:21', NULL, '2026-02-24 15:51:46', '2026-02-24 15:52:21'),
(11, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'cb6b3425db23961fdb9955e5046111b48ffdae1308be2681242d437be8a9c54b', '[\"*\"]', '2026-02-24 15:56:47', NULL, '2026-02-24 15:55:48', '2026-02-24 15:56:47'),
(12, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'bb901e84cf68f1b99229563b34a7e9ffae5696bef410250325d08f310d98ce49', '[\"*\"]', '2026-02-24 15:57:02', NULL, '2026-02-24 15:56:56', '2026-02-24 15:57:02'),
(13, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '68598f4759d5214f9a27edee199410732897c5e483788dc8c9454b90db9bda1a', '[\"*\"]', '2026-02-24 16:18:12', NULL, '2026-02-24 15:58:35', '2026-02-24 16:18:12'),
(14, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '077f93b8e056a8588599988184be238580df18cd13bf67299eddf2cffbef27b8', '[\"*\"]', '2026-02-24 16:20:23', NULL, '2026-02-24 16:19:10', '2026-02-24 16:20:23'),
(15, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'c0a4c44ee4a15b3ae0057796c4d6fa20e4efd03c92835d88e48b23dbd8f6d9ba', '[\"*\"]', '2026-02-24 16:50:58', NULL, '2026-02-24 16:45:00', '2026-02-24 16:50:58'),
(16, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '107c917628c3187a6ebf8b9f3cf3f39905dd26a5302349484b9454b69bdc0c50', '[\"*\"]', '2026-02-24 17:56:41', NULL, '2026-02-24 17:56:29', '2026-02-24 17:56:41'),
(17, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'c75d40e2d07414a375bdc75f103176c88f01d1d2e7322ed0e7d603a528399e82', '[\"*\"]', '2026-02-24 18:05:53', NULL, '2026-02-24 18:05:48', '2026-02-24 18:05:53'),
(18, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'b6f50fefc5a3b87265e5446e6239b28c29cea520e9039d137d1962a646d45df4', '[\"*\"]', '2026-02-24 18:07:37', NULL, '2026-02-24 18:06:01', '2026-02-24 18:07:37'),
(19, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '1481f63f28ef8658b2e0740a0f313c20eea468dce86439bc0a4a82e8e92f9b8a', '[\"*\"]', '2026-02-24 18:27:02', NULL, '2026-02-24 18:26:49', '2026-02-24 18:27:02'),
(20, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '040fefac03f341735f66636758f787e84ed92a788dc8a65ab1732ab4b6a30d15', '[\"*\"]', '2026-02-24 18:31:13', NULL, '2026-02-24 18:27:11', '2026-02-24 18:31:13'),
(21, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'e4d3a3e13356fbdb9c5db081c9b942ce53bcc1892336caec325041c68df50131', '[\"*\"]', '2026-02-24 18:31:51', NULL, '2026-02-24 18:31:22', '2026-02-24 18:31:51'),
(22, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'f24d0dd47c60cfa29c1f6f34dc06b6aaf1c1d0464912ac0fe377054af8f11d20', '[\"*\"]', '2026-02-24 18:35:46', NULL, '2026-02-24 18:32:01', '2026-02-24 18:35:46'),
(23, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '78741a697730ff34c00c22bdd92defbc35acb2349fabeba82eca82d1c1ca233d', '[\"*\"]', '2026-02-24 18:39:51', NULL, '2026-02-24 18:37:02', '2026-02-24 18:39:51'),
(24, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ef9348db1591f79fce4a130e2c72234b475c9713b4637c89765676aed6d2c50a', '[\"*\"]', '2026-02-24 18:40:06', NULL, '2026-02-24 18:40:01', '2026-02-24 18:40:06'),
(25, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '4580da041ebab10e5e2736735b93e9abc8fd621dca509ee269a8ae5cde0b10e1', '[\"*\"]', '2026-02-24 18:45:33', NULL, '2026-02-24 18:40:25', '2026-02-24 18:45:33'),
(26, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ee83cb39107a9cd819a12c08ea9480486c70ea24d1a21648c7b85d5c080d6d3f', '[\"*\"]', '2026-02-24 18:45:55', NULL, '2026-02-24 18:45:45', '2026-02-24 18:45:55'),
(27, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'df93cfbffd8ea4c8c16a6254c50f19ae17623b6195911aa217b1f900fc3bf0f1', '[\"*\"]', '2026-02-24 18:51:18', NULL, '2026-02-24 18:46:02', '2026-02-24 18:51:18'),
(28, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '2510d083e7de925de61faa93ac9ad74b1ceaf6b1ad4f4580a3d103e84c405e68', '[\"*\"]', '2026-02-24 18:51:31', NULL, '2026-02-24 18:51:26', '2026-02-24 18:51:31'),
(29, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'd3f73df6851a77d0bf3118d07c474a00da9c38f99372ed315b581e9824a2a0ac', '[\"*\"]', '2026-02-24 19:53:45', NULL, '2026-02-24 19:47:15', '2026-02-24 19:53:45'),
(30, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'a079deac71eb6f50811ac8346a9297a4a7b259f181e5bd95c71f5948b1b7ee01', '[\"*\"]', '2026-02-25 04:11:39', NULL, '2026-02-25 03:57:44', '2026-02-25 04:11:39'),
(31, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '2337c1fdb5c12eec6357bdd8a3afc9cfe9ff399ff3bbb66ab316a1e22361cc05', '[\"*\"]', '2026-02-25 04:11:08', NULL, '2026-02-25 04:07:33', '2026-02-25 04:11:08'),
(32, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'ee866a929b964ea620f5e775a2389febe3f5adfc109f59ac995d2d9c4b4450e9', '[\"*\"]', '2026-02-25 04:31:37', NULL, '2026-02-25 04:11:13', '2026-02-25 04:31:37'),
(33, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '015acb8812e0a933da678f149065efb2c218ab8f1da01e50a66cb8cef5fa7db6', '[\"*\"]', '2026-02-25 04:45:47', NULL, '2026-02-25 04:37:38', '2026-02-25 04:45:47'),
(34, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '80a4255862c6132f011e3b2c562d72a38aed9ddfe7c8188af1e4fac898db7fc7', '[\"*\"]', '2026-02-25 04:46:06', NULL, '2026-02-25 04:45:52', '2026-02-25 04:46:06'),
(35, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '4b35b2ea2997a9cfc120e131b2b5c935e22da80626277bdb77c3f14c9b2c5a71', '[\"*\"]', '2026-02-25 04:47:07', NULL, '2026-02-25 04:46:15', '2026-02-25 04:47:07'),
(36, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '16f5b25aa0308acf5e97113709aba2745c6b1df326f39c8bed07d300de45fb23', '[\"*\"]', '2026-02-25 04:47:23', NULL, '2026-02-25 04:47:14', '2026-02-25 04:47:23'),
(37, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ab697c559e2527a8ad98801e5eab4b8aae15be1134b38ed16c0a9ab9db4dbc27', '[\"*\"]', '2026-02-25 04:55:02', NULL, '2026-02-25 04:54:49', '2026-02-25 04:55:02'),
(38, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '27de0723c6a34d8db7213ae6667ddcda7f7204e1dc1d6083429083a62ee875e3', '[\"*\"]', '2026-02-25 04:55:35', NULL, '2026-02-25 04:55:17', '2026-02-25 04:55:35'),
(39, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2ee524fb94e76b59f5d36ffa7b9fcedb61c879734abe551d0c985611f6937d5f', '[\"*\"]', '2026-02-25 05:09:17', NULL, '2026-02-25 04:55:41', '2026-02-25 05:09:17'),
(40, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '8fffb8bc3b6830e04d787f3156300afee004597656ada0a8860b3e7bb5cdbb84', '[\"*\"]', '2026-02-25 05:09:52', NULL, '2026-02-25 05:09:26', '2026-02-25 05:09:52'),
(41, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2bc56e39f4812d815a4929e0050279f7f6ae01b2f2def3656230019af6b992e9', '[\"*\"]', '2026-02-25 05:17:25', NULL, '2026-02-25 05:09:58', '2026-02-25 05:17:25'),
(42, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'd119d298a63e2d09ebe48f4fdac25ba5866290c0a14e0cf53a5a3bf180b9e128', '[\"*\"]', '2026-02-25 05:19:25', NULL, '2026-02-25 05:19:20', '2026-02-25 05:19:25'),
(43, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '3efe5da4a0f73a70acf4759219805383d52bdf91b09c6423d3c13f3a20459e41', '[\"*\"]', '2026-02-25 05:19:35', NULL, '2026-02-25 05:19:29', '2026-02-25 05:19:35'),
(44, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e7a6b7c449f10ff69f11e1d4eab338a461ee69c2539e6b01d200fd8e72ef7200', '[\"*\"]', '2026-02-25 05:28:37', NULL, '2026-02-25 05:20:13', '2026-02-25 05:28:37'),
(45, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'f4830b533c00b802adf288e7d39c8ed9871f6eae69893e37008f1d31988674ad', '[\"*\"]', '2026-02-25 05:29:06', NULL, '2026-02-25 05:28:49', '2026-02-25 05:29:06'),
(46, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '9086a35e71afb112caa7a9a6cd2cf71ab07e9e8a25a95d87075682010a5d6404', '[\"*\"]', '2026-02-25 05:31:53', NULL, '2026-02-25 05:29:15', '2026-02-25 05:31:53'),
(47, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '6a6a95523a39e1bd43c33dc70b4a1a9de9d4b2149ceae188dbf58435bd470f8d', '[\"*\"]', '2026-02-25 05:32:24', NULL, '2026-02-25 05:31:57', '2026-02-25 05:32:24'),
(48, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ff02e0f634ac73e33ef759cc220d21b0e2d1c7ba7da683a8b67eb190aa8c250d', '[\"*\"]', '2026-02-25 05:32:34', NULL, '2026-02-25 05:32:27', '2026-02-25 05:32:34'),
(49, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2501d2616513fe7669cc20cd909bdd76dd02176b735a46a2a4abb109956847f3', '[\"*\"]', '2026-02-25 05:32:50', NULL, '2026-02-25 05:32:39', '2026-02-25 05:32:50'),
(50, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '54e605e94ee675aac35fd695781940b5fd036a7d0c3ed0306d25f2cda9355583', '[\"*\"]', '2026-02-25 05:37:42', NULL, '2026-02-25 05:32:56', '2026-02-25 05:37:42'),
(51, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '7fbf91fc690004605f7b1d00db4043043214858006db2452436f5c8de1566b33', '[\"*\"]', '2026-02-25 05:39:53', NULL, '2026-02-25 05:37:54', '2026-02-25 05:39:53'),
(52, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '16a56e71e2c5247487520f64c4fb10060a1bbb693fd3ae5ef40ca7d69d3d398f', '[\"*\"]', '2026-02-25 05:42:21', NULL, '2026-02-25 05:40:00', '2026-02-25 05:42:21'),
(53, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'a3b738571ae8c6c95843977a2f677bae440a29725053157ae618cf28721265a4', '[\"*\"]', '2026-02-25 05:47:16', NULL, '2026-02-25 05:42:32', '2026-02-25 05:47:16'),
(54, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '2a99b497cd26c2810fa3d18eb641671957e8c7f939805b637abf4096689c2440', '[\"*\"]', '2026-02-25 05:49:41', NULL, '2026-02-25 05:49:28', '2026-02-25 05:49:41'),
(55, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '9b6bb7c3ba470b2ac7b2f9a9f987b5801992fe97c079a01c5bc65e9e051dbe84', '[\"*\"]', '2026-02-25 05:49:59', NULL, '2026-02-25 05:49:46', '2026-02-25 05:49:59'),
(56, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'ea5afb730e05e6ac03bae872169068297150b8bea5705219ee598b0886c3f0f2', '[\"*\"]', '2026-02-25 06:26:15', NULL, '2026-02-25 05:50:06', '2026-02-25 06:26:15'),
(57, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '9b03ac694158485e06c3c5c49870646823095cff08157d56aa5591ded8f94dbb', '[\"*\"]', '2026-02-25 06:32:23', NULL, '2026-02-25 06:26:21', '2026-02-25 06:32:23'),
(58, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '63123de818d3096d811d53cb17dda367b83ac3af2b61fafbc695e76158bee2a0', '[\"*\"]', '2026-02-25 06:32:45', NULL, '2026-02-25 06:32:43', '2026-02-25 06:32:45'),
(59, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '8a54224508001b4dac92f787be659d57328734901f86bba6a7394ad9492635aa', '[\"*\"]', '2026-02-25 06:59:24', NULL, '2026-02-25 06:33:08', '2026-02-25 06:59:24'),
(60, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '951f01ebe6dd94113e2516928bf0cc30dfb6559f115e5f9be5fb8f372ae73f66', '[\"*\"]', '2026-02-25 14:16:04', NULL, '2026-02-25 14:13:03', '2026-02-25 14:16:04'),
(61, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '2016bc03a9418e9b560a42ada455eecc0a4c8a1a227b03705a5cda74a9812169', '[\"*\"]', '2026-02-25 16:15:25', NULL, '2026-02-25 16:15:23', '2026-02-25 16:15:25'),
(62, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '727ef91d245c5d1a09bf029dba1966acbf146070ed7eee96a91995ce5a70893e', '[\"*\"]', '2026-02-25 16:17:27', NULL, '2026-02-25 16:15:31', '2026-02-25 16:17:27'),
(63, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '615143dab245c958fb7c28906d14504ae766fb4a1658c7e0bf6e625cad167ea9', '[\"*\"]', '2026-02-25 16:35:26', NULL, '2026-02-25 16:17:36', '2026-02-25 16:35:26'),
(64, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '235a4e8537a2e067f80443a0015163a9e602fb463d2b3a0465ac550199c54e5e', '[\"*\"]', '2026-02-25 16:59:13', NULL, '2026-02-25 16:59:09', '2026-02-25 16:59:13'),
(65, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '5dc73972818c4cdc7993904db958e443addcb43b50bebb5ed20469dbe43ff03e', '[\"*\"]', '2026-02-25 17:00:14', NULL, '2026-02-25 17:00:11', '2026-02-25 17:00:14'),
(66, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '21b02ea1515cc80d7e0522dddf90b8e78c665a7b80299624e2ef96bd6328971f', '[\"*\"]', '2026-02-26 13:50:47', NULL, '2026-02-26 13:50:39', '2026-02-26 13:50:47'),
(67, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2d5691e30dad0accf8bf1869112e1a26555802d5b8be410845872bb1332769d6', '[\"*\"]', '2026-02-26 13:51:57', NULL, '2026-02-26 13:51:45', '2026-02-26 13:51:57'),
(68, 'App\\Models\\User', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'api-token', 'fd294b53e88d2f74ad43f77b6960cd289a7e60867011017bf38e1a7a7efbf11f', '[\"*\"]', '2026-02-26 14:01:41', NULL, '2026-02-26 14:01:27', '2026-02-26 14:01:41'),
(69, 'App\\Models\\User', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'api-token', '21baa613c6012df9f21254e6a08280ecce910c8cb9d5de045e3d149553a891ed', '[\"*\"]', '2026-02-26 14:01:49', NULL, '2026-02-26 14:01:47', '2026-02-26 14:01:49'),
(70, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '5d7156033e842c7d0e6d0360b38e9c293913c9785edc49fe0d354ed3c3ef08ce', '[\"*\"]', '2026-02-26 14:08:42', NULL, '2026-02-26 14:01:55', '2026-02-26 14:08:42'),
(71, 'App\\Models\\User', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'api-token', 'fc146ade512a63716ca381a0c763ad575e669a5d0f6072c11e8a28ff19343e53', '[\"*\"]', '2026-02-26 14:09:45', NULL, '2026-02-26 14:09:43', '2026-02-26 14:09:45'),
(72, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '382e5825505ebe5ab806ef5a3de4b5700d58338e13b307dd61095337add210eb', '[\"*\"]', '2026-02-26 14:10:01', NULL, '2026-02-26 14:09:59', '2026-02-26 14:10:01'),
(73, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a0d0e9188a6c8eba61c86d83dbb6cbb75e8735d250d38c808daf1f0852c18d78', '[\"*\"]', '2026-02-26 15:13:41', NULL, '2026-02-26 14:10:07', '2026-02-26 15:13:41'),
(74, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '766a56cccc70730bc0973e6f130df70c008e8400432e9e6fffec759c20d1e948', '[\"*\"]', '2026-02-26 15:13:22', NULL, '2026-02-26 15:13:19', '2026-02-26 15:13:22'),
(75, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'ee45293a7d8af0bacdbf7bee4eaca30b15dd9eade8c313151ef958d8b292bfe1', '[\"*\"]', '2026-02-26 15:32:26', NULL, '2026-02-26 15:13:44', '2026-02-26 15:32:26'),
(76, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ce84d91b8f3c994234cc53fce9492c370a259b26cf2d6425af27805df5e9520a', '[\"*\"]', '2026-02-26 16:41:39', NULL, '2026-02-26 16:41:36', '2026-02-26 16:41:39'),
(77, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'be421da03418672c1fed36bbffbd77b327605054910193a7c0533435953f8abd', '[\"*\"]', '2026-02-26 16:53:48', NULL, '2026-02-26 16:41:48', '2026-02-26 16:53:48'),
(78, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'd8e366e2352e45e86f2dd483fcf79670e6d56a5265ad6fd16d1d1221b26f0ade', '[\"*\"]', '2026-02-26 16:54:45', NULL, '2026-02-26 16:54:42', '2026-02-26 16:54:45'),
(79, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '7ebdda24d8755951529d8d679569de9912f0d426c79a92bf6bd3a654620a25e3', '[\"*\"]', '2026-02-26 17:06:51', NULL, '2026-02-26 16:56:07', '2026-02-26 17:06:51'),
(80, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'f05dbb4760ccd023fe5388dd0ae96db0fb4ff6ee00ed4eb6f3c376f21e438364', '[\"*\"]', '2026-02-26 17:07:01', NULL, '2026-02-26 17:06:58', '2026-02-26 17:07:01'),
(81, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '993608ae4bec449f21a572db376112cb82b994cee66ad08f780153cc8828fc78', '[\"*\"]', '2026-02-26 17:07:10', NULL, '2026-02-26 17:07:06', '2026-02-26 17:07:10'),
(82, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '9692464dd4efd864a7cef654c1382515afc1e5e42abca366b7b792730b7fa660', '[\"*\"]', '2026-02-26 17:07:40', NULL, '2026-02-26 17:07:37', '2026-02-26 17:07:40'),
(83, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '11fb77168770b610819ca0a018cd562fdda30e82cd15b3d4274a2d4bb75dcf75', '[\"*\"]', '2026-02-26 17:07:50', NULL, '2026-02-26 17:07:47', '2026-02-26 17:07:50'),
(84, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '8babaee43a4a1a25541531c44bb4459cdca3f0e967c820e51a63e1000e98ceac', '[\"*\"]', '2026-02-26 17:11:15', NULL, '2026-02-26 17:08:08', '2026-02-26 17:11:15'),
(85, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'ec479525f4f2d3ffa10ac5f0b30e0e0c4dc6fb3e3a899d051ee1d08a67988d61', '[\"*\"]', '2026-02-26 17:11:23', NULL, '2026-02-26 17:11:20', '2026-02-26 17:11:23'),
(86, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '65bccf4679c43efd331eebd0772a2b0c0d872cbd276c11c1325a762d0850d2b7', '[\"*\"]', '2026-02-26 17:17:28', NULL, '2026-02-26 17:11:28', '2026-02-26 17:17:28'),
(87, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'b0dbfdb899d735684342a1cb78ece837e66f8b7eef45c291d7ce7ec7b79ad31c', '[\"*\"]', '2026-02-26 17:17:45', NULL, '2026-02-26 17:17:42', '2026-02-26 17:17:45'),
(88, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '049f54a08a073450d7b7d137176d4c6d8968f838c476fcc955f655ce7e4510b6', '[\"*\"]', '2026-02-26 17:18:01', NULL, '2026-02-26 17:17:52', '2026-02-26 17:18:01'),
(89, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'c1ef5ee77f7cee24360277b5985de926e205b0fe85310f78e7136848df144019', '[\"*\"]', '2026-02-26 17:22:37', NULL, '2026-02-26 17:22:34', '2026-02-26 17:22:37'),
(90, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '24ca787e16e798462fc2da6e9b2f2f414fc0248a1d4c721beb679a8eaddc44fa', '[\"*\"]', '2026-02-26 17:23:23', NULL, '2026-02-26 17:23:18', '2026-02-26 17:23:23'),
(91, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '8179f76eaa033f365dd82efbd3dc4f0b94bd577a33e08fb53bab9fdcd68380b8', '[\"*\"]', '2026-02-26 17:23:37', NULL, '2026-02-26 17:23:34', '2026-02-26 17:23:37'),
(92, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '15204e3cabe9709ba9c07de1e96d615d7dc9ad0e27af194421e6bec312ab9673', '[\"*\"]', '2026-02-26 17:23:45', NULL, '2026-02-26 17:23:43', '2026-02-26 17:23:45'),
(93, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '0d6b17ad5bffe28fbd6cbc42f0e139d0d5e508b763324041536a6b9c11109931', '[\"*\"]', '2026-02-26 17:28:07', NULL, '2026-02-26 17:28:04', '2026-02-26 17:28:07'),
(94, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '0df02d0c2ee95b0738e27a22b5c811cd579ea9444d44b09e6bf1b8e749ef6928', '[\"*\"]', '2026-02-26 17:29:52', NULL, '2026-02-26 17:29:38', '2026-02-26 17:29:52'),
(95, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '4f0e78ef56008b88d6bb6952d4b381f2f4977f838c70b5e5f94d25d3991e2f03', '[\"*\"]', '2026-02-26 17:34:05', NULL, '2026-02-26 17:29:59', '2026-02-26 17:34:05'),
(96, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '21dd35504c3dec749799f474e5692cfe14114cdef17b75f8c5841b53737ec7f4', '[\"*\"]', '2026-02-26 17:34:11', NULL, '2026-02-26 17:34:07', '2026-02-26 17:34:11'),
(97, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '8a7f27ce4e3e4d530c99b761f516f00c2daf27bc82cf0dfc3ab7aca9b837fb3b', '[\"*\"]', '2026-02-26 17:34:31', NULL, '2026-02-26 17:34:28', '2026-02-26 17:34:31'),
(98, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '1f257268531857b34f04dc66456002e2e2474ebd4b35ac79c240357028d8ee2d', '[\"*\"]', '2026-02-26 17:34:38', NULL, '2026-02-26 17:34:34', '2026-02-26 17:34:38'),
(99, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '12bafbb732ef6b78fe81986fb751670d985b3ad220543d9582c2f560964b0dfa', '[\"*\"]', '2026-02-26 17:40:25', NULL, '2026-02-26 17:40:21', '2026-02-26 17:40:25'),
(100, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '6521e1b5d02cc6cf3da76adaff7cbe0a553aabdbd88c344810b95fdf6cbb5b28', '[\"*\"]', '2026-02-26 17:47:37', NULL, '2026-02-26 17:47:24', '2026-02-26 17:47:37'),
(101, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '8e48472ceeceb24aaf74d7490d5c9b50a7668329fc7e928aeb256197afb11c12', '[\"*\"]', '2026-02-26 17:48:34', NULL, '2026-02-26 17:48:31', '2026-02-26 17:48:34'),
(102, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '00a1a9734778dd3f55c7ecee69f667cf94902c45252125b753730b1b11a248e0', '[\"*\"]', '2026-02-26 17:48:41', NULL, '2026-02-26 17:48:37', '2026-02-26 17:48:41'),
(103, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '5373fd40fac7a845323d21bc174edf0717f451488d8160c5b78830b3aefccbd5', '[\"*\"]', '2026-02-26 17:49:04', NULL, '2026-02-26 17:49:00', '2026-02-26 17:49:04'),
(104, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e9b9f98c00521a5b55d9fb1aa316a789dc067ac6371577bc715658e68d1b21d1', '[\"*\"]', '2026-02-26 17:49:13', NULL, '2026-02-26 17:49:11', '2026-02-26 17:49:13'),
(105, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '917d9b061fba32fefb4113d9308e2090c5cddd8e2a835a3e59e77467f0e18752', '[\"*\"]', '2026-02-26 17:49:23', NULL, '2026-02-26 17:49:19', '2026-02-26 17:49:23'),
(106, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'd3e122d1d2d87db64a65e53b9e355fde9976df8cb334e56d5ffd5c081ef33cf4', '[\"*\"]', '2026-02-26 17:49:37', NULL, '2026-02-26 17:49:34', '2026-02-26 17:49:37'),
(107, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'f6c6074313fb52f99cc675fa4cffcbfdbc1ded5dd184fa3082f994c09df355f7', '[\"*\"]', '2026-02-26 17:49:46', NULL, '2026-02-26 17:49:42', '2026-02-26 17:49:46'),
(108, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '286033b365e5470eb4d7ca9e689768de946fb2ad4f7aa24ff28d1e6bedf73dde', '[\"*\"]', '2026-02-26 17:50:59', NULL, '2026-02-26 17:50:56', '2026-02-26 17:50:59'),
(109, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '93998769dba9070523039cae4d2b74d277730071dbdf4387f9d344d00a8329c0', '[\"*\"]', '2026-02-26 17:54:10', NULL, '2026-02-26 17:54:06', '2026-02-26 17:54:10'),
(110, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '6cb1c564c06be16bca96867ddc8ed3f9127832abbdbd8a8081a10ca107c22ad1', '[\"*\"]', '2026-02-26 17:54:39', NULL, '2026-02-26 17:54:34', '2026-02-26 17:54:39'),
(111, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '91456c3272ce61978e83090d6f0cad2f681e1f666450d40016befed689154b4d', '[\"*\"]', '2026-02-26 17:54:45', NULL, '2026-02-26 17:54:42', '2026-02-26 17:54:45'),
(112, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '4a1d8d0ac042d0986197e5bf095c529adf3085dbff3f6c90e0de2d56b4a3752a', '[\"*\"]', '2026-02-26 17:57:25', NULL, '2026-02-26 17:57:23', '2026-02-26 17:57:25'),
(113, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '6bca96c72743054ac9df3d8d0bb212846d937cadf80b49347dd4babef8543e3f', '[\"*\"]', '2026-02-26 18:23:09', NULL, '2026-02-26 17:58:00', '2026-02-26 18:23:09'),
(114, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '898aa38f72089aaa163aa961a80d04f30499bdc52881151c39978f6fb431bf49', '[\"*\"]', '2026-02-26 18:23:49', NULL, '2026-02-26 18:23:46', '2026-02-26 18:23:49'),
(115, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a6929df7dcbc6596b3635db40701a60fcc3fe6cc25eadd087d9f12fd238c0088', '[\"*\"]', '2026-02-26 18:24:05', NULL, '2026-02-26 18:24:02', '2026-02-26 18:24:05'),
(116, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'fe22f4b360b77d96cb971d31661ae85c1ce01d8e4b056f414803b94369e3c566', '[\"*\"]', '2026-02-26 18:25:12', NULL, '2026-02-26 18:25:09', '2026-02-26 18:25:12'),
(117, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2d47d4b2f89c6e327344636ba9eccb035c9a52d4987a012fa26c7949216ea207', '[\"*\"]', '2026-02-26 18:30:16', NULL, '2026-02-26 18:25:23', '2026-02-26 18:30:16'),
(118, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'cc74053d02afb376f7fd89d50b896899fc50325bf2ed5f881092141ce7bbc317', '[\"*\"]', '2026-02-26 18:34:20', NULL, '2026-02-26 18:30:33', '2026-02-26 18:34:20'),
(119, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '7aae8a11fc91f2b02bcc386fce8f9be5ad4474b9ff966ec27b82a090a3bd1d8f', '[\"*\"]', '2026-02-26 18:34:45', NULL, '2026-02-26 18:34:24', '2026-02-26 18:34:45'),
(120, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'ba37211759b2788a2cfafbbb0ef69e100a9b768ae22b991153fbf9e8cfbe7eb5', '[\"*\"]', '2026-02-26 18:35:12', NULL, '2026-02-26 18:35:09', '2026-02-26 18:35:12'),
(121, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'fbd9f4238937c4480bcdfbc9b5095cb74c669cef26bfb6410716425e044c46f9', '[\"*\"]', '2026-02-26 18:35:34', NULL, '2026-02-26 18:35:31', '2026-02-26 18:35:34'),
(122, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e502caee9ba97716124eeb83c10d666b1f8840b34ddfc11885413f1ea0090bb8', '[\"*\"]', '2026-02-26 18:35:43', NULL, '2026-02-26 18:35:40', '2026-02-26 18:35:43'),
(123, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '38b22dd09b23109e1f9c3190a2be107b39df923f0feec198cf9d5f1559cdec4f', '[\"*\"]', '2026-02-26 18:35:48', NULL, '2026-02-26 18:35:45', '2026-02-26 18:35:48'),
(124, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2ad6c586d19f26aa21b84d16154e70c0e98cec0e21c95758290661035fd0d2e3', '[\"*\"]', '2026-02-26 18:36:46', NULL, '2026-02-26 18:36:06', '2026-02-26 18:36:46'),
(125, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'cbc8eefdfa9516e626feed35712fb555c10c4bc9a181745786dbaa7024c60045', '[\"*\"]', '2026-02-26 18:36:50', NULL, '2026-02-26 18:36:47', '2026-02-26 18:36:50'),
(126, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '963a702828b6750acfaaae5276160f54c0bd108cd16b7def84e42b59299a2170', '[\"*\"]', '2026-02-26 18:37:09', NULL, '2026-02-26 18:37:06', '2026-02-26 18:37:09'),
(127, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e11d254ed335895e084bb5eefea74fa7dfcf412c9f107c77ded63607f196ff2e', '[\"*\"]', '2026-02-26 18:42:21', NULL, '2026-02-26 18:42:17', '2026-02-26 18:42:21'),
(128, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '00fcb9fd8b76a94a6963d53fe12c3a5247ff1a3f65fba3e211703654a8cd8ce6', '[\"*\"]', '2026-02-26 18:42:50', NULL, '2026-02-26 18:42:47', '2026-02-26 18:42:50'),
(129, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '39e4cc74db5b0260d7766ac0fa036e428c9072f3cb76d54e5f9fe41f36bc445a', '[\"*\"]', '2026-02-26 18:43:05', NULL, '2026-02-26 18:43:03', '2026-02-26 18:43:05'),
(130, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '20211e018ca66514c47b28911112950c44a3660fc3e0903c11e3361ad93e03cc', '[\"*\"]', '2026-02-26 18:43:30', NULL, '2026-02-26 18:43:27', '2026-02-26 18:43:30'),
(131, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'ac9cd70f46bd6ec4d3398a10c871bdd75aa8b7af4bb08e645a6c2bfa94fb9b28', '[\"*\"]', '2026-02-26 18:43:36', NULL, '2026-02-26 18:43:33', '2026-02-26 18:43:36'),
(132, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '8a28115c382897046720d24e5460823f6c7add0fc8d211acb39b1d2aadc12add', '[\"*\"]', '2026-02-26 18:58:09', NULL, '2026-02-26 18:43:52', '2026-02-26 18:58:09'),
(133, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '66d12741654fa8044bc610d888c83b22cbdb527440540485fd57cf461079cbe4', '[\"*\"]', '2026-02-26 19:02:43', NULL, '2026-02-26 18:58:23', '2026-02-26 19:02:43'),
(134, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '544f3f497dde047f87b94dbe826dd1a0bc4eaad3137a066227f5d5164908e7b9', '[\"*\"]', '2026-02-26 19:03:02', NULL, '2026-02-26 19:02:49', '2026-02-26 19:03:02'),
(135, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '8bb3f67ffedbf08d6f14cbea1024bac6f39ec743ff9a1b0680c38ddadea32065', '[\"*\"]', '2026-02-27 12:03:29', NULL, '2026-02-27 11:54:32', '2026-02-27 12:03:29'),
(136, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ac875686ca36276853a89325947975bfce69eceb7850c3f284b7c5f42bfa8eaf', '[\"*\"]', '2026-02-27 12:03:44', NULL, '2026-02-27 12:03:37', '2026-02-27 12:03:44'),
(137, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '7b3fb8a097835b3c3ee87863cb0f3104ac5c71b5af9976fb4853152e363c7e59', '[\"*\"]', '2026-02-27 12:14:55', NULL, '2026-02-27 12:04:03', '2026-02-27 12:14:55'),
(138, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '39ddedb143595ba0005d849bf72bff46a430aeda23fcdd9c754e121b6ce07eff', '[\"*\"]', '2026-02-27 12:18:17', NULL, '2026-02-27 12:15:05', '2026-02-27 12:18:17'),
(139, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'fd7f178a5c2a900354c172a1e72fb8ecaad825f75f047d0bb70d956185a33251', '[\"*\"]', '2026-02-27 12:19:05', NULL, '2026-02-27 12:18:49', '2026-02-27 12:19:05'),
(140, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '820a1fc9dbdb7f9d1c234b92ad3eaf7a61c91ea31684e0130e6a7b2689acf37d', '[\"*\"]', '2026-02-27 12:24:46', NULL, '2026-02-27 12:24:12', '2026-02-27 12:24:46'),
(141, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '56d63699bcc7f085a758efb12a23a25690b365e5e206a7c5a4ac9de280f01ab0', '[\"*\"]', '2026-02-27 12:26:47', NULL, '2026-02-27 12:26:43', '2026-02-27 12:26:47'),
(142, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '61ee06ca8973ca875218ed6afb09e14858b3ccab17dfd9f37c16d806f40b955c', '[\"*\"]', '2026-02-27 12:27:21', NULL, '2026-02-27 12:27:03', '2026-02-27 12:27:21'),
(143, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '4e0dce579f53742495d4d80b8673347a81e769d675e4bf48ebb5bb80878812ff', '[\"*\"]', '2026-02-27 13:23:26', NULL, '2026-02-27 12:34:01', '2026-02-27 13:23:26'),
(144, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'a1a9eeb7fa70b285b2f7ee046ff0ecaa4f1848b09664e23adb54e45109faecb1', '[\"*\"]', '2026-02-27 15:18:55', NULL, '2026-02-27 15:18:20', '2026-02-27 15:18:55'),
(145, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2ea7298a106b79ee9eb5146aaea49fd772d804ef1502ad5bbbabd32cbacb2f4c', '[\"*\"]', '2026-02-27 15:22:36', NULL, '2026-02-27 15:20:15', '2026-02-27 15:22:36'),
(146, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'a32de7840f9c1e9262b1c891d063ad2e52a6f5afda1e66f77bef088f2ec3c7b9', '[\"*\"]', '2026-02-27 15:49:33', NULL, '2026-02-27 15:36:34', '2026-02-27 15:49:33'),
(147, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'cd838ed5d137fb63f4eb2d2d5aaa1743ed500ae3fe8e6e190fd7d85e42128062', '[\"*\"]', '2026-02-27 19:26:22', NULL, '2026-02-27 19:26:19', '2026-02-27 19:26:22'),
(148, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '3ca58e9fe6401d9e8fec8f73eb8b90e45fbedbde117feba7e552f95e2a50ec54', '[\"*\"]', '2026-02-28 06:22:01', NULL, '2026-02-28 06:21:58', '2026-02-28 06:22:01'),
(149, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'a8c43770ef6f7c8d7739d80f828cc7602e15d7246ed98e89b38fa6df1a601579', '[\"*\"]', NULL, NULL, '2026-02-28 06:21:59', '2026-02-28 06:21:59'),
(150, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '46297925701117e9f68c35cc206eacc7118bc8d4758ffc4092fd38131614ec2b', '[\"*\"]', '2026-02-28 06:23:07', NULL, '2026-02-28 06:22:09', '2026-02-28 06:23:07'),
(151, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'e8f79d21eef84510651c7b1ff2975ecac2e94518f2c70045a94530a8c8d048dd', '[\"*\"]', '2026-02-28 06:24:03', NULL, '2026-02-28 06:23:11', '2026-02-28 06:24:03'),
(152, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'fedf3af611c97a58ef6299a13f0f0a951ffa62cdb8108a465a9e4f5a6e0c2008', '[\"*\"]', '2026-02-28 06:24:31', NULL, '2026-02-28 06:24:08', '2026-02-28 06:24:31'),
(153, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'c39907b9bf5346f6774b25d98d5946ef124921367e143cb14677ad47ae65c156', '[\"*\"]', '2026-02-28 06:25:26', NULL, '2026-02-28 06:24:50', '2026-02-28 06:25:26'),
(154, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '30266d12c18a603177e8464ca74680395e408253c73aa120b998c9da68eca8a4', '[\"*\"]', '2026-02-28 06:35:59', NULL, '2026-02-28 06:25:30', '2026-02-28 06:35:59'),
(155, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '5c614c600489026b773cf5fe589271ef6221c294f20c587930d491dca6f545a9', '[\"*\"]', '2026-02-28 06:36:22', NULL, '2026-02-28 06:36:09', '2026-02-28 06:36:22'),
(156, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '3f104b212a4c23ea71853ca76e3a2ea121493f7ea70fc3346e55d9b1811ccb6f', '[\"*\"]', '2026-02-28 06:47:59', NULL, '2026-02-28 06:38:56', '2026-02-28 06:47:59'),
(157, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '65c1c48099b85f74a091b16dfed671a1672e20d4ff01b8237605ee5882aff7d4', '[\"*\"]', '2026-02-28 06:48:50', NULL, '2026-02-28 06:48:28', '2026-02-28 06:48:50'),
(158, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'acaf5e286488f2bc3c75c9faeab1a9ad5597dea005a190b40bd31f5a5888a3b8', '[\"*\"]', '2026-02-28 06:55:37', NULL, '2026-02-28 06:48:56', '2026-02-28 06:55:37'),
(159, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'dc9eb6f11cd836bc03fcff2e09a47665aeb337046461f571463848fafbb595ec', '[\"*\"]', '2026-02-28 08:09:19', NULL, '2026-02-28 08:08:33', '2026-02-28 08:09:19'),
(160, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e83b9509a673d0a1f50fd38db28e88d6efd3fdbb1124ac476084e281a795f13a', '[\"*\"]', '2026-02-28 08:17:42', NULL, '2026-02-28 08:12:24', '2026-02-28 08:17:42'),
(161, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '8aa744648c958da4ecb37ac385c8812f20ac80121c22438a4177d4dfb32368c2', '[\"*\"]', '2026-02-28 08:36:52', NULL, '2026-02-28 08:18:00', '2026-02-28 08:36:52'),
(162, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2a976a228ee7753287eff1fc4f3e6a0b8d215f0429ae60a4f4509de81c7b92a3', '[\"*\"]', '2026-02-28 08:38:04', NULL, '2026-02-28 08:37:20', '2026-02-28 08:38:04'),
(163, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a8ab23d8ed918f51b1be1625a6e6c64e2393aeb98d00ddae48e626cd8fd7dba4', '[\"*\"]', '2026-02-28 08:39:18', NULL, '2026-02-28 08:38:09', '2026-02-28 08:39:18'),
(164, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '9ab640fbf1c12b63d57a5e133f15eccb48db82af80afd87e8499f09ed5988d35', '[\"*\"]', '2026-02-28 08:44:00', NULL, '2026-02-28 08:39:32', '2026-02-28 08:44:00'),
(165, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '7b8d7272d77ded30ebb4859e408bc5e059441eaa9f1830e3da4fc57c3bc6a2dd', '[\"*\"]', '2026-02-28 08:45:09', NULL, '2026-02-28 08:44:29', '2026-02-28 08:45:09'),
(166, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '4181976c58deb3870cc8d2a76123933eb6f16780d760139c4d21113005932dc0', '[\"*\"]', '2026-02-28 08:45:28', NULL, '2026-02-28 08:45:22', '2026-02-28 08:45:28'),
(167, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e451c7962fbc6bafe6c0b75c97626467db97d68a16061a5065bb1c5513854cde', '[\"*\"]', '2026-02-28 09:29:53', NULL, '2026-02-28 09:29:49', '2026-02-28 09:29:53'),
(168, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'bb85996be249e4271e6a575e48a281de6f79b0cbff9a2357d9357152fcc89e24', '[\"*\"]', '2026-02-28 09:31:08', NULL, '2026-02-28 09:30:09', '2026-02-28 09:31:08'),
(169, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '5dd67d44740c469c0be7ade99c2690613f44c07b9206d69b780ff436a0ecd08f', '[\"*\"]', '2026-02-28 09:41:37', NULL, '2026-02-28 09:31:15', '2026-02-28 09:41:37'),
(170, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e146c05c46c8858b43d6210bf45ea56303694aa43fa76694da22587174bfa501', '[\"*\"]', '2026-02-28 09:41:49', NULL, '2026-02-28 09:41:44', '2026-02-28 09:41:49'),
(171, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '9965ae501c5073aa71984382cbf7320553ef39508e5ff929e0d41462c97660d4', '[\"*\"]', '2026-02-28 09:42:53', NULL, '2026-02-28 09:42:16', '2026-02-28 09:42:53'),
(172, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '64eba286ca49c52aa131bd339148b05199d8fff30f277b49cc89a5846e10a62a', '[\"*\"]', '2026-02-28 09:57:32', NULL, '2026-02-28 09:46:19', '2026-02-28 09:57:32'),
(173, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '42367682a1a8ff4d02bc2d4602e95e1fd87745ec722deeed9dd13a790fdef180', '[\"*\"]', '2026-02-28 09:57:42', NULL, '2026-02-28 09:57:37', '2026-02-28 09:57:42'),
(174, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '466733cfb8f1bca7fe61fe4f1ef7047504b2201877b75597e17604db204be4fa', '[\"*\"]', '2026-02-28 09:57:53', NULL, '2026-02-28 09:57:48', '2026-02-28 09:57:53'),
(175, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '2a0f7eb5c94eaa1ed20c048c7fa68958805e38a2488b4962f2076f7925938aa9', '[\"*\"]', '2026-02-28 10:12:31', NULL, '2026-02-28 09:57:54', '2026-02-28 10:12:31'),
(176, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'ef4aad497623f8a801c878009a0451faf9d4bb6ccdb73a7189230aed54c65241', '[\"*\"]', '2026-02-28 14:45:35', NULL, '2026-02-28 14:34:24', '2026-02-28 14:45:35'),
(177, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'ce5d60b07f92b26c7e049f0162b2a8bc6c1a17618a33d32392c69a82f1ad8bc3', '[\"*\"]', '2026-02-28 14:45:51', NULL, '2026-02-28 14:45:47', '2026-02-28 14:45:51'),
(178, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'db745fa46425969f655e4984c6c73c6218e18054a5b72b0f5855e95fcf1a73d3', '[\"*\"]', '2026-02-28 14:45:57', NULL, '2026-02-28 14:45:51', '2026-02-28 14:45:57'),
(179, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'a015aff3f73ff1559a1564d16c4e2cbfb688fe3c5f720aee475595a0cbcfa684', '[\"*\"]', '2026-02-28 14:47:03', NULL, '2026-02-28 14:46:09', '2026-02-28 14:47:03'),
(180, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '91813974129ac96cbcff1cabb6c355ad595a73d49efc165acfae39ecc8dfc071', '[\"*\"]', '2026-02-28 14:51:42', NULL, '2026-02-28 14:47:23', '2026-02-28 14:51:42'),
(181, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '08a502deb07d1fe424a2587eb068c4a95254d3c9c23d49d4bece48ab1b17724c', '[\"*\"]', '2026-02-28 15:02:17', NULL, '2026-02-28 14:51:48', '2026-02-28 15:02:17'),
(182, 'App\\Models\\User', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'api-token', 'd2081096b980e40736ae3a227a5246a4c29502e4bfa5b899e5cf5d8e0ce77e3a', '[\"*\"]', '2026-02-28 15:05:20', NULL, '2026-02-28 15:02:47', '2026-02-28 15:05:20'),
(183, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'bb38270d30ddb39623cac4deb3a027b583535abc1dec5fe11380594555070073', '[\"*\"]', '2026-02-28 17:49:01', NULL, '2026-02-28 17:47:17', '2026-02-28 17:49:01'),
(184, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a498073319d525dd04d022ed01c72f13e5612579a02a5e5cab875feb715fb93b', '[\"*\"]', '2026-02-28 18:36:58', NULL, '2026-02-28 17:49:09', '2026-02-28 18:36:58'),
(185, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '3a204023925ca05e54e7a16e12d2ce7c5957f4a15cd74c8d76587acce22d8b9b', '[\"*\"]', '2026-03-01 07:10:03', NULL, '2026-03-01 05:51:15', '2026-03-01 07:10:03'),
(186, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '97eb4b25b4c047e64cd781a665ae2145aa3ac2b1ec5a9bb1de70877622a92d82', '[\"*\"]', '2026-03-01 08:21:58', NULL, '2026-03-01 08:09:11', '2026-03-01 08:21:58'),
(187, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '59d7574213f9c7b401bb024ed794e28b59fef61d3c93e16d199be8d3cf05cfe9', '[\"*\"]', '2026-03-01 09:23:33', NULL, '2026-03-01 09:20:06', '2026-03-01 09:23:33'),
(188, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '231fa2c5088c6cf60849f3d40aa3c16af457b10965f12e61b107ac6716cf6643', '[\"*\"]', '2026-03-01 09:31:16', NULL, '2026-03-01 09:23:35', '2026-03-01 09:31:16'),
(189, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '7520e0e07a65de42cdc818d9e61c2f72f3713e5bf331f957a6cda32d6058288c', '[\"*\"]', '2026-03-01 09:23:55', NULL, '2026-03-01 09:23:51', '2026-03-01 09:23:55'),
(190, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '0f56fc8d6f9912d6fe6e1049804fb2342a1e6e238e4e6e1162e3464c351b13f7', '[\"*\"]', '2026-03-01 14:51:12', NULL, '2026-03-01 14:47:21', '2026-03-01 14:51:12'),
(191, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'af00c57d71651f1a2491ada4108498a310e4bae21b081f7e33c12bef9d9b0b00', '[\"*\"]', '2026-03-01 14:51:41', NULL, '2026-03-01 14:51:21', '2026-03-01 14:51:41'),
(192, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'c498023b8ae76d6a2ab8600ee9ac998f0e4c8a92fe2e606747f8635c61ee859f', '[\"*\"]', '2026-03-01 14:55:58', NULL, '2026-03-01 14:51:48', '2026-03-01 14:55:58'),
(193, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '374351b4b87606a1dcb13f93ffed82fa3d1e31512c57e21c29f5ea20ffc1abe5', '[\"*\"]', '2026-03-01 14:56:15', NULL, '2026-03-01 14:56:01', '2026-03-01 14:56:15'),
(194, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a3aff26c15c7b5245df4ba830e57a56a3f50a1a07cb2abdb0f5c6eb1b1e1927c', '[\"*\"]', '2026-03-01 15:02:48', NULL, '2026-03-01 14:56:30', '2026-03-01 15:02:48'),
(195, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '222e4695def387d3301f37f5b8be434415ea4fd417163e0e7e57f2f2a2bf3f1c', '[\"*\"]', '2026-03-01 15:03:43', NULL, '2026-03-01 15:03:21', '2026-03-01 15:03:43'),
(196, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'd4decea18c6111cf03ff3b9d37ea4859325f16872c929ee75678a1f91fd1d233', '[\"*\"]', '2026-03-01 15:14:22', NULL, '2026-03-01 15:03:54', '2026-03-01 15:14:22'),
(197, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '8512484ce4e01aa6b51759b1be8f6d2350a3c9d3217f0cc535a191888da8cf42', '[\"*\"]', '2026-03-01 15:14:33', NULL, '2026-03-01 15:14:29', '2026-03-01 15:14:33'),
(198, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'fdd9bbb4000554a58527ec93b2d061c832e1e18d5cfb603c482cf8a693bb025e', '[\"*\"]', '2026-03-01 15:14:42', NULL, '2026-03-01 15:14:37', '2026-03-01 15:14:42'),
(199, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '6c7bfa49e6fc972e2e64b4e4ba1b04089d9019096a2a90a85270732d855ea81b', '[\"*\"]', '2026-03-01 15:18:22', NULL, '2026-03-01 15:18:11', '2026-03-01 15:18:22'),
(200, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'b3feea71f27aece1eac8510941c4f5b0f652628eed703a11d66fd46c9dc10b8e', '[\"*\"]', '2026-03-01 15:22:31', NULL, '2026-03-01 15:18:28', '2026-03-01 15:22:31'),
(201, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '0ffb97d9bec94428c586517b51421eaaed8a277d5fa2ecbaf6acb696a839284f', '[\"*\"]', '2026-03-01 15:31:01', NULL, '2026-03-01 15:22:37', '2026-03-01 15:31:01'),
(202, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '1b6482b2c0aa6cdd26a43fcb114b9614857ed586c79d88e060c06415da48eab8', '[\"*\"]', '2026-03-01 15:35:44', NULL, '2026-03-01 15:31:25', '2026-03-01 15:35:44'),
(203, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '6e4532c1eedc618ea7ccf6c783fce22add56a12bb0c110c5f7da4ccc0c8b66a9', '[\"*\"]', '2026-03-01 15:36:14', NULL, '2026-03-01 15:35:58', '2026-03-01 15:36:14'),
(204, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a9b1844cb1b942d47ebc7b68a134466a5f6d2dea6d42eb173dc91aa827f83b0e', '[\"*\"]', '2026-03-01 15:41:26', NULL, '2026-03-01 15:36:29', '2026-03-01 15:41:26'),
(205, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '6c68e1b2f0dfc0a6a61e9aa0a03f28342acfce518cc4ba8e986d3506bebc4043', '[\"*\"]', '2026-03-01 15:45:37', NULL, '2026-03-01 15:41:32', '2026-03-01 15:45:37'),
(206, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'd3e1f55741ddd82fa4afab75c71373b0ee8eac826b966685297dedc1d357e341', '[\"*\"]', '2026-03-01 15:49:36', NULL, '2026-03-01 15:45:42', '2026-03-01 15:49:36'),
(207, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '8a5ce4500df75a924980596cf0af7af7b658aee460214881e6d1802c1fbbe689', '[\"*\"]', '2026-03-01 15:50:06', NULL, '2026-03-01 15:49:55', '2026-03-01 15:50:06'),
(208, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'a51b85c1951753ee0e3010dc6edf0e4c73ab06753fc20f6d133e9f91bae68879', '[\"*\"]', '2026-03-01 16:31:20', NULL, '2026-03-01 16:02:57', '2026-03-01 16:31:20'),
(209, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'c23fa09b80669aa831fdf56de6462f352e2c9fd81aca7f43c72f05e85166c37c', '[\"*\"]', '2026-03-01 16:31:40', NULL, '2026-03-01 16:31:31', '2026-03-01 16:31:40'),
(210, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '17d9eafafb0ca9b90f52f3006a74d5110b76471d2c196d84037c2f6e41f6fd81', '[\"*\"]', '2026-03-01 19:26:09', NULL, '2026-03-01 19:25:55', '2026-03-01 19:26:09'),
(211, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'e14dbbb0a83b5ff6cf7061ea5586a52d2b52c82eeb04a0dd4d64e9aa295310b4', '[\"*\"]', '2026-03-02 03:33:09', NULL, '2026-03-02 03:33:04', '2026-03-02 03:33:09'),
(212, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '113fbfc8b1932a8e6aaf05efab2b416ccc6da0da197ddab82ca868cd6d6e95e0', '[\"*\"]', '2026-03-02 04:03:16', NULL, '2026-03-02 04:00:46', '2026-03-02 04:03:16'),
(213, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '93e34df8f32197bcf6573f4f4f78787cac647cd629cf2f8e99a420b600ecdfa3', '[\"*\"]', '2026-03-02 04:03:43', NULL, '2026-03-02 04:03:36', '2026-03-02 04:03:43'),
(214, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'ab890f1019c38fb791454764901552c022c39b37e21310d0adfe10116140850d', '[\"*\"]', '2026-03-02 04:08:18', NULL, '2026-03-02 04:08:13', '2026-03-02 04:08:18');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(215, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'b2013d3f98f5d6e97755643678d28289906858cbbe7740465e1a15251d772f29', '[\"*\"]', '2026-03-02 04:09:17', NULL, '2026-03-02 04:08:22', '2026-03-02 04:09:17'),
(216, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'b7ba27ea3485db95945d0adb301211212643318ce59c0ca32610d9a2af5f2ad0', '[\"*\"]', '2026-03-02 04:09:37', NULL, '2026-03-02 04:09:31', '2026-03-02 04:09:37'),
(217, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'c7f55f1005acd3d978a0b66ece753acac9adf24e60e08ba2f6af8244adc512c8', '[\"*\"]', '2026-03-02 04:11:04', NULL, '2026-03-02 04:10:54', '2026-03-02 04:11:04'),
(218, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '999a38ffe7d971c75fc11073cb6138fed01b047e88e35957b789a8fa562e6748', '[\"*\"]', '2026-03-02 04:11:20', NULL, '2026-03-02 04:11:12', '2026-03-02 04:11:20'),
(219, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '71853417e98bf3a13934b6dc3b560e16a08494eebb46b19b257f00b4617090e2', '[\"*\"]', '2026-03-02 04:12:41', NULL, '2026-03-02 04:11:45', '2026-03-02 04:12:41'),
(220, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'c85e94c0b35e0ecfb980f5c458840a546c38d2c8bfa88deae3c6a150cdb08973', '[\"*\"]', '2026-03-02 04:13:14', NULL, '2026-03-02 04:12:47', '2026-03-02 04:13:14'),
(221, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'ac5e5255218112eca1844da8d52e06355c51e1a02eec0df8b2179489464daee7', '[\"*\"]', '2026-03-02 04:24:58', NULL, '2026-03-02 04:14:13', '2026-03-02 04:24:58'),
(222, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '524a0390152c6de22a76b350b11a675a76e91131075314197c1ea8b77782a116', '[\"*\"]', '2026-03-02 04:45:09', NULL, '2026-03-02 04:44:35', '2026-03-02 04:45:09'),
(223, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2a9599f022554eba8697a19c4edc7b31bab68617fdce8d60ec40c13e7dbf851f', '[\"*\"]', '2026-03-02 04:55:42', NULL, '2026-03-02 04:55:33', '2026-03-02 04:55:42'),
(224, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '313aed6ecf7f1068d7be52917c99316a038debad0edfa3c855842466e79fee22', '[\"*\"]', '2026-03-02 04:55:57', NULL, '2026-03-02 04:55:52', '2026-03-02 04:55:57'),
(225, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'fc872dc533caea7cbaee8865784a8e11fa87a848ac32a9eabeacd78c64b169ab', '[\"*\"]', '2026-03-02 05:49:52', NULL, '2026-03-02 05:04:08', '2026-03-02 05:49:52'),
(226, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '20137241a3718d46d13ef6f23deb7cb7bf4a8bbc2a68f337ebbe3b30899d734a', '[\"*\"]', '2026-03-02 05:45:22', NULL, '2026-03-02 05:16:33', '2026-03-02 05:45:22'),
(227, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '4ef10cdfa1ce4a3c701c1817f2e7e3b0d894ab8f5bce968f1a590ad9b32c746f', '[\"*\"]', '2026-03-04 09:35:43', NULL, '2026-03-04 09:17:20', '2026-03-04 09:35:43'),
(228, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', '5b632495c9f16f7b120982b510a98b83ac32785c3328e98d5eed0b5e6bef8619', '[\"*\"]', '2026-03-04 12:59:20', NULL, '2026-03-04 12:58:31', '2026-03-04 12:59:20'),
(229, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '2ecf350c2096002d543d66999cb1593d41bad2e504d752022bc6864ae78450b6', '[\"*\"]', '2026-03-04 13:19:51', NULL, '2026-03-04 13:19:20', '2026-03-04 13:19:51'),
(230, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'fd189cf48cc6e3e188a1875ad07dc367e895d9d3d8e96bc95eae3b614d40bd6e', '[\"*\"]', '2026-03-04 13:22:12', NULL, '2026-03-04 13:19:53', '2026-03-04 13:22:12'),
(231, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '230942b68920084cdf4082c4b2bd20a186d13e3fac09a4be739390775255861c', '[\"*\"]', '2026-03-04 13:24:47', NULL, '2026-03-04 13:24:43', '2026-03-04 13:24:47'),
(232, 'App\\Models\\User', 'a12535dd-8f69-439f-a280-eadcdd9af659', 'api-token', '8afbb378f134d994feaaae2771831efd1a776975e496aaf1671fee8c8645e15f', '[\"*\"]', '2026-03-04 13:24:57', NULL, '2026-03-04 13:24:54', '2026-03-04 13:24:57'),
(233, 'App\\Models\\User', 'a12535dd-8c12-429a-a97c-2e727ac15071', 'api-token', 'c8296f179fd38879f2d8575d0cbdef3ebb8ad28c2e80868bff801b66a3de6b4a', '[\"*\"]', '2026-03-04 13:25:10', NULL, '2026-03-04 13:25:06', '2026-03-04 13:25:10'),
(234, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '55945faede686368e98b861a5091554e7836b95a81fa296007b9089368c62b47', '[\"*\"]', '2026-03-04 13:26:30', NULL, '2026-03-04 13:26:19', '2026-03-04 13:26:30'),
(235, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', 'a01b9a629e3d92f36817febae96b53bce7b65d23939a450cfaa4f74ddb3d9c3c', '[\"*\"]', '2026-03-04 14:38:26', NULL, '2026-03-04 14:38:20', '2026-03-04 14:38:26'),
(236, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '1f29afe37608be81bce126fb04a825c24bf9a4b1e9e3d4c7046cdc03c5d51c8f', '[\"*\"]', '2026-03-04 14:38:34', NULL, '2026-03-04 14:38:30', '2026-03-04 14:38:34'),
(237, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '832417ba92903fc56648e7e177d64f71f366ae74bc92647e8e822d86b531e591', '[\"*\"]', '2026-03-04 14:38:45', NULL, '2026-03-04 14:38:41', '2026-03-04 14:38:45'),
(238, 'App\\Models\\User', 'a12535dd-84fe-436e-b02e-a83a458891f1', 'api-token', '9a6a3950a6ce8d1cb61bcc05d356701521e46829d3b74f7d9c7656edeb297a5f', '[\"*\"]', '2026-03-04 14:42:53', NULL, '2026-03-04 14:38:58', '2026-03-04 14:42:53'),
(239, 'App\\Models\\User', 'a1382248-28ea-4159-b91c-258cd1eb71b5', 'api-token', '8bc6c35c7bb9d339269d2aa4d9b8e2dfc7fc74af9933484b839faf6adce45a56', '[\"*\"]', '2026-03-04 14:44:33', NULL, '2026-03-04 14:44:13', '2026-03-04 14:44:33'),
(240, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'a6e95c2c1a621e2b45a07d87922d356f527fd4a41dc03f703ac4acc151ef6a88', '[\"*\"]', '2026-03-04 15:08:02', NULL, '2026-03-04 15:07:18', '2026-03-04 15:08:02'),
(241, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '85dcc27276f6dfbc96cd38c9b93ce890497b60d198e1cda5005e61731bf87fd0', '[\"*\"]', '2026-03-04 15:33:17', NULL, '2026-03-04 15:08:34', '2026-03-04 15:33:17'),
(242, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '7b880016e1adb6331fbe9b6eb0d238a7f952cc13ccaf9280416ef37e1b6bf9ab', '[\"*\"]', '2026-03-04 15:50:12', NULL, '2026-03-04 15:38:33', '2026-03-04 15:50:12'),
(243, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', '8fedb31bb830790322b11a9fe4783b7b5c1038f811303041b7381f95afcb8eb0', '[\"*\"]', '2026-03-04 18:43:51', NULL, '2026-03-04 18:15:15', '2026-03-04 18:43:51'),
(245, 'App\\Models\\User', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', 'api-token', 'e3d95514dc603a373e7c05cffbd0f11f5704f6648dcdf78705202793e313c317', '[\"*\"]', '2026-03-04 18:50:01', NULL, '2026-03-04 18:49:48', '2026-03-04 18:50:01');

-- --------------------------------------------------------

--
-- Table structure for table `plan_line_items`
--

CREATE TABLE `plan_line_items` (
  `id` char(36) NOT NULL,
  `budget_category_id` char(36) NOT NULL,
  `support_item_id` char(36) NOT NULL,
  `allocated_units` decimal(10,2) UNSIGNED NOT NULL,
  `allocated_amount_cents` bigint(20) UNSIGNED NOT NULL,
  `used_units` decimal(10,2) UNSIGNED NOT NULL DEFAULT 0.00,
  `used_amount_cents` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plan_line_items`
--

INSERT INTO `plan_line_items` (`id`, `budget_category_id`, `support_item_id`, `allocated_units`, `allocated_amount_cents`, `used_units`, `used_amount_cents`, `is_active`, `created_at`, `updated_at`) VALUES
('a12535dd-2a83-4a26-95e5-3cde3e081988', 'a12535dd-28f0-4e4b-b5f4-80a268d7879e', 'a12535db-a649-4445-a01e-45e0eefa2e72', 18.93, 3000000, 10.67, 108236, 1, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-2b69-4c23-b3ce-78e6015b70be', 'a12535dd-28f0-4e4b-b5f4-80a268d7879e', 'a12535db-b047-4c34-9eaa-f7605b184657', 493.48, 2000000, 236.99, 1939289, 1, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-2f4e-4866-bfab-2695b80da566', 'a12535dd-2e85-4d2b-87d9-93ab747ccd71', 'a12535db-a649-4445-a01e-45e0eefa2e72', 200.41, 2500000, 117.79, 1110995, 1, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-2fd0-44d5-bc0e-438aa4742073', 'a12535dd-2e85-4d2b-87d9-93ab747ccd71', 'a12535db-b047-4c34-9eaa-f7605b184657', 437.89, 1500000, 212.73, 1982430, 1, '2026-02-23 04:58:15', '2026-02-23 04:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `platform_settings`
--

CREATE TABLE `platform_settings` (
  `key` varchar(64) NOT NULL,
  `value` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `platform_settings`
--

INSERT INTO `platform_settings` (`key`, `value`, `created_at`, `updated_at`) VALUES
('payment_qr_gcash_url', 'data:image/jpeg;base64,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', NULL, '2026-02-28 09:41:37');
INSERT INTO `platform_settings` (`key`, `value`, `created_at`, `updated_at`) VALUES
('payment_qr_maya_url', 'data:image/jpeg;base64,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', NULL, '2026-02-28 09:41:37');

-- --------------------------------------------------------

--
-- Table structure for table `promo_codes`
--

CREATE TABLE `promo_codes` (
  `id` char(36) NOT NULL,
  `code` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `discount_percent` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `min_rental_days` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `max_rental_days` tinyint(3) UNSIGNED DEFAULT NULL COMMENT 'Null = any; set to 1 for 1-day only',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `promo_codes`
--

INSERT INTO `promo_codes` (`id`, `code`, `title`, `description`, `discount_percent`, `min_rental_days`, `max_rental_days`, `active`, `expires_at`, `created_at`, `updated_at`) VALUES
('a1304e7b-fa64-45e0-93f4-0ab919e20ad0', 'BULOD10', '10% off 3-day minimum booking', 'Use at checkout for 10% off when you book for 3 or more days.', 10, 3, NULL, 1, '2026-12-31 15:59:59', '2026-02-28 17:21:12', '2026-03-01 05:57:09');

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

CREATE TABLE `receipts` (
  `id` char(36) NOT NULL,
  `invoice_id` char(36) NOT NULL,
  `official_receipt_number` varchar(255) DEFAULT NULL,
  `issued_at` timestamp NULL DEFAULT NULL,
  `pdf_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `refunds`
--

CREATE TABLE `refunds` (
  `id` char(36) NOT NULL,
  `cancellation_request_id` char(36) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(8) NOT NULL DEFAULT 'PHP',
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `reference` varchar(255) DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rental_bookings`
--

CREATE TABLE `rental_bookings` (
  `id` varchar(64) NOT NULL,
  `transaction_id` varchar(64) NOT NULL,
  `vehicle_name` varchar(255) NOT NULL,
  `business_name` varchar(255) NOT NULL,
  `client_name` varchar(255) NOT NULL,
  `client_email` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'Pending',
  `previous_status` varchar(32) DEFAULT NULL,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `archived` tinyint(1) NOT NULL DEFAULT 0,
  `car_owner_seen_at` timestamp NULL DEFAULT NULL,
  `vehicle_id` varchar(64) DEFAULT NULL,
  `client_user_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rental_bookings`
--

INSERT INTO `rental_bookings` (`id`, `transaction_id`, `vehicle_name`, `business_name`, `client_name`, `client_email`, `start_date`, `end_date`, `amount`, `status`, `previous_status`, `confirmed_at`, `paid_at`, `cancelled_at`, `completed_at`, `archived`, `car_owner_seen_at`, `vehicle_id`, `client_user_id`, `created_at`, `updated_at`) VALUES
('01KJH52E8KTFQTCPAGG721KTTR', 'TG721KTTR', 'JAJA', 'Demo Car Owner', 'Demo Client', 'client@bulodph.demo', '2026-02-28', '2026-03-02', 7500, 'Approved', NULL, NULL, NULL, NULL, NULL, 0, '2026-03-01 09:25:14', 'a12f63f5-6328-4a38-af15-91e067b7b463', 'a12535dd-84fe-436e-b02e-a83a458891f1', '2026-02-28 06:35:57', '2026-03-01 09:25:14'),
('01KJH5VE5FBK4PRAKSDE9GBGDF', 'TDE9GBGDF', 'JAJA', 'Demo Car Owner', 'Demo Client', 'client@bulodph.demo', '2026-02-28', '2026-03-02', 7500, 'Pending', NULL, NULL, NULL, NULL, NULL, 0, NULL, 'a12f63f5-6328-4a38-af15-91e067b7b463', 'a12535dd-84fe-436e-b02e-a83a458891f1', '2026-02-28 06:49:37', '2026-02-28 06:49:37'),
('01KJHAWNXEG7SGXVZMAEMQD0MP', 'TAEMQD0MP', 'JAJA', 'Demo Car Owner', 'Demo Client', 'client@bulodph.demo', '2026-02-28', '2026-03-02', 7500, 'Approved', NULL, NULL, NULL, NULL, NULL, 0, '2026-03-01 09:25:14', 'a12f63f5-6328-4a38-af15-91e067b7b463', 'a12535dd-84fe-436e-b02e-a83a458891f1', '2026-02-28 08:17:40', '2026-03-01 09:25:14'),
('01KJJ15KNDZYKQ7DRXBAKWN0ZR', 'TBAKWN0ZR', 'testingers', 'Demo Car Owner', 'Demo Client', 'client@bulodph.demo', '2026-02-28', '2026-03-09', 25000, 'Cancelled', NULL, NULL, '2026-02-28 14:51:41', NULL, NULL, 0, '2026-03-01 09:25:14', 'a12e1fa7-a325-4521-ab42-56e92b14dc3b', 'a12535dd-84fe-436e-b02e-a83a458891f1', '2026-02-28 14:47:01', '2026-03-02 05:42:16'),
('01KJP5P48MMBVZ6RQ85XFV63XF', 'T5XFV63XF', 'Toyota Hilux', 'C', 'Demo Client', 'client@bulodph.demo', '2026-03-03', '2026-03-10', 800, 'Pending', NULL, NULL, NULL, NULL, NULL, 0, NULL, '5', 'a12535dd-84fe-436e-b02e-a83a458891f1', '2026-03-02 05:22:55', '2026-03-02 05:22:55');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` char(36) NOT NULL,
  `booking_reference` varchar(255) DEFAULT NULL,
  `reviewer_id` char(36) NOT NULL,
  `reviewee_id` char(36) DEFAULT NULL,
  `vehicle_reference` varchar(255) DEFAULT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `comment` longtext DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reward_points`
--

CREATE TABLE `reward_points` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `points_delta` int(11) NOT NULL,
  `balance_after` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reward_tiers`
--

CREATE TABLE `reward_tiers` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `min_points` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `benefits` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `organization_id` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `organization_id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'a12535db-c0bd-4cc5-97be-a851a378fc84', 'Admin', 'web', '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
(2, 'a12535db-c0bd-4cc5-97be-a851a378fc84', 'Support Worker', 'web', '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
(3, 'a12535db-c0bd-4cc5-97be-a851a378fc84', 'Coordinator', 'web', '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
(4, 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'client', 'web', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
(5, 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'admin', 'web', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
(6, 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'car_owner', 'web', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
(7, 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'marketing_staff', 'web', '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
(8, 'a1382247-be19-49da-9a83-dcab372c5657', 'car_owner', 'web', '2026-03-04 14:44:13', '2026-03-04 14:44:13');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('03wNtwzxqtbkMONm19azN0dHDvSbfwCutbEUt0zO', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWE12UzNyeVcwVkdZNngyTmV4TUxRQVJiOGFaSjAzNVRnWGlUQUNmeSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637447),
('0EneJHmrydnYovgtQtpNwYqxEmKvEjpfGu7YGizv', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTVZxcnZXckJOS3VHTzUwdFdPTkFVNm5STHB2ZEpKOTdRREVsTnhqNSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627917),
('0JbQk3sUEYlgUH8ZvxB6jBF3qperpjZCduTzOSpE', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTW02OEUza0kzdXJCRUt3c2dSeEVTMkRqdFI5UGFNczFmSk1hU1ZnaCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626130),
('0ldWLGx40FlumdsOpdDqMIhY2GVbykCCkTt0lyME', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibFVQVDBLU24zM2JKTkx1RGhUc2lrWnpJSVBpNzlOU3BzdUdYcm5KciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628339),
('12SLgZlXeyOfxq1dFPhJdkianKmFfh7Q6XuWV7wg', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNDFqRG1OcmlLTW93eERCcE5jWHQ5YkJIbHR1elBJOFJHak8zV1JxciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628378),
('17r5DymDmqVAWfbvUONR1cfQfOKIW25jD8v1QpFD', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVmFkMzZRdVBocTVOc1M0d1ZONDJxdDlrZFVHVVJ3R3N1NU5XQW5sYyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639383),
('1LnCFY5p0TNtnJcpCDiQqebEpRM5R0ClmrYSe3Ho', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQjFDVmFaOUZzNHVWdFNpTnVoNHNyQ0ZFcksxa1IwRkpQd2Y2TURkeCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628378),
('1UAYMYUqmYfOkKWBRjgHcDrBcc4jQSBGE2c9vQCH', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTzRmN2t1OW5CRkE2cm1RamhOVHh1U0V3M1NaMkRBOTh4d2FLeXJCSSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639030),
('1yREUys3s5ZkLzmPIlA5oVKMcvlQncMNmpiv1Cib', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSUp1a2FRaFVQc0VnMVBvc0lMSkhLRTh4aFE1bm94Z251eWZZY0ZpOCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626038),
('1ZmRgc4hJXNwlf00M5Yr212jiAnzwtii7Zjelvkq', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidmtTaTNnTEhmaVRqUmE1YzJvQVp0SGFlNGl2SElQV2pucm1XcVNpbiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626043),
('2R1k09gY9MkbY1bB27XCSnDP9Abw6Zsh1DLlzBT2', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoialRWbnVaSGhIN3NiUjloNnZWSTJqbXA3Rm1NRnBHRTBYRGM5S3RWbiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624339),
('2s1qOtpDvNguIM5Nwh394V2cFdby9VSYupfEdon3', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRWZDbms0UzJaQlJMenI2MlkwRTRzek5KQUtEZ08xVDRNcUhha3JpMSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626078),
('36CBZNCO0t1KEOFNtA4qBgGnoXtpCpR3Wtb5W5VH', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiaUFUb0xHS29jNW5VdW5CaE10b1l1VU1RUm5ZN0ZiSzdySXFMQkJXSSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772625268),
('3roV6gbk4HwrTwQPErg3Tv7sINwRRuiLJDNGztKO', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoib3NZemlrNGNLaG95VEExZUUxcWdPUXduTlVFVzRlaWtLYzJDM3VCUiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624663),
('3sNh7I8rWYZPVegeYPOF3ZB5Gb4xx71xLmAwSMVt', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiOGZkazJCVGtZdjJ1TVUyTGI4NzJ4S1dOdUM3Q2J1eHlLVVhEeWZTdCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626076),
('3TfRHI2L9ZJsXCIKQohQxDvtEkGSGVYtiLwIkQrl', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieHhhVzFCRUhQVENoUDhNdXhUNThNRjBVYzF2SW1XOG0wYTZXdmdqOSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639031),
('3uam2mxFtuKi9QM8pim6fS4eAQj0THzYbaljMiIy', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicElCRzFCWEtHVjZwWE1Lb3NGSEo5ZGVJYzQwd3Jhblg4TzhQcWRabCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624322),
('3ybXK9cOcwTmlXIfcAy8bQ2xELQAzJmeTAjm7hxc', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZngxQVoyUWFTY1RNZm9XVTA0U01FM0VTM2ZaNU5Kc3JmeHp6a2oySSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637344),
('4I9qR2YDNPftJPboU5czPE2mBPAYHgWg1RegIsBy', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibndqajJnNXROUUVsa0NQWENybzVpYmJwQWY0SlhHV043bDJDaWlOVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624313),
('5uSYvOiAL0uTAmkxngAa3Wq0BBbrXOMrzHkXN5gI', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiN2xyTVVpYnFNSWZHQnhOdkg0NkVsS2FqajJieVlDUGRERUk5UVdraSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624457),
('66m1cFYxKdxiHiaaXV5L1t3KpnfstUMTfhKNc8oc', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoic3BndWR3SWJKaUZrWENjcGlqTEZJR2NSTkhwSEtZNVZ6bDFUTjhOYyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624572),
('69NUlVGnizqUi20XWZZsq89PBx1r8orsR38Tvvhr', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQ1pGR2pPNlc0alczMElYemhxWHlUOGRsNkRIZ0dPOUg1WUl3bVJlVyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626077),
('6n59skQcBPJjzsOvkT5uZVd2zVEPJkUBgFRky3Tf', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieVRsWUJyVXpXV05TeU9TaWxwNlBlSE1jY0lIMjRqYXpSWDJvVUl4RCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624323),
('6rfCKDWC6hMC8a02yvP9c5mKyPl641Iv20LZr9Oq', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicmVmRkk0Y1FnWHlIR2hkVXNYMUtnVVg2UnRZSEJjWU5YZFZmeHRxeiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626945),
('6TcqN8ozqt51kTDsEQXXlHl9MeuyM1bsJ5a2oXQB', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieUxOa1pOOUl0eVFNQ2lmeEt0Q1daQlB1UXRKdElIZUFSaDZoZTdCbSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624458),
('6umSdicZfzPdgJVOE1QvEmX5EMuXnq4QFotbTuIk', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYnVSUTVRSWphVGg3M0thcm1mMW01WUVEZjhMWkZ3MFh1RTRFdGNzRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626082),
('88uP8mxo03sPJu9evYrKVG7befqA1gBu5vnZdLja', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiN3RJNXdGMDFQSUsxS3VvSVBnWFI5eWZOdlhxaTRMcTRUN3BsbGFHRiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639031),
('8EH1G2P8OdvlIrBQzD59yGsoRQ9mlGm2ENntNjIB', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiT00wak5DTGlPVmk1d1JsWHJ3d2VTOGgyRUhUalhZOUJMRUxadGlXNCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626116),
('8lUK76Zgh6CFEXaCLMLWXbMWTOjddNp4Ml9Pl1t9', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicFgyQXZ3VlB3N1NwYWpVYlcydHZvVlBGamN6VXhkOHBiVVFjUFF6QyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627187),
('8MvkXRo8lSGEEWWeXO3l7lsr6UTvlUVpQnrecCGH', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoia1NBaWd2TGxxSFp4dEhuZmhJSUpNOHRuUGxZUzRydGEyazRNSFl4biI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627980),
('8pPWfJ8mDOQCWoDATk55BXJqt91qexwuRIXGL9ZP', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTEVVV1ZMQnd3YU9TQXFicEJldWZiMlp4Sk9aTVRmdUVhaUFNbmlLNSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627917),
('8SN1uuPVPrifS2M9W0Aqe358yyQfv9pUt4W5Fzvr', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRVY4MWxnYlRIa1htM0dPN3hXbFd3SXh3UEJSY1JRRXdJOE8zYzRnNSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637533),
('9FgCsg1R80B3q9I60UOhozCO1GCiC3tmr69MyiZt', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQlpOclNVaDBmc2ZiVnpFSWZVb29hOWZnaHlsMFlEMkVscENHT2UzMiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624341),
('9qef3zpimPRaJpQv0EKqjXofWy4UXurJfMpKf3Oq', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUWE0bGZzZGU3cWVsS1pCN09jcU9XblpZbXpybG1BNkg1MmZsbHVBTCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628338),
('9sml3aYoezdwdBbmft1Uo0KcIS31IJRcyG8YAX2u', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQ0FNTVRoSXB0M3hIUUtWejdEMnNOVWxOcHM1azZSejJQeWxMWHhLaiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637345),
('9u1be3NyrR32ajWw62GPDbp9LV74RnXLA4I85uwq', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVzV6OHlEdlFSTmRBZzMxTWtOMXF1SVEwYmlPQ0ZuY1VJY0Jna2QzSCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627064),
('A5kFIYhJeubqd8vzTDN57vcvzj6z9o7O8WmaUkoU', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiaXp5UmZjdGZ0WWVhV0JTU1BuUHhsS2xlSW5xR0xJcllJTG5pUEw1QSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624571),
('aAqKRcO3P0xjfoeFXdmRtXni4npaOfWDqTXePZyL', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiekphazZNN2xxcDltZEozUW1BaW4yNmk0VTU4Zkw0N1lxSmtvancwQSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626079),
('aGccz3aXKEKKGM6qt0meIhd0yqqoO0vXSiieRBHl', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoic1JnMzVtSVVQU2hGSGZOcU1WZUp1S2owZzNWZ05QWFN6UndKMW92MiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626076),
('AJzVdwas3y1E9fnDG3SY13uGKG8ifb8tvtzlVRbk', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicDZaT0tWdUN2ZjRwUUg5U0JEc3MxaGdDMnU4YTFBZGpnNlZzdmQ0NyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626074),
('ARdpbTJk6kYG4BwdxJGrCAyeX04m95EU40W0DTvF', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTnoweVBMdGMwSkpIOHlYUjZaQmdRSXVybVI2Z3U2RkVyY3Bka1BNbiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637315),
('BBTPMczGAOsWD9SmVofmOe4GQr1lfidKNWbsPEk5', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidHhGUk81NlF3WGtyU3BQUmJ2ZFZWa3pGY0dhbWdjeXY1WFNQQ2l3QiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772638921),
('BLcZfzSrFYDmdV6jjYYc1fi05ablmXuPVtIC7huM', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicWdaaUl4OGg5TlFwSjBtRktQZFM0ODVBcndMWmJsU2Uzc1BKcXN6TSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624306),
('BU8LI4QR8a3fZ02Faz370aoA8S1U8KKHrrJB2RqT', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVHhJdjgxbXBNS000czVjRmFBYjlFVlAwS3dSOFZCbzdqcWVkT2RZUSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624305),
('bUHvvNlbfm0VYt3MKDSpPwDZbxmAwQO6FTR71XPI', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQnVQZ3hlOXFkNThLTEx5cUF0cFNaSUpyMDNUZTdPTnZCNk1TVjFCVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639392),
('BuV55CwNVTXhnfJTM0NI1Uif2Mvog1k7u3irunmz', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZnVsTXZMemFvNlphNXZLTWdjWVU4cE16clBsOUpsbGQxZUlxU1BoSCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626053),
('BxTvBLLgah0GasQfWI8WOsUFfYmwNsgwx1EMAgrP', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNGkxbjZUNklzN2NBQk9xTGI5cllVV1d2SFJlNDVab3c3dmpqMndPWCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637676),
('c8MqeIj1m5XxFbOskooMojefu2ApXeumR6VYtlr1', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieG1VRXQxMXdsbDZrTU15UEdseUlpc2FFbTR2OFNDN3hNYW5ic3hqbiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627485),
('Cbjr6SzBlpGcIWWiXyVco6J2hvdtuOJAFSKS59wm', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoia1EzaXJCOGtYMTRicDZtRUtORk94UGVxS2V6M25Wd09jdkhZSDh5bCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626475),
('CbUrenSQQGgefgBrMBYbxTeGSoqrrc2RwZkQsSi6', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiR1RZdVl6OEdJUENoRGJaQ1dnYXlaM25ucjZleGVtWlliMjB0MkJwNyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626041),
('ciYOYAvPGrveUXuep96PDrXSDnB89YmEqIks7WSN', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVE9kd1BiUTlmTFhxbzBaTnpPMHVTZkZqbVFoTXBPRVI1Sm5uWkY5aCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626044),
('CQvY9Vwbx0pyyG9SKnMyDmBdPEYn73WzXXXaMzHN', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiajhjTnJhUDNURFBTZ1A3TmFDdXlXbGtoNEQ4dXlzNUZFT01PU2h3TiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639407),
('CsiwtsABQfHakPMAsH6xpxzDck96q4Fnf7YkpltI', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibmN1NGp0U3NjUXljQUYwSWNTVVE0TzlPOW5uaDRmN1FvWnQxR05YaiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626078),
('ctGxqPiX5DlMbhxBJzkX56x2NA34jlAzvvqA8GNO', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidjF0bXk2Nk5WcFhMaXJNYmdxT05yUXRLa2RMTTM4V0FxVTF1SWhrdSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624672),
('D4DjZGVJ6KGEin8QtpgXZvDRURyGpWehByDrbVIa', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibDZxU2pyVEQ2UEEwbmp3REFZU1lTSXEzMERGTHF6cE9MZUhRMGtYNSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624314),
('DBjibpvAq4FI4ZzfkdgKmUmOLPyIjz2OvIKgVyuY', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoid1pmdWNhbjBpNW1RRkVpdG9nbjduZFEwRTJNbXRvaUJKWTE1YVFSMyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626043),
('dCQiys4xkceYkVl0uYCjCCQhYnd2IezE3jZPG4xO', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibmRiQXRyS3NuT2JrWHhwWUV2RnR5cVJ2V3E1T3Y1aGlBYVVkQ2N5byI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627173),
('Dfc8VOC5kCVEulqVG9ABWm14HFbdK9P2L3WSJ6WH', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiODRrM21FSzRVeVRoUDVLemxmdEFveWl0STlQU3ZDcU51MlIwaUozQyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637343),
('DfsXYnQwpyvRXCcRUP7zWzUGL8U0GxFpp7LgiIVE', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSFR3ZUdGU1RjMmFkN1dmaU9aOE05aGtZZnh0dFlocDBudjBtZ0pIYyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624311),
('dhduHK6IpExRlN6YGQQAFWju7KEsfU6ep9BYw6dr', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiU3NpRGpQdXJubnRUblg4bGhvNGxrY1ZjTWY4RVlYVzVYSVNFTVJXbiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772638921),
('DOfcq2n6wwPQlDljhikxankRHz7KD99kdlu3Xowt', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidDN6SDJDSGE4Um02ejdYRXNvQ2d2NXJuQUhwdzFmUzJHZUptc0FVeSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639349),
('DpFEvXC0UkBgZPwXBWVDZbV6ZLlGZKqDeCfaqI7d', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiOGQ2QWZ3RUdiV0NyM2dCSnNkenJURHAzaHZXZ3ZWM2MyVVhYUDUyMiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624340),
('DR7GmG9oUUDXap9kYP8lEqeODG7VjgqdXU04lPPy', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiazhyaEVlaGJBaUU1cG1sN1Vicnlwb2dvMTVuNld2UEFiVVUyMkN4MiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639388),
('E3EsINwDXGHM2ItDIRma09MTRgdTQowDOFxAkTNw', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYk94MVJ6Um91NG8xYzFQQnNCZDFtWklOS2hUdHp3MmFEUFlFSDdqYSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624573),
('Ez442mpnc4AjhFVKzu3jysK7Mm4L9vTbCqVNxNt8', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZTdrOWJVY0t2NDMwcGFRaDZXSjA5ME8xMThFY3JBbDVKTXhzckhoeiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639393),
('eZv6wqqfwPSCvqJ45PR9LPTJcgh2PYXtXq1cfSEj', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoid3drbnNZZkpyZXBjS1p4akZueXRYM3lzcWZxcFF2R21nRE9qdm01MCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626204),
('F2QqqgWjqCMCR8abYGSpm5Ihd17P7TR9vVDwTtKq', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWWtvUmw4a21ZYk5lT3dZbzA3UmRPZTY3VzVGN29Mdm4zSXd0VWhFciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626118),
('F4f9VduFWrnWAp7lMVyJLofuMNNSIv8Q0IODWskQ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVloyUTgzaGtHd1hwSzdsRzhaV2xGYjRNNVl5NU1rMkdVcjNyeHZtVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624300),
('f5QCQ41TI4NRiJyON2gvgQIQGkqrPNyzMY2HCwFj', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicUtpUlhuenoxaVQ5STRZRWFnWFJHZldDVlNkVGk4Z01mMERkZXg2bSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627594),
('FCISyi7VJ7ygnbz5n7P0qUWmG8AS1GgXclb5uXs5', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibUlSU1NxOHVsa0JIN21NQzJxODFvdTNPaEhXRUlPd3g3c0FzNUNLVSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626083),
('fgdAkfFVDqdFpuGakrPn1LQVbKoeG0xYAkRhn7wo', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNEw3NTZ4QkNvSk1yMlhRb1U5VWpnbUdVNVJHa1FCWTdHZnd5NHRRUiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624568),
('FgGaooQvKi6zjaWWoCipjHmw4Wuo7jjx3apwbStg', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSnd2cElvRE11ZFNLZ1Q1d2RsWTJsZFFrNG8yNU8xU1Q4bFRBMlM4bCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624325),
('FjGyBlTKh9bSuYMidyyOXHi88JrxY9u1hfIxxmuy', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYlF1M2RIRlo2TlZSd2c5QmNibGk3NlVpOGRRS04wZUxpOFJKZkp2TiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628344),
('gBbdJh9mUAi3vp8hRfTKuJT1F9Gjq8lL1E51tmSN', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieno4YUVQakRrRzRVbVMyYkdaZWt4VjdMQjZDSlNlSWM2RDlGWXpwRSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624671),
('gIwCJrByZ5EFcO2C0j40SMPVQPz7b32d34xclQZg', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRGZWaTN4UDI5aGpZTFdJaW92MG1sRnJyNzRRRnpiWE9xalhRcGlLRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626475),
('Gw6dY5bGicH8ugceKvHkDrzQhQFuJvCF8yqdXJc0', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSk5VSlkwcnU0ZHhIdk96alZBY0JlQ1FxY3lDWWI3UkZHU2MweFhHMSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626117),
('GyfkJFyjokNIgNAGH0SNUVoH927BC5B2V1RFtBvD', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVHliYVR6VTlLQWg2M1EyN0dndmtYVzZnejVQcU9OcG4xOVhnNFN3UiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624655),
('GYwfqX5zFMl1Rm3Qn7M8xVgMGmrk3bNzrS0E5oTm', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiOFpLbk4xdm9sdHhBQkJSbzlpV2dBME51NFd4dkg1dmk4WnFuNlh6dyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639389),
('H7XzbUcuVGGo9pINwCDSRBT0TqvKdQvTsXZbuPtz', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicnVkUXN0WmVqYjZMWjh6RmN6UVF3eUx4b3FHeU52Y1JUQ1d1azZGaCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626194),
('Hf9jXxq5BLdAg0LZn2vOqPZy86THF3zhL56yvby6', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZHNPWlpEVXpVNlZjZkNqbUpSaTliVkRLN3hzZGRWV2J4bVUzRU4yRiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624673),
('HfPSaWHKq8DHbvC4p5isTz3WJSItSj7D6TVtbM7b', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiS0pxTzFlUEpyaDlkVHBTeTFac001OEpqN1hRWlpRTGpueFhPWm1NTCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628390),
('hfRmDnkOnSem9s5W8uxDbIAPm3kQYQz9MHtgLNgN', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiazBSYmZGeFZXd0pmakhUOVkyTFk5UVNDYzlpbXFLZXdNOVJsalJNeCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626193),
('hHJ1iTVAa9LsGtSomSvzk2pORWdYLkFh7d2YEt79', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoid1pLalNuSEVOUXRlVmpnVFQ0djhLWk4yMWRyVllmbFBRekNKOENMZyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639393),
('Hoggc149ryrGeo3zJsRdiOKCbuIbYPI5bHs9x1A3', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiaFlhOVk3Vm81dFRKWXBXMzZRRGpTR2lHbFRHbHlNS2NxOFBjZTBEOCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624670),
('hRxHUXXIM2XXTDwvx1PVT8OUYPPLcQPfD8VwOyHk', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWG5nenhqcVZ1S0RHenVxVGVPbXRFWGZGMFpMa1BYYXRodFV6cURmaCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637351),
('hWPinIYa1zc21i14ZxVvOKxq8RpYiZogXwevGnZl', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicFhDSFBnaG43bXBjSDVjQmlWWjZxQk0xMnhZem03VW1iVFE3c2xOTyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637345),
('i7QYswp8PKKCGjkPqDsKs7fkyeyIeOmClVEJoNpD', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRGt1c1dVaU5vZHZ2dENWMFVrTjJvVHFiYU96d2dIWm1FVUQwWXo1VCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624457),
('IcKIoUG2QIRlKCjF4gEXuYxoNixhbzsrV5XbLnBg', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNDFBeEEzUWdBczhyOTRhWEdXTndLVjFycnQ5RzdZU1J4QjRpcHE0OSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624453),
('IfF2V7DHTWKjPo2Ejwxi2u9XmzudKAnR0o1E6oZa', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidzF5d0I3Vm95T3Q3VW5xTDcwZGxUcnVERWpJb0pvNEJ3bms3QVBDbiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624312),
('iiVQTs0KP9A7uYcv1y3RoGNZqit1l1WyUlBH6QIU', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVjJXeUVjb0g3TXUwckhtN2R0QWVNMjcwVldFb1Jxb3pqeEdLR08wMiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626080),
('iLUl0nXMdtmsCYj2LAWtG1zIPANdwPUQqPmw3tLr', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTE01SE5qeEh4eWFpeTFZSUJrdnpNbHlUWWtFOEY5cmhpMFczaXJicSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626051),
('ipRKuQNwbH5VYddhpd58uhTOAeRxmYyyL9cniLmA', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoid2VkejhHS1VrS0drUzVndFdlVVRKYm5leUNFa282VDlmanlzbHhJSyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626373),
('iqSp8My72azc9C71K7NP9nYa5kUVEljg2yEPmqx9', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNzhLdndjaThZUW5nNHp6M0hPSWxuSlNLcnhJdWxCV2FaeWJsTmxqSCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624323),
('ItCsynLEYNMjEy5UJYp0bOY2Ysz3FNu9VaWHHFdg', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMlhmQmltc1B0U1Y3NGxOWFBGcm9RS0Rvd1pTblZzRXluZFVBcnlpVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624656),
('IU5Sa5vfFc7OPW28hmVWqvUJ65pHVZ1NKVXkqT1e', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQkl0OFR0NVR2VUt4eDhlMXRhZ3pPOHNHM2IyNE81SnlJeHNwVFo1YyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624341),
('J4bgKa9Hqoe1R94noeOqtVgNq63pcn65lExNIApu', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTmZFN3pVcXNDa1lRUGdNRHhiTWRodXdYOTd6aUJrUUZhOVByQUVUTiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628103),
('j6UeQH9MfOGCXdVFQZigpBMKg7dj6AoiO00Vg1u8', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVFR4c1FlSzdnc2VlRFRnbU00Y3ZGOHVxNktqem5FcWlCT0d4TmxOOCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626949),
('JCWr77d4VvbOKLIRPnD4nQlSC3F4zwFDoR5upLGr', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUUNoVzdoaDFMZWRRSFMyWGpWUVg3ZGFNRmlCYTBSdUtHQnIyRUVPdiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626042),
('JGhbucJ0Ng0Ki53seoh2Cu9goAzj74IScs43LXUD', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieTlyRnNjTnZqNUVNc0wwZUZNbkRLeHFPMldsZ09pMkd0VDREZ0lRdiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626374),
('jGVoo4FtWt51CxKJzoA5cd5aIDXZAMX41Oxmbp1A', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoib3BqUWdmQXRVbkdad3BreEIwSFBSbXdveWczZjM0d0szNzlVdVYyeSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624312),
('kGQRIy8ty72sv26EGp6qC86aTxmaaUjLq6DFEos0', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiOHFoNk1SbkhWckNETDcycUdmZ3d0YUl2RGJXbHlhTGJOTXlVNzlFZSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627918),
('kXn1PCyP2QtOzQaIvWArJqYcTAzYjBjHTNWtKDNJ', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiV0M3d3Fib2xyVkJRSUdYZDNpUDE0Vmd0bmdFeXIyOFlIN1JuWW50OSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624453),
('L7jThkNqbz6MmWTn1Pv5LTnohgTXXF1EFxBHtU2H', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTHlaRzBNNU55TWcxVmY0S0NWS3VHYW04dXVvTkYxbVhpZ0tXbXhKNiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637356),
('m8yQTC1lqnvQfayaA9ltRYoe1Jd6DMMZrizlZqSu', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoib3gyZ3VTbWJ6MFc1OGhMYld0OHBqSmNQZU9DbWtzS0wzZEdiTGtDaSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627172),
('mavuIQZdgKRqNTU67MAgvSb7eNFGPFsEwjWT9an0', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYWRWZjdLaGU0dnJhNHU4T3YwRzlNV2tYSmJkMmFYckNGbG11eUJGRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624456),
('MB0LnPjeokpB4ohyTGe8cosRCRjUdJZTxgIhtqUg', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoienU4cWFoWW9uMlBxUFYyZ1hMUjVkUFZCVFEwMFFncVZJUUNVQjE5eCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627596),
('ML6NXfHwYDnwjsUPrvWQueoIWjpzPzNYGrNRnHLq', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVkxTcWJka29Ia3ZaN0RvQUlmMGhoZlhFRlBsejlNelM4VklTc3l1eSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626053),
('n8tFYz0WqHeko69HePa719WYJW1e3n6M2x2sV2OM', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUEpZcU54bkxzWURMdjYyR1dGd1RONHdpQTViZmNZM29jSzRCcWM4eCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627172),
('n92ZAdOrNgjV3Q7GXvg3ZylxglenFAAQ39ItyP8a', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicFRiVmlYZW9EVEs1OWFCRElvQU5LOEl0TTRwWEhvejZ1eTNuc2hvVyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624572),
('nCpnwpgwSImYD09BsjR5y4Z6cZT3PkDoSdsUBu7M', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVHlobTVNMXdJdHl2ZlFZVXBuMVZ0UGhFQlVpTGNiUjYzZTkxY1E2YiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639391),
('njuvu0cDMc9T0ImVJKjdvcKPMyEUKWe4TpEAU6ql', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieTBUTjk0SUxIVFRyaVNiNXVEVWJtcFFoQVh2WDBESW9OSVNZRDVTUCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626052),
('NpUU3PqyF2bcu31vpwqPybncQsBXeAQhnd0TgbYX', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicHN3WktXcHI1b2JsQ05SYkpyMzM1eXJpbHhtZWVZRUtGaXkxVjd6eSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624310),
('NSUtoN2CeMe2vSjJ9IieoONWGW0RZBrxaP4XY02K', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVTFtTzZVZElROE5GQ3NDbjRDSW5VRHQwcGFYZFBiMFl4Y0RRTm1VYyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627595),
('NYLbpKaysK7tfyjDYm72k1b06RXvRl6kE5MuJnju', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiY3BRRVltaHZVRHFoMmxFeVZKODFXV0hxdUw4aWRtQ3Q1OG9kT1RtViI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626116),
('O17XiKjOQTC8BcpTnaKPzymYdEz5NUD8x6tdlXsX', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWU8zcGpiaGZWZVBpSVBNRXlPTks4dFhTR0lzT0lIcE5FNFdaMVR1WiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626480),
('O26XcJcfnmNBORqC5gDoJDe94Q01ix0hwJLkLJim', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMXFqcktuSUZwOHJnUFE0WEhESzdra3V3Qk12N3h1cWFLU3ZrSUhVUSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624661),
('Oac76f42pSA0RgkXqx1b1B2LXfrWjTdnHCKKj9k7', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQjJwbmg3M2dJWmRKWktlMmZZWWVXWk5oaWliSlliUTFiSjZoU3FEMSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624324),
('OJ1lCzVP2VnY4ihjxxEaJ8jdg4dTQ2K07LgrSpyw', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTHJDZlNjM3VqT0xzeWlmTkJpT0xzN3hWQTJSdGFVMkNOUXJ0cnpwMyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624668),
('oJMSOzySGL8h9J9mXhz4AacfNKYzVZblGo3bCAlE', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWkQ3UlF0SFNXQmRiWmJxaEFkZktrd2VzNE12cXZGeXBjNGM3aWVJRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627478),
('oNYRzPQ1Vk3JctGpfzXY15SqwtRFYjPzOXAlsBY6', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiaVIzUEtVaXhBdkVuNDA4V3pPd1dLekFDakN0bW5EeEViZ0VwVHhRRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624570),
('oPCprhDjYrTO6zGI1OuZ6DjEkVWnsS3oVb2CDnOI', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMmFtUFFVQjhPUVh4bjVVTWY0NjVhUFFJSG9Tcm5QNTNQWFNoQ1JOcCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627068),
('oQvCziFHI0edsHem4D4gOo3Ntqpiu24mVNOlOBpG', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibmVrWkVRT0dOeXEwZDUwNDJDa3c0RnVDQkZPQU1BTWVPZXNyTzZRaSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624340),
('ovfFqQhqo8MXxlZLIFCHtms1z1VclSoOJd45508m', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRTlTUHlubnRxcEtHU3lMN2NFV0dHWGI1RU1QeGtxMkxTd21USWhHVSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624570),
('pkrbXpSesqhsPfB3UTiNBrw8KrvSCS7niBXc7rI9', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQTN3NEtPamdlTjlJRXFDNWpXSXBPQ2RUYWFwZTB3bmloMDlhbmcwMiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624321),
('PrD2vYsF2qXew8lJxtLTsCvT4N5kkG35wF2VNAdL', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiV244RlVObWJPNmY1ckl3MjFVbVZiSTUyNUxHb2h6aEloSHZ0Q0c0OSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624457),
('PSapTPwdsNzNz0FXcZAMaQXI9CqcSNghHZ8SD18c', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRjFYSnlKZXFIc01BM3dMS2xhdGk3bFl1R0R5ejVNbFM0cm9EbEpjTSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626052),
('pXSSOZEqyzdosnEDAOqobDbfleY8vmgrgYnWQEG6', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibXNBTDRTbE5DQ2Vzck5Jd2xvN25FcXZ0VW5FZ3g0ZHhDb3A3RVdseCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624305),
('qHsVlUZF2a1a9ljMdPfUXRi0fVE4CuhiWYR4crsN', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidngyTURZbVExMHNCOFZPaTNXMW1kZkIzdDdER0hSd1A3R3RBakhDRSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637344);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('QkhfbxwWjWgR1BqP8tcLuudyhZ2KnEPnVeLlQP4C', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVVlYdVdYMmNueFNyakEzV0xvamROcjJiOEVMU2pTWk00SElIRXpVRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624454),
('r16qsuoJ8NhYeoSeVIqMk7iaL07s65VpLkYDMaP2', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQmRCTzlOY0JMQW1ZVEhkTzR0SlFxZm9xVTlrRXNIQmhjSlc0OURzbyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772638920),
('rAMvSk3LCfYLBAIN5T6ZBkklT7RMJawzgoLQCer3', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiT3piM1phTzZHcmxpS29PNkV5ZWNFU2xKMW5wVjhBcXE0ZGZEZWtYaSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626044),
('reIPhIxiceyZde4TJ688VwehW7mutKm5agdEIiAh', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUnVmQW9rMDZoOEl6OG84Q1VsNnA2YmlQMWdVdkIxQTdhUzViTXI4ZyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624672),
('rnxk1B0FH957us4qvsb2WfvleUDBw08QOSE53M08', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQVp4eTNVREJjOTdOMTU4b094d2tXSm1RSGE3dXRDcjVscEM5cHNjayI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627600),
('RUNleqknhgeMJBoez9gvMdrEntrDGEtOhdnIeV5a', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVTNMZnRDQ1F3d242YmlXUWFLTTRxRWd5QzBYNkpSWHBDR2lWOUJKeSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624315),
('RvKuR9rj2GP1jINvlHrivGlS7yTMDsTN5xQi8WhX', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibnVENW1hZDhoVmU0dVRWNVViOWZCY1FJWGVKT3ZITVYxdmtzTGp3NCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639383),
('s6J6uW7feMhO5SlQNC0mIcpP0IdeAoLcbGwV0INZ', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNFRPaG9TVk9yZ2lScGxtaGRJMEp1ZGlPSmR6TzlGR29SU2RhV3I4aiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626943),
('SGe11L7SnzhAplcs7IbPE24Q7AOwAj28i0OWB5q2', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiV0lGMzRtMEhmdmFLbndxbXoxb24xM091VGZsankwOUc5cTRyMVJRTiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624670),
('SMkvhwV7ImefT7KcIQayi13WImdbEQQQy3d9vWsC', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVGJVajE4WkhNY3J5S0luVVk4dFNmRmIxbUlRdVJna2tLd1RYdXVNcyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637343),
('sR6O8c96bITvH9GjmQ2kVSK1gY0LrBkyL1M4ASqv', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUUFGeFJFdjlBemhTQVpndkJtYTdUUkZKd0ZSSkNvQXhBN2xUWExpMyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624305),
('sRc0GXBsTRTfLj6oacOAmCV94dNEQhx9QlWTQfYI', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidVhiRHB6N0xqYkszR2VScDRvQ3E4NHU2UlZVY1pHQU5xQ0YzdXg5cSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626372),
('t9PrYGZ0ZpuP2s5Ypf61lSHd0cabDnxz9rDljw2r', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWExVRU52SnBwMjBmZWtTTUtVQ3VUUGxiZGo1M2o0Wm9BVWJUTDBMNCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624671),
('TDPasLikoxSRNl8i9AQNi7k5PtGif9St0XK4o204', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiS2IzNWpaRzFUY2xxb0R2QXBxYzk5ajVlSVBaY0lKa09WcnZvTG01ZCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628377),
('TdvGjUz9hLj9FCEoVpy0ZbcvRJOKqpwlA6J8usAX', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoib3JZU0VpbFAxSGp3bTZxQUVlSGJlS3BrNGJGSEFtdmoxOTlKanhUQyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639389),
('TlWjfIxhvLR02FiRKmMnKCtgyziDtuangHBewoPc', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicDNnSDZ0SjRtZ3BXS1RIaDNVdHZkUEhpRXREbVFhSFlURDNFa1Z3SiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624304),
('TNE6IKS3Mby3Dz7FyBP5bqcwA5tbbnsJqwu89LB2', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoib1FqYldsTHNWVXlKTXBscno5SVMxeGQ0a1NDd0xGaU9COUhWSmhtSCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627913),
('TosaIBialwvqVwjoSU6jLNh9JeDAWfxsWuZIcvCG', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSHFwOGFKSnBVRk1kOW9lYnVRdkoxMHBKU1daczh0bVF5U28xNlppWSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772637344),
('tWV7gUPz5m4ilTCSDal2tsvHiuCn3tjpUQLtikRZ', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiOEtXdzNteTdjdmJCeXFuTlBNYWFqWXp4YmZMTlFyWHdCQ0FOUWVabyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627917),
('uHwqhq9UrDDYbCUIt3eZtJESdr4hW41c0M7mKlOL', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiem45dG81NWFlcUNqYVZkazk5TTdnNmQ2cWJZSlp4YVVCbFJ6THVDQSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627918),
('uiTshOCOZrurn8VLzQSgaFQtW4WVWRFPrPGnGB0n', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWUVCektyRmVHY3NiMVRkck1ZaFZLVlhaNWsyU0NxcVl0V1pRV1lmMSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626114),
('UlJpV2pXDVQOIQHHzK61Iz6Zj0so8nzMpNXc459N', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiM3hXcVZJYjMzd3FzUGtNWFZLUmtKcVVOdk1mOXdQaWo3UGE5d1JsUiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624662),
('umqMD0yqqxWW20oLskzl1UiRS04XLTbCT3VMbNhS', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicHJmNVZlYUdxTElDVFI5TExISWpZSUFIeFdxeWFGNHA1Z0xVUDI2QSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624324),
('uNuhOfPSKJ26771ijzafBrlYDWiuHpfXJKeHMgR2', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYzFKVGJJMVJvT2hEaThoSkZzaHFSNENTaFR6OGZxWk9Jb215d3ZRNyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626379),
('UOCCVLxSrc4AZNMlsSNDbbXEeR0UwKcxo52J2Nd5', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQUVXSFQ2SUpzZUg5QkVlZWRSdzFTdGtRYTIyZ3JTMXdYMjRKY3JZayI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626117),
('uR5OxA5XBR0Digyyl3Z9f6XxjziD9F7m7P7R2l8N', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYVlQd3MzdUpmc1laZkZueWdLSlNTQ3NQWm51WUh4bXpUanFmUXlGYyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626194),
('UrEXlaCAFdQTgqzRnEWFxD7RnKZjcUWNPLqRBMqY', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiclc2QWNyd1FLdDhKTjhxU0Jjc0s0eUdweXJxMXRBaWNnaXBHaEZvUCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624661),
('urMRUYrlfMPkf5QBw8nGKsagT6pxyadngRkGYnX0', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVWhSelBRMFdGQmoyZ2d6d0hTWEpZckt4Y1E3T2Y4ZEZSZmhrYmFJRCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639384),
('uW7gVROt4P1laMLXjotkp3vwYBp54CXuvFlEuk4k', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUVdJWWpCcmpBNkh5NTNaSG1XUzRBd0F3bzZvTjJ1MHBETXdHRnN2OSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626474),
('UzYxepZrnuAe8E1EOgNE6IT0lKdG1uaEhIKzdE9d', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibUM0UFdmMmk0a1ZYZllFRzFvVno4eXNTTjFYRnp6UmpMNTNENHZ3USI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627177),
('V1OovOo1USQeYzac843o7JddBgVbDKVD0nSqvvct', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVjZPbGFjOTZGTTJJQnUwWWJCVkNGczRLSmJVdnpPcHFqMEhOaFZFeiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624452),
('V43VYkAOrxWfdUELgS548wbNYxUfuQC1wvMXAmQD', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidnN2TVF6N3lGOFRobzZYVEhxaHRZY1FFa1NOUE9uZTllZXQzTTNoQiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624654),
('VZnSoBT8BV7QMqnoWJsZg1NIm4m3I8DKLBqVb3Jj', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSGdpZkVZRUFCTEh1MXJ4MHRJaUExR3daaUR0ZDl0S09ocloxTmlLRiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624655),
('W19DwDbAPdGW5w6zhZPwrbsr1Q5gqgIjY0QVf79l', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMXlzUmR0cE5UZlM5MklqejNIWlBNRnMwZHRPQUVWQnJUbEpiZFdrVyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627918),
('whL4ixSJehEs4aWISiJwzRNq84hYSG6jivw5zN1M', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiaEVzWXJGdHBPSno0dVYwcmlDbjdPektwU3kzVkJkNklXa2JxbkN2NCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626115),
('wicbDcs8r7IGa1rDXve7ZfBrOKNGOFOYmW03YC7k', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicFZIZmJQcWd4eUF5aXNuMnRFN3NVRWo1a1BqWm45SVFTTEc4eldYSSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626115),
('WjIluHqskd0PqEDAm7LoHmofZpPPiV0HptqEtzuP', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiaHdRcWx1RjZ4anNzUVhnMUs2SDNOWW81TEFwWjJSa3Z3NDB4bHZjTiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639238),
('wNB6sYHgZVv3n45hQsajzMsAUyEmSDHmpEAbgdXe', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTjdUNTdUbURFbzFnQ096b2xEcVY5d2tsMWc5OE1UUWd5TjdQc3dIcSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624324),
('wpaNqiVYe5de9O4KVScabM1qI59mBzRQmq1hCmU5', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRTZaZ3RqQlJvc3RIUVVsRld1WmlMd1F5akpkaXZSOGpEZG4wNFJKQiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624311),
('WpFhmPl4korSxN6TaxL0onDZr8rQR8vUWgGkqRWM', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiclRMTXBlMklKeGpYRm9RbHhKS3oxZ0gyU0ZuWldyUjZJYktWdUpGOSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628339),
('WQroIrpHyPegkDlnu2vJ4zH1vGmxdwnq4qEaZ5ls', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSVNmZUVxN21jZ3lGenA4U01kMDhjOHlNbFppMXZ6aEhtY0N1aEhWMCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772638236),
('wqxrxFWJaNnmx9ZagyOZDjCbVreVYFutfZANRwOe', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiN2xlMWRKc2p3MnY2YUdHMDRpR0ZpYmdORUVpYTBQQ2Y5aTRFell1UiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627064),
('wunKIJAburS5LlBhCwi9u0gVliPrlifUWNRbS5Iq', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZkpiZHJHRnFmSzFvOWl1ZnF2R1lLelNBSXQ2NzRxYkZ5M3FRVXd6UCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624573),
('WVdcHObDZosvsKukfUFOZWM98ohJQTAFpcT2yKXa', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYXluU2dUQ2tHaUhOTGE5MmpsR2hWQjJwdWlqcHBkQTJXSGZ1YUVOMCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628583),
('WYYDxcbN2OCi70uApkC6F5gKFnsOhTt6orW0vATw', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibU1rQmt6QTJNR013eTNxVk9XaFphdmNTd1JuVWNBcGFKS25palVXViI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624340),
('X9X01xjeM4JhWLP7rJZDyAYIXHAKyjVyi6yztRtc', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiOUdQVGhwS1VWUWY0WnZBSXFTd0xZWVRpZkkxam1TMzZDZmoxd3dOTSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624454),
('xD7fCEzvZMaAcmte4tYFJDwP1mq0QBdz6tmMbEeM', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRUpjZGphWUZhQjl0aFdrdG40M01XYmY1aHJmME5TM0dIa2RpMmdpSSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624306),
('XpjKw9SiHzDjPDHqeK7NEosuLx55vcvnXLJoHOHm', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMW9nTjJpUTl5UnNKdzJERDJJY050dElrRzY4WnNvZ0dQMzFVNHZNcyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627365),
('xPXIWr2V6hUmLJsvQu4xylb3DF5L9IO7oeT48F5w', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVHdkMTFESEpzanB3NGpjQldZSDVCbThCTE1oNHVUWDhKQTFCelpKcSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627918),
('XUx13rFmtvlQABOtxcAUkzGd1EqL6Rr4bQY24Paw', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiYnluVktIWDVJZ2UxRTFld3NBSWhLY0FDWXpIOUdubXYxbTQ2QUgzciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624338),
('xVrUTduwuyob5FSq8Xf3m4QnwpNWu9MdpfDToRKZ', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZkJMcE9sS2dpZ0NrVzNCYWY4T2ZUd1RhNFpwVHFzbE5UZ2lBSmdGdiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626945),
('y0uLjQqf6bhWxqM4YQicf1tpNWQuVZM1TagSBTKA', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiWERLZmpydkZtTTAyaW1oUDU4Zk9WcUVXNlgxWU0zNUpaUmJJdkRvWCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626079),
('YIxVmgdBICgzblznRzeusXiGzyc1Ok1pJ9Z2kF2F', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTU1UOTkwSkp5MENwNUhzYWJYT1Bab2w3V2ZvdGViekxPdVdrRWhFTyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626082),
('YKBxYz391xdgbRAJJDbin6bYyWmDp3421AD7Ig2s', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidVpYWERhcFVEalE0QU45QkRaNzRLM2t1Nm5jblBXSlQ4NXVoSGg1SyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772626042),
('YRO70XUGYzSqUqKNOqVI42ueN9Zpx0Kzc2ueYn76', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSDFVTnhMWWVEazg5WDdGRGZXdkRkVzlDTGp6ZGtaanl3WkM0RUtWVSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639232),
('YymEHLX46BhQJ8EXZTI0hkGt8PIfeeQedQO3tivc', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNkVOSmltem5WUWpac2hoRDZoeWZKcFlXcGpmYVN3ZnhoclBNQXRDeiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628615),
('z17kBOtkrGUxkCgeuTqIyt0mCAD2T1JGJRiKW5k7', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVzR4Y0M0UGlHOUN2a2V3ekM5TERscHA1ck44aEFxWGFaamhqZFFwWCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772639392),
('z2PfUBcgZ4UZgALxyMjyfGqyINpkRwEUe6vG9pye', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiTVR0UHJZc0xZSGxwUUFHbENSTWhMcmwzWFZMdGxOMlNXaWZkSXhVaCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628602),
('zaDCVjEX2jNHyrWT6LQwefCNUJiUFJdZHznVSFgb', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSUMydXlYY2ZNYWJ4ZU5Jd1lHMldKMUswSTltaExmRnBtRnlGaUhqcyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772628258),
('zJn67OSEiYYcUL02jiCow17P2fOwxN7251QPsB4e', 'a1382248-28ea-4159-b91c-258cd1eb71b5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiNlhkaDllYTVuRGJOUm05VlZIbFJVNXpSQWM1REg4Q2t6S1RkanBoeCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624662),
('zkUgANZxXHhVvAxa3N7fvVytpLxNxHG9X8OTA5GP', 'a12535dd-8888-4e4a-8cc6-0993db89abeb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiVFF4V1RTbkc5MUtRajE3aUpWdHdJdmNEcFFTSzhaa3ZVNTNRZUVNVSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772627063),
('zt3Mnccp60BugDT218PlkqmL4qpI0E7K7nIrKJfk', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiSFNyUjBKYjRFN0ljTGZ4T3ZNbXJUS1VuUnJSWFFUQ1ppWm9nS05BdCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624304),
('zyPcdowuBdFs4S3x8AwNdulCMFXhCEx5U3PHdLeW', 'a12535dd-84fe-436e-b02e-a83a458891f1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoicUxTTjg5U3RFckxWWXpjcEIwWFVtU2VPbTZlSWRHbzFjbHJXVGtTNSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772624342);

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `id` char(36) NOT NULL,
  `organization_id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `primary_worker_id` char(36) NOT NULL,
  `parent_shift_id` char(36) DEFAULT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime NOT NULL,
  `actual_start` datetime DEFAULT NULL,
  `actual_end` datetime DEFAULT NULL,
  `clock_in_latitude` decimal(10,7) DEFAULT NULL,
  `clock_in_longitude` decimal(10,7) DEFAULT NULL,
  `clock_out_latitude` decimal(10,7) DEFAULT NULL,
  `clock_out_longitude` decimal(10,7) DEFAULT NULL,
  `status` enum('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
  `cancellation_reason` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shift_lines`
--

CREATE TABLE `shift_lines` (
  `id` char(36) NOT NULL,
  `shift_id` char(36) NOT NULL,
  `plan_line_item_id` char(36) NOT NULL,
  `units` decimal(10,2) UNSIGNED NOT NULL,
  `unit_price_cents` bigint(20) UNSIGNED NOT NULL,
  `total_cents` bigint(20) UNSIGNED NOT NULL,
  `is_billable` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` longtext NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_logs`
--

CREATE TABLE `system_logs` (
  `id` char(36) NOT NULL,
  `type` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `context` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trust_safety_policies`
--

CREATE TABLE `trust_safety_policies` (
  `id` char(36) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `organization_id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `tfn_encrypted` text DEFAULT NULL,
  `mobile` varchar(20) NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `marketing_consent_at` timestamp NULL DEFAULT NULL,
  `marketing_consent_source` varchar(64) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `organization_id`, `name`, `email`, `password`, `tfn_encrypted`, `mobile`, `city`, `province`, `address`, `notes`, `avatar_url`, `is_active`, `marketing_consent_at`, `marketing_consent_source`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`) VALUES
('a12535dc-6af8-4f9d-b3bf-2add879ea5ba', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, 'admin@hpaplus.com.au', '$2y$12$x7B0ySJrQa51KQE.N/FjtuseqtE02mT5nFgCw5YZnERmD8a4ovwXO', NULL, '0400000001', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:14', '2026-02-23 04:58:14'),
('a12535dc-bf38-4d5e-a496-701886110452', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, 'worker1@hpaplus.com.au', '$2y$12$veA16PmDM6p3Ujd9CvkBDO5hQEgZ2oFKy0c5fqV0XE1qaP3XBN.wC', NULL, '0400000002', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-120d-4b81-8b89-d8610b7fba74', 'a12535db-c0bd-4cc5-97be-a851a378fc84', NULL, 'worker2@hpaplus.com.au', '$2y$12$CcyFsci1y.FfaJeCwbJnSu/oIJT36wtNoD15OrmUGUcCdOW3L0dZu', NULL, '0400000003', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:15', '2026-02-23 04:58:15'),
('a12535dd-84fe-436e-b02e-a83a458891f1', 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'Demo Client', 'client@bulodph.demo', '$2y$12$ptVgQ80Hyfq/2/6XYi3B8e75g03Ysf2ooSfRe7JyL31WABCeQOBXO', NULL, '639171234567', NULL, NULL, NULL, NULL, 'http://localhost:8000/storage/avatars/a12535dd-84fe-436e-b02e-a83a458891f1/69a43fa90b9259.21989620.png', 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:15', '2026-03-01 16:31:21'),
('a12535dd-8888-4e4a-8cc6-0993db89abeb', 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'Demo Admin', 'admin@bulodph.demo', '$2y$12$nIV6UWmVvFFJI68/eOO35ODB4L7.EgnDLVN/nkt/V1OKztCTmNZ9a', NULL, '639171234568', NULL, NULL, NULL, NULL, 'http://localhost:8000/storage/avatars/a12535dd-8888-4e4a-8cc6-0993db89abeb/kTffqirNak2EKpjjV08WPimeoWUZfTzxolG2w822.jpg', 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:15', '2026-02-24 15:56:40'),
('a12535dd-8c12-429a-a97c-2e727ac15071', 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'Demo Car Owner', 'carowner@bulodph.demo', '$2y$12$hrmPmCPuekD4DGJimyL.nOfiGLT9d5eWHupwsHuJV2WERjJ5ZnlL2', NULL, '639171234569', NULL, NULL, NULL, NULL, 'http://localhost:8000/storage/avatars/a12535dd-8c12-429a-a97c-2e727ac15071/4OfF9MiUKy1e6u290tAGXSetTvZ86iCioWFzIB4N.png', 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:15', '2026-02-25 05:29:04'),
('a12535dd-8f69-439f-a280-eadcdd9af659', 'a12535dd-31f1-401c-b249-1ecbe48ac575', 'Demo Marketing', 'marketing@bulodph.demo', '$2y$12$DkpjJy9sjIy9vOt3UhmW2.KUOnyl5fP99MXeCobPWo/N5/GNdpD/W', NULL, '639171234570', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-02-23 04:58:15', '2026-02-23 18:25:08'),
('a1382248-28ea-4159-b91c-258cd1eb71b5', 'a1382247-be19-49da-9a83-dcab372c5657', 'hayatop Paet', 'maylinpaet19@gmail.com', '$2y$12$1Ma.gGNfDsmpGH5nHVNcK.SCX2r7GTt9v09Nqr1B79ihKR3zrwr6e', NULL, '639263091135', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-04 14:44:13', 'registration', NULL, NULL, '2026-03-04 14:44:13', '2026-03-04 14:44:13');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'Car',
  `location` varchar(255) DEFAULT NULL,
  `price_per_day` decimal(12,2) NOT NULL DEFAULT 0.00,
  `original_price_per_day` decimal(12,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(1024) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Available',
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `hidden_from_listing` tinyint(1) NOT NULL DEFAULT 0,
  `approved_at` timestamp NULL DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `host_name` varchar(255) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `car_type` varchar(50) DEFAULT NULL,
  `capacity` tinyint(3) UNSIGNED DEFAULT NULL,
  `rental_mode` varchar(32) NOT NULL DEFAULT 'both',
  `min_rental_period_hours` int(10) UNSIGNED DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `images_four_sides` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images_four_sides`)),
  `listed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity_logs_user_id_foreign` (`user_id`),
  ADD KEY `activity_logs_action_index` (`action`);

--
-- Indexes for table `affiliate_applications`
--
ALTER TABLE `affiliate_applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `affiliate_applications_status_index` (`status`);

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `announcements_created_by_foreign` (`created_by`),
  ADD KEY `announcements_recipient_type_index` (`recipient_type`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_foreign` (`user_id`),
  ADD KEY `idx_audit_composite` (`organization_id`,`auditable_type`,`auditable_id`,`created_at`),
  ADD KEY `audit_logs_request_id_created_at_index` (`request_id`,`created_at`);

--
-- Indexes for table `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `blog_posts_slug_unique` (`slug`),
  ADD KEY `blog_posts_status_index` (`status`);

--
-- Indexes for table `budget_categories`
--
ALTER TABLE `budget_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `budget_categories_ndis_plan_id_category_type_index` (`ndis_plan_id`,`category_type`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cancellation_requests`
--
ALTER TABLE `cancellation_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cancellation_requests_user_id_foreign` (`user_id`),
  ADD KEY `cancellation_requests_booking_reference_index` (`booking_reference`),
  ADD KEY `cancellation_requests_status_index` (`status`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_user_id_vehicle_id_start_date_end_date_index` (`user_id`,`vehicle_id`,`start_date`,`end_date`),
  ADD KEY `cart_items_vehicle_id_index` (`vehicle_id`);

--
-- Indexes for table `car_rental_profiles`
--
ALTER TABLE `car_rental_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `car_rental_profiles_user_id_unique` (`user_id`),
  ADD KEY `car_rental_profiles_slug_index` (`slug`);

--
-- Indexes for table `certifications`
--
ALTER TABLE `certifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `certifications_user_id_expiry_date_index` (`user_id`,`expiry_date`);

--
-- Indexes for table `city_pages`
--
ALTER TABLE `city_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `city_pages_slug_unique` (`slug`),
  ADD KEY `city_pages_status_index` (`status`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clients_ndis_number_unique` (`ndis_number`),
  ADD KEY `clients_organization_id_ndis_number_index` (`organization_id`,`ndis_number`);

--
-- Indexes for table `client_profiles`
--
ALTER TABLE `client_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client_profiles_user_id_unique` (`user_id`),
  ADD KEY `client_profiles_slug_index` (`slug`);

--
-- Indexes for table `disputes`
--
ALTER TABLE `disputes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `disputes_opened_by_user_id_foreign` (`opened_by_user_id`),
  ADD KEY `disputes_against_user_id_foreign` (`against_user_id`),
  ADD KEY `disputes_booking_reference_index` (`booking_reference`),
  ADD KEY `disputes_status_index` (`status`);

--
-- Indexes for table `dispute_evidence`
--
ALTER TABLE `dispute_evidence`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dispute_evidence_dispute_id_foreign` (`dispute_id`),
  ADD KEY `dispute_evidence_uploaded_by_user_id_foreign` (`uploaded_by_user_id`);

--
-- Indexes for table `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_templates_name_unique` (`name`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `favorites_user_id_vehicle_id_unique` (`user_id`,`vehicle_id`),
  ADD KEY `favorites_vehicle_id_index` (`vehicle_id`);

--
-- Indexes for table `fraud_risk_flags`
--
ALTER TABLE `fraud_risk_flags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fraud_risk_flags_user_id_foreign` (`user_id`),
  ADD KEY `fraud_risk_flags_booking_reference_index` (`booking_reference`),
  ADD KEY `fraud_risk_flags_severity_index` (`severity`),
  ADD KEY `fraud_risk_flags_status_index` (`status`);

--
-- Indexes for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD PRIMARY KEY (`id`),
  ADD KEY `insurance_claims_insurance_selection_id_foreign` (`insurance_selection_id`),
  ADD KEY `insurance_claims_user_id_foreign` (`user_id`),
  ADD KEY `insurance_claims_status_index` (`status`);

--
-- Indexes for table `insurance_plans`
--
ALTER TABLE `insurance_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `insurance_selections`
--
ALTER TABLE `insurance_selections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `insurance_selections_user_id_foreign` (`user_id`),
  ADD KEY `insurance_selections_insurance_plan_id_foreign` (`insurance_plan_id`),
  ADD KEY `insurance_selections_booking_reference_index` (`booking_reference`),
  ADD KEY `insurance_selections_status_index` (`status`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoices_user_id_foreign` (`user_id`),
  ADD KEY `invoices_owner_id_foreign` (`owner_id`),
  ADD KEY `invoices_booking_reference_index` (`booking_reference`),
  ADD KEY `invoices_status_index` (`status`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kyc_submissions`
--
ALTER TABLE `kyc_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kyc_submissions_user_id_foreign` (`user_id`),
  ADD KEY `kyc_submissions_reviewed_by_user_id_foreign` (`reviewed_by_user_id`),
  ADD KEY `kyc_submissions_status_index` (`status`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_thread_id_foreign` (`thread_id`),
  ADD KEY `messages_sender_id_foreign` (`sender_id`);

--
-- Indexes for table `message_threads`
--
ALTER TABLE `message_threads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message_threads_client_id_foreign` (`client_id`),
  ADD KEY `message_threads_owner_id_foreign` (`owner_id`),
  ADD KEY `message_threads_booking_reference_index` (`booking_reference`),
  ADD KEY `message_threads_status_index` (`status`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`organization_id`,`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  ADD KEY `model_has_permissions_permission_id_foreign` (`permission_id`),
  ADD KEY `model_has_permissions_team_foreign_key_index` (`organization_id`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`organization_id`,`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  ADD KEY `model_has_roles_role_id_foreign` (`role_id`),
  ADD KEY `model_has_roles_team_foreign_key_index` (`organization_id`);

--
-- Indexes for table `ndis_plans`
--
ALTER TABLE `ndis_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ndis_plans_plan_number_unique` (`plan_number`),
  ADD KEY `ndis_plans_client_id_is_active_index` (`client_id`,`is_active`);

--
-- Indexes for table `ndis_support_items`
--
ALTER TABLE `ndis_support_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ndis_support_items_support_item_number_unique` (`support_item_number`),
  ADD KEY `ndis_support_items_support_item_number_index` (`support_item_number`),
  ADD KEY `ndis_support_items_category_type_effective_from_index` (`category_type`,`effective_from`);

--
-- Indexes for table `organizations`
--
ALTER TABLE `organizations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `organizations_abn_unique` (`abn`),
  ADD KEY `organizations_abn_index` (`abn`),
  ADD KEY `organizations_is_active_index` (`is_active`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payment_webhook_logs`
--
ALTER TABLE `payment_webhook_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_webhook_logs_provider_index` (`provider`),
  ADD KEY `payment_webhook_logs_event_index` (`event`),
  ADD KEY `payment_webhook_logs_reference_index` (`reference`),
  ADD KEY `payment_webhook_logs_status_index` (`status`);

--
-- Indexes for table `payouts`
--
ALTER TABLE `payouts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payouts_user_id_foreign` (`user_id`),
  ADD KEY `payouts_status_index` (`status`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `plan_line_items`
--
ALTER TABLE `plan_line_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_line_items_support_item_id_foreign` (`support_item_id`),
  ADD KEY `plan_line_items_budget_category_id_is_active_index` (`budget_category_id`,`is_active`);

--
-- Indexes for table `platform_settings`
--
ALTER TABLE `platform_settings`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `promo_codes`
--
ALTER TABLE `promo_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `promo_codes_code_unique` (`code`);

--
-- Indexes for table `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `receipts_invoice_id_foreign` (`invoice_id`),
  ADD KEY `receipts_official_receipt_number_index` (`official_receipt_number`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `refunds_cancellation_request_id_foreign` (`cancellation_request_id`),
  ADD KEY `refunds_status_index` (`status`);

--
-- Indexes for table `rental_bookings`
--
ALTER TABLE `rental_bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rental_bookings_client_user_id_foreign` (`client_user_id`),
  ADD KEY `rental_bookings_transaction_id_index` (`transaction_id`),
  ADD KEY `rental_bookings_status_index` (`status`),
  ADD KEY `rental_bookings_vehicle_id_index` (`vehicle_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reviews_reviewer_id_foreign` (`reviewer_id`),
  ADD KEY `reviews_reviewee_id_foreign` (`reviewee_id`),
  ADD KEY `reviews_booking_reference_index` (`booking_reference`),
  ADD KEY `reviews_vehicle_reference_index` (`vehicle_reference`),
  ADD KEY `reviews_status_index` (`status`);

--
-- Indexes for table `reward_points`
--
ALTER TABLE `reward_points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reward_points_user_id_foreign` (`user_id`);

--
-- Indexes for table `reward_tiers`
--
ALTER TABLE `reward_tiers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_organization_id_name_guard_name_unique` (`organization_id`,`name`,`guard_name`),
  ADD KEY `roles_team_foreign_key_index` (`organization_id`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shifts_client_id_foreign` (`client_id`),
  ADD KEY `shifts_organization_id_scheduled_start_index` (`organization_id`,`scheduled_start`),
  ADD KEY `shifts_primary_worker_id_scheduled_start_index` (`primary_worker_id`,`scheduled_start`),
  ADD KEY `shifts_parent_shift_id_index` (`parent_shift_id`);

--
-- Indexes for table `shift_lines`
--
ALTER TABLE `shift_lines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shift_lines_plan_line_item_id_foreign` (`plan_line_item_id`),
  ADD KEY `shift_lines_shift_id_index` (`shift_id`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `support_tickets_user_id_foreign` (`user_id`),
  ADD KEY `support_tickets_status_index` (`status`);

--
-- Indexes for table `system_logs`
--
ALTER TABLE `system_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `system_logs_type_index` (`type`);

--
-- Indexes for table `trust_safety_policies`
--
ALTER TABLE `trust_safety_policies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `trust_safety_policies_slug_unique` (`slug`),
  ADD KEY `trust_safety_policies_created_by_foreign` (`created_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_organization_id_is_active_index` (`organization_id`,`is_active`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicles_user_id_foreign` (`user_id`),
  ADD KEY `vehicles_approved_listed_at_index` (`approved`,`listed_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_organization_id_foreign` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `budget_categories`
--
ALTER TABLE `budget_categories`
  ADD CONSTRAINT `budget_categories_ndis_plan_id_foreign` FOREIGN KEY (`ndis_plan_id`) REFERENCES `ndis_plans` (`id`);

--
-- Constraints for table `cancellation_requests`
--
ALTER TABLE `cancellation_requests`
  ADD CONSTRAINT `cancellation_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `car_rental_profiles`
--
ALTER TABLE `car_rental_profiles`
  ADD CONSTRAINT `car_rental_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `certifications`
--
ALTER TABLE `certifications`
  ADD CONSTRAINT `certifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_organization_id_foreign` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`);

--
-- Constraints for table `client_profiles`
--
ALTER TABLE `client_profiles`
  ADD CONSTRAINT `client_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `disputes`
--
ALTER TABLE `disputes`
  ADD CONSTRAINT `disputes_against_user_id_foreign` FOREIGN KEY (`against_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `disputes_opened_by_user_id_foreign` FOREIGN KEY (`opened_by_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `dispute_evidence`
--
ALTER TABLE `dispute_evidence`
  ADD CONSTRAINT `dispute_evidence_dispute_id_foreign` FOREIGN KEY (`dispute_id`) REFERENCES `disputes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `dispute_evidence_uploaded_by_user_id_foreign` FOREIGN KEY (`uploaded_by_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fraud_risk_flags`
--
ALTER TABLE `fraud_risk_flags`
  ADD CONSTRAINT `fraud_risk_flags_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD CONSTRAINT `insurance_claims_insurance_selection_id_foreign` FOREIGN KEY (`insurance_selection_id`) REFERENCES `insurance_selections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `insurance_claims_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `insurance_selections`
--
ALTER TABLE `insurance_selections`
  ADD CONSTRAINT `insurance_selections_insurance_plan_id_foreign` FOREIGN KEY (`insurance_plan_id`) REFERENCES `insurance_plans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `insurance_selections_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `invoices_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `kyc_submissions`
--
ALTER TABLE `kyc_submissions`
  ADD CONSTRAINT `kyc_submissions_reviewed_by_user_id_foreign` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `kyc_submissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_thread_id_foreign` FOREIGN KEY (`thread_id`) REFERENCES `message_threads` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `message_threads`
--
ALTER TABLE `message_threads`
  ADD CONSTRAINT `message_threads_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `message_threads_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ndis_plans`
--
ALTER TABLE `ndis_plans`
  ADD CONSTRAINT `ndis_plans_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`);

--
-- Constraints for table `payouts`
--
ALTER TABLE `payouts`
  ADD CONSTRAINT `payouts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `plan_line_items`
--
ALTER TABLE `plan_line_items`
  ADD CONSTRAINT `plan_line_items_budget_category_id_foreign` FOREIGN KEY (`budget_category_id`) REFERENCES `budget_categories` (`id`),
  ADD CONSTRAINT `plan_line_items_support_item_id_foreign` FOREIGN KEY (`support_item_id`) REFERENCES `ndis_support_items` (`id`);

--
-- Constraints for table `receipts`
--
ALTER TABLE `receipts`
  ADD CONSTRAINT `receipts_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refunds`
--
ALTER TABLE `refunds`
  ADD CONSTRAINT `refunds_cancellation_request_id_foreign` FOREIGN KEY (`cancellation_request_id`) REFERENCES `cancellation_requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rental_bookings`
--
ALTER TABLE `rental_bookings`
  ADD CONSTRAINT `rental_bookings_client_user_id_foreign` FOREIGN KEY (`client_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_reviewee_id_foreign` FOREIGN KEY (`reviewee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `reviews_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reward_points`
--
ALTER TABLE `reward_points`
  ADD CONSTRAINT `reward_points_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `shifts_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  ADD CONSTRAINT `shifts_organization_id_foreign` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `shifts_parent_shift_id_foreign` FOREIGN KEY (`parent_shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shifts_primary_worker_id_foreign` FOREIGN KEY (`primary_worker_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `shift_lines`
--
ALTER TABLE `shift_lines`
  ADD CONSTRAINT `shift_lines_plan_line_item_id_foreign` FOREIGN KEY (`plan_line_item_id`) REFERENCES `plan_line_items` (`id`),
  ADD CONSTRAINT `shift_lines_shift_id_foreign` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `trust_safety_policies`
--
ALTER TABLE `trust_safety_policies`
  ADD CONSTRAINT `trust_safety_policies_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_organization_id_foreign` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`);

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
