
  create view "ecommerce_raw"."marts_intermediate"."int_ordenes_detalle__dbt_tmp"
    
    
  as (
    

SELECT
    o.orden_id,
    o.usuario_id,
    o.fecha_orden,
    o.estado as estado_orden,
    o.total,
    d.producto_id,
    d.cantidad,
    d.precio_unitario,
    (d.cantidad * d.precio_unitario) as monto_linea
FROM "ecommerce_raw"."marts_staging"."stg_ordenes" o
LEFT JOIN "ecommerce_raw"."marts_staging"."stg_detalle_ordenes" d
    ON o.orden_id = d.orden_id
  );