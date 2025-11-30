

SELECT
    categoria_id,
    nombre,
    descripcion,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.categorias
WHERE categoria_id IS NOT NULL