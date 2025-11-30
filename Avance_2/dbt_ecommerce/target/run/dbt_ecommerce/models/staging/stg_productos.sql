
  create view "ecommerce_raw"."marts_staging"."stg_productos__dbt_tmp"
    
    
  as (
    

SELECT
    producto_id,
    nombre,
    descripcion,
    precio,
    stock,
    categoria_id,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.productos
WHERE producto_id IS NOT NULL
  );