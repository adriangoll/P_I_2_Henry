
    
    

select
    id_hecho_pago as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_hecho_pago"
where id_hecho_pago is not null
group by id_hecho_pago
having count(*) > 1


