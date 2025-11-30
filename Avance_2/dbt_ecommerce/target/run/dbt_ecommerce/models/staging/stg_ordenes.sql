
  create view "ecommerce_raw"."marts_staging"."stg_ordenes__dbt_tmp"
    
    
  as (
    

SELECT
    orden_id,
    usuario_id,
    fecha_orden,
    total,
    estado,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.ordenes
WHERE orden_id IS NOT NULL
  );