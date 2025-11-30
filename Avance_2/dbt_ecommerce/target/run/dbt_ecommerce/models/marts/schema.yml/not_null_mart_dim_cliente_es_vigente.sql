
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select es_vigente
from "ecommerce_raw"."marts_marts"."mart_dim_cliente"
where es_vigente is null



  
  
      
    ) dbt_internal_test