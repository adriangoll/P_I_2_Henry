-- DEMOSTRACIÓN SCD Type 2 - NO EJECUTAR EN PRODUCCIÓN
-- Esta consulta muestra la LÓGICA de detección de cambios
-- En producción: usar Airflow/dbt-utils para automatizar

{{ config(materialized='view', schema='marts', tags=['scd_demo']) }}

WITH cliente_base AS (
  SELECT
    usuario_id as id_cliente,
    nombre,
    email,
    CURRENT_DATE as fecha_carga
  FROM {{ ref('int_cliente_completo') }}
),

cliente_con_hash AS (
  SELECT
    id_cliente,
    nombre,
    email,
    fecha_carga,
    MD5(CONCAT(nombre, email)) as hash_cliente,
    LAG(MD5(CONCAT(nombre, email))) OVER 
      (PARTITION BY id_cliente ORDER BY fecha_carga) as hash_anterior
  FROM cliente_base
),

cliente_con_cambios AS (
  SELECT
    id_cliente,
    nombre,
    email,
    CURRENT_DATE as fecha_inicio,
    '9999-12-31'::DATE as fecha_fin,
    TRUE as es_vigente,
    ROW_NUMBER() OVER (PARTITION BY id_cliente ORDER BY fecha_carga) as version,
    CASE 
      WHEN hash_cliente != hash_anterior THEN 'CAMBIO_DETECTADO'
      ELSE 'SIN_CAMBIO'
    END as estado_cambio
  FROM cliente_con_hash
)

SELECT * FROM cliente_con_cambios
-- En producción: INSERT/UPDATE en mart_dim_cliente con:
-- - UPDATE registros vigentes: fecha_fin = hoy, es_vigente = FALSE
-- - INSERT nuevo registro: fecha_inicio = hoy, version++