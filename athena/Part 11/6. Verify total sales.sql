-- ============================================================
-- TASK 28 - CHECK 6
-- Total sales reconciliation
-- ============================================================

SELECT
    'fact_order_detail' AS source_table,
    SUM(net_sales) AS total_sales
FROM ecommerce_wh.fact_order_detail

UNION ALL

SELECT
    'fact_customer_sales',
    SUM(sales)
FROM ecommerce_wh.fact_customer_sales

UNION ALL

SELECT
    'fact_product_sales',
    SUM(net_sales)
FROM ecommerce_wh.fact_product_sales;