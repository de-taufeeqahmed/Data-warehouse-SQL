  /*
==============================================================================
DDL script : create Bronze tables
==============================================================================
Purpose:
        The ourpose of this script is to load records in the tables of bronze schema.
You can create procedures as well in terms of loading the data quickly.
==============================================================================
*/



Create table bronze_crm_cust_info
( cst_id int,
cst_key Varchar (15),
cst_firstname Varchar (15),
cst_lastname Varchar (20),
cst_marital_status Varchar (15),
cst_gndr Varchar (5),
cst_create_date date
);

Create table bronze_crm_prd_info (
prd_id INT,
prd_key Varchar (25),
prd_nm Varchar (50),
prd_cost INT,
prd_line Varchar (5),
prd_start_dt date,
prd_end_dt date );

create table cronze_crm_sales_details(
sls_ord_num	Varchar (10),
sls_prd_key	Varchar (20),
sls_cust_id	INT,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales INT,
sls_quantity INT,
sls_price INT);

create table bronze_erp_cust_az12 (
CID	Varchar (50),
BDATE date,
GEN varchar (10));

create table bronze_erp_loc_a101(
CID	Varchar (20),
CNTRY Varchar (20)
);

create table bronze_erp_px_cat_g1v2 (
ID Varchar(20),
CAT Varchar(50),
SUBCAT Varchar(50),
MAINTENANCE Varchar (10)
);

Select "Loading Bronze layer" As message;
Select "------------------------------------------------------------" As message;
Select "Loading CRM tables" As message;
Set @start_time = NOW(); 

truncate table bronze_crm_cust_info;
LOAD DATA LOCAL INFILE "D:/MySQL June Batch/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv"
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

truncate table bronze_crm_prd_info;
LOAD DATA LOCAL INFILE "D:/MySQL June Batch/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv"
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

truncate table bronze_crm_sales_details;
LOAD DATA LOCAL INFILE "D:/MySQL June Batch/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv"
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

set @start_time = now();
Set @end_time = Now();
select "Loading Duration", Cast(timestampdiff(second, @start_time, @end_time) As char) as duration , "seconds" as unit;


Select "------------------------------------------------------------" As message;
Select " Loading erp tables" As message;

SET @start_time = Now();
truncate table bronze_erp_cust_az12;
LOAD DATA LOCAL INFILE "D:/MySQL June Batch/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv"
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

truncate table bronze_erp_loc_a101;
LOAD DATA LOCAL INFILE "D:/MySQL June Batch/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv"
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

truncate table bronze_erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE "D:/MySQL June Batch/sql-data-warehouse-project/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv"
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Set @End_time = Now();
select "Loading Duration", Cast(timestampdiff(second, @start_time, @end_time) As char) AS duration , "seconds" As unit;
