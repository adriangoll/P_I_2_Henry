{{ config(materialized='view', schema='intermediate') }}

SELECT
    om.orden_id,
    om.metodo_id,
    mp.nombre as nombre_metodo,
    om.monto_pagado
FROM {{ ref('stg_ordenes_metodos_pago') }} om
LEFT JOIN {{ ref('stg_metodos_pago') }} mp 
    ON om.metodo_id = mp.metodo_id