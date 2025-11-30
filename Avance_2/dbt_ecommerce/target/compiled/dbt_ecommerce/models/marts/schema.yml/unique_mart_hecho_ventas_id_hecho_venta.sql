
    
    

select
    id_hecho_venta as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_hecho_ventas"
where id_hecho_venta is not null
group by id_hecho_venta
having count(*) > 1


