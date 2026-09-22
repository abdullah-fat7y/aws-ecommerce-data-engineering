# E-Commerce Data Engineering Platform on AWS

<img width="1536" height="1024" alt="AWS_architecture" src="https://github.com/user-attachments/assets/a7056785-058f-46f0-8a3c-51d6056ab5e7" />


## Project Overview

This project is an end-to-end **E-Commerce Data Engineering platform**
built on AWS.

The project has two connected parts:

1.  **Historical Data Warehouse Pipeline**\
    Loads the existing e-commerce CSV datasets into Amazon S3, processes
    and models them with AWS Glue and PySpark, stores the curated
    warehouse data as Parquet, catalogs it with AWS Glue, and analyzes
    it with Amazon Athena.

2.  **API Incremental Ingestion Extension**\
    Extends the historical platform with a Python Orders API and AWS
    Lambda. New orders are fetched incrementally from the API, stored as
    individual JSON objects in S3, and then processed with PySpark into
    the same analytical data model.

The final platform therefore combines **historical data** with an
**incremental API-based ingestion path**.

The project was completed through the **SQL analytics stage using Amazon
Athena**. No BI dashboard was implemented.

------------------------------------------------------------------------

# 1. High-Level Architecture

The complete project can be understood as two pipelines that converge on
the same analytical data platform.

``` text
                         HISTORICAL PIPELINE

  Historical CSV Files
          |
          v
     Amazon S3
     Raw Layer
          |
          v
  AWS Glue + PySpark
          |
          v
     Data Cleaning
     Transformations
     Star Schema
          |
          v
     Amazon S3
   Processed Parquet
          |
          |
          +-----------------------------+
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


                         INCREMENTAL API EXTENSION

       Python Orders API
               |
               v
          AWS Lambda
               |
               v
       API Raw JSON in S3
               |
               v
        PySpark / Glue
               |
               v
      Incremental Processing
               |
               v
      Same Curated Data Model
               |
               v
          S3 Parquet
               |
               v
       Glue Catalog / Athena
```

The two architectures are complementary:

``` text
Historical CSV Data
        \
         \
          +----> S3 / PySpark / Star Schema / Athena
         /
        /
API Orders -> Lambda -> S3 -> PySpark
```

------------------------------------------------------------------------

# 2. Technologies

  Technology              Role
  ----------------------- --------------------------------------------------------
  Python                  API interaction and data extraction
  REST API                Source of incoming orders
  AWS Lambda              Incremental API ingestion and S3 delivery
  Amazon S3               Raw and curated data lake storage
  PySpark                 Data processing, cleaning, transformation and modeling
  AWS Glue                Managed Spark processing environment
  Apache Parquet          Curated analytical storage format
  AWS Glue Crawler        Schema discovery
  AWS Glue Data Catalog   Metadata/catalog layer
  Amazon Athena           Serverless SQL analytics
  IAM                     AWS permissions and access control
  SQL                     Validation, aggregation and advanced analytics

------------------------------------------------------------------------

# 3. Historical Data Pipeline

The first architecture handles the existing historical e-commerce
datasets.

## 3.1 Data Sources

The historical source consists of 12 CSV datasets:

``` text
customers.csv
categories.csv
products.csv
departments.csv
employees.csv
suppliers.csv
orders.csv
order_details.csv
payments.csv
product_suppliers.csv
shippers.csv
shipments.csv
```

These datasets represent the historical relational data of the
e-commerce system.

------------------------------------------------------------------------

# 4. Historical Raw Layer

The historical files are stored in Amazon S3.

Bucket:

``` text
s3://aws-ecommerce-s3/
```

Historical raw area:

``` text
s3://aws-ecommerce-s3/ecommerce/raw/
```

Conceptually:

``` text
aws-ecommerce-s3
|
+-- ecommerce/
    |
    +-- raw/
        |
        +-- customers/
        +-- categories/
        +-- products/
        +-- departments/
        +-- employees/
        +-- suppliers/
        +-- orders/
        +-- order_details/
        +-- payments/
        +-- product_suppliers/
        +-- shippers/
        +-- shipments/
```

The raw layer preserves the source data before transformation.

------------------------------------------------------------------------

# 5. Historical Processing with AWS Glue and PySpark

The historical data is processed using **PySpark in an AWS Glue Spark
Notebook**.

The processing workflow includes:

``` text
Raw CSV Data
     |
     v
Data Ingestion
     |
     v
Data Profiling
     |
     v
Data Validation
     |
     v
Data Cleaning
     |
     v
Data Type Transformation
     |
     v
Business Transformations
     |
     v
Joins
     |
     v
Aggregations
     |
     v
Dimensional Modeling
     |
     v
Parquet Output
```

The project included checks for:

-   Schemas
-   Row counts
-   Column counts
-   Business keys
-   Foreign-key relationships
-   Nullable fields
-   Duplicate records
-   Invalid values
-   Invalid dates
-   Invalid numeric values
-   Orphan records
-   Data consistency

------------------------------------------------------------------------

# 6. Data Cleaning

The historical datasets were standardized before modeling.

Main operations included:

-   Converting column names to `snake_case`
-   Trimming string values
-   Converting empty strings to NULL
-   Standardizing status values
-   Normalizing email values
-   Converting columns to appropriate data types
-   Handling missing values
-   Removing duplicates
-   Validating dates
-   Validating numerical values
-   Validating business keys
-   Validating shipment dates

The cleaned datasets were written in Parquet format.

------------------------------------------------------------------------

# 7. Star Schema Data Warehouse

The processed data was modeled as a **star schema** consisting of:

``` text
10 Dimension Tables
6 Fact Tables
```

## 7.1 Dimensions

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

The dimensions use surrogate keys in addition to their business keys.

------------------------------------------------------------------------

## 7.2 Facts

``` text
fact_order
fact_order_detail
fact_payment
fact_shipment
fact_customer_sales
fact_product_sales
```

### Fact grains

``` text
fact_order
    -> One row per order

fact_order_detail
    -> One row per order-detail/product line

fact_payment
    -> One row per payment transaction

fact_shipment
    -> One row per shipment

fact_customer_sales
    -> One customer per day

fact_product_sales
    -> One product per day
```

This provides both detailed transactional facts and aggregated
analytical facts.

------------------------------------------------------------------------

# 8. Curated S3 Data Warehouse Layer

The final warehouse datasets are stored as Parquet in:

``` text
s3://aws-ecommerce-s3/ecommerce/processed/ecommerce_dwh/
```

Structure:

``` text
ecommerce_dwh/
|
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
|
+-- fact_order/
+-- fact_order_detail/
+-- fact_payment/
+-- fact_shipment/
+-- fact_customer_sales/
+-- fact_product_sales/
```

Parquet was selected for the curated layer because it provides columnar
storage and is well suited for analytical workloads.

------------------------------------------------------------------------

# 9. API Incremental Ingestion Extension

The second architecture extends the historical platform with an
API-driven ingestion path.

Instead of relying only on historical CSV files, new orders can arrive
from a Python Orders REST API.

The extension is:

``` text
Python Orders API
        |
        v
     AWS Lambda
        |
        v
   Amazon S3
   API Raw Layer
        |
        v
  PySpark / Glue
        |
        v
Incremental Processing
        |
        v
Curated Data Model
```

This allows the platform to process new incoming orders without
rebuilding the entire historical source.

------------------------------------------------------------------------

# 10. Python Orders API

The API exposes an endpoint similar to:

``` text
GET /api/orders?from_order_id=...&limit=...
```

The API returns order objects containing nested information such as:

``` text
metadata
order
order_details
payment
shipment
summary
```

Example conceptual structure:

``` json
{
  "metadata": {
    "event_id": "...",
    "event_type": "ORDER_CREATED",
    "event_timestamp": "...",
    "source": "ordering_api"
  },
  "order": {
    "OrderID": 50974,
    "CustomerID": 7508,
    "OrderDate": "2026-09-21",
    "Status": "Confirmed"
  },
  "order_details": [],
  "payment": {},
  "shipment": {}
}
```

------------------------------------------------------------------------

# 11. AWS Lambda Ingestion

AWS Lambda is used as the API ingestion component.

Its responsibilities include:

1.  Reading the current API ingestion position.
2.  Calling the Orders API.
3.  Retrieving new orders.
4.  Writing each order as an individual JSON object to S3.
5.  Updating the ingestion checkpoint.

The resulting objects follow a pattern such as:

``` text
order_50001.json
order_50002.json
order_50003.json
...
order_51000.json
```

This keeps incoming API records independently stored in the raw layer.

------------------------------------------------------------------------

# 12. API Raw S3 Layer

API data is stored separately from the historical CSV raw layer.

Example:

``` text
s3://aws-ecommerce-s3/ecommerce/api_raw/orders/
```

Conceptually:

``` text
api_raw/
|
+-- orders/
    |
    +-- order_50001.json
    +-- order_50002.json
    +-- order_50003.json
    +-- ...
```

The raw JSON files are retained before Spark transformation.

This provides a durable source for:

-   Reprocessing
-   Auditing
-   Debugging
-   Incremental transformations
-   Data lineage

------------------------------------------------------------------------

# 13. API Processing with PySpark

The API JSON data is processed using PySpark.

The JSON contains nested structures, so the processing pipeline:

``` text
JSON
 |
 v
Explicit Schema
 |
 v
Parse Metadata
 |
 v
Parse Order
 |
 v
Parse Order Details
 |
 v
Parse Payment
 |
 v
Parse Shipment
 |
 v
Validate
 |
 v
Deduplicate
 |
 v
Identify New Orders
 |
 v
Transform to Relational Structures
```

The nested order details are flattened using Spark transformations.

The API data is transformed into structures corresponding to the
historical warehouse model:

``` text
API Orders
      |
      +--> Orders
      |
      +--> Order Details
      |
      +--> Payments
      |
      +--> Shipments
```

------------------------------------------------------------------------

# 14. Integration with the Historical Model

One of the main goals of the API extension is to make incoming API data
compatible with the existing warehouse model.

Conceptually:

``` text
Historical CSV Data
        |
        v
Historical Processing
        |
        +------------------+
                           |
                           v
                    Star Schema
                           ^
                           |
        +------------------+
        |
API JSON -> Lambda -> S3 -> PySpark
```

Both historical and incoming data therefore feed the same analytical
model.

This creates a unified platform rather than maintaining two independent
analytical systems.

------------------------------------------------------------------------

# 15. API Incremental Processing

The API extension uses an incremental approach.

Instead of processing every order from the beginning each time:

``` text
All Orders
    |
    v
Process Everything
```

the intended workflow is:

``` text
Last Processed Position
        |
        v
Request New Orders
        |
        v
Store New JSON Objects
        |
        v
Process New Records
        |
        v
Update Curated Data
```

This reduces unnecessary processing as the API dataset grows.

------------------------------------------------------------------------

# 16. Glue Data Catalog

After the curated Parquet datasets are produced, an AWS Glue Crawler
scans:

``` text
s3://aws-ecommerce-s3/ecommerce/processed/ecommerce_dwh/
```

The crawler discovers:

-   Table structures
-   Columns
-   Data types
-   Parquet schemas
-   S3 locations

The metadata is stored in the AWS Glue Data Catalog.

The Athena database is:

``` text
ecommerce_wh
```

------------------------------------------------------------------------

# 17. Amazon Athena

Amazon Athena is the final analytical query engine.

Athena queries the Parquet datasets directly in S3 through the Glue Data
Catalog.

The database contains:

``` text
10 Dimensions
6 Facts
16 Tables Total
```

Examples:

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

------------------------------------------------------------------------

# 18. Data Validation

The final warehouse was validated using Athena SQL.

Validation included:

### Row Counts

Checking all 16 dimension and fact tables.

### Duplicate Detection

Checking:

-   Dimension business keys
-   Fact primary/grain keys
-   Composite fact grains

### Foreign-Key Validation

Checking fact-to-dimension relationships.

### Null Key Validation

Checking required surrogate and foreign keys.

### Relationship Validation

Calculating:

``` text
Total Rows
Matched Rows
Orphan Rows
Match Percentage
```

### Sales Reconciliation

Sales were reconciled across:

``` text
fact_order_detail
fact_customer_sales
fact_product_sales
```

This verifies consistency between detailed and aggregated
representations.

------------------------------------------------------------------------

# 19. Business Analytics

The project reached the SQL analytics stage using Athena.

## Overall KPIs

``` text
Total Sales
Total Orders
Total Customers
Total Products
Total Quantity Sold
Total Profit
```

## Monthly Analytics

``` text
Monthly Sales
Monthly Orders
Monthly Quantity
Monthly Profit
```

## Sales Analysis

``` text
Sales by Category
Sales by Product
Sales by Customer
```

A department-sales calculation was not created because the actual
source/model does not contain a valid direct relationship between
sales/products and departments.

## Top Products

``` text
Top 10 Products by Sales
```

## Top Customers

``` text
Top 10 Customers by Total Spending
```

## Average Order Value

``` text
Average Order Value
```

## Order Status Analysis

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

## Payment Analysis

For each payment method:

``` text
Number of Transactions
Total Payment Amount
Average Payment Amount
```

## Shipment Performance

``` text
Total Shipments
Average Delivery Days
Minimum Delivery Days
Maximum Delivery Days
```

------------------------------------------------------------------------

# 20. Advanced SQL Analytics

The project also implements SQL window functions.

## Running Sales

Cumulative sales by date using:

``` sql
SUM(...) OVER (
    ORDER BY sales_date
)
```

## Month-over-Month Growth

Calculated:

``` text
Current Month Sales
Previous Month Sales
Sales Difference
Growth Percentage
```

using:

``` sql
LAG(...) OVER (
    ORDER BY year, month
)
```

## Product Ranking

Products are ranked within each category:

``` sql
RANK() OVER (
    PARTITION BY category_id
    ORDER BY sales DESC
)
```

The top 3 products from each category are returned.

## Customer Ranking

Customers are ranked by total spending:

``` sql
RANK() OVER (
    ORDER BY total_spending DESC
)
```

------------------------------------------------------------------------

# 21. Final Combined Architecture

The complete platform can be summarized as:

``` text
                 HISTORICAL SOURCES
                 12 CSV DATASETS
                        |
                        v
                  Amazon S3 Raw
                        |
                        |
                        +-----------------------+
                                                |
                                                v
                                        AWS Glue / PySpark
                                                |
                                                |
                 API EXTENSION                  |
                                                |
 Python Orders API                              |
        |                                       |
        v                                       |
    AWS Lambda                                  |
        |                                       |
        v                                       |
 API Raw JSON in S3 ----------------------------+
                                                |
                                                v
                                      Validation & Cleaning
                                                |
                                                v
                                      Transformations
                                                |
                                                v
                                       Star Schema Model
                                                |
                              +-----------------+----------------+
                              |                                  |
                              v                                  v
                       10 Dimensions                         6 Facts
                              |                                  |
                              +----------------+-----------------+
                                               |
                                               v
                                      S3 Parquet DWH
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

------------------------------------------------------------------------

# 22. Why the Two Pipelines Are Important

The historical pipeline establishes the initial analytical foundation:

``` text
Historical Data
    ↓
Data Warehouse
    ↓
Analytics
```

The API extension adds an ingestion mechanism for future orders:

``` text
New API Orders
    ↓
Lambda
    ↓
S3 JSON
    ↓
PySpark
    ↓
Same Data Warehouse
    ↓
Analytics
```

Together, they form a platform that can start from historical data and
continue receiving new orders through an API-driven ingestion process.

------------------------------------------------------------------------

# 23. Project Layers

The final architecture can also be viewed as six logical layers:

``` text
1. SOURCE LAYER
   Historical CSV + Orders API

2. INGESTION LAYER
   S3 Raw + AWS Lambda

3. PROCESSING LAYER
   AWS Glue + PySpark

4. STORAGE / WAREHOUSE LAYER
   S3 + Parquet + Star Schema

5. CATALOG LAYER
   AWS Glue Crawler + Glue Data Catalog

6. ANALYTICS LAYER
   Amazon Athena + SQL
```

------------------------------------------------------------------------

# 24. Final Project Status

``` text
[✓] Historical CSV ingestion
[✓] S3 raw layer
[✓] Data profiling
[✓] Data quality checks
[✓] Data cleaning
[✓] PySpark transformations
[✓] Star-schema modeling
[✓] 10 dimension tables
[✓] 6 fact tables
[✓] Parquet warehouse layer
[✓] API integration
[✓] AWS Lambda ingestion
[✓] API JSON raw storage
[✓] Nested JSON processing with PySpark
[✓] Incremental API processing design
[✓] AWS Glue Crawler
[✓] AWS Glue Data Catalog
[✓] Athena database
[✓] Warehouse validation
[✓] Business analytics
[✓] Advanced SQL
[✓] Window functions

[—] BI Dashboard
      Not implemented
```

------------------------------------------------------------------------

# 25. Important Architecture Note

The original assignment referenced Amazon Redshift as the final
warehouse/query layer.

Redshift was not used in the final implementation.

Instead, the project uses an S3-based analytical warehouse with:

``` text
Amazon S3
    ↓
Parquet
    ↓
AWS Glue Crawler
    ↓
Glue Data Catalog
    ↓
Amazon Athena
    ↓
SQL Analytics
```

This means the final implementation remains centered around a
dimensional warehouse model, while S3 provides the physical storage and
Athena provides the SQL analytical layer.

------------------------------------------------------------------------

# 26. Project Outcome

The completed project demonstrates an end-to-end AWS data engineering
workflow:

``` text
SOURCE
  ↓
INGEST
  ↓
STORE
  ↓
PROCESS
  ↓
CLEAN
  ↓
MODEL
  ↓
CATALOG
  ↓
QUERY
  ↓
ANALYZE
```

It combines:

-   Historical batch data
-   API-based incremental ingestion
-   Serverless AWS storage
-   PySpark data engineering
-   Dimensional modeling
-   Parquet
-   AWS Glue
-   AWS Glue Data Catalog
-   Amazon Athena
-   SQL analytics
-   Advanced window functions

The result is a unified e-commerce analytical data platform capable of
combining the existing historical dataset with incoming API orders and
exposing the resulting warehouse data for SQL-based analytics.
