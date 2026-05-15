-- Run this once on your live database to add the columns needed for the security fixes.

-- 1. Add reset_token column to users_table (for forgot password)
ALTER TABLE `users_table`
  ADD COLUMN `reset_token` VARCHAR(100) DEFAULT NULL;

-- 2. Add admin_token column to admins_table (for admin session auth)
ALTER TABLE `admins_table`
  ADD COLUMN `admin_token` VARCHAR(100) DEFAULT NULL;

-- 3. Withdrawal requests table
CREATE TABLE IF NOT EXISTS `withdrawal_requests` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `wallet_address` VARCHAR(255) NOT NULL,
  `status` ENUM('pending','completed','rejected') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
