-- ============================================
-- 07_customer_analytics.sql
-- Customer behavior, repeat rate, time between purchases, top customers
-- ============================================
USE analytics;

-- 1) Customer purchase summary (orders, revenue, first/last purchase)
SELECT
  CustomerID,
  COUNT(DISTINCT Invoice) AS orders,
  SUM(Revenue) AS total_revenue,
  MIN(InvoiceDate) AS first_purchase,
  MAX(InvoiceDate) AS last_purchase,
  DATEDIFF(MAX(InvoiceDate), MIN(InvoiceDate)) AS customer_lifespan_days
FROM online_retail
GROUP BY CustomerID;

-- 2) New customers per month (based on first purchase month)
WITH first_purchase AS (
  SELECT
    CustomerID,
    MIN(InvoiceDate) AS first_purchase_date
  FROM online_retail
  GROUP BY CustomerID
)
SELECT
  DATE_FORMAT(first_purchase_date, '%Y-%m') AS cohort_month,
  COUNT(*) AS new_customers
FROM first_purchase
GROUP BY cohort_month
ORDER BY cohort_month;

-- 3) Repeat customer rate (customers with 2+ orders / all customers)
WITH customer_orders AS (
  SELECT
    CustomerID,
    COUNT(DISTINCT Invoice) AS orders
  FROM online_retail
  GROUP BY CustomerID
)
SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN orders >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
  ROUND(SUM(CASE WHEN orders >= 2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS repeat_rate_pct
FROM customer_orders;

-- 4) Average time to next purchase (gap between consecutive purchases per customer)
WITH invoice_level AS (
  SELECT
    CustomerID,
    Invoice,
    MIN(InvoiceDate) AS invoice_date
  FROM online_retail
  GROUP BY CustomerID, Invoice
),
gaps AS (
  SELECT
    CustomerID,
    invoice_date,
    DATEDIFF(
      LEAD(invoice_date) OVER (PARTITION BY CustomerID ORDER BY invoice_date),
      invoice_date
    ) AS days_to_next
  FROM invoice_level
)
SELECT
  ROUND(AVG(days_to_next), 2) AS avg_days_to_next_purchase
FROM gaps
WHERE days_to_next IS NOT NULL;

-- 5) Top 20 customers by revenue
SELECT
  CustomerID,
  SUM(Revenue) AS total_revenue,
  COUNT(DISTINCT Invoice) AS orders
FROM online_retail
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 20;

-- 6) Customer concentration: share of revenue from top 1% customers
WITH customer_rev AS (
  SELECT
    CustomerID,
    SUM(Revenue) AS cust_revenue
  FROM online_retail
  GROUP BY CustomerID
),
ranked AS (
  SELECT
    CustomerID,
    cust_revenue,
    NTILE(100) OVER (ORDER BY cust_revenue DESC) AS rev_percentile
  FROM customer_rev
)
SELECT
  ROUND(SUM(CASE WHEN rev_percentile = 1 THEN cust_revenue ELSE 0 END) / SUM(cust_revenue) * 100, 2) AS top_1pct_revenue_share_pct
FROM ranked;