/*==================================================================================================================
  PERFORMANCE ANALYSIS: YEARLY PRODUCT SALES VS AVERAGE & PRIOR YEAR COMPARISON
  ------------------------------------------------------------------------------------------------------------------
  Objective:
    This script evaluates the **yearly sales performance of individual products** by comparing:
      - Each product's annual sales to its overall average sales across all years
      - Each year’s sales to the product’s previous year's performance

  Key Questions Answered:
    - Is a product performing above or below its long-term average in a given year?
    - Did the product’s performance improve or decline compared to the previous year?

  Techniques & Functions Used:
    - CTE (`WITH` clause) to pre-aggregate yearly sales per product
    - `AVG(...) OVER(PARTITION BY ...)` to compute average sales per product across years
    - `LAG(...) OVER(PARTITION BY ... ORDER BY ...)` to fetch previous year’s sales per product
    - CASE statements to classify changes as:
        • "Above Avg" / "Below Avg" / "Avg"
        • "Increase" / "Decrease" / "No Change"
    - Basic arithmetic for difference calculation (e.g., `avg_diff`, `py_diff`)
    - `CAST(...)` to format averages as integers for comparison

  Output Columns:
    - `year_date`         → The year of sales
    - `product_id`        → Unique identifier for each product
    - `total_sales`       → Product sales in that year
    - `avg_sales`         → Average annual sales for that product
    - `avg_diff`          → Difference from average
    - `avg_change`        → Status vs. average: Above Avg, Below Avg, Avg
    - `py_sales`          → Previous year's sales
    - `py_diff`           → Difference from previous year
    - `py_chnage`         → Status vs. last year: Increase, Decrease, No Change

==================================================================================================================*/

-- Analyze the yearly performance of products by comparing their sales to both the
-- average sales performance of the product and the previous year's sales
WITH yearly_product_sales AS (
SELECT
year(order_date) as year_date,
product_id,
ROUND(SUM(sales),0) as total_sales
FROM superstore
GROUP by YEAR(order_date), product_id
)

SELECT
year_date,
product_id,
total_sales,
CAST(AVG(total_sales) OVER(PARTITION BY product_id) AS INT) AS avg_sales,
total_sales - CAST(AVG(total_sales) OVER(PARTITION BY product_id) AS INT) AS avg_diff,
CASE
WHEN total_sales - CAST(AVG(total_sales) OVER(PARTITION BY product_id) AS INT) > 0 THEN 'Above Avg'
WHEN total_sales - CAST(AVG(total_sales) OVER(PARTITION BY product_id) AS INT) < 0 THEN 'Below Avg'
ELSE 'Avg'
END AS avg_change,
LAG(total_sales) OVER(PARTITION BY product_id ORDER BY product_id,year_date) AS py_sales,
total_sales - LAG(total_sales) OVER(PARTITION BY product_id ORDER BY product_id,year_date) AS py_diff,
CASE
WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_id ORDER BY product_id,year_date) > 0 THEN 'Increase'
WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_id ORDER BY product_id,year_date) < 0 THEN 'Decrease'
ELSE 'No Change'
END AS py_chnage


FROM yearly_product_sales
ORDER by product_id, year_date
