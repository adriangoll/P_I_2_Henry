
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    id_fecha as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_fecha"
where id_fecha is not null
group by id_fecha
having count(*) > 1



  
  
      
    ) dbt_internal_test