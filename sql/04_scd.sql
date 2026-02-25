DESC TABLE SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER;

DESC TABLE SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER_ADDRESS;


use warehouse compute_wh;
use database snowflake_learning_db;

create or replace table silver.customer_dim(
    customer_sk number autoincrement,
    customer_id number,
    state string,
    start_date date,
    end_date date,
    is_current string
);

--initial load

insert into silver.customer_dim(customer_id, state, start_date, end_date, is_current)
select
    c_customer_sk,
    ca.ca_state,
   current_date(),
   null,
    'Y'
    from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER c
    join SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER_ADDRESS ca
    on c.c_current_addr_sk = ca.ca_address_sk;

    select count(*) from silver.customer_dim;

    select * from silver.customer_dim limit 5 ;

    --CREATE A SMALL STAGE 
    CREATE OR REPLACE TABLE SILVER.CUSTOMER_STAGE AS 
    SELECT customer_id, state
    FROM SILVER.CUSTOMER_DIM
    WHERE is_current = 'Y' ;

    UPDATE SILVER.CUSTOMER_STAGE
    SET state = 'TX'
    WHERE customer_id = 82715872;

    SELECT * FROM SILVER.CUSTOMER_STAGE;

   
   
   --VALIDAATE THE SCD BEHAVIOR

   SELECT * FROM SILVER.CUSTOMER_DIM
   WHERE customer_id = 82715872
   ORDER BY start_date DESC;

    