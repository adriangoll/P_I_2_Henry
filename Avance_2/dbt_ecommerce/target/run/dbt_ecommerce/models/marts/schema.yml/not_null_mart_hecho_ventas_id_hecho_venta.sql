
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_hecho_venta
from "ecommerce_raw"."marts_marts"."mart_hecho_ventas"
where id_hecho_venta is null



  
  
      
    ) dbt_internal_test