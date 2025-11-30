

SELECT
    pago_id,
    orden_id,
    metodo_id,
    monto_pagado,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.ordenes_metodos_pago
WHERE pago_id IS NOT NULL