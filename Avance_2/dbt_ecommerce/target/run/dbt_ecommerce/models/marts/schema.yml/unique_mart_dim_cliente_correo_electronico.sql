
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    correo_electronico as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_cliente"
where correo_electronico is not null
group by correo_electronico
having count(*) > 1



  
  
      
    ) dbt_internal_test