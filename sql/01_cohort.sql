DROP TABLE IF EXISTS cohort_long;

CREATE TABLE cohort_long AS
WITH base AS (
  SELECT
    CustomerID::BIGINT AS customer_id,
    date_trunc('month', InvoiceDate) AS activity_month
  FROM transactions
  WHERE CustomerID IS NOT NULL
),
first_month AS (
  SELECT customer_id, MIN(activity_month) AS cohort_month
  FROM base
  GROUP BY 1
),
cohort_activity AS (
  SELECT
    b.customer_id,
    f.cohort_month,
    b.activity_month,
    date_diff('month', f.cohort_month, b.activity_month) AS months_since
  FROM base b
  JOIN first_month f USING (customer_id)
),
cohort_counts AS (
  SELECT
    cohort_month,
    months_since,
    COUNT(DISTINCT customer_id) AS active_customers
  FROM cohort_activity
  GROUP BY 1,2
),
sizes AS (
  SELECT cohort_month, active_customers AS cohort_size
  FROM cohort_counts
  WHERE months_since = 0
)
SELECT
  c.cohort_month,
  c.months_since,
  c.active_customers,
  s.cohort_size,
  (1.0 * c.active_customers / s.cohort_size) AS retention_rate
FROM cohort_counts c
JOIN sizes s USING (cohort_month)
WHERE c.months_since >= 0
ORDER BY 1,2;


SELECT COUNT(*) AS cohort_rows FROM cohort_long;
