

SELECT
    dp.id_producto,
    dp.nombre_producto,
    dp.categoria,
    SUM(hv.cantidad) as total_vendido,
    SUM(hv.monto_neto) as monto_total,
    AVG(hv.cantidad) as promedio_unidades_por_orden,
    COUNT(DISTINCT hv.orden_id) as cantidad_ordenes,
    ROW_NUMBER() OVER (ORDER BY SUM(hv.cantidad) DESC) as ranking_ventas,
    CURRENT_TIMESTAMP as fecha_carga
FROM "ecommerce_raw"."marts_marts"."mart_hecho_ventas" hv
LEFT JOIN "ecommerce_raw"."marts_marts"."mart_dim_producto" dp 
    ON hv.producto_id = dp.id_producto
GROUP BY dp.id_producto, dp.nombre_producto, dp.categoria