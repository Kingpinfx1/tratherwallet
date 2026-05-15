-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 15, 2024 at 04:09 AM
-- Server version: 10.6.19-MariaDB-cll-lve
-- PHP Version: 8.1.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `indehqrv_alcoinbox`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins_table`
--

CREATE TABLE `admins_table` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(100) NOT NULL,
  `admin_email` varchar(100) NOT NULL,
  `admin_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins_table`
--

INSERT INTO `admins_table` (`admin_id`, `admin_name`, `admin_email`, `admin_password`) VALUES
(1, 'kingpin', 'admin@gmail.com', 'Password1');

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` varchar(200) NOT NULL,
  `image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_methods`
--

INSERT INTO `payment_methods` (`id`, `name`, `description`, `image`) VALUES
(6, 'Bitcoin', '1PunqhQR84u9iQEkNycnZYQkz4Aso5hCyB', 'https://i.imgur.com/kLeRyUZ.png'),
(8, 'Ethereum', '0x6D89f1a33391475B2D9521cB287b3DeDb8C23Fed', 'https://i.imgur.com/kEYFpgB.png'),
(9, 'Dogecoin', 'DKd2dJ7q7FqsJRpVWQvNzzmBSACdQ7dK5z', 'https://i.imgur.com/D96HlNe.png');

-- --------------------------------------------------------

--
-- Table structure for table `users_table`
--

CREATE TABLE `users_table` (
  `user_id` int(11) NOT NULL,
  `user_firstname` varchar(100) NOT NULL,
  `user_lastname` varchar(100) NOT NULL,
  `user_address` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` text NOT NULL,
  `user_balance` varchar(191) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_table`
--

INSERT INTO `users_table` (`user_id`, `user_firstname`, `user_lastname`, `user_address`, `user_email`, `user_password`, `user_balance`) VALUES
(2, 'techwith', 'Kingpin', 'Angels Camp California', 'kingpinfx1@gmail.com', '2ac9cb7dc02b3c0083eb70898e549b63', '100'),
(35, 'Test', 'Bot', 'olodi corner, back of SKD junction near otilo atreet', 'olodofc1@gmail.com', '2ac9cb7dc02b3c0083eb70898e549b63', '0'),
(36, 'test', 'test', 'test', 'test@example.com', 'Password1', '0'),
(37, 'Frank', 'Ã§onnie', 'frnkconniel@gmail.com', 'frnkconniel@gmail.com', '61fc39437d6c5393fea9987ceacca773', '0'),
(38, 'saria', 'Carolina', '', 'sariacarolina757@gmail.com', 'b33c2b8b5c25c5a795cb2568d522951a', '0'),
(39, 'Kratos', 'Max', 'dannywebb@gmail10p.com', 'dannywebb@gmail10p.com', '25f9e794323b453885f5181f1b624d0b', '0'),
(40, 'from', 'good', 'frnkconnieo@gmail.com', 'frnkconnieo@gmail.com', '61fc39437d6c5393fea9987ceacca773', '0'),
(41, 'good', 'Google', 'gooohhh@gmail.com', 'gooohhh@gmail.com', '61fc39437d6c5393fea9987ceacca773', '0'),
(42, 'Presley', 'Miller', '5 orode street', 'perezion12@gmail.com', 'b56ea056d80f9eeef2337f480a53a832', '0'),
(43, 'Presley', 'Miller', '5 orode street', 'perezion12@gmail.com', 'b56ea056d80f9eeef2337f480a53a832', '0'),
(44, 'Mark', 'Moore', '112 SANTA AVE CA', 'markmoore147q@gmail.com', 'cb3b6824ae822f7411f402762939dda0', '0'),
(45, 'test', 'test', 'my address', 'test@gmail.com', '2ac9cb7dc02b3c0083eb70898e549b63', '1000'),
(46, 'Greatness', 'Gift', '01', 'hpoiuytr19@gmail.com', 'c09c9f1199d8a853d8f939029239e61b', '0'),
(47, 'Miller', 'Jordan', 'Mission Road Number 5', 'millerinvestor02@gmail.com', 'c73b7e41784abc31a0495a427533096c', '0'),
(48, 'Miller', 'Jordan', 'Mission Road Number 5', 'millerinvestor02@gmail.com', 'c73b7e41784abc31a0495a427533096c', '0'),
(49, 'lucky', 'Daniel', 'Lagos Nigeria', 'Elvisavanoma@gmail.com', '74c3d864d84be891e2dc12df6fcbfa24', '0'),
(50, 'raymond', 'Anthony', 'oteri', 'alxoilmone1245@gmail.com', '868dfecc9e5586c6340a0b3eb72f1c91', '0'),
(51, 'raymond', 'Anthony', 'oteri', 'alxoilmone1245@gmail.com', '868dfecc9e5586c6340a0b3eb72f1c91', '0'),
(52, 'imere', 'bright', 'patani express road', 'brightzino37@gmail.com', '9dcf7b49a14751cab87fd6b8b49b208d', '0'),
(53, 'imere', 'bright', 'patani express road', 'brightzino37@gmail.com', '9dcf7b49a14751cab87fd6b8b49b208d', '0'),
(54, 'promise', 'white', 'Delta state', 'Promisewhite55@gmail.com', '913a2751fa36976896f40c9eee306b1a', '0'),
(55, 'promise', 'white', 'Delta state', 'Promisewhite55@gmail.com', '913a2751fa36976896f40c9eee306b1a', '0'),
(56, 'promise', 'white', 'Delta state', 'Promisewhite55@gmail.com', '913a2751fa36976896f40c9eee306b1a', '0'),
(57, 'bateren', 'Eseverere', '12 ughelli', 'batereneseverere@gmail.com', '29636b157e4bb196afd165ccd201152d', '0'),
(58, '', '', '', '', 'd41d8cd98f00b204e9800998ecf8427e', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins_table`
--
ALTER TABLE `admins_table`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_table`
--
ALTER TABLE `users_table`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins_table`
--
ALTER TABLE `admins_table`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users_table`
--
ALTER TABLE `users_table`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
