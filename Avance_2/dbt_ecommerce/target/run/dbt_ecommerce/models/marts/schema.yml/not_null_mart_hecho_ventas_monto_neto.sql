
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select monto_neto
from "ecommerce_raw"."marts_marts"."mart_hecho_ventas"
where monto_neto is null



  
  
      
    ) dbt_internal_test