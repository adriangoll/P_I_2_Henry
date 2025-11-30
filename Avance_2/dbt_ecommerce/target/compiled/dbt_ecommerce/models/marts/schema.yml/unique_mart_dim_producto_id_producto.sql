
    
    

select
    id_producto as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_producto"
where id_producto is not null
group by id_producto
having count(*) > 1


