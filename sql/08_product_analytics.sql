-- ============================================
-- 08_product_analytics.sql
-- Product performance, Pareto (80/20), top SKUs, country-category patterns
-- ============================================
USE analytics;

-- 1) Top 20 products by revenue
SELECT
  StockCode,
  MAX(Description) AS product_name,
  SUM(Revenue) AS revenue,
  SUM(Quantity) AS units_sold,
  COUNT(DISTINCT Invoice) AS orders_containing
FROM online_retail
GROUP BY StockCode
ORDER BY revenue DESC
LIMIT 20;

-- 2) Top 20 products by units sold
SELECT
  StockCode,
  MAX(Description) AS product_name,
  SUM(Quantity) AS units_sold,
  SUM(Revenue) AS revenue
FROM online_retail
GROUP BY StockCode
ORDER BY units_sold DESC
LIMIT 20;

-- 3) Product concentration (Pareto): what % of products generate 80% revenue?
WITH prod_rev AS (
  SELECT
    StockCode,
    SUM(Revenue) AS revenue
  FROM online_retail
  GROUP BY StockCode
),
ranked AS (
  SELECT
    StockCode,
    revenue,
    SUM(revenue) OVER () AS total_revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC) AS running_revenue,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn,
    COUNT(*) OVER () AS total_products
  FROM prod_rev
)
SELECT
  MIN(rn) AS products_needed_for_80pct,
  ROUND(MIN(rn) / MAX(total_products) * 100, 2) AS pct_of_products_for_80pct_revenue
FROM ranked
WHERE running_revenue >= total_revenue * 0.80;

-- 4) Revenue by product x country (top 10 rows)
SELECT
  Country,
  StockCode,
  MAX(Description) AS product_name,
  SUM(Revenue) AS revenue
FROM online_retail
GROUP BY Country, StockCode
ORDER BY revenue DESC
LIMIT 10;

-- 5) “Basket size”: average items per invoice
WITH invoice_items AS (
  SELECT
    Invoice,
    SUM(Quantity) AS items_in_invoice,
    SUM(Revenue) AS invoice_revenue
  FROM online_retail
  GROUP BY Invoice
)
SELECT
  ROUND(AVG(items_in_invoice), 2) AS avg_items_per_order,
  ROUND(AVG(invoice_revenue), 2) AS avg_order_value
FROM invoice_items;