-- ============================================================
-- Business Queries — Retail Sales Analytics
-- Run in Amazon Athena against the `curated` table
-- (Database: retail_demo_db)
-- ============================================================

-- Note: A few columns in this table carry a "#N" suffix
-- (e.g. ship_mode#4) — an artifact from the Glue Crawler
-- merging multiple schema versions across runs. Those columns
-- must be double-quoted exactly as shown below.

-- ------------------------------------------------------------
-- 1. Total sales by category
-- ------------------------------------------------------------
SELECT
    category,
    SUM(CAST(sales AS DOUBLE)) AS total_sales
FROM curated
GROUP BY category
ORDER BY total_sales DESC;

-- ------------------------------------------------------------
-- 2. Average order value by customer segment
-- ------------------------------------------------------------
SELECT
    segment,
    AVG(CAST(sales AS DOUBLE)) AS avg_order_value
FROM curated
GROUP BY segment
ORDER BY avg_order_value DESC;

-- ------------------------------------------------------------
-- 3. Orders and revenue by shipping mode
-- ------------------------------------------------------------
SELECT
    "ship_mode#4" AS ship_mode,
    COUNT(*) AS num_orders,
    SUM(CAST(sales AS DOUBLE)) AS total_sales
FROM curated
GROUP BY "ship_mode#4"
ORDER BY total_sales DESC;

-- ------------------------------------------------------------
-- 4. Top 5 states by revenue
-- ------------------------------------------------------------
SELECT
    state,
    SUM(CAST(sales AS DOUBLE)) AS total_sales
FROM curated
GROUP BY state
ORDER BY total_sales DESC
LIMIT 5;
