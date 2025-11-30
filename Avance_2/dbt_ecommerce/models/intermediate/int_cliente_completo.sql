{{ config(materialized='view', schema='intermediate') }}

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
FROM {{ ref('stg_usuarios') }} u
LEFT JOIN {{ ref('stg_direcciones_envio') }} d 
    ON u.usuario_id = d.usuario_id