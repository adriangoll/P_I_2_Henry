
    
    

select
    id_fecha as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_fecha"
where id_fecha is not null
group by id_fecha
having count(*) > 1


