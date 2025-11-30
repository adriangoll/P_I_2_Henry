-- Staging: Usuarios
-- Limpieza y estandarización de datos de usuarios



SELECT
    usuario_id,
    nombre,
    apellido,
    dni,
    email,
    contrasena,
    CURRENT_TIMESTAMP as fecha_carga
FROM staging.usuarios
WHERE usuario_id IS NOT NULL