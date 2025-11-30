
    
    

select
    id_metodo_pago as unique_field,
    count(*) as n_records

from "ecommerce_raw"."marts_marts"."mart_dim_metodo_pago"
where id_metodo_pago is not null
group by id_metodo_pago
having count(*) > 1


