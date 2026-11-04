/* =====================================================================
   SuperStore Orders – SQL Analysis (PostgreSQL)
   Source : data/superstore_cleaned.csv (51,290 order lines, 18 columns)
   Run    : psql -U postgres -f sql/superstore_analysis.sql
            (run from the project root so the \copy path resolves)
   ===================================================================== */


/* ---------------------------------------------------------------------
   PART 1: DATABASE
   --------------------------------------------------------------------- */
DROP DATABASE IF EXISTS superstore_db;
CREATE DATABASE superstore_db;

\c superstore_db


/* ---------------------------------------------------------------------
   PART 2: TABLE
   One row = one order line (a product within an order).
   --------------------------------------------------------------------- */
CREATE TABLE superstore_orders (
    order_line_id  INT PRIMARY KEY,
    order_id       VARCHAR(30)    NOT NULL,
    order_date     DATE           NOT NULL,
    ship_date      DATE           NOT NULL,
    ship_mode      VARCHAR(20)    NOT NULL,
    customer_name  VARCHAR(60)    NOT NULL,
    segment        VARCHAR(20)    NOT NULL,
    country        VARCHAR(60)    NOT NULL,
    market         VARCHAR(20)    NOT NULL,
    category       VARCHAR(30)    NOT NULL,
    sub_category   VARCHAR(30)    NOT NULL,
    product_name   VARCHAR(200)   NOT NULL,
    sales          NUMERIC(12,2)  NOT NULL CHECK (sales >= 0),
    quantity       INT            NOT NULL CHECK (quantity > 0),
    discount       NUMERIC(4,3)   NOT NULL CHECK (discount BETWEEN 0 AND 1),
    profit         NUMERIC(12,2)  NOT NULL,
    shipping_cost  NUMERIC(10,2)  NOT NULL CHECK (shipping_cost >= 0),
    order_priority VARCHAR(10)    NOT NULL,
    CHECK (ship_date >= order_date)
);

-- Load the cleaned data (alternative: pgAdmin > Import/Export Data)
\copy superstore_orders FROM 'data/superstore_cleaned.csv' WITH (FORMAT csv, HEADER true)

-- Sanity check: expect 51,290 rows
SELECT COUNT(*) AS total_rows FROM superstore_orders;


/* ---------------------------------------------------------------------
   PART 3: ANALYSIS QUERIES
   --------------------------------------------------------------------- */

-- =========================== A. BUSINESS OVERVIEW ====================

-- Q1 [Basic] What are the company's overall key performance indicators?
SELECT
    COUNT(DISTINCT order_id)                       AS total_orders,
    COUNT(DISTINCT customer_name)                  AS total_customers,
    COUNT(DISTINCT country)                        AS total_countries,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)       AS profit_margin_pct
FROM superstore_orders;


-- Q2 [Basic] How have sales and profit changed each year?
SELECT
    EXTRACT(YEAR FROM order_date)::INT             AS order_year,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)       AS profit_margin_pct
FROM superstore_orders
GROUP BY order_year
ORDER BY order_year;


-- Q3 [Intermediate] What is the year-over-year sales growth?
WITH yearly_sales AS (
    SELECT EXTRACT(YEAR FROM order_date)::INT AS order_year,
           SUM(sales)                         AS total_sales
    FROM superstore_orders
    GROUP BY order_year
)
SELECT
    order_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_year) AS previous_year_sales,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY order_year))
          / LAG(total_sales) OVER (ORDER BY order_year) * 100, 2) AS yoy_growth_pct
FROM yearly_sales
ORDER BY order_year;


-- Q4 [Basic] Which months are the strongest for sales (seasonality)?
SELECT
    EXTRACT(MONTH FROM order_date)::INT            AS order_month,
    SUM(sales)                                     AS total_sales,
    COUNT(DISTINCT order_id)                       AS total_orders
FROM superstore_orders
GROUP BY order_month
ORDER BY order_month;


-- =========================== B. PRODUCTS =============================

-- Q5 [Basic] How does each product category perform?
SELECT
    category,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)       AS profit_margin_pct
FROM superstore_orders
GROUP BY category
ORDER BY total_profit DESC;


-- Q6 [Basic] Which 10 sub-categories generate the highest profit?
SELECT
    sub_category,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 10;


-- Q7 [Basic] Which sub-categories are loss-making?
SELECT
    sub_category,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;


-- Q8 [Basic] What are the 10 best-selling products by sales value?
SELECT
    product_name,
    SUM(quantity)                                  AS units_sold,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


-- Q9 [Intermediate] What are the top 3 sub-categories by sales within each category?
WITH sub_sales AS (
    SELECT category, sub_category, SUM(sales) AS total_sales
    FROM superstore_orders
    GROUP BY category, sub_category
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS sales_rank
    FROM sub_sales
)
SELECT category, sub_category, total_sales, sales_rank
FROM ranked
WHERE sales_rank <= 3
ORDER BY category, sales_rank;


-- =========================== C. GEOGRAPHY ============================

-- Q10 [Basic] How does each market perform, including shipping cost burden?
SELECT
    market,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)       AS profit_margin_pct,
    ROUND(SUM(shipping_cost) / SUM(sales) * 100, 2) AS shipping_cost_pct
FROM superstore_orders
GROUP BY market
ORDER BY total_sales DESC;


-- Q11 [Basic] Which 10 countries generate the most sales?
SELECT
    country,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
GROUP BY country
ORDER BY total_sales DESC
LIMIT 10;


-- Q12 [Basic] Which 10 countries have the largest total losses?
SELECT
    country,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
GROUP BY country
HAVING SUM(profit) < 0
ORDER BY total_profit
LIMIT 10;


-- =========================== D. CUSTOMERS ============================

-- Q13 [Basic] How do the customer segments compare?
SELECT
    segment,
    COUNT(DISTINCT customer_name)                  AS customers,
    COUNT(DISTINCT order_id)                       AS orders,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)       AS profit_margin_pct
FROM superstore_orders
GROUP BY segment
ORDER BY total_sales DESC;


-- Q14 [Basic] Who are the top 10 customers by sales?
SELECT
    customer_name,
    segment,
    COUNT(DISTINCT order_id)                       AS orders,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
GROUP BY customer_name, segment
ORDER BY total_sales DESC
LIMIT 10;


-- Q15 [Intermediate] What is the average order value for each segment?
WITH order_totals AS (
    SELECT order_id, segment, SUM(sales) AS order_value
    FROM superstore_orders
    GROUP BY order_id, segment
)
SELECT
    segment,
    COUNT(*)                                       AS total_orders,
    ROUND(AVG(order_value), 2)                     AS avg_order_value
FROM order_totals
GROUP BY segment
ORDER BY avg_order_value DESC;


-- Q16 [Intermediate] How many customers fall into each value tier?
--      High: 20,000+ | Medium: 10,000 to 19,999 | Low: below 10,000
WITH customer_sales AS (
    SELECT customer_name, SUM(sales) AS total_sales
    FROM superstore_orders
    GROUP BY customer_name
)
SELECT
    CASE
        WHEN total_sales >= 20000 THEN 'High'
        WHEN total_sales >= 10000 THEN 'Medium'
        ELSE 'Low'
    END                                            AS customer_tier,
    COUNT(*)                                       AS customers,
    SUM(total_sales)                               AS tier_sales,
    ROUND(SUM(total_sales) * 100.0 / SUM(SUM(total_sales)) OVER (), 2) AS sales_share_pct
FROM customer_sales
GROUP BY customer_tier
ORDER BY tier_sales DESC;


-- =========================== E. DISCOUNTS & SHIPPING =================

-- Q17 [Intermediate] How do discount levels affect profit?
SELECT
    CASE
        WHEN discount = 0    THEN '1. No discount'
        WHEN discount <= 0.2 THEN '2. Up to 20%'
        WHEN discount <= 0.4 THEN '3. 21% to 40%'
        ELSE                      '4. Above 40%'
    END                                            AS discount_band,
    COUNT(*)                                       AS order_lines,
    SUM(profit)                                    AS total_profit,
    ROUND(AVG(profit), 2)                          AS avg_profit_per_line
FROM superstore_orders
GROUP BY discount_band
ORDER BY discount_band;


-- Q18 [Basic] How do shipping modes compare on speed and cost?
SELECT
    ship_mode,
    COUNT(DISTINCT order_id)                       AS orders,
    ROUND(AVG(ship_date - order_date), 2)          AS avg_shipping_days,
    ROUND(AVG(shipping_cost), 2)                   AS avg_shipping_cost
FROM superstore_orders
GROUP BY ship_mode
ORDER BY avg_shipping_days;


-- Q19 [Basic] Is delivery time consistent with order priority?
SELECT
    order_priority,
    COUNT(DISTINCT order_id)                       AS orders,
    ROUND(AVG(ship_date - order_date), 2)          AS avg_shipping_days
FROM superstore_orders
GROUP BY order_priority
ORDER BY avg_shipping_days;


-- Q20 [Basic] How much profit is lost to heavy discounts (above 30%) in each category?
SELECT
    category,
    COUNT(*)                                       AS discounted_lines,
    SUM(sales)                                     AS total_sales,
    SUM(profit)                                    AS total_profit
FROM superstore_orders
WHERE discount > 0.3
GROUP BY category
ORDER BY total_profit;
