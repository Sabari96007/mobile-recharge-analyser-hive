-- =============================================================================
-- Mobile Recharge Data Analysis using Apache Hive
-- Database and Table Initialization Script
-- =============================================================================

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS mobile_recharge_db;

-- Step 2: Switch to Database
USE mobile_recharge_db;

-- Step 3: Drop existing table if any
DROP TABLE IF EXISTS mobile_recharge;

-- Step 4: Create External Table for Mobile Recharge Data
CREATE EXTERNAL TABLE IF NOT EXISTS mobile_recharge (
    recharge_id INT COMMENT 'Unique Recharge Transaction Identifier',
    customer_id INT COMMENT 'Customer Identifier',
    customer_name STRING COMMENT 'Customer Full Name',
    mobile_number STRING COMMENT '10-digit Mobile Number',
    operator STRING COMMENT 'Telecom Operator (Jio, Airtel, Vi, BSNL)',
    plan_type STRING COMMENT 'Recharge Plan Category',
    recharge_amount DECIMAL(10,2) COMMENT 'Transaction Amount in INR',
    data_gb DECIMAL(5,2) COMMENT 'Data Quota in GB',
    validity_days INT COMMENT 'Validity Period in Days',
    recharge_date DATE COMMENT 'Date of Transaction (YYYY-MM-DD)',
    payment_method STRING COMMENT 'Payment Mode (UPI, Card, Wallet)',
    location STRING COMMENT 'City / Telecom Circle',
    status STRING COMMENT 'Status (Success, Failed, Pending)'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/opt/hive/data/warehouse/mobile_recharge_db.db/mobile_recharge'
TBLPROPERTIES ("skip.header.line.count"="1");

-- Step 5: Verify Table Structure
SHOW TABLES;
DESCRIBE FORMATTED mobile_recharge;
