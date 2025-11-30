
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_ubicacion
from "ecommerce_raw"."marts_marts"."mart_dim_ubicacion"
where id_ubicacion is null



  
  
      
    ) dbt_internal_test