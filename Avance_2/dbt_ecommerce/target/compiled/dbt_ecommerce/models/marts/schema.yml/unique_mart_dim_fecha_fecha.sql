
    
    

select
    fecha as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_fecha"
where fecha is not null
group by fecha
having count(*) > 1


