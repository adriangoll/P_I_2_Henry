

SELECT
    resena_id,
    usuario_id,
    producto_id,
    calificacion,
    comentario,
    fecha,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.resenas_productos
WHERE resena_id IS NOT NULL