/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
select * from silver.crm_cust_info 
where cst_id is null or cst_id <= 0;

select * from silver.crm_cust_info
where cst_key is null;

select * from silver.crm_cust_info
where cst_firstname != Trim(cst_firstname);

select * from silver.crm_cust_info
where cst_lastname != Trim(cst_lastname);

select distinct(cst_gndr) from silver.crm_cust_info;

/*
=========================================================================================
*/
select * from silver.crm_prd_info
where prd_id is null or prd_id <=0;


select * from silver.crm_prd_info
where prd_nm != trim(prd_nm);


select * from silver.crm_prd_info
where prd_cost is null;

select * from silver.crm_prd_info
where prd_start_dt >=prd_end_dt;

/*
===============================================================================================
*/
select * from silver.crm_sales_details
where sls_order_dt is null;

select * from silver.crm_sales_details
where sls_sales is null or sls_sales != sls_quantity * sls_price;

select * from silver.crm_sales_details
where sls_price  <= 0;

/*
=================================================================================================
*/
select * from silver.erp_cust_az12
where Bdate >= Now() Or Bdate < 1924-01-01;

select distinct(gen) from silver.erp_cust_az12;

/*
===================================================================================================
*/
select distinct(cntry) from silver.erp_loc_a101;
/*
====================================================================================================
*/
select * from silver.erp_px_cat_g1v2
where Cat != Trim(Cat);

select * from silver.erp_px_cat_g1v2
where SUBCAT != Trim(SUBCAT);

select distinct(MAINTENANCE) from silver.erp_px_cat_g1v2;
