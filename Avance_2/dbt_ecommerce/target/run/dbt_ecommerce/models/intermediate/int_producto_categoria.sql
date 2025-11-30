
  create view "ecommerce_raw"."marts_intermediate"."int_producto_categoria__dbt_tmp"
    
    
  as (
    

SELECT
    p.producto_id,
    p.nombre as nombre_producto,
    p.descripcion,
    p.precio,
    p.stock,
    c.categoria_id,
    c.nombre as nombre_categoria
FROM "ecommerce_raw"."marts_staging"."stg_productos" p
LEFT JOIN "ecommerce_raw"."marts_staging"."stg_categorias" c 
    ON p.categoria_id = c.categoria_id
  );