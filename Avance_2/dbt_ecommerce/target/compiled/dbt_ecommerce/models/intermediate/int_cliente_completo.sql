

SELECT
    u.usuario_id,
    u.nombre,
    u.apellido,
    u.email,
    u.dni,
    d.ciudad,
    d.provincia,
    d.pais,
    d.codigo_postal,
    d.calle,
    d.departamento,
    d.distrito
FROM "ecommerce_raw"."marts_staging"."stg_usuarios" u
LEFT JOIN "ecommerce_raw"."marts_staging"."stg_direcciones_envio" d 
    ON u.usuario_id = d.usuario_id