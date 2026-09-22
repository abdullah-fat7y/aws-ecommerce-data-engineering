-- ============================================================
-- TASK 28 - CHECK 6B
-- Automated total sales reconciliation
-- ============================================================

WITH detail_total AS (

    SELECT
        SUM(net_sales) AS detail_sales
    FROM ecommerce_wh.fact_order_detail

),

customer_total AS (

    SELECT
        SUM(sales) AS customer_sales
    FROM ecommerce_wh.fact_customer_sales

),

product_total AS (

    SELECT
        SUM(net_sales) AS product_sales
    FROM ecommerce_wh.fact_product_sales

)

SELECT

    detail_sales,

    customer_sales,

    product_sales,

    customer_sales - detail_sales
        AS customer_sales_difference,

    product_sales - detail_sales
        AS product_sales_difference,

    CASE

        WHEN ABS(customer_sales - detail_sales) < 0.01
         AND ABS(product_sales - detail_sales) < 0.01

        THEN 'PASS'

        ELSE 'FAIL'

    END AS validation_status

FROM detail_total
CROSS JOIN customer_total
CROSS JOIN product_total;