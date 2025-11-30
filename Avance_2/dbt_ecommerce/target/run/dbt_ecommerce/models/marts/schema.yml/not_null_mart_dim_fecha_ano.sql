
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ano
from "ecommerce_raw"."marts_marts"."mart_dim_fecha"
where ano is null



  
  
      
    ) dbt_internal_test