-- ============================================================
-- TASK 28 - CHECK 4
-- Check NULL surrogate / foreign keys
-- ============================================================

SELECT
    'fact_order.customer_key' AS column_name,
    COUNT(*) AS null_count
FROM ecommerce_wh.fact_order
WHERE customer_key IS NULL

UNION ALL

SELECT
    'fact_order.date_key',
    COUNT(*)
FROM ecommerce_wh.fact_order
WHERE date_key IS NULL

UNION ALL

SELECT
    'fact_order.order_status_key',
    COUNT(*)
FROM ecommerce_wh.fact_order
WHERE order_status_key IS NULL

UNION ALL

SELECT
    'fact_order_detail.product_key',
    COUNT(*)
FROM ecommerce_wh.fact_order_detail
WHERE product_key IS NULL

UNION ALL

SELECT
    'fact_order_detail.customer_key',
    COUNT(*)
FROM ecommerce_wh.fact_order_detail
WHERE customer_key IS NULL

UNION ALL

SELECT
    'fact_order_detail.date_key',
    COUNT(*)
FROM ecommerce_wh.fact_order_detail
WHERE date_key IS NULL

UNION ALL

SELECT
    'fact_payment.customer_key',
    COUNT(*)
FROM ecommerce_wh.fact_payment
WHERE customer_key IS NULL

UNION ALL

SELECT
    'fact_payment.date_key',
    COUNT(*)
FROM ecommerce_wh.fact_payment
WHERE date_key IS NULL

UNION ALL

SELECT
    'fact_payment.payment_method_key',
    COUNT(*)
FROM ecommerce_wh.fact_payment
WHERE payment_method_key IS NULL

UNION ALL

SELECT
    'fact_shipment.customer_key',
    COUNT(*)
FROM ecommerce_wh.fact_shipment
WHERE customer_key IS NULL

UNION ALL

SELECT
    'fact_shipment.shipper_key',
    COUNT(*)
FROM ecommerce_wh.fact_shipment
WHERE shipper_key IS NULL

UNION ALL

SELECT
    'fact_shipment.ship_date_key',
    COUNT(*)
FROM ecommerce_wh.fact_shipment
WHERE ship_date_key IS NULL

UNION ALL

SELECT
    'fact_shipment.delivery_date_key',
    COUNT(*)
FROM ecommerce_wh.fact_shipment
WHERE delivery_date_key IS NULL

UNION ALL

SELECT
    'fact_customer_sales.customer_key',
    COUNT(*)
FROM ecommerce_wh.fact_customer_sales
WHERE customer_key IS NULL

UNION ALL

SELECT
    'fact_customer_sales.date_key',
    COUNT(*)
FROM ecommerce_wh.fact_customer_sales
WHERE date_key IS NULL

UNION ALL

SELECT
    'fact_product_sales.product_key',
    COUNT(*)
FROM ecommerce_wh.fact_product_sales
WHERE product_key IS NULL

UNION ALL

SELECT
    'fact_product_sales.date_key',
    COUNT(*)
FROM ecommerce_wh.fact_product_sales
WHERE date_key IS NULL

ORDER BY column_name;