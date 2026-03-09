-- 06_time_trends.sql
USE analytics;

-- Monthly revenue + orders
SELECT
  DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
  SUM(Revenue) AS monthly_revenue,
  COUNT(DISTINCT Invoice) AS monthly_orders,
  SUM(Revenue) / COUNT(DISTINCT Invoice) AS aov
FROM online_retail
GROUP BY month
ORDER BY month;

-- MoM growth (MySQL 8 window functions)
WITH monthly AS (
  SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    SUM(Revenue) AS monthly_revenue
  FROM online_retail
  GROUP BY month
)
SELECT
  month,
  monthly_revenue,
  LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue,
  ROUND(
    (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
    / NULLIF(LAG(monthly_revenue) OVER (ORDER BY month), 0) * 100
  , 2) AS mom_growth_pct
FROM monthly
ORDER BY month;