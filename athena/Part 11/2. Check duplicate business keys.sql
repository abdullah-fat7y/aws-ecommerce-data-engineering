-- ============================================================
-- TASK 28 - CHECK 2
-- Check duplicate business / grain keys
-- ============================================================

-- ============================================================
-- DIMENSIONS
-- ============================================================

SELECT
    'dim_customer' AS table_name,
    'customer_id' AS business_key,
    CAST(customer_id AS VARCHAR) AS key_value,
    COUNT(*) AS duplicate_count
FROM ecommerce_wh.dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'dim_product',
    'product_id',
    CAST(product_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.dim_product
GROUP BY product_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'dim_category',
    'category_id',
    CAST(category_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.dim_category
GROUP BY category_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'dim_department',
    'department_id',
    CAST(department_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.dim_department
GROUP BY department_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'dim_supplier',
    'supplier_id',
    CAST(supplier_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.dim_supplier
GROUP BY supplier_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'dim_employee',
    'employee_id',
    CAST(employee_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.dim_employee
GROUP BY employee_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'dim_shipper',
    'shipper_id',
    CAST(shipper_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.dim_shipper
GROUP BY shipper_id
HAVING COUNT(*) > 1

-- ============================================================
-- FACT TABLES
-- ============================================================

UNION ALL

SELECT
    'fact_order',
    'order_id',
    CAST(order_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.fact_order
GROUP BY order_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'fact_order_detail',
    'order_detail_id',
    CAST(order_detail_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.fact_order_detail
GROUP BY order_detail_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'fact_payment',
    'payment_id',
    CAST(payment_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.fact_payment
GROUP BY payment_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'fact_shipment',
    'shipment_id',
    CAST(shipment_id AS VARCHAR),
    COUNT(*)
FROM ecommerce_wh.fact_shipment
GROUP BY shipment_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'fact_customer_sales',
    'customer_key + date_key',
    CONCAT(
        CAST(customer_key AS VARCHAR),
        '-',
        CAST(date_key AS VARCHAR)
    ),
    COUNT(*)
FROM ecommerce_wh.fact_customer_sales
GROUP BY customer_key, date_key
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'fact_product_sales',
    'product_key + date_key',
    CONCAT(
        CAST(product_key AS VARCHAR),
        '-',
        CAST(date_key AS VARCHAR)
    ),
    COUNT(*)
FROM ecommerce_wh.fact_product_sales
GROUP BY product_key, date_key
HAVING COUNT(*) > 1

ORDER BY table_name;