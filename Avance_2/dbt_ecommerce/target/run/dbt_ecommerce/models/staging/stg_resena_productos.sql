
  create view "ecommerce_raw"."marts_staging"."stg_resena_productos__dbt_tmp"
    
    
  as (
    

SELECT
    resena_id,
    usuario_id,
    producto_id,
    calificacion,
    comentario,
    fecha,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.resenas_productos
WHERE resena_id IS NOT NULL
  );