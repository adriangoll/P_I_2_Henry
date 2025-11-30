

SELECT
    ROW_NUMBER() OVER (ORDER BY op.orden_id) as id_hecho_pago,
    op.orden_id,
    op.metodo_id as id_metodo_pago,
    EXTRACT(YEAR FROM CURRENT_DATE) * 10000 + 
    EXTRACT(MONTH FROM CURRENT_DATE) * 100 + 
    EXTRACT(DAY FROM CURRENT_DATE) as id_fecha,
    op.monto_pagado,
    NULL as estado_pago,
    CURRENT_TIMESTAMP as fecha_carga
FROM "ecommerce_raw"."marts_intermediate"."int_ordenes_pagos" op

---