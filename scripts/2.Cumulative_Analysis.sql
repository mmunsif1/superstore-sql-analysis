/*==================================================================================================================
  CUMULATIVE SALES ANALYSIS: RUNNING TOTALS OVER TIME
  ------------------------------------------------------------------------------------------------------------------
  Objective:
    This script performs a cumulative analysis of monthly and yearly sales in the 'superstore' dataset.
    It calculates both:
      - Total sales for each month/year
      - Running (cumulative) sales totals across time periods

  Key Use Cases:
    - Identify sales momentum over time
    - Spot patterns of growth or decline
    - Compare cumulative performance across years

  Techniques Used:
    - Subqueries to calculate monthly/yearly total sales
    - Window Function: SUM(...) OVER(ORDER BY ...) for cumulative totals
    - Optional Partitioning by Year using PARTITION BY clause for intra-year comparison
    - Time Functions: DATETRUNC() for grouping, FORMAT() for display

  Breakdown of Queries:
    1. Monthly Cumulative Sales:
       - Cumulative sales over all months (no partitioning)
    2. Monthly Cumulative Sales by Year:
       - Cumulative sales restarted at the beginning of each year (partitioned)
    3. Yearly Cumulative Sales:
       - Cumulative sales aggregated at the year level

  Output:
    Each query returns:
      - Time Period (month or year)
      - Total Sales for that period
      - Running Total (cumulative) of sales

==================================================================================================================*/

-- Calculate the total sales per month
-- And the running total of sales over months
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER by order_date) AS running_total_sales
FROM (
  SELECT
  DATETRUNC(month ,order_date) AS order_date,
  ROUND(SUM(sales),0) as total_sales
  FROM superstore
  GROUP by DATETRUNC(month ,order_date)
)t;


-- Calculate the total sales per month
-- And the running total of sales over months
-- Partitioned by year
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY year(order_date) ORDER by order_date) AS running_total_sales
FROM (
  SELECT
  DATETRUNC(month ,order_date) AS order_date,
  ROUND(SUM(sales),0) as total_sales
  FROM superstore
  GROUP by DATETRUNC(month ,order_date)
)t;

-- Calculate the total sales per year
-- And the running total of sales over years
SELECT
FORMAT(order_date, 'yyyy') AS order_date,
total_sales,
SUM(total_sales) OVER(ORDER by order_date) AS running_total_sales
FROM (
  SELECT
  DATETRUNC(year ,order_date) AS order_date,
  ROUND(SUM(sales),0) as total_sales
  FROM superstore
  GROUP by DATETRUNC(year ,order_date)
)t;