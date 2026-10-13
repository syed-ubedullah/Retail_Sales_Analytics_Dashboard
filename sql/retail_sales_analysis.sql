/* =====================================================================
   Retail Sales Analytics Dashboard - SQL Analysis
   Dialect : MySQL 8+
   Data    : ../data/Retail_Sales_Analytics_Dashboard.csv (9,994 rows)
   Purpose : Validate the Power BI KPIs and answer the business questions
             behind each dashboard page.
   ===================================================================== */

/* ---------------------------------------------------------------------
   0. TABLE + LOAD
   --------------------------------------------------------------------- */
CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    row_id        INT,
    order_id      VARCHAR(20),
    order_date    DATE,
    ship_date     DATE,
    ship_mode     VARCHAR(20),
    customer_id   VARCHAR(15),
    customer_name VARCHAR(60),
    segment       VARCHAR(20),
    country       VARCHAR(30),
    city          VARCHAR(40),
    state         VARCHAR(30),
    postal_code   VARCHAR(10),
    region        VARCHAR(15),
    product_id    VARCHAR(20),
    category      VARCHAR(20),
    sub_category  VARCHAR(20),
    product_name  VARCHAR(255),
    sales         DECIMAL(12,4),
    quantity      INT,
    discount      DECIMAL(4,2),
    profit        DECIMAL(12,4)
);

-- The CSV is Windows-1252 (latin1) and dates are M/D/YYYY.
LOAD DATA LOCAL INFILE 'Retail_Sales_Analytics_Dashboard.csv'
INTO TABLE retail_sales
CHARACTER SET latin1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(row_id, order_id, @order_date, @ship_date, ship_mode, customer_id, customer_name,
 segment, country, city, state, postal_code, region, product_id, category,
 sub_category, product_name, sales, quantity, discount, profit)
SET order_date = STR_TO_DATE(@order_date, '%m/%d/%Y'),
    ship_date  = STR_TO_DATE(@ship_date,  '%m/%d/%Y');

/* ---------------------------------------------------------------------
   1. DATA QUALITY CHECKS
   --------------------------------------------------------------------- */
-- Row count, date range, and rows that failed date parsing (should be 0)
SELECT COUNT(*)                         AS total_rows,
       MIN(order_date)                  AS first_order,
       MAX(order_date)                  AS last_order,
       SUM(order_date IS NULL)          AS bad_order_dates
FROM retail_sales;

-- Duplicate order lines (should be 0)
SELECT COUNT(*) - COUNT(DISTINCT row_id) AS duplicate_rows FROM retail_sales;

/* ---------------------------------------------------------------------
   2. EXECUTIVE OVERVIEW - headline KPIs
   --------------------------------------------------------------------- */
SELECT ROUND(SUM(sales), 2)                          AS total_sales,
       ROUND(SUM(profit), 2)                         AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
       ROUND(AVG(discount) * 100, 2)                 AS avg_discount_pct,
       COUNT(DISTINCT order_id)                      AS total_orders,
       COUNT(DISTINCT customer_id)                   AS total_customers,
       ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM retail_sales;

-- Sales and profit by category
SELECT category,
       ROUND(SUM(sales), 2)                     AS total_sales,
       ROUND(SUM(profit), 2)                    AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Monthly sales and profit trend
SELECT YEAR(order_date)  AS yr,
       MONTH(order_date) AS mth,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mth;

-- Seasonality: average sales by calendar month across all years
SELECT MONTH(order_date) AS mth,
       ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY MONTH(order_date)
ORDER BY total_sales DESC;

-- Year-over-year sales growth
WITH yearly AS (
    SELECT YEAR(order_date) AS yr, SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY YEAR(order_date)
)
SELECT yr,
       ROUND(total_sales, 2) AS total_sales,
       ROUND((total_sales - LAG(total_sales) OVER (ORDER BY yr))
             / LAG(total_sales) OVER (ORDER BY yr) * 100, 2) AS yoy_growth_pct
FROM yearly
ORDER BY yr;

/* ---------------------------------------------------------------------
   3. SALES & PRODUCT ANALYSIS
   --------------------------------------------------------------------- */
-- Sub-category performance with margin
SELECT category, sub_category,
       ROUND(SUM(sales), 2)                     AS total_sales,
       ROUND(SUM(profit), 2)                    AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM retail_sales
GROUP BY category, sub_category
ORDER BY total_profit DESC;

-- Loss-making sub-categories
SELECT sub_category,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Top 10 products by sales
SELECT product_name,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Impact of discounting on profit
SELECT CASE WHEN discount = 0    THEN '0%'
            WHEN discount <= 0.2 THEN '1-20%'
            WHEN discount <= 0.4 THEN '21-40%'
            ELSE 'Above 40%' END AS discount_band,
       COUNT(*)                  AS order_lines,
       ROUND(SUM(sales), 2)      AS total_sales,
       ROUND(SUM(profit), 2)     AS total_profit
FROM retail_sales
GROUP BY discount_band
ORDER BY MIN(discount);

/* ---------------------------------------------------------------------
   4. CUSTOMER ANALYSIS
   --------------------------------------------------------------------- */
-- Segment summary
SELECT segment,
       COUNT(DISTINCT customer_id)               AS customers,
       ROUND(SUM(sales), 2)                      AS total_sales,
       ROUND(SUM(profit), 2)                     AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2)  AS margin_pct
FROM retail_sales
GROUP BY segment
ORDER BY total_sales DESC;

-- Top 10 customers by sales (with their profit)
SELECT customer_name,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 customers by profit
SELECT customer_name,
       ROUND(SUM(profit), 2) AS total_profit,
       ROUND(SUM(sales), 2)  AS total_sales
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC
LIMIT 10;

/* ---------------------------------------------------------------------
   5. REGIONAL PERFORMANCE
   --------------------------------------------------------------------- */
-- Region summary
SELECT region,
       ROUND(SUM(sales), 2)                     AS total_sales,
       ROUND(SUM(profit), 2)                    AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM retail_sales
GROUP BY region
ORDER BY total_sales DESC;

-- Region x category sales
SELECT region, category, ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY region, category
ORDER BY region, total_sales DESC;

-- Top 10 states by profit
SELECT state,
       ROUND(SUM(profit), 2) AS total_profit,
       ROUND(SUM(sales), 2)  AS total_sales
FROM retail_sales
GROUP BY state
ORDER BY total_profit DESC
LIMIT 10;

-- Loss-making states
SELECT state,
       ROUND(SUM(profit), 2)       AS total_profit,
       ROUND(AVG(discount) * 100, 2) AS avg_discount_pct
FROM retail_sales
GROUP BY state
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Top 10 cities by sales
SELECT city, state,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY city, state
ORDER BY total_sales DESC
LIMIT 10;

-- Shipping mode performance
SELECT ship_mode,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales), 2)     AS total_sales,
       ROUND(SUM(profit), 2)    AS total_profit
FROM retail_sales
GROUP BY ship_mode
ORDER BY total_sales DESC;
