-- 04_data_validation.sql
USE analytics;

-- Row counts: raw vs clean
SELECT 'raw'  AS source_layer, COUNT(*) AS row_count
FROM online_retail_raw
UNION ALL
SELECT 'clean' AS source_layer, COUNT(*) AS row_count
FROM online_retail;

-- Date range
SELECT MIN(InvoiceDate) AS min_date, MAX(InvoiceDate) AS max_date
FROM online_retail;

-- Check for invalids (should be 0)
SELECT
  SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS null_customers,
  SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS non_positive_qty,
  SUM(CASE WHEN UnitPrice <= 0 THEN 1 ELSE 0 END) AS non_positive_price
FROM online_retail;

-- Cancellations should be removed (should be 0)
SELECT COUNT(*) AS cancelled_rows
FROM online_retail
WHERE Invoice LIKE 'C%';