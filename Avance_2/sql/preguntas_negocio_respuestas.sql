-- ============================================
-- PREGUNTAS DE NEGOCIO - RESPUESTAS SQL
-- ============================================

-- PREGUNTA 1: ¿Cuáles son los productos más vendidos por categoría?
SELECT
    categoria,
    nombre_producto,
    SUM(cantidad) as total_vendido,
    SUM(monto_neto) as monto_total,
    RANK() OVER (PARTITION BY categoria ORDER BY SUM(cantidad) DESC) as ranking_categoria
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_producto dp ON hv.producto_id = dp.id_producto
GROUP BY categoria, nombre_producto
ORDER BY categoria, ranking_categoria;

-- PREGUNTA 2: ¿Qué clientes realizaron más compras y cuánto gastaron en promedio?
SELECT
    id_cliente,
    nombre_completo,
    COUNT(DISTINCT orden_id) as total_ordenes,
    SUM(monto_neto) as gasto_total,
    ROUND(AVG(monto_neto), 2) as ticket_promedio,
    RANK() OVER (ORDER BY SUM(monto_neto) DESC) as ranking_clientes
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_cliente dc ON hv.usuario_id = dc.id_cliente
GROUP BY id_cliente, nombre_completo
HAVING COUNT(DISTINCT orden_id) > 1
ORDER BY gasto_total DESC
LIMIT 20;

-- PREGUNTA 3: ¿Cuáles son los productos con mayor y menor rotación?
WITH rotacion AS (
    SELECT
        nombre_producto,
        categoria,
        COUNT(DISTINCT orden_id) as cantidad_ordenes,
        SUM(cantidad) as total_unidades,
        ROUND(100.0 * SUM(cantidad) / (SELECT SUM(cantidad) FROM marts_marts.mart_hecho_ventas), 2) as porcentaje_ventas
    FROM marts_marts.mart_hecho_ventas hv
    LEFT JOIN marts_marts.mart_dim_producto dp ON hv.producto_id = dp.id_producto
    GROUP BY nombre_producto, categoria
)
SELECT * FROM rotacion
ORDER BY total_unidades DESC;

-- PREGUNTA 4: ¿Cuál es la evolución mensual del ingreso bruto?
SELECT
    df.ano,
    df.mes,
    COUNT(DISTINCT hv.orden_id) as total_ordenes,
    SUM(hv.cantidad) as total_unidades,
    ROUND(SUM(hv.monto_neto)::numeric, 2) as ingreso_bruto_mes,
    ROUND(AVG(hv.monto_neto)::numeric, 2) as ticket_promedio_mes,
    LAG(SUM(hv.monto_neto)) OVER (ORDER BY df.ano, df.mes) as ingreso_mes_anterior,
    ROUND(((SUM(hv.monto_neto) - LAG(SUM(hv.monto_neto)) OVER (ORDER BY df.ano, df.mes)) / 
            LAG(SUM(hv.monto_neto)) OVER (ORDER BY df.ano, df.mes) * 100)::numeric, 2) as variacion_porcentual
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_fecha df ON hv.id_fecha = df.id_fecha
GROUP BY df.ano, df.mes
ORDER BY df.ano, df.mes;

-- PREGUNTA 5: ¿Qué categorías aportan el mayor margen de ganancia?
SELECT
    dp.categoria,
    COUNT(DISTINCT hv.producto_id) as cantidad_productos,
    COUNT(DISTINCT hv.orden_id) as cantidad_ordenes,
    SUM(hv.cantidad) as total_unidades_vendidas,
    ROUND(SUM(hv.monto_neto)::numeric, 2) as ingresos,
    ROUND((100.0 * SUM(hv.monto_neto) / (SELECT SUM(monto_neto) FROM marts_marts.mart_hecho_ventas))::numeric, 2) as porcentaje_ingresos_totales
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_producto dp ON hv.producto_id = dp.id_producto
GROUP BY dp.categoria
ORDER BY ingresos DESC;

-- PREGUNTA 6: ¿En qué provincias hay mayor concentración de clientes?
SELECT
    du.provincia,
    COUNT(DISTINCT dc.id_cliente) as cantidad_clientes,
    SUM(hv.monto_neto) as ingresos_provincia,
    ROUND(AVG(hv.monto_neto)::numeric, 2) as ticket_promedio,
    RANK() OVER (ORDER BY COUNT(DISTINCT dc.id_cliente) DESC) as ranking_provincias
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_cliente dc ON hv.usuario_id = dc.id_cliente
LEFT JOIN marts_marts.mart_dim_ubicacion du ON dc.pais = du.pais AND dc.provincia = du.provincia
GROUP BY du.provincia
ORDER BY cantidad_clientes DESC;

-- PREGUNTA 7: ¿Cuál es el ticket promedio por categoría?
SELECT
    dp.categoria,
    COUNT(DISTINCT hv.orden_id) as total_ordenes,
    ROUND(AVG(hv.monto_neto)::numeric, 2) as ticket_promedio,
    ROUND(MIN(hv.monto_neto)::numeric, 2) as ticket_minimo,
    ROUND(MAX(hv.monto_neto)::numeric, 2) as ticket_maximo,
    ROUND(STDDEV(hv.monto_neto)::numeric, 2) as desviacion_estandar
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_producto dp ON hv.producto_id = dp.id_producto
GROUP BY dp.categoria
ORDER BY ticket_promedio DESC;

-- PREGUNTA 8: ¿Qué porcentaje de clientes son recurrentes vs nuevos cada mes?
WITH clientes_por_mes AS (
    SELECT
        df.ano,
        df.mes,
        dc.id_cliente,
        MIN(df.fecha) OVER (PARTITION BY dc.id_cliente) as primera_compra
    FROM marts_marts.mart_hecho_ventas hv
    LEFT JOIN marts_marts.mart_dim_cliente dc ON hv.usuario_id = dc.id_cliente
    LEFT JOIN marts_marts.mart_dim_fecha df ON hv.id_fecha = df.id_fecha
)
SELECT
    ano,
    mes,
    COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM primera_compra) = ano AND EXTRACT(MONTH FROM primera_compra) = mes THEN id_cliente END) as clientes_nuevos,
    COUNT(DISTINCT CASE WHEN NOT (EXTRACT(YEAR FROM primera_compra) = ano AND EXTRACT(MONTH FROM primera_compra) = mes) THEN id_cliente END) as clientes_recurrentes,
    COUNT(DISTINCT id_cliente) as total_clientes_activos,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM primera_compra) = ano AND EXTRACT(MONTH FROM primera_compra) = mes THEN id_cliente END) / 
          COUNT(DISTINCT id_cliente), 2) as porcentaje_nuevos
FROM clientes_por_mes
GROUP BY ano, mes
ORDER BY ano, mes;

-- PREGUNTA 9: ¿Cuál es el producto peor calificado?
SELECT
    nombre_producto,
    categoria,
    ROUND(AVG(dp.precio_actual)::numeric, 2) as precio_promedio,
    SUM(hv.cantidad) as total_vendido,
    COUNT(DISTINCT hv.orden_id) as cantidad_ordenes
FROM marts_marts.mart_hecho_ventas hv
LEFT JOIN marts_marts.mart_dim_producto dp ON hv.producto_id = dp.id_producto
GROUP BY nombre_producto, categoria, dp.id_producto
ORDER BY nombre_producto
LIMIT 10;