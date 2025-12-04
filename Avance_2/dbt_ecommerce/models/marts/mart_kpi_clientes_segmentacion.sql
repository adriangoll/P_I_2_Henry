{{ config(materialized='table', schema='marts') }}

SELECT
    dc.id_cliente,
    dc.nombre_completo,
    dc.correo_electronico,
    COUNT(DISTINCT hv.orden_id) as total_ordenes,
    SUM(hv.monto_neto) as monto_total_gastado,
    AVG(hv.monto_neto) as ticket_promedio,
    MAX(df.fecha) as ultima_compra,
    CASE 
        WHEN SUM(hv.monto_neto) > 10000 THEN 'Premium'
        WHEN SUM(hv.monto_neto) > 5000 THEN 'Gold'
        WHEN SUM(hv.monto_neto) > 1000 THEN 'Silver'
        ELSE 'Bronze'
    END as segmento_cliente,
    CURRENT_TIMESTAMP as fecha_carga
FROM {{ ref('mart_hecho_ventas') }} hv
LEFT JOIN {{ ref('mart_dim_cliente') }} dc 
    ON hv.usuario_id = dc.id_cliente
LEFT JOIN {{ ref('mart_dim_fecha') }} df 
    ON hv.id_fecha = df.id_fecha
GROUP BY dc.id_cliente, dc.nombre_completo, dc.correo_electronico