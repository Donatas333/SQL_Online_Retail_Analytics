-- 03_clean_transform.sql
USE analytics;

DROP TABLE IF EXISTS online_retail;

CREATE TABLE online_retail AS
SELECT
    Invoice,
    StockCode,
    Description,
    CAST(Quantity AS SIGNED) AS Quantity,
    STR_TO_DATE(InvoiceDate, '%Y-%m-%d %H:%i:%s') AS InvoiceDate,
    CAST(Price AS DECIMAL(10,2)) AS UnitPrice,
    CAST(REPLACE(NULLIF(TRIM(Customer_ID), ''), '.0', '') AS UNSIGNED) AS CustomerID,
    Country,
    CAST(Quantity AS SIGNED) * CAST(Price AS DECIMAL(10,2)) AS Revenue
FROM online_retail_raw
WHERE
    NULLIF(TRIM(Customer_ID), '') IS NOT NULL
    AND CAST(Quantity AS SIGNED) > 0
    AND CAST(Price AS DECIMAL(10,2)) > 0
    AND Invoice NOT LIKE 'C%';

-- Performance indexes (optional but professional)
CREATE INDEX idx_or_customer ON online_retail(CustomerID);
CREATE INDEX idx_or_date ON online_retail(InvoiceDate);
CREATE INDEX idx_or_invoice ON online_retail(Invoice);
CREATE INDEX idx_or_country ON online_retail(Country);
CREATE INDEX idx_or_stock ON online_retail(StockCode);