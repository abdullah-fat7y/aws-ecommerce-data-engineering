-- ============================================================
-- PART 13 — ADVANCED SQL
-- Database: ecommerce_wh
--
-- Task 38: Running Sales
-- Task 39: Month-over-Month Growth
-- Task 40: Product Ranking
-- Task 41: Customer Ranking
--
-- All tasks use SQL window functions.
-- ============================================================


-- ============================================================
-- TASK 38 — RUNNING SALES
--
-- Calculate cumulative sales by date.
--
-- Step 1:
-- Aggregate sales for each date.
--
-- Step 2:
-- Use SUM() OVER() to calculate cumulative sales.
-- ============================================================

WITH daily_sales AS (
    SELECT
        d.full_date AS sales_date,
        SUM(f.net_sales) AS daily_sales

    FROM ecommerce_wh.fact_order_detail f

    JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key

    GROUP BY
        d.full_date
)

SELECT
    sales_date,

    ROUND(daily_sales, 2) AS daily_sales,

    ROUND(
        SUM(daily_sales) OVER (
            ORDER BY sales_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_sales

FROM daily_sales

ORDER BY
    sales_date;


-- ============================================================
-- TASK 39 — MONTH-OVER-MONTH GROWTH
--
-- Calculate:
--   Current Month Sales
--   Previous Month Sales
--   Sales Difference
--   Growth Percentage
--
-- LAG() is used to retrieve the previous month's sales.
-- ============================================================

WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        d.month_name,

        SUM(f.net_sales) AS current_month_sales

    FROM ecommerce_wh.fact_order_detail f

    JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key

    GROUP BY
        d.year,
        d.month,
        d.month_name
),

monthly_with_previous AS (
    SELECT
        year,
        month,
        month_name,
        current_month_sales,

        LAG(current_month_sales) OVER (
            ORDER BY year, month
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    year,
    month,
    month_name,

    ROUND(current_month_sales, 2)
        AS current_month_sales,

    ROUND(previous_month_sales, 2)
        AS previous_month_sales,

    ROUND(
        current_month_sales - previous_month_sales,
        2
    ) AS sales_difference,

    ROUND(
        CASE
            WHEN previous_month_sales IS NULL
                THEN NULL

            WHEN previous_month_sales = 0
                THEN NULL

            ELSE
                (
                    (current_month_sales - previous_month_sales)
                    / previous_month_sales
                ) * 100
        END,
        2
    ) AS growth_percentage

FROM monthly_with_previous

ORDER BY
    year,
    month;


-- ============================================================
-- TASK 40 — PRODUCT RANKING
--
-- Rank products by sales within each category.
--
-- Return:
--   Category
--   Product
--   Sales
--   Rank
--
-- Only the top 3 products from each category are returned.
-- ============================================================

WITH product_sales AS (
    SELECT
        p.category_id,
        p.category_name,

        p.product_id,
        p.product_name,

        SUM(f.net_sales) AS sales

    FROM ecommerce_wh.fact_order_detail f

    JOIN ecommerce_wh.dim_product p
        ON f.product_key = p.product_key

    GROUP BY
        p.category_id,
        p.category_name,
        p.product_id,
        p.product_name
),

ranked_products AS (
    SELECT
        category_name,
        product_id,
        product_name,
        sales,

        RANK() OVER (
            PARTITION BY category_id
            ORDER BY sales DESC
        ) AS product_rank

    FROM product_sales
)

SELECT
    category_name AS category,
    product_name AS product,

    ROUND(sales, 2) AS sales,

    product_rank AS rank

FROM ranked_products

WHERE product_rank <= 3

ORDER BY
    category,
    rank,
    sales DESC;


-- ============================================================
-- TASK 41 — CUSTOMER RANKING
--
-- Rank customers by total spending.
--
-- Return:
--   Customer
--   Total Spending
--   Order Count
--   Rank
-- ============================================================

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,

        SUM(f.net_sales) AS total_spending,

        COUNT(DISTINCT f.order_id) AS order_count

    FROM ecommerce_wh.fact_order_detail f

    JOIN ecommerce_wh.dim_customer c
        ON f.customer_key = c.customer_key

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),

ranked_customers AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        total_spending,
        order_count,

        RANK() OVER (
            ORDER BY total_spending DESC
        ) AS customer_rank

    FROM customer_sales
)

SELECT
    CONCAT(first_name, ' ', last_name) AS customer,

    ROUND(total_spending, 2) AS total_spending,

    order_count,

    customer_rank AS rank

FROM ranked_customers

ORDER BY
    rank,
    total_spending DESC;