

SELECT
    ROW_NUMBER() OVER (ORDER BY od.orden_id, od.producto_id) as id_hecho_venta,
    od.orden_id,
    od.producto_id,
    od.usuario_id,
    pc.categoria_id,
    EXTRACT(YEAR FROM od.fecha_orden) * 10000 + 
    EXTRACT(MONTH FROM od.fecha_orden) * 100 + 
    EXTRACT(DAY FROM od.fecha_orden) as id_fecha,
    NULL::INTEGER as id_metodo_pago,
    NULL::INTEGER as id_ubicacion,
    od.cantidad,
    od.precio_unitario,
    od.monto_linea,
    0 as descuento,
    od.monto_linea as monto_neto,
    od.estado_orden,
    NULL as estado_pago,
    CURRENT_TIMESTAMP as fecha_carga
FROM "ecommerce_raw"."marts_intermediate"."int_ordenes_detalle" od
LEFT JOIN "ecommerce_raw"."marts_intermediate"."int_producto_categoria" pc 
    ON od.producto_id = pc.producto_id
     WHERE od.cantidad IS NOT NULL 
  AND od.monto_linea IS NOT NULL
  AND od.producto_id IS NOT NULL