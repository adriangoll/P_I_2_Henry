
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_metodo_pago
from "ecommerce_raw"."marts_marts"."mart_dim_metodo_pago"
where id_metodo_pago is null



  
  
      
    ) dbt_internal_test