/*==================================================================================================================
  PART-TO-WHOLE ANALYSIS: CATEGORY, REGION, SEGMENT & SHIP MODE CONTRIBUTIONS
  ------------------------------------------------------------------------------------------------------------------
  Objective:
    This script evaluates how different dimensions contribute to the **overall total** — a key technique in 
    understanding distribution and proportionality in business performance. It answers the question: 
    “Which part contributes the most to the whole?”

  Dimensions Analyzed:
    1. Category-wise Sales Contribution
    2. Region-wise Sales Contribution
    3. Segment-wise Profit Contribution
    4. Ship Mode-wise Product Distribution

  Key Metrics Calculated:
    - Total value (Sales / Profit / Product Count) for each group
    - Overall total across all groups
    - Percentage of total each group represents (`percent_of_total`)

  Techniques & Functions Used:
    - Common Table Expressions (CTEs) for pre-aggregation
    - `SUM(...) OVER()` to compute overall totals without requiring a join
    - `ROUND()` and `CAST()` for precision handling
    - `CONCAT()` to append `%` and format results for display
    - `COUNT()` for analyzing shipping volume

  Output Columns (vary by query):
    - Grouping Field (e.g., `category`, `region`, `segment`, `ship_mode`)
    - Total Measure (e.g., `total_sales`, `total_profit`, `total_products`)
    - Overall Total (e.g., `overall_sales`, `overall_profit`, `overall_products`)
    - Percentage of Contribution (e.g., `percent_of_total`)

==================================================================================================================*/

-- Which category contributes the most to overall sales?
WITH category_sales AS (
  SELECT
    category,
    ROUND(SUM(sales),0) AS total_sales
  FROM superstore
  GROUP BY category
)
SELECT
  category,
  total_sales,
  SUM(total_sales) OVER() AS overall_sales,
  CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') AS percent_of_total
FROM category_sales
ORDER by percent_of_total DESC;

-- Which region contributes the most to overall sales?
WITH region_sales AS (
  SELECT
    region,
    ROUND(SUM(sales),0) AS total_sales
  FROM superstore
  GROUP BY region
)
SELECT
  region,
  total_sales,
  SUM(total_sales) OVER() AS overall_sales,
  CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100,2), '%') AS percent_of_total
FROM region_sales
ORDER BY percent_of_total DESC;

-- Which segment contributes the most to overall profit?
WITH segment_profit AS (
  SELECT
    segment,
    ROUND(SUM(profit),0) AS total_profit
  FROM superstore
  GROUP BY segment
)
SELECT
  segment,
  total_profit,
  SUM(total_profit) OVER() AS overall_profit,
  CONCAT(ROUND((total_profit / SUM(total_profit) OVER()) * 100,2), '%') AS percent_of_total
FROM segment_profit
ORDER BY percent_of_total DESC;

-- How are our products shipped?
WITH products_shipped AS (
  SELECT
      ship_mode,
      count(product_id) AS total_products
  FROM superstore
  GROUP by ship_mode
)
SELECT
  ship_mode,
  total_products,
  SUM(total_products) over() AS overall_products,
  CONCAT(ROUND(CAST(total_products AS FLOAT) / SUM(total_products) over() * 100 ,2), '%') AS percent_of_total
FROM products_shipped
ORDER By total_products DESC
