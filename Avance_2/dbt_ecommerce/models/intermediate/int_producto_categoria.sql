{{ config(materialized='view', schema='intermediate') }}

SELECT
    p.producto_id,
    p.nombre as nombre_producto,
    p.descripcion,
    p.precio,
    p.stock,
    c.categoria_id,
    c.nombre as nombre_categoria
FROM {{ ref('stg_productos') }} p
LEFT JOIN {{ ref('stg_categorias') }} c 
    ON p.categoria_id = c.categoria_id