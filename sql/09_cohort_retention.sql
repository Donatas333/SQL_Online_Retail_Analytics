-- ============================================
-- 09_cohort_retention.sql
-- Cohort retention (monthly)
-- ============================================
USE analytics;

-- 1) Build customer cohorts (first purchase month)
WITH customer_first AS (
  SELECT
    CustomerID,
    DATE_FORMAT(MIN(InvoiceDate), '%Y-%m-01') AS cohort_month
  FROM online_retail
  GROUP BY CustomerID
),
customer_orders AS (
  SELECT
    CustomerID,
    DATE_FORMAT(InvoiceDate, '%Y-%m-01') AS order_month
  FROM online_retail
  GROUP BY CustomerID, DATE_FORMAT(InvoiceDate, '%Y-%m-01')
),
cohort_activity AS (
  SELECT
    cf.CustomerID,
    cf.cohort_month,
    co.order_month,
    TIMESTAMPDIFF(MONTH, cf.cohort_month, co.order_month) AS month_index
  FROM customer_first cf
  JOIN customer_orders co
    ON cf.CustomerID = co.CustomerID
)
SELECT
  cohort_month,
  order_month,
  month_index,
  COUNT(DISTINCT CustomerID) AS active_customers
FROM cohort_activity
GROUP BY cohort_month, order_month, month_index
ORDER BY cohort_month, order_month;

-- 2) Retention rates (active / cohort size)
WITH customer_first AS (
  SELECT
    CustomerID,
    DATE_FORMAT(MIN(InvoiceDate), '%Y-%m-01') AS cohort_month
  FROM online_retail
  GROUP BY CustomerID
),
customer_orders AS (
  SELECT
    CustomerID,
    DATE_FORMAT(InvoiceDate, '%Y-%m-01') AS order_month
  FROM online_retail
  GROUP BY CustomerID, DATE_FORMAT(InvoiceDate, '%Y-%m-01')
),
cohort_activity AS (
  SELECT
    cf.cohort_month,
    co.order_month,
    TIMESTAMPDIFF(MONTH, cf.cohort_month, co.order_month) AS month_index,
    co.CustomerID
  FROM customer_first cf
  JOIN customer_orders co
    ON cf.CustomerID = co.CustomerID
),
cohort_sizes AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT CustomerID) AS cohort_size
  FROM customer_first
  GROUP BY cohort_month
),
activity AS (
  SELECT
    cohort_month,
    month_index,
    COUNT(DISTINCT CustomerID) AS active_customers
  FROM cohort_activity
  GROUP BY cohort_month, month_index
)
SELECT
  a.cohort_month,
  a.month_index,
  a.active_customers,
  cs.cohort_size,
  ROUND(a.active_customers / cs.cohort_size * 100, 2) AS retention_pct
FROM activity a
JOIN cohort_sizes cs
  ON a.cohort_month = cs.cohort_month
ORDER BY a.cohort_month, a.month_index;