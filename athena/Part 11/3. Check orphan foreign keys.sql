-- ============================================================
-- TASK 28 - CHECK 3
-- Check orphan foreign keys
-- ============================================================

-- fact_order -> dim_customer
SELECT
    'fact_order -> dim_customer' AS relationship,
    COUNT(*) AS orphan_count
FROM ecommerce_wh.fact_order f
LEFT JOIN ecommerce_wh.dim_customer d
    ON f.customer_key = d.customer_key
WHERE f.customer_key IS NOT NULL
  AND d.customer_key IS NULL

UNION ALL

-- fact_order -> dim_date
SELECT
    'fact_order -> dim_date',
    COUNT(*)
FROM ecommerce_wh.fact_order f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.date_key = d.date_key
WHERE f.date_key IS NOT NULL
  AND d.date_key IS NULL

UNION ALL

-- fact_order -> dim_order_status
SELECT
    'fact_order -> dim_order_status',
    COUNT(*)
FROM ecommerce_wh.fact_order f
LEFT JOIN ecommerce_wh.dim_order_status d
    ON f.order_status_key = d.order_status_key
WHERE f.order_status_key IS NOT NULL
  AND d.order_status_key IS NULL

UNION ALL

-- fact_order_detail -> dim_product
SELECT
    'fact_order_detail -> dim_product',
    COUNT(*)
FROM ecommerce_wh.fact_order_detail f
LEFT JOIN ecommerce_wh.dim_product d
    ON f.product_key = d.product_key
WHERE f.product_key IS NOT NULL
  AND d.product_key IS NULL

UNION ALL

-- fact_order_detail -> dim_customer
SELECT
    'fact_order_detail -> dim_customer',
    COUNT(*)
FROM ecommerce_wh.fact_order_detail f
LEFT JOIN ecommerce_wh.dim_customer d
    ON f.customer_key = d.customer_key
WHERE f.customer_key IS NOT NULL
  AND d.customer_key IS NULL

UNION ALL

-- fact_order_detail -> dim_date
SELECT
    'fact_order_detail -> dim_date',
    COUNT(*)
FROM ecommerce_wh.fact_order_detail f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.date_key = d.date_key
WHERE f.date_key IS NOT NULL
  AND d.date_key IS NULL

UNION ALL

-- fact_payment -> dim_customer
SELECT
    'fact_payment -> dim_customer',
    COUNT(*)
FROM ecommerce_wh.fact_payment f
LEFT JOIN ecommerce_wh.dim_customer d
    ON f.customer_key = d.customer_key
WHERE f.customer_key IS NOT NULL
  AND d.customer_key IS NULL

UNION ALL

-- fact_payment -> dim_date
SELECT
    'fact_payment -> dim_date',
    COUNT(*)
FROM ecommerce_wh.fact_payment f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.date_key = d.date_key
WHERE f.date_key IS NOT NULL
  AND d.date_key IS NULL

UNION ALL

-- fact_payment -> dim_payment_method
SELECT
    'fact_payment -> dim_payment_method',
    COUNT(*)
FROM ecommerce_wh.fact_payment f
LEFT JOIN ecommerce_wh.dim_payment_method d
    ON f.payment_method_key = d.payment_method_key
WHERE f.payment_method_key IS NOT NULL
  AND d.payment_method_key IS NULL

UNION ALL

-- fact_shipment -> dim_customer
SELECT
    'fact_shipment -> dim_customer',
    COUNT(*)
FROM ecommerce_wh.fact_shipment f
LEFT JOIN ecommerce_wh.dim_customer d
    ON f.customer_key = d.customer_key
WHERE f.customer_key IS NOT NULL
  AND d.customer_key IS NULL

UNION ALL

-- fact_shipment -> dim_shipper
SELECT
    'fact_shipment -> dim_shipper',
    COUNT(*)
FROM ecommerce_wh.fact_shipment f
LEFT JOIN ecommerce_wh.dim_shipper d
    ON f.shipper_key = d.shipper_key
WHERE f.shipper_key IS NOT NULL
  AND d.shipper_key IS NULL

UNION ALL

-- fact_shipment -> dim_date (ship)
SELECT
    'fact_shipment -> dim_date (ship)',
    COUNT(*)
FROM ecommerce_wh.fact_shipment f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.ship_date_key = d.date_key
WHERE f.ship_date_key IS NOT NULL
  AND d.date_key IS NULL

UNION ALL

-- fact_shipment -> dim_date (delivery)
SELECT
    'fact_shipment -> dim_date (delivery)',
    COUNT(*)
FROM ecommerce_wh.fact_shipment f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.delivery_date_key = d.date_key
WHERE f.delivery_date_key IS NOT NULL
  AND d.date_key IS NULL

UNION ALL

-- fact_customer_sales -> dim_customer
SELECT
    'fact_customer_sales -> dim_customer',
    COUNT(*)
FROM ecommerce_wh.fact_customer_sales f
LEFT JOIN ecommerce_wh.dim_customer d
    ON f.customer_key = d.customer_key
WHERE f.customer_key IS NOT NULL
  AND d.customer_key IS NULL

UNION ALL

-- fact_customer_sales -> dim_date
SELECT
    'fact_customer_sales -> dim_date',
    COUNT(*)
FROM ecommerce_wh.fact_customer_sales f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.date_key = d.date_key
WHERE f.date_key IS NOT NULL
  AND d.date_key IS NULL

UNION ALL

-- fact_product_sales -> dim_product
SELECT
    'fact_product_sales -> dim_product',
    COUNT(*)
FROM ecommerce_wh.fact_product_sales f
LEFT JOIN ecommerce_wh.dim_product d
    ON f.product_key = d.product_key
WHERE f.product_key IS NOT NULL
  AND d.product_key IS NULL

UNION ALL

-- fact_product_sales -> dim_date
SELECT
    'fact_product_sales -> dim_date',
    COUNT(*)
FROM ecommerce_wh.fact_product_sales f
LEFT JOIN ecommerce_wh.dim_date d
    ON f.date_key = d.date_key
WHERE f.date_key IS NOT NULL
  AND d.date_key IS NULL

ORDER BY relationship;