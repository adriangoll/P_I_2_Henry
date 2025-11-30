
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select producto_id
from "ecommerce_raw"."marts_marts"."mart_hecho_ventas"
where producto_id is null



  
  
      
    ) dbt_internal_test