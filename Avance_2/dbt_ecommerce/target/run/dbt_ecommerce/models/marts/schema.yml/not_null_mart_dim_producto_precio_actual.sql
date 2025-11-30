
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select precio_actual
from "ecommerce_raw"."marts_marts"."mart_dim_producto"
where precio_actual is null



  
  
      
    ) dbt_internal_test