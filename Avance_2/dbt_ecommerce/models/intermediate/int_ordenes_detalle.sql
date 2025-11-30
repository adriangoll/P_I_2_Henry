{{ config(materialized='view', schema='intermediate') }}

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
FROM {{ ref('stg_ordenes') }} o
LEFT JOIN {{ ref('stg_detalle_ordenes') }} d
    ON o.orden_id = d.orden_id