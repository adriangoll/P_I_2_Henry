-- SCD Type 2 - Dimensión Producto
-- Detecta cambios en: precio, categoría, descripción

{{ config(materialized='view', schema='marts', tags=['scd_demo']) }}

WITH producto_base AS (
  SELECT
    id_producto,
    nombre_producto,
    categoria,
    precio_actual,
    CURRENT_DATE as fecha_carga
  FROM {{ ref('int_producto_categoria') }}
),

producto_con_hash AS (
  SELECT
    id_producto,
    nombre_producto,
    categoria,
    precio_actual,
    fecha_carga,
    MD5(CONCAT(nombre_producto, categoria, precio_actual)) as hash_producto,
    LAG(MD5(CONCAT(nombre_producto, categoria, precio_actual))) OVER 
      (PARTITION BY id_producto ORDER BY fecha_carga) as hash_anterior
  FROM producto_base
),

producto_con_cambios AS (
  SELECT
    id_producto,
    nombre_producto,
    categoria,
    precio_actual,
    CURRENT_DATE as fecha_inicio,
    '9999-12-31'::DATE as fecha_fin,
    TRUE as es_vigente,
    ROW_NUMBER() OVER (PARTITION BY id_producto ORDER BY fecha_carga) as version,
    CASE 
      WHEN hash_producto != hash_anterior THEN 'CAMBIO_PRECIO_O_CATEGORIA'
      ELSE 'SIN_CAMBIO'
    END as tipo_cambio,
    CASE
      WHEN LAG(precio_actual) OVER (PARTITION BY id_producto ORDER BY fecha_carga) != precio_actual 
        THEN precio_actual - LAG(precio_actual) OVER (PARTITION BY id_producto ORDER BY fecha_carga)
      ELSE 0
    END as delta_precio
  FROM producto_con_hash
)

SELECT * FROM producto_con_cambios
-- Detecta cambios en precio, categoría
-- En producción: histórico de precios para análisis de elasticidad