{{ config(materialized='table', schema='marts') }}

SELECT
    ROW_NUMBER() OVER (ORDER BY pais, provincia, ciudad) as id_ubicacion,
    pais,
    provincia,
    ciudad,
    NULL as region,
    codigo_postal,
    CURRENT_TIMESTAMP as fecha_carga
FROM {{ ref('stg_direcciones_envio') }}
WHERE ciudad IS NOT NULL
GROUP BY pais, provincia, ciudad, codigo_postal