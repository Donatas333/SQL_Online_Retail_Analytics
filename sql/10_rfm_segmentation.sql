-- ============================================
-- 10_rfm_segmentation.sql
-- RFM segmentation (Recency, Frequency, Monetary)
-- ============================================
USE analytics;

-- Snapshot date = last invoice date in dataset (acts like "today")
WITH snapshot AS (
  SELECT MAX(InvoiceDate) AS snap_date
  FROM online_retail
),
rfm_base AS (
  SELECT
    CustomerID,
    DATEDIFF((SELECT snap_date FROM snapshot), MAX(InvoiceDate)) AS recency_days,
    COUNT(DISTINCT Invoice) AS frequency_orders,
    SUM(Revenue) AS monetary_revenue
  FROM online_retail
  GROUP BY CustomerID
),
rfm_scored AS (
  SELECT
    CustomerID,
    recency_days,
    frequency_orders,
    monetary_revenue,
    -- Recency: lower is better => order by recency ASC for higher score
    NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
    -- Frequency & Monetary: higher is better
    NTILE(5) OVER (ORDER BY frequency_orders DESC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary_revenue DESC) AS m_score
  FROM rfm_base
),
rfm_final AS (
  SELECT
    *,
    CONCAT(r_score, f_score, m_score) AS rfm_score,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
      WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal'
      WHEN r_score >= 3 AND f_score >= 3 THEN 'Potential Loyalist'
      WHEN r_score = 5 AND f_score <= 2 THEN 'New Customers'
      WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
      ELSE 'Others'
    END AS segment
  FROM rfm_scored
)
SELECT
  segment,
  COUNT(*) AS customers,
  ROUND(AVG(recency_days), 1) AS avg_recency_days,
  ROUND(AVG(frequency_orders), 2) AS avg_orders,
  ROUND(AVG(monetary_revenue), 2) AS avg_revenue
FROM rfm_final
GROUP BY segment
ORDER BY customers DESC;

-- Optional: list top customers in each segment
-- (Example: top 20 Champions by monetary)
WITH snapshot AS (
  SELECT MAX(InvoiceDate) AS snap_date
  FROM online_retail
),
rfm_base AS (
  SELECT
    CustomerID,
    DATEDIFF((SELECT snap_date FROM snapshot), MAX(InvoiceDate)) AS recency_days,
    COUNT(DISTINCT Invoice) AS frequency_orders,
    SUM(Revenue) AS monetary_revenue
  FROM online_retail
  GROUP BY CustomerID
),
rfm_scored AS (
  SELECT
    CustomerID,
    recency_days,
    frequency_orders,
    monetary_revenue,
    NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency_orders DESC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary_revenue DESC) AS m_score
  FROM rfm_base
),
rfm_final AS (
  SELECT
    *,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
      WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal'
      WHEN r_score >= 3 AND f_score >= 3 THEN 'Potential Loyalist'
      WHEN r_score = 5 AND f_score <= 2 THEN 'New Customers'
      WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
      WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
      ELSE 'Others'
    END AS segment
  FROM rfm_scored
)
SELECT
  CustomerID,
  recency_days,
  frequency_orders,
  monetary_revenue
FROM rfm_final
WHERE segment = 'Champions'
ORDER BY monetary_revenue DESC
LIMIT 20;