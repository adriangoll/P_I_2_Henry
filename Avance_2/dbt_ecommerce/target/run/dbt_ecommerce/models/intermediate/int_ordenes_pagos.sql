
  create view "ecommerce_raw"."marts_intermediate"."int_ordenes_pagos__dbt_tmp"
    
    
  as (
    

SELECT
    om.orden_id,
    om.metodo_id,
    mp.nombre as nombre_metodo,
    om.monto_pagado
FROM "ecommerce_raw"."marts_staging"."stg_ordenes_metodos_pago" om
LEFT JOIN "ecommerce_raw"."marts_staging"."stg_metodos_pago" mp 
    ON om.metodo_id = mp.metodo_id
  );