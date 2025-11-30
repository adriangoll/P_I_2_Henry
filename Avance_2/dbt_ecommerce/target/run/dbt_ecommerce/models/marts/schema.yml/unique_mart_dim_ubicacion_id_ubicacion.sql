
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    id_ubicacion as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_ubicacion"
where id_ubicacion is not null
group by id_ubicacion
having count(*) > 1



  
  
      
    ) dbt_internal_test