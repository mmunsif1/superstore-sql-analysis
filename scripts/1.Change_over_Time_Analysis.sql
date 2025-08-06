/*==================================================================================================================
  CHANGE OVER TIME ANALYSIS: SALES, QUANTITY & PROFIT TRENDS
  ------------------------------------------------------------------------------------------------------------------
  Objective:
    This script analyzes how key business metrics — Sales, Quantity Sold, and Profit — have evolved over time 
    in the 'superstore' dataset. It breaks down these measures across various time periods to identify trends 
    and patterns in business performance.

  Time Granularities Covered:
    1. Yearly Overview                  → Using YEAR() function
    2. Quarterly Overview               → Using DATETRUNC() with FORMAT()
    3. Year-Month (Numeric Format)     → Using YEAR() and MONTH() combination
    4. Year-Month (Full Date Format)   → Using DATETRUNC(month, ...)
    5. Year-Month (yyyy-MM String)     → Using FORMAT() for clean string grouping
    6. Year-Month (yyyy-MMM Format)    → Using FORMAT() to include month names

  Key Functions & Concepts Used:
    - Aggregation Functions: SUM(), ROUND()
    - Time Functions: YEAR(), MONTH(), DATETRUNC()
    - String Formatting: FORMAT()
    - Grouping and Sorting for temporal comparison

  Why Multiple Methods?
    Each variation demonstrates a different approach to time-based aggregation, allowing flexibility based on:
      - Preferred time granularity
      - Desired output format

  Output:
    Each query returns:
      - Time period (year/quarter/month)
      - Total Sales
      - Total Quantity
      - Total Profit
==================================================================================================================*/


-- Analyze Sales, Quantity & Profit Over YEARS
SELECT
  YEAR(order_date) AS order_year,
  ROUND(SUM(sales),0) AS total_sales,
  SUM(quantity) AS total_quanitity,
  ROUND(SUM(profit),0) AS total_profit
FROM superstore
GROUP BY YEAR(order_date)
ORDER by YEAR(order_date);

-- Analyze Sales, Quantity & Profit Over QUARTERS
SELECT
  FORMAT(DATETRUNC(qq, order_date),'yyyy-MM') AS order_quarter,
  ROUND(SUM(sales),0) AS total_sales,
  SUM(quantity) AS total_quanitity,
  ROUND(SUM(profit),0) AS total_profit
FROM superstore
GROUP by DATETRUNC(quarter, order_date)
order by DATETRUNC(quarter, order_date);

-- Analyze Sales, Quantity & Profit Over YEARS & MONTHS Using YEAR() & MONTH() functions
SELECT
  YEAR(order_date) AS order_year,
  MONTH(order_date) AS order_month,
  ROUND(SUM(sales),0) AS total_sales,
  SUM(quantity) AS total_quanitity,
  ROUND(SUM(profit),0) AS total_profit
FROM superstore
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER by YEAR(order_date), MONTH(order_date);

-- Analyze Sales, Quantity & Profit Over YEARS & MONTHS Using DATETRUNC() function
SELECT
  DATETRUNC(month, order_date) AS order_month,
  ROUND(SUM(sales),0) AS total_sales,
  SUM(quantity) AS total_quanitity,
  ROUND(SUM(profit),0) AS total_profit
FROM superstore
GROUP BY DATETRUNC(month, order_date)
ORDER by DATETRUNC(month, order_date);

-- Analyze Sales, Quantity & Profit Over YEARS & MONTHS Using Format() function With year and month_number
SELECT
  FORMAT(order_date,'yyyy-MM') AS order_month,
  ROUND(SUM(sales),0) AS total_sales,
  SUM(quantity) AS total_quanitity,
  ROUND(SUM(profit),0) AS total_profit
FROM superstore
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY FORMAT(order_date,'yyyy-MM');

-- Analyze Sales, Quantity & Profit Over YEARS & MONTHS Using Format() With year and month_name
SELECT
  FORMAT(order_date,'yyyy-MMM') AS order_month,
  ROUND(SUM(sales),0) AS total_sales,
  SUM(quantity) AS total_quanitity,
  ROUND(SUM(profit),0) AS total_profit
FROM superstore
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM');