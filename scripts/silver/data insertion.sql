/*
==========================================================================
After cleaning, normalizing and handling missing values we will insert our
records in the silver layer.
===========================================================================
*/
insert into silver.crm_cust_info
(cst_key, cst_id, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)

select t.cst_key, t.cst_id,trim(t.cst_firstname) as cst_firstname, trim(t.cst_lastname) as cst_lastname,
 Case When upper(trim(t.cst_marital_status)) = "S" THEN "Single"
     when upper(trim(t.cst_marital_status)) = "M" Then "Married"
     Else "N/A"
     End cst_marital_status,
 case when upper(t.cst_gndr) = "F" Then "Female"
	When upper(t.cst_gndr) = "M" Then "Male"
    Else "N/A"
    End cst_gndr,
    t.cst_create_date
from 
(select *, row_number() Over (partition by cst_id order by cst_create_date desc) as flag from bronze.bronze_crm_cust_info )t
where t.flag = 1 and t.cst_id is not null;


select * from silver.crm_cust_info;
/*
==========================================================================
*/
insert into silver.crm_prd_info(prd_id, cat_id, prd_key,prd_nm, prd_cost, prd_line,prd_start_dt, prd_end_dt)
SELECT 
  prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
FROM
(select prd_id,
replace(substring(prd_key, 1, 5) ,'-','_') as cat_id,
 substring(prd_key,7, length(prd_key)) as prd_key,
 prd_nm,
 ifnull(prd_cost, 0) as prd_cost,
 case upper(trim(prd_line))
 when 'R' then 'Road'
 when 'S' then 'Sport'
 when 'M' then 'Mountain'
 when 'T' then 'Touring'
 else 'N/A'
 end as prd_line, prd_start_dt,
 date_sub(lead(prd_start_dt)  over( partition by prd_key order by prd_start_dt), interval 1 day) as prd_end_dt 
from bronze.bronze_crm_prd_info)
as delivered_table;

select * from silver.crm_prd_info
  /*
  ===================================================================================
  */
  insert into silver.crm_sales_details
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)

select sls_ord_num, 
sls_prd_key, 
sls_cust_id, 
nullif(sls_order_dt,0) as sls_order_dt, 
sls_ship_dt, 
sls_due_dt, 
case when sls_sales is null or sls_sales<= 0 or sls_sales != sls_quantity * abs(sls_price)
 then sls_quantity * abs(sls_price) else sls_sales
end as sls_sales,
sls_quantity, 
case when sls_price is null or sls_price <=0 then 
abs(sls_sales)/sls_quantity else sls_price
end as sls_price
from bronze_crm_sales_details;

select * from silver.crm_sales_details
where sls_order_dt is null;


 set sql_safe_updates = 0;
update silver.crm_sales_details
set sls_sales = 
case when sls_sales is null or sls_sales<= 0 or sls_sales != sls_quantity * abs(sls_price)
 then sls_quantity * abs(sls_price) else sls_sales
end ;

  /*
  ============================================================================
  */
  insert into silver.erp_cust_az12(CID, Bdate, Gen)
select  
case when cid like 'NAS%' then substring(cid, 4, length(cid))
else cid
end as cid,
case when BDATE > NOW() then Bdate = null
else BDATE
end as Bdate, 
case When upper(trim(GEN)) in ('F','FEMALE') then Gen = "Female"
When upper(trim(GEN)) in ('M','MALE') then Gen = "Male"
Else 'N/A'
end as Gen from bronze_erp_cust_az12;
  /*
  ===========================================================================
  */
  insert into silver.erp_loc_a101(cid,cntry)

select replace(cid, '-', '')as cid,
CASE
    WHEN REPLACE(TRIM(cntry), '\r', '') = '' OR cntry IS NULL THEN 'N/A'
    WHEN UPPER(REPLACE(TRIM(cntry), '\r', '')) = 'DE' THEN 'Denmark'
    WHEN UPPER(REPLACE(TRIM(cntry), '\r', '')) IN ('US', 'USA') THEN 'United States'
    ELSE REPLACE(TRIM(cntry), '\r', '')
END as cntry from bronze_erp_loc_a101;

select * from silver.erp_loc_a101;
/*
==========================================================================
*/
insert into silver.erp_px_cat_g1v2(id,cat,subcat, MAINTENANCE)

select ID, CAT, SUBCAT, MAINTENANCE from bronze_erp_px_cat_g1v2
;
select * from silver.erp_px_cat_g1v2;
