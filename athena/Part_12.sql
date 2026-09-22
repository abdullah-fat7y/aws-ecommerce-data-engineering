-- ============================================================
-- PART 12 — ANALYTICS & AGGREGATIONS
-- Database: ecommerce_wh
--
-- Tasks:
--   29. Overall Business KPIs
--   30. Monthly Sales, Orders, Quantity and Profit
--   31. Sales by Category, Department, Product, Customer
--   32. Top 10 Products by Sales
--   33. Top 10 Customers by Total Spending
--   34. Average Order Value
--   35. Order Status Analysis
--   36. Payment Method Analysis
--   37. Shipment Performance
--
-- IMPORTANT:
-- Athena executes each SELECT statement separately.
-- Run the entire cell/script, then inspect each result set.
-- ============================================================


-- ============================================================
-- TASK 29
-- Overall Business KPIs
-- ============================================================

SELECT
    ROUND(SUM(net_sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_products,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_wh.fact_order_detail;


-- ============================================================
-- TASK 30
-- Monthly Sales, Orders, Quantity and Profit
-- ============================================================

SELECT
    d.year,
    d.month,
    d.month_name,

    ROUND(SUM(f.net_sales), 2) AS sales,

    COUNT(DISTINCT f.order_id) AS orders,

    SUM(f.quantity) AS quantity,

    ROUND(SUM(f.profit), 2) AS profit

FROM ecommerce_wh.fact_order_detail f

JOIN ecommerce_wh.dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month,
    d.month_name

ORDER BY
    d.year,
    d.month;


-- ============================================================
-- TASK 31.1
-- Sales by Category
-- ============================================================

SELECT
    p.category_id,
    p.category_name,

    ROUND(SUM(f.net_sales), 2) AS total_sales

FROM ecommerce_wh.fact_order_detail f

JOIN ecommerce_wh.dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.category_id,
    p.category_name

ORDER BY
    total_sales DESC;


-- ============================================================
-- TASK 31.2
-- Sales by Department
--
-- NOTE:
-- The current source/model does not provide a valid relationship
-- between sales and department.
--
-- products has no department_id
-- orders has no employee_id
--
-- Therefore, no valid department-sales query can be produced
-- without inventing a relationship.
-- ============================================================


-- ============================================================
-- TASK 31.3
-- Sales by Product
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.brand,

    ROUND(SUM(f.net_sales), 2) AS total_sales

FROM ecommerce_wh.fact_order_detail f

JOIN ecommerce_wh.dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.product_id,
    p.product_name,
    p.brand

ORDER BY
    total_sales DESC;


-- ============================================================
-- TASK 31.4
-- Sales by Customer
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,

    ROUND(SUM(f.net_sales), 2) AS total_sales

FROM ecommerce_wh.fact_order_detail f

JOIN ecommerce_wh.dim_customer c
    ON f.customer_key = c.customer_key

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email

ORDER BY
    total_sales DESC;


-- ============================================================
-- TASK 32
-- Top 10 Products by Sales
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.brand,
    p.category_name,

    ROUND(SUM(f.net_sales), 2) AS total_sales,

    SUM(f.quantity) AS quantity_sold

FROM ecommerce_wh.fact_order_detail f

JOIN ecommerce_wh.dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.product_id,
    p.product_name,
    p.brand,
    p.category_name

ORDER BY
    total_sales DESC

LIMIT 10;


-- ============================================================
-- TASK 33
-- Top 10 Customers by Total Spending
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,

    ROUND(SUM(f.net_sales), 2) AS total_spending,

    COUNT(DISTINCT f.order_id) AS total_orders

FROM ecommerce_wh.fact_order_detail f

JOIN ecommerce_wh.dim_customer c
    ON f.customer_key = c.customer_key

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email

ORDER BY
    total_spending DESC

LIMIT 10;


-- ============================================================
-- TASK 34
-- Average Order Value
--
-- First calculate the total value of each order,
-- then calculate the average across orders.
-- ============================================================

WITH order_totals AS (
    SELECT
        order_id,
        SUM(net_sales) AS order_value

    FROM ecommerce_wh.fact_order_detail

    GROUP BY
        order_id
)

SELECT
    COUNT(*) AS total_orders,

    ROUND(SUM(order_value), 2) AS total_sales,

    ROUND(AVG(order_value), 2) AS average_order_value

FROM order_totals;


-- ============================================================
-- TASK 35
-- Order Status Analysis
--
-- Calculates:
--   Number of orders
--   Total order value
--
-- Required statuses:
--   PENDING
--   PROCESSING
--   SHIPPED
--   DELIVERED
--   CANCELLED
-- ============================================================

SELECT
    s.order_status,

    COUNT(DISTINCT f.order_id) AS number_of_orders,

    ROUND(SUM(f.net_sales), 2) AS order_value

FROM ecommerce_wh.fact_order f

JOIN ecommerce_wh.dim_order_status s
    ON f.order_status_key = s.order_status_key

WHERE s.order_status IN (
    'PENDING',
    'PROCESSING',
    'SHIPPED',
    'DELIVERED',
    'CANCELLED'
)

GROUP BY
    s.order_status

ORDER BY
    CASE s.order_status
        WHEN 'PENDING' THEN 1
        WHEN 'PROCESSING' THEN 2
        WHEN 'SHIPPED' THEN 3
        WHEN 'DELIVERED' THEN 4
        WHEN 'CANCELLED' THEN 5
        ELSE 6
    END;


-- ============================================================
-- TASK 36
-- Payment Method Analysis
--
-- Calculates:
--   Number of transactions
--   Total payment amount
--   Average payment amount
-- ============================================================

SELECT
    pm.payment_method,

    COUNT(f.payment_id) AS number_of_transactions,

    ROUND(SUM(f.amount), 2) AS total_payment_amount,

    ROUND(AVG(f.amount), 2) AS average_payment_amount

FROM ecommerce_wh.fact_payment f

JOIN ecommerce_wh.dim_payment_method pm
    ON f.payment_method_key = pm.payment_method_key

GROUP BY
    pm.payment_method

ORDER BY
    total_payment_amount DESC;


-- ============================================================
-- TASK 37
-- Shipment Performance
--
-- Calculates:
--   Total Shipments
--   Average Delivery Days
--   Minimum Delivery Days
--   Maximum Delivery Days
--
-- Total shipments includes undelivered shipments.
-- Delivery-day calculations naturally ignore NULL values.
-- ============================================================

SELECT
    COUNT(DISTINCT shipment_id) AS total_shipments,

    ROUND(AVG(delivery_duration_days), 2)
        AS average_delivery_days,

    MIN(delivery_duration_days)
        AS minimum_delivery_days,

    MAX(delivery_duration_days)
        AS maximum_delivery_days

FROM ecommerce_wh.fact_shipment;