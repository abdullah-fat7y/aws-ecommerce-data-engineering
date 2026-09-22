# E-Commerce Orders Data Engineering Project

<img width="1536" height="813" alt="ChatGPT Image Sep 22, 2026, 05_16_40 PM" src="https://github.com/user-attachments/assets/22579c1e-c941-4849-a042-464704e3bf9f" />


## Overview

An end-to-end E-Commerce Data Engineering pipeline on AWS.

The project extracts order data from a Python REST API, stores raw JSON
in Amazon S3, processes and transforms the data using PySpark in an AWS
Glue Spark Notebook, builds a dimensional/star-schema model, stores the
final datasets as Parquet in S3, catalogs them using an AWS Glue
Crawler, and performs analytical SQL queries using Amazon Athena.

**Project endpoint:** SQL analytics. No BI dashboard was implemented.

## Architecture

``` text
Python REST API
       |
       v
   orders_json
       |
       v
 Amazon S3 - Raw
       |
       v
 AWS Glue / PySpark
       |
       +-------------------+
       |                   |
       v                   v
 Dimensions              Facts
       |                   |
       +---------+---------+
                 |
                 v
            S3 Parquet
                 |
                 v
         AWS Glue Crawler
                 |
                 v
        Glue Data Catalog
                 |
                 v
          Amazon Athena
                 |
                 v
           SQL Analytics
```

## Technologies

  Technology              Purpose
  ----------------------- ---------------------------------------------------
  Python / Requests       REST API extraction
  Amazon S3               Raw and processed data storage
  PySpark                 Validation, cleaning, transformation and modeling
  AWS Glue                Spark processing environment and Data Catalog
  AWS Glue Crawler        Schema discovery and cataloging
  Apache Parquet          Columnar processed-data format
  Amazon Athena           Serverless SQL analytics over S3
  SQL                     Validation, aggregations and advanced analytics
  IAM                     AWS access control
  CloudWatch / AWS logs   Monitoring and troubleshooting

## S3 Structure

Bucket:

``` text
s3://aws-ecommerce-s3/
```

Main structure:

``` text
ecommerce/
|
+-- raw/
|   +-- orders_json/
|       +-- order_50001.json
|       +-- order_50002.json
|       +-- ...
|
+-- api_raw/
|   +-- orders/
|
+-- processed/
    +-- ecommerce_dwh/
        +-- dim_customer/
        +-- dim_product/
        +-- dim_category/
        +-- dim_department/
        +-- dim_supplier/
        +-- dim_employee/
        +-- dim_shipper/
        +-- dim_date/
        +-- dim_payment_method/
        +-- dim_order_status/
        +-- fact_order/
        +-- fact_order_detail/
        +-- fact_payment/
        +-- fact_shipment/
        +-- fact_customer_sales/
        +-- fact_product_sales/
```

Final warehouse layer:

``` text
s3://aws-ecommerce-s3/ecommerce/processed/ecommerce_dwh/
```

## Source Data

Historical source tables:

``` text
customers
categories
products
departments
employees
suppliers
orders
order_details
payments
product_suppliers
shippers
shipments
orders_json
```

The API order structure contains:

``` text
metadata
order
order_details
payment
shipment
summary
```

The JSON objects were read directly by Spark from the S3 prefix. The
project did not manually concatenate the 1000+ JSON files.

## Data Quality and Exploration

The initial PySpark analysis included:

-   Schema inspection
-   Sample records
-   Row and column counts
-   Business keys
-   Foreign-key relationships
-   Nullable columns
-   Duplicate detection
-   Invalid values
-   Invalid dates
-   Invalid numeric values
-   Orphan-record checks
-   Email validation
-   Payment and shipment consistency checks

Examples of business keys:

``` text
customers       -> CustomerID
categories      -> CategoryID
products        -> ProductID
departments     -> DepartmentID
employees       -> EmployeeID
suppliers       -> SupplierID
orders          -> OrderID
order_details   -> OrderDetailID
payments        -> PaymentID
shippers        -> ShipperID
shipments       -> ShipmentID
```

`product_suppliers` uses the composite business key:

``` text
ProductID + SupplierID
```

## Data Cleaning

PySpark transformations included:

-   Converting column names to `snake_case`
-   Trimming strings
-   Converting empty strings to NULL
-   Normalizing emails
-   Standardizing status values
-   Converting data types
-   Handling invalid emails
-   Handling missing values
-   Removing duplicates
-   Validating dates and numeric values
-   Validating business keys
-   Handling invalid shipment dates

The cleaned datasets were written as Parquet.

## Star Schema

The final model contains:

``` text
10 Dimension Tables
6 Fact Tables
```

### Dimensions

``` text
dim_customer
dim_product
dim_category
dim_department
dim_supplier
dim_employee
dim_shipper
dim_date
dim_payment_method
dim_order_status
```

Surrogate keys were generated for the dimensions.

### Facts

``` text
fact_order
fact_order_detail
fact_payment
fact_shipment
fact_customer_sales
fact_product_sales
```

### Fact Grains

``` text
fact_order
    -> one row per order

fact_order_detail
    -> one row per order-detail/product line

fact_payment
    -> one row per payment transaction

fact_shipment
    -> one row per shipment

fact_customer_sales
    -> one customer per day

fact_product_sales
    -> one product per day
```

## API Integration

The nested API JSON was parsed with an explicit PySpark schema.

The API data was transformed into relational-style datasets:

``` text
api_orders
api_order_details
api_payments
api_shipments
```

The `order_details` array was handled using Spark transformations and
`explode`, rather than manually rebuilding JSON files.

## PySpark Processing Flow

``` text
Read
  |
Validate
  |
Clean
  |
Standardize
  |
Transform
  |
Generate Surrogate Keys
  |
Build Dimensions
  |
Build Facts
  |
Write Parquet
```

Processing was performed in an AWS Glue Spark Notebook.

## Parquet Data Warehouse Layer

The final dimensional model is stored at:

``` text
s3://aws-ecommerce-s3/ecommerce/processed/ecommerce_dwh/
```

Parquet provides:

-   Columnar storage
-   Compression
-   Efficient analytical reads
-   Schema preservation
-   Efficient querying from Athena

## AWS Glue Crawler

The Glue Crawler points to:

``` text
s3://aws-ecommerce-s3/ecommerce/processed/ecommerce_dwh/
```

It discovers the Parquet schemas and creates metadata in the AWS Glue
Data Catalog.

Athena database:

``` text
ecommerce_wh
```

The catalog contains 16 warehouse tables:

``` text
10 dimensions
6 facts
```

## Amazon Athena

Amazon Athena is the final SQL analytics layer.

It queries the Parquet data directly from S3 through the Glue Data
Catalog.

Example table names:

``` text
ecommerce_wh.dim_customer
ecommerce_wh.dim_product
ecommerce_wh.dim_category
ecommerce_wh.dim_department
ecommerce_wh.dim_supplier
ecommerce_wh.dim_employee
ecommerce_wh.dim_shipper
ecommerce_wh.dim_date
ecommerce_wh.dim_payment_method
ecommerce_wh.dim_order_status

ecommerce_wh.fact_order
ecommerce_wh.fact_order_detail
ecommerce_wh.fact_payment
ecommerce_wh.fact_shipment
ecommerce_wh.fact_customer_sales
ecommerce_wh.fact_product_sales
```

## Data Validation

Athena validation queries checked:

1.  Row counts across all 16 tables
2.  Duplicate business/grain keys
3.  Fact-to-dimension orphan relationships
4.  NULL surrogate and foreign keys
5.  Fact-to-dimension match percentages
6.  Sales reconciliation between detailed and aggregate facts

Sales reconciliation compared:

``` text
fact_order_detail
fact_customer_sales
fact_product_sales
```

## Analytics

### Overall KPIs

Calculated:

``` text
Total Sales
Total Orders
Total Customers
Total Products
Total Quantity Sold
Total Profit
```

### Monthly Analytics

Calculated:

``` text
Sales
Orders
Quantity
Profit
```

### Sales Analysis

Sales were analyzed by:

``` text
Category
Product
Customer
```

A department-sales metric was not calculated because the available
source model does not provide a valid direct relationship between
sales/products and departments.

### Top Products

Top 10 products by sales.

### Top Customers

Top 10 customers by total spending.

### Average Order Value

Calculated at the order level:

``` text
AOV = Total Sales / Number of Orders
```

### Order Status

Analyzed:

``` text
Pending
Processing
Shipped
Delivered
Cancelled
```

For each status:

``` text
Number of Orders
Order Value
```

### Payment Methods

For each payment method:

``` text
Number of Transactions
Total Payment Amount
Average Payment Amount
```

### Shipment Performance

Calculated:

``` text
Total Shipments
Average Delivery Days
Minimum Delivery Days
Maximum Delivery Days
```

## Advanced SQL

### Running Sales

Cumulative sales by date using:

``` sql
SUM(...) OVER (...)
```

### Month-over-Month Growth

Calculated:

``` text
Current Month Sales
Previous Month Sales
Sales Difference
Growth Percentage
```

using:

``` sql
LAG(...) OVER (...)
```

### Product Ranking

Products were ranked by sales within each category using:

``` sql
RANK() OVER (
    PARTITION BY category
    ORDER BY sales DESC
)
```

Only the top 3 products from each category were returned.

### Customer Ranking

Customers were ranked by total spending using:

``` sql
RANK() OVER (
    ORDER BY total_spending DESC
)
```

## Final End-to-End Flow

``` text
Python REST API
       |
       v
orders_json
       |
       v
Amazon S3 - Raw Layer
       |
       v
AWS Glue / PySpark Notebook
       |
       +-----------------------+
       |                       |
       v                       v
10 Dimensions              6 Facts
       |                       |
       +-----------+-----------+
                   |
                   v
              S3 Parquet
                   |
                   v
           AWS Glue Crawler
                   |
                   v
          Glue Data Catalog
                   |
                   v
             Amazon Athena
                   |
                   v
             SQL Analytics
```

## Project Deliverables

-   Python REST API extraction
-   Raw JSON storage in S3
-   Historical data exploration
-   Data quality validation
-   PySpark data cleaning
-   Nested JSON parsing
-   Dimension tables
-   Fact tables
-   Surrogate keys
-   Star-schema data model
-   Parquet processed layer
-   AWS Glue Crawler
-   Glue Data Catalog
-   Athena database and tables
-   Data validation SQL
-   Business analytics SQL
-   Advanced SQL
-   Window-function analytics
-   Final architecture documentation

## Project Status

``` text
[✓] API Extraction
[✓] Raw Data Storage
[✓] Data Exploration
[✓] Data Quality Checks
[✓] Data Cleaning
[✓] PySpark Transformations
[✓] Dimension Modeling
[✓] Fact Modeling
[✓] Star Schema
[✓] Parquet Storage
[✓] Glue Crawler
[✓] Glue Data Catalog
[✓] Athena Database
[✓] Data Validation
[✓] Business Analytics
[✓] Advanced SQL
[✓] Window Functions

Project endpoint:
SQL Analytics

BI Dashboard:
Not implemented
```

## Note About Redshift

The original assignment architecture referenced Amazon Redshift.
Redshift was not used in the final implementation because it was not
available for the AWS account.

The final architecture therefore uses:

``` text
S3 Parquet
   |
AWS Glue Crawler
   |
Glue Data Catalog
   |
Amazon Athena
   |
SQL Analytics
```

This preserves the analytical warehouse workflow while using Athena as
the final query engine over the S3-based dimensional model.
