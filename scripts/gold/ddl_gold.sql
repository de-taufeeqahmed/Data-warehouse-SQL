/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
create view gold.dim_customers AS
SELECT 
row_number() Over(order by cst_id) As customer_key,
ci.cst_id as customer_id, 
ci.cst_key as customer_number, 
ci.cst_firstname as firstname,
ci.cst_lastname As lastname,
ci.cst_marital_status as marital_status,
Case when ci.cst_gndr !='N/A' then ci.cst_gndr
Else coalesce(ca.gen, 'N/A')
End as Gender,
ci.cst_create_date as create_date,
ca.BDATE as birthdate,
li.CNTRY as country
FROM silver.crm_cust_info as ci
Left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 li
on ci.cst_key = li.cid
;
-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
create view gold.dim_product AS
select
row_number() over (order by prd_start_dt, prd_key) as product_key,
 pl.prd_id as product_id,
pl.prd_key as product_number,
pl.cat_id as category_id,
pn.cat as category,
pn.subcat as subcategory,
pn.MAINTENANCE,
pl.prd_nm as product_name,
pl.prd_cost as product_cost,
pl.prd_line as product_line, 
pl.prd_start_dt as Start_date,
pl.prd_end_dt as end_date
from silver.crm_prd_info pl
left join silver.erp_px_cat_g1v2 pn
on pl.cat_id = pn.ID
where prd_end_dt Is null;

-- =============================================================================
-- Create Fact: gold.fact_sales
-- =============================================================================

create view gold.fact_sales as
select
sls_ord_num as order_number,
pr.product_key ,
cu.customer_key,
 sls_order_dt as order_date,
 sls_ship_dt As shipping_date,
 sls_due_dt as due_date,
 sls_sales as total_sales,
 sls_quantity as qunatity,
 sls_price as price from silver.crm_sales_details cd
 left join gold.dim_product pr
 on cd.sls_prd_key = pr.product_number
 Left Join gold.dim_customers cu
 on cd.sls_cust_id = cu.customer_id;
 

