/*
=====================================================================
DDl script for creation of silver layer in our data warehouse.
You can use procedure as well to execute all at one go.
======================================================================
*/
Create table silver.crm_cust_info
( cst_id int,
cst_key Varchar (15),
cst_firstname Varchar (15),
cst_lastname Varchar (20),
cst_marital_status Varchar (15),
cst_gndr Varchar (5),
cst_create_date date,
dwh_create_time datetime default NOW()
);

Create table silver.crm_prd_info (
prd_id INT,
prd_key Varchar (25),
cat_id Varchar (10),
prd_nm Varchar (50),
prd_cost INT,
prd_line Varchar (5),
prd_start_dt date,
prd_end_dt date ,
dwh_create_time datetime default NOW());

create table silver.crm_sales_details(
sls_ord_num	Varchar (10),
sls_prd_key	Varchar (20),
sls_cust_id	INT,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_time datetime default NOW());

create table silver.erp_cust_az12 (
CID	Varchar (50),
BDATE date,
GEN varchar (10),
dwh_create_time datetime default NOW());

create table silver.erp_loc_a101(
CID	Varchar (20),
CNTRY Varchar (20),
dwh_create_time datetime default NOW()
);

create table silver.erp_px_cat_g1v2 (
ID Varchar(20),
CAT Varchar(50),
SUBCAT Varchar(50),
MAINTENANCE Varchar (10),
dwh_create_time datetime default NOW()
);
