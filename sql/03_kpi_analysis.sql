-- ============================================
-- 03_kpi_analysis.sql
-- Core Revenue & Business KPIs
-- ============================================

USE analytics;

-- Total Revenue
SELECT SUM(Revenue) AS total_revenue
FROM online_retail;

-- Total Orders
SELECT COUNT(DISTINCT Invoice) AS total_orders
FROM online_retail;

-- Average Order Value
SELECT 
    SUM(Revenue) / COUNT(DISTINCT Invoice) AS avg_order_value
FROM online_retail;