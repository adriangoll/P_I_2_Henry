{{ config(materialized='table', schema='marts') }}

SELECT
    df.fecha,
    COUNT(DISTINCT hv.orden_id) as total_ordenes,
    SUM(hv.cantidad) as total_unidades,
    SUM(hv.monto_neto) as monto_total_vendido,
    AVG(hv.monto_neto) as ticket_promedio,
    COUNT(DISTINCT hv.usuario_id) as clientes_unicos,
    CURRENT_TIMESTAMP as fecha_carga
FROM {{ ref('mart_hecho_ventas') }} hv
LEFT JOIN {{ ref('mart_dim_fecha') }} df 
    ON hv.id_fecha = df.id_fecha
GROUP BY df.fecha