-- =============================================================================
-- Mobile Recharge Data Analysis using Apache Hive
-- 20 Comprehensive HiveQL Analysis Queries
-- =============================================================================

USE mobile_recharge_db;

-- -----------------------------------------------------------------------------
-- Query 1: Display all recharge records (limited to 25 for readable display)
-- -----------------------------------------------------------------------------
SELECT 
    recharge_id, customer_id, customer_name, mobile_number, 
    operator, plan_type, recharge_amount, data_gb, validity_days, 
    recharge_date, payment_method, location, status
FROM mobile_recharge
LIMIT 25;

-- -----------------------------------------------------------------------------
-- Query 2: Count total recharge transactions
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS total_transactions 
FROM mobile_recharge;

-- -----------------------------------------------------------------------------
-- Query 3: Calculate total recharge revenue (successful transactions only)
-- -----------------------------------------------------------------------------
SELECT SUM(recharge_amount) AS total_successful_revenue_inr 
FROM mobile_recharge 
WHERE status = 'Success';

-- -----------------------------------------------------------------------------
-- Query 4: Calculate average recharge amount across all attempts
-- -----------------------------------------------------------------------------
SELECT ROUND(AVG(recharge_amount), 2) AS average_recharge_amount 
FROM mobile_recharge;

-- -----------------------------------------------------------------------------
-- Query 5: Find minimum recharge amount
-- -----------------------------------------------------------------------------
SELECT MIN(recharge_amount) AS min_recharge_amount 
FROM mobile_recharge;

-- -----------------------------------------------------------------------------
-- Query 6: Find maximum recharge amount
-- -----------------------------------------------------------------------------
SELECT MAX(recharge_amount) AS max_recharge_amount 
FROM mobile_recharge;

-- -----------------------------------------------------------------------------
-- Query 7: Count recharges operator-wise
-- -----------------------------------------------------------------------------
SELECT 
    operator, 
    COUNT(*) AS total_recharges
FROM mobile_recharge 
GROUP BY operator 
ORDER BY total_recharges DESC;

-- -----------------------------------------------------------------------------
-- Query 8: Calculate operator-wise revenue (successful recharges)
-- -----------------------------------------------------------------------------
SELECT 
    operator, 
    SUM(recharge_amount) AS operator_revenue_inr
FROM mobile_recharge 
WHERE status = 'Success'
GROUP BY operator 
ORDER BY operator_revenue_inr DESC;

-- -----------------------------------------------------------------------------
-- Query 9: Find the most popular operator (highest volume of transactions)
-- -----------------------------------------------------------------------------
SELECT 
    operator, 
    COUNT(*) AS transaction_volume 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY transaction_volume DESC 
LIMIT 1;

-- -----------------------------------------------------------------------------
-- Query 10: Find successful recharge transactions (sample preview)
-- -----------------------------------------------------------------------------
SELECT 
    recharge_id, customer_name, operator, recharge_amount, payment_method, location
FROM mobile_recharge 
WHERE status = 'Success' 
LIMIT 10;

-- -----------------------------------------------------------------------------
-- Query 11: Count failed transactions
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS total_failed_transactions 
FROM mobile_recharge 
WHERE status = 'Failed';

-- -----------------------------------------------------------------------------
-- Query 12: Count pending transactions
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS total_pending_transactions 
FROM mobile_recharge 
WHERE status = 'Pending';

-- -----------------------------------------------------------------------------
-- Query 13: Calculate payment-method-wise transactions and total volume
-- -----------------------------------------------------------------------------
SELECT 
    payment_method, 
    COUNT(*) AS transaction_count, 
    SUM(recharge_amount) AS total_amount_inr
FROM mobile_recharge 
GROUP BY payment_method 
ORDER BY transaction_count DESC;

-- -----------------------------------------------------------------------------
-- Query 14: Find highest recharge plan recorded
-- -----------------------------------------------------------------------------
SELECT 
    recharge_id, customer_name, operator, plan_type, recharge_amount, validity_days, location
FROM mobile_recharge 
ORDER BY recharge_amount DESC 
LIMIT 1;

-- -----------------------------------------------------------------------------
-- Query 15: Find customers with recharge amount greater than 500
-- -----------------------------------------------------------------------------
SELECT 
    recharge_id, customer_name, operator, recharge_amount, plan_type, status 
FROM mobile_recharge 
WHERE recharge_amount > 500.00 
ORDER BY recharge_amount DESC;

-- -----------------------------------------------------------------------------
-- Query 16: Calculate location-wise recharge revenue (successful transactions)
-- -----------------------------------------------------------------------------
SELECT 
    location, 
    COUNT(*) AS successful_count, 
    SUM(recharge_amount) AS city_revenue_inr
FROM mobile_recharge 
WHERE status = 'Success'
GROUP BY location 
ORDER BY city_revenue_inr DESC;

-- -----------------------------------------------------------------------------
-- Query 17: Calculate average data offered by each operator (in GB)
-- -----------------------------------------------------------------------------
SELECT 
    operator, 
    ROUND(AVG(data_gb), 2) AS avg_data_offered_gb 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY avg_data_offered_gb DESC;

-- -----------------------------------------------------------------------------
-- Query 18: Calculate average validity offered by operator (in Days)
-- -----------------------------------------------------------------------------
SELECT 
    operator, 
    ROUND(AVG(validity_days), 1) AS avg_validity_days 
FROM mobile_recharge 
GROUP BY operator 
ORDER BY avg_validity_days DESC;

-- -----------------------------------------------------------------------------
-- Query 19: Find the number of successful recharges for each operator
-- -----------------------------------------------------------------------------
SELECT 
    operator, 
    COUNT(*) AS successful_recharges 
FROM mobile_recharge 
WHERE status = 'Success' 
GROUP BY operator 
ORDER BY successful_recharges DESC;

-- -----------------------------------------------------------------------------
-- Query 20: Find the top 5 customers based on total recharge amount spent
-- -----------------------------------------------------------------------------
SELECT 
    customer_id, 
    customer_name, 
    COUNT(*) AS total_recharges_done, 
    SUM(recharge_amount) AS total_spent_inr
FROM mobile_recharge 
WHERE status = 'Success'
GROUP BY customer_id, customer_name 
HAVING COUNT(*) >= 1
ORDER BY total_spent_inr DESC 
LIMIT 5;
