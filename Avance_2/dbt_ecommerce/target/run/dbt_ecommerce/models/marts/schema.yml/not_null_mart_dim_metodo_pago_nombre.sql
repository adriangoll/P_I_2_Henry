
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select nombre
from "ecommerce_raw"."marts_marts"."mart_dim_metodo_pago"
where nombre is null



  
  
      
    ) dbt_internal_test