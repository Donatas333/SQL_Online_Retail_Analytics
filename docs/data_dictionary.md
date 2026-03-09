# Data Dictionary

## Table: online_retail_raw

Raw imported CSV data with all fields stored as VARCHAR for initial ingestion.

Columns:
- Invoice (VARCHAR)
- StockCode (VARCHAR)
- Description (TEXT)
- Quantity (VARCHAR)
- InvoiceDate (VARCHAR)
- Price (VARCHAR)
- Customer_ID (VARCHAR)
- Country (VARCHAR)

---

## Table: online_retail (Clean Layer)

Cleaned transactional dataset.

- Invoice (VARCHAR) – Order identifier
- StockCode (VARCHAR) – Product identifier
- Description (TEXT) – Product description
- Quantity (INT) – Units purchased (positive only)
- InvoiceDate (DATETIME) – Transaction timestamp
- UnitPrice (DECIMAL) – Price per unit
- CustomerID (INT) – Unique customer identifier
- Country (VARCHAR) – Customer country
- Revenue (DECIMAL) – Quantity × UnitPrice

Cleaning Rules:
- Removed invoices starting with 'C' (cancellations)
- Removed negative quantity
- Removed zero or negative price
- Removed null CustomerID