
  
    

  create  table "ecommerce_raw"."marts_marts"."mart_dim_cliente__dbt_tmp"
  
  
    as
  
  (
    

WITH cliente_ranked AS (
    SELECT
        usuario_id as id_cliente,
        nombre,
        apellido,
        CONCAT(nombre, ' ', apellido) as nombre_completo,
        email as correo_electronico,
        dni,
        ciudad,
        provincia,
        pais,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY usuario_id) as rn
    FROM "ecommerce_raw"."marts_intermediate"."int_cliente_completo"
)
SELECT
    id_cliente,
    nombre,
    apellido,
    nombre_completo,
    correo_electronico,
    dni,
    ciudad,
    provincia,
    pais,
    CURRENT_DATE as fecha_inicio,
    '9999-12-31'::DATE as fecha_fin,
    TRUE as es_vigente,
    1 as version,
    CURRENT_TIMESTAMP as fecha_carga
FROM cliente_ranked
WHERE rn = 1
  );
  