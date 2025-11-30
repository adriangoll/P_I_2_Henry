
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select nombre_producto
from "ecommerce_raw"."marts_marts"."mart_dim_producto"
where nombre_producto is null



  
  
      
    ) dbt_internal_test