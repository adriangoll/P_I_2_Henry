{{ config(materialized='table', schema='marts') }}

SELECT
    dp.categoria,
    COUNT(DISTINCT hv.producto_id) as cantidad_productos,
    SUM(hv.cantidad) as total_unidades_vendidas,
    SUM(hv.monto_neto) as monto_total_categoria,
    AVG(hv.monto_neto) as ticket_promedio,
    COUNT(DISTINCT hv.orden_id) as total_ordenes,
    COUNT(DISTINCT hv.usuario_id) as clientes_unicos,
    ROUND(100.0 * SUM(hv.monto_neto) / 
        (SELECT SUM(monto_neto) FROM {{ ref('mart_hecho_ventas') }}), 2) as porcentaje_ventas_totales,
    CURRENT_TIMESTAMP as fecha_carga
FROM {{ ref('mart_hecho_ventas') }} hv
LEFT JOIN {{ ref('mart_dim_producto') }} dp 
    ON hv.producto_id = dp.id_producto
GROUP BY dp.categoria