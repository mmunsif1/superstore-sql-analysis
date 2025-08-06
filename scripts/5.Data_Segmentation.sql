/*==================================================================================================================
  DATA SEGMENTATION: PRODUCT SALES RANGES
  ------------------------------------------------------------------------------------------------------------------
  Objective:
    This script segments products based on their total sales and counts how many products fall into each defined
    sales range. This technique helps in categorizing product performance and identifying concentration patterns.

  Key Questions Answered:
    - How many products have low, medium, or high sales?
    - What is the distribution of products across defined sales brackets?

  Segmentation Logic:
    Products are grouped into the following custom-defined sales ranges:
      • 'Below 1000'
      • '1000–5000'
      • '5000–10000'
      • '10000–15000'
      • 'Above 15000'

  Techniques & Functions Used:
    - CTE `products_sales` to calculate total sales per product
    - CTE `products_segments` to classify each product into a sales range using a `CASE` statement
    - `ROUND()` for simplified sales figures
    - `COUNT()` to determine how many products fall in each range
    - `GROUP BY` and `ORDER BY` to organize and rank results

  Output:
    - `sale_range`: The defined bracket the product's sales fall into
    - `total_products`: Number of products in each sales range

==================================================================================================================*/

-- Segment products into sale ranges
-- and count how many products fall into each segment
WITH products_sales AS (
  SELECT
    product_id,
    ROUND(SUM(sales),0) AS sales
  FROM superstore
  GROUP By product_id
),

products_segments AS (
  SELECT
    product_id,
    sales,
    CASE
    WHEN sales < 1000 THEN 'Below 1000'
    WHEN sales >= 1000 AND sales <= 5000 THEN '1000-5000'
    WHEN sales > 5000 AND sales <= 10000 THEN '5000-10000'
    WHEN sales > 10000 AND sales <= 15000 THEN '10000-15000'
    ELSE 'Above 15000'
    END AS sale_range
  FROM products_sales
)

SELECT
  sale_range,
  COUNT(sale_range) AS total_products
FROM products_segments
GROUP BY sale_range
ORDER By total_products DESC
