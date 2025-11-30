

SELECT
    orden_id,
    producto_id,
    cantidad,
    precio_unitario,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.detalle_ordenes
WHERE orden_id IS NOT NULL