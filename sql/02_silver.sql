USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE_LEARNING_DB;

CREATE SCHEMA IF NOT EXISTS SILVER;
USE SCHEMA SILVER;
CREATE OR REPLACE TABLE SILVER.STORE_SALES_CLEAN AS
SELECT
    ss.ss_sold_date_sk,
    ss.ss_store_sk,
    ss.ss_customer_sk,     
    ss.ss_quantity,
    ss.ss_sales_price
FROM BRONZE.STORE_SALES_RAW ss
join SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.DATE_DIM dd
on ss.ss_sold_date_sk = dd.d_date_sk
WHERE dd.d_year between 1998 and 1999
AND  ss.ss_sales_price IS NOT NULL
AND ss.ss_quantity > 0;

--DATA VALIDATION
select min(ss_sold_date_sk) as min_sold_date, max(ss_sold_date_sk) as max_sold_date from SILVER.STORE_SALES_CLEAN; 

SELECT COUNT(*) AS TOTAL_RECORDS FROM SILVER.STORE_SALES_CLEAN;

SELECT COUNT(*) FROM BRONZE.STORE_SALES_RAW;

SELECT COUNT(*)
FROM SILVER.STORE_SALES_CLEAN
WHERE ss_sales_price IS NULL;

SELECT COUNT(*)
FROM SILVER.STORE_SALES_CLEAN WHERE ss_quantity <= 0;