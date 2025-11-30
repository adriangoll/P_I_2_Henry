

SELECT
    metodo_id,
    nombre,
    descripcion,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.metodos_pago
WHERE metodo_id IS NOT NULL