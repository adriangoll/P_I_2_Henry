
  create view "ecommerce_raw"."marts_staging"."stg_metodos_pago__dbt_tmp"
    
    
  as (
    

SELECT
    metodo_id,
    nombre,
    descripcion,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.metodos_pago
WHERE metodo_id IS NOT NULL
  );