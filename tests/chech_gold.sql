 select * from gold.fact_sales f
 left join gold.dim_customers c
 Using (customer_key)
left join gold.dim_product p 
Using (product_key)
where product_key is null;
