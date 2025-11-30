
  
    

  create  table "ecommerce_raw"."marts_marts"."mart_dim_fecha__dbt_tmp"
  
  
    as
  
  (
    

WITH fecha_base AS (
    SELECT CAST(CURRENT_DATE - (INTERVAL '1 day' * generate_series(0, 3650)) AS DATE) as fecha
)
SELECT
    EXTRACT(YEAR FROM fecha) * 10000 + 
    EXTRACT(MONTH FROM fecha) * 100 + 
    EXTRACT(DAY FROM fecha) as id_fecha,
    fecha,
    EXTRACT(DAY FROM fecha)::INTEGER as dia_mes,
    EXTRACT(MONTH FROM fecha)::INTEGER as mes,
    CEIL(EXTRACT(MONTH FROM fecha) / 3)::INTEGER as trimestre,
    EXTRACT(YEAR FROM fecha)::INTEGER as ano,
    (EXTRACT(ISODOW FROM fecha))::INTEGER as dia_semana_num,
    TO_CHAR(fecha, 'Day') as dia_semana_nombre,
    FALSE as es_feriado,
    EXTRACT(WEEK FROM fecha)::INTEGER as semana_ano,
    CURRENT_TIMESTAMP as fecha_carga
FROM fecha_base
  );
  