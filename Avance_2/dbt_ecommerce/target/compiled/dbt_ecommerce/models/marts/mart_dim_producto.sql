

SELECT
    producto_id as id_producto,
    nombre_producto,
    nombre_categoria as categoria,
    descripcion,
    precio as precio_actual,
    stock as stock_actual,
    CURRENT_DATE as fecha_inicio,
    '9999-12-31'::DATE as fecha_fin,
    TRUE as es_vigente,
    1 as version,
    CURRENT_TIMESTAMP as fecha_carga
FROM "ecommerce_raw"."marts_intermediate"."int_producto_categoria"