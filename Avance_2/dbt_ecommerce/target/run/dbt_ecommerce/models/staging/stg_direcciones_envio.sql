
  create view "ecommerce_raw"."marts_staging"."stg_direcciones_envio__dbt_tmp"
    
    
  as (
    

SELECT
    usuario_id,
    calle,
    ciudad,
    departamento,
    provincia,
    estado,
    distrito,
    pais,
    codigo_postal,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.direcciones_envio
WHERE usuario_id IS NOT NULL
  );