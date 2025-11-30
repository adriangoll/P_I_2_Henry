
    
    

with all_values as (

    select
        cantidad as value_field,
        count(*) as n_records

    from "ecommerce_raw"."marts_marts"."mart_hecho_ventas"
    group by cantidad

)

select *
from all_values
where value_field not in (
    '1','2','3','4','5','10','20','50','100'
)


