
  
    

  create  table "ecommerce_raw"."marts_marts"."mart_kpi_ventas_diarias__dbt_tmp"
  
  
    as
  
  (
    

SELECT
    df.fecha,
    COUNT(DISTINCT hv.orden_id) as total_ordenes,
    SUM(hv.cantidad) as total_unidades,
    SUM(hv.monto_neto) as monto_total_vendido,
    AVG(hv.monto_neto) as ticket_promedio,
    COUNT(DISTINCT hv.usuario_id) as clientes_unicos,
    CURRENT_TIMESTAMP as fecha_carga
FROM "ecommerce_raw"."marts_marts"."mart_hecho_ventas" hv
LEFT JOIN "ecommerce_raw"."marts_marts"."mart_dim_fecha" df 
    ON hv.id_fecha = df.id_fecha
GROUP BY df.fecha
  );
  