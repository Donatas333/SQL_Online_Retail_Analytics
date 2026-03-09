# Data Quality & Engineering Notes

## Import Issues

1. MySQL secure_file_priv restriction required file placement in:
   C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\

2. Initial imports returned 0 rows due to incorrect line terminator.
   Correct setting:
   LINES TERMINATED BY '\n'

3. CSV encoding handled with:
   CHARACTER SET utf8mb4

---

## Data Cleaning Decisions

1. Removed cancellations (Invoice LIKE 'C%')
2. Removed rows with negative quantity
3. Removed rows with price <= 0
4. Removed null or blank Customer_ID
5. Converted Excel-style numeric IDs ending in '.0' to integers

---

## Validation Checks

- Compared raw vs clean row counts
- Verified date range
- Verified no null CustomerID
- Verified no negative price/quantity
- Verified cancellations removed

All validation checks passed before analytics phase.