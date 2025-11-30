{{ config(materialized='view', schema='staging') }}

SELECT
    orden_id,
    usuario_id,
    fecha_orden,
    total,
    estado,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.ordenes
WHERE orden_id IS NOT NULL
