# Online Retail SQL Analytics Project
Production-style SQL analytics pipeline built in MySQL 8.

Demonstrates data ingestion, transformation, validation, retention modeling, and RFM segmentation on a real-world transactional dataset.
## Project Overview

This project analyzes transactional e-commerce data (2009–2011) using MySQL 8.
The goal was to build a production-style analytics pipeline from raw CSV ingestion to business-level insights including KPIs, retention, and RFM segmentation.

The project demonstrates:
- Data ingestion using `LOAD DATA INFILE`
- Data cleaning and transformation
- Data validation checks
- KPI computation
- Cohort retention analysis
- RFM customer segmentation
- Window functions and advanced SQL

---

## Dataset

Online Retail transactional dataset (2009–2011).

Time range:
- Start: December 2009
- End: December 2011

After cleaning:
- 36,969 orders
- 5,878 customers
- £1,774,329.16 total revenue

---

## Data Pipeline

1. Raw ingestion from CSV
2. Clean transformation layer
3. Data validation checks
4. KPI layer
5. Time trend analysis
6. Customer analytics
7. Product analytics
8. Cohort retention
9. RFM segmentation

The architecture follows a layered structure:
Raw → Clean → Business → Analytics

---

## Core Business KPIs

- **Total Revenue:** £1,774,329.16
- **Total Orders:** 36,969
- **Total Customers:** 5,878
- **Average Order Value (AOV):** £479.95
- **Repeat Customer Rate:** 72.39%

### Peak Month
- **November 2010**
- Revenue: £1,172,336.04

---

## Key Insights

### 1. Strong Customer Loyalty
72.39% of customers placed more than one order.
This indicates strong repeat purchasing behavior and high customer engagement.

### 2. High Order Value Business Model
With an AOV of £479.95, this business operates in a mid-to-high value transactional range rather than low-cost mass retail.

### 3. Revenue Seasonality
November 2010 shows a major revenue spike, likely driven by seasonal holiday demand.
This indicates heavy Q4 dependence.

### 4. Customer Retention Patterns
Cohort analysis shows declining retention over time, with strong Month 0 activity and expected decay afterward.
This is typical for e-commerce but presents opportunity for lifecycle marketing.

### 5. Revenue Concentration
RFM segmentation shows a small percentage of high-value customers drive a disproportionate share of revenue.

---

## Business Recommendations

1. Invest in retention marketing during Months 1–3 post acquisition.
2. Launch loyalty campaigns before Q4 to maximize seasonal momentum.
3. Develop targeted offers for high-value RFM segments.
4. Analyze churn signals for customers inactive after Month 1.
5. Diversify revenue outside November to reduce seasonality risk.

---

## Technical Highlights

- Used `LOAD DATA INFILE` with secure_file_priv restrictions
- Resolved LF vs CRLF line-ending issue (0-row import bug)
- Applied data cleaning rules:
  - Removed cancellations (Invoice LIKE 'C%')
  - Removed negative quantity and price
  - Removed null customer IDs
- Built cohort analysis using `TIMESTAMPDIFF`
- Built RFM scoring using `NTILE`
- Used window functions (LEAD, ROW_NUMBER)

---

## How To Reproduce

Run SQL files in order:

1. `01_schema_setup.sql`
2. `02_raw_import.sql`
3. `03_clean_transform.sql`
4. `04_data_validation.sql`
5. `05_business_kpis.sql`
6. `06_time_trends.sql`
7. `07_customer_analytics.sql`
8. `08_product_analytics.sql`
9. `09_cohort_retention.sql`
10. `10_rfm_segmentation.sql`

---

## Repository Structure
