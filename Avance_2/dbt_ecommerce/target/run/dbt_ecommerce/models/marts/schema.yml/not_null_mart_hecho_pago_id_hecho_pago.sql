
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_hecho_pago
from "ecommerce_raw"."marts_marts"."mart_hecho_pago"
where id_hecho_pago is null



  
  
      
    ) dbt_internal_test