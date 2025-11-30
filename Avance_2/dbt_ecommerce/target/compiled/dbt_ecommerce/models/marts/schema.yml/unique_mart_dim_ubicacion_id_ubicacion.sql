
    
    

select
    id_ubicacion as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_ubicacion"
where id_ubicacion is not null
group by id_ubicacion
having count(*) > 1


