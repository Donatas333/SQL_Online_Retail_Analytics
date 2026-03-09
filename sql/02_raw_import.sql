-- 02_raw_import.sql
USE analytics;

DROP TABLE IF EXISTS online_retail_raw;

CREATE TABLE online_retail_raw (
  Invoice VARCHAR(30),
  StockCode VARCHAR(30),
  Description TEXT,
  Quantity VARCHAR(30),
  InvoiceDate VARCHAR(50),
  Price VARCHAR(30),
  Customer_ID VARCHAR(30),
  Country VARCHAR(120)
);

-- NOTE:
-- MySQL 8 uses secure_file_priv; file must be placed in:
-- C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_retail_II.csv'
INTO TABLE analytics.online_retail_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM online_retail_raw;