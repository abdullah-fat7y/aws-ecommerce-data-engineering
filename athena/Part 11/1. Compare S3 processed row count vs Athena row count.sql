-- ============================================================
-- TASK 28 - CHECK 1
-- Processed S3 / Athena row counts
-- ============================================================

SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count
FROM ecommerce_wh.dim_customer

UNION ALL

SELECT 'dim_product', COUNT(*)
FROM ecommerce_wh.dim_product

UNION ALL

SELECT 'dim_category', COUNT(*)
FROM ecommerce_wh.dim_category

UNION ALL

SELECT 'dim_department', COUNT(*)
FROM ecommerce_wh.dim_department

UNION ALL

SELECT 'dim_supplier', COUNT(*)
FROM ecommerce_wh.dim_supplier

UNION ALL

SELECT 'dim_employee', COUNT(*)
FROM ecommerce_wh.dim_employee

UNION ALL

SELECT 'dim_shipper', COUNT(*)
FROM ecommerce_wh.dim_shipper

UNION ALL

SELECT 'dim_date', COUNT(*)
FROM ecommerce_wh.dim_date

UNION ALL

SELECT 'dim_payment_method', COUNT(*)
FROM ecommerce_wh.dim_payment_method

UNION ALL

SELECT 'dim_order_status', COUNT(*)
FROM ecommerce_wh.dim_order_status

UNION ALL

SELECT 'fact_order', COUNT(*)
FROM ecommerce_wh.fact_order

UNION ALL

SELECT 'fact_order_detail', COUNT(*)
FROM ecommerce_wh.fact_order_detail

UNION ALL

SELECT 'fact_payment', COUNT(*)
FROM ecommerce_wh.fact_payment

UNION ALL

SELECT 'fact_shipment', COUNT(*)
FROM ecommerce_wh.fact_shipment

UNION ALL

SELECT 'fact_customer_sales', COUNT(*)
FROM ecommerce_wh.fact_customer_sales

UNION ALL

SELECT 'fact_product_sales', COUNT(*)
FROM ecommerce_wh.fact_product_sales

ORDER BY table_name;