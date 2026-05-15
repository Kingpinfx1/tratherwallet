-- Run this once on your live database to add the columns needed for the security fixes.

-- 1. Add reset_token column to users_table (for forgot password)
ALTER TABLE `users_table`
  ADD COLUMN `reset_token` VARCHAR(100) DEFAULT NULL;

-- 2. Add admin_token column to admins_table (for admin session auth)
ALTER TABLE `admins_table`
  ADD COLUMN `admin_token` VARCHAR(100) DEFAULT NULL;
