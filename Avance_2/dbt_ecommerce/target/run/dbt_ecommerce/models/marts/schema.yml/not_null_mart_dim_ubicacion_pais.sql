
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select pais
from "ecommerce_raw"."marts_marts"."mart_dim_ubicacion"
where pais is null



  
  
      
    ) dbt_internal_test