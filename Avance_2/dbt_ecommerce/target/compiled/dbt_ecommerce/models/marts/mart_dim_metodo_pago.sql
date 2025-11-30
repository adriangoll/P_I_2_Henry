

SELECT
    metodo_id as id_metodo_pago,
    nombre_metodo as nombre,
    NULL as descripcion,
    CASE 
        WHEN nombre_metodo LIKE '%Tarjeta%' THEN 'Tarjeta'
        WHEN nombre_metodo LIKE '%Billetera%' THEN 'Billetera'
        WHEN nombre_metodo = 'Efectivo' THEN 'Efectivo'
        ELSE 'Otro'
    END as categoria,
    TRUE as es_activo,
    CURRENT_TIMESTAMP as fecha_carga
FROM "ecommerce_raw"."marts_intermediate"."int_ordenes_pagos"
GROUP BY metodo_id, nombre_metodo