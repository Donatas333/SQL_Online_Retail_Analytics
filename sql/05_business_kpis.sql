-- 05_business_kpis.sql
USE analytics;

-- Total revenue, orders, customers
SELECT
  SUM(Revenue) AS total_revenue,
  COUNT(DISTINCT Invoice) AS total_orders,
  COUNT(DISTINCT CustomerID) AS total_customers,
  SUM(Revenue) / COUNT(DISTINCT Invoice) AS avg_order_value,
  SUM(Revenue) / COUNT(DISTINCT CustomerID) AS revenue_per_customer
FROM online_retail;

-- Top 10 countries by revenue
SELECT
  Country,
  SUM(Revenue) AS revenue
FROM online_retail
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10;