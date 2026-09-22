-- ============================================================
-- TASK 28 - CHECK 5
-- Fact-to-dimension relationship validation
-- ============================================================

WITH relationship_checks AS (

    -- ========================================================
    -- FACT ORDER
    -- ========================================================

    SELECT
        'fact_order -> dim_customer' AS relationship,
        COUNT(*) AS total_rows,
        SUM(
            CASE
                WHEN d.customer_key IS NOT NULL THEN 1
                ELSE 0
            END
        ) AS matched_rows
    FROM ecommerce_wh.fact_order f
    LEFT JOIN ecommerce_wh.dim_customer d
        ON f.customer_key = d.customer_key

    UNION ALL

    SELECT
        'fact_order -> dim_date',
        COUNT(*),
        SUM(
            CASE
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_order f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key

    UNION ALL

    SELECT
        'fact_order -> dim_order_status',
        COUNT(*),
        SUM(
            CASE
                WHEN d.order_status_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_order f
    LEFT JOIN ecommerce_wh.dim_order_status d
        ON f.order_status_key = d.order_status_key


    -- ========================================================
    -- FACT ORDER DETAIL
    -- ========================================================

    UNION ALL

    SELECT
        'fact_order_detail -> dim_product',
        COUNT(*),
        SUM(
            CASE
                WHEN d.product_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_order_detail f
    LEFT JOIN ecommerce_wh.dim_product d
        ON f.product_key = d.product_key

    UNION ALL

    SELECT
        'fact_order_detail -> dim_customer',
        COUNT(*),
        SUM(
            CASE
                WHEN d.customer_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_order_detail f
    LEFT JOIN ecommerce_wh.dim_customer d
        ON f.customer_key = d.customer_key

    UNION ALL

    SELECT
        'fact_order_detail -> dim_date',
        COUNT(*),
        SUM(
            CASE
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_order_detail f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key


    -- ========================================================
    -- FACT PAYMENT
    -- ========================================================

    UNION ALL

    SELECT
        'fact_payment -> dim_customer',
        COUNT(*),
        SUM(
            CASE
                WHEN d.customer_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_payment f
    LEFT JOIN ecommerce_wh.dim_customer d
        ON f.customer_key = d.customer_key

    UNION ALL

    SELECT
        'fact_payment -> dim_date',
        COUNT(*),
        SUM(
            CASE
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_payment f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key

    UNION ALL

    SELECT
        'fact_payment -> dim_payment_method',
        COUNT(*),
        SUM(
            CASE
                WHEN d.payment_method_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_payment f
    LEFT JOIN ecommerce_wh.dim_payment_method d
        ON f.payment_method_key = d.payment_method_key


    -- ========================================================
    -- FACT SHIPMENT
    -- ========================================================

    UNION ALL

    SELECT
        'fact_shipment -> dim_customer',
        COUNT(*),
        SUM(
            CASE
                WHEN d.customer_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_shipment f
    LEFT JOIN ecommerce_wh.dim_customer d
        ON f.customer_key = d.customer_key

    UNION ALL

    SELECT
        'fact_shipment -> dim_shipper',
        COUNT(*),
        SUM(
            CASE
                WHEN d.shipper_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_shipment f
    LEFT JOIN ecommerce_wh.dim_shipper d
        ON f.shipper_key = d.shipper_key

    UNION ALL

    SELECT
        'fact_shipment -> dim_date (ship)',
        COUNT(*),
        SUM(
            CASE
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_shipment f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.ship_date_key = d.date_key

    UNION ALL

    SELECT
        'fact_shipment -> dim_date (delivery)',
        COUNT(*),
        SUM(
            CASE
                -- A NULL delivery date can be valid when
                -- the shipment has not been delivered yet.
                WHEN f.delivery_date_key IS NULL THEN 1
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_shipment f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.delivery_date_key = d.date_key


    -- ========================================================
    -- FACT CUSTOMER SALES
    -- ========================================================

    UNION ALL

    SELECT
        'fact_customer_sales -> dim_customer',
        COUNT(*),
        SUM(
            CASE
                WHEN d.customer_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_customer_sales f
    LEFT JOIN ecommerce_wh.dim_customer d
        ON f.customer_key = d.customer_key

    UNION ALL

    SELECT
        'fact_customer_sales -> dim_date',
        COUNT(*),
        SUM(
            CASE
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_customer_sales f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key


    -- ========================================================
    -- FACT PRODUCT SALES
    -- ========================================================

    UNION ALL

    SELECT
        'fact_product_sales -> dim_product',
        COUNT(*),
        SUM(
            CASE
                WHEN d.product_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_product_sales f
    LEFT JOIN ecommerce_wh.dim_product d
        ON f.product_key = d.product_key

    UNION ALL

    SELECT
        'fact_product_sales -> dim_date',
        COUNT(*),
        SUM(
            CASE
                WHEN d.date_key IS NOT NULL THEN 1
                ELSE 0
            END
        )
    FROM ecommerce_wh.fact_product_sales f
    LEFT JOIN ecommerce_wh.dim_date d
        ON f.date_key = d.date_key
)

SELECT
    relationship,
    total_rows,
    matched_rows,
    total_rows - matched_rows AS orphan_rows,

    ROUND(
        100.0 * matched_rows / NULLIF(total_rows, 0),
        2
    ) AS match_percentage

FROM relationship_checks
ORDER BY relationship;