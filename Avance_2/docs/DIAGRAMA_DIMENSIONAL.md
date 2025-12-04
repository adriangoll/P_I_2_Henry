# Diagrama Dimensional - Star Schema

## Modelo Dimensional OLAP

### Estructura General

```
                    dim_fecha
                       │
                       │
    dim_cliente ───→ hecho_ventas ←── dim_producto
                       │
                       ├──→ dim_ubicacion
                       │
                       └──→ dim_metodo_pago
```

## Tabla de Hechos Central: hecho_ventas

**Granularidad:** Línea de orden (detalle_ordenes)
**Registros:** 40,000
**Medidas:** cantidad, precio_unitario, monto_neto

```
hecho_ventas
├─ id_hecho_venta (PK)
├─ orden_id (FK)
├─ producto_id (FK → dim_producto)
├─ usuario_id (FK → dim_cliente)
├─ id_fecha (FK → dim_fecha)
├─ cantidad (MEASURE)
├─ precio_unitario (MEASURE)
└─ monto_neto (MEASURE)
```

## Dimensiones

### dim_cliente (1,000 filas) - SCD Type 2
```
id_cliente (PK)
├─ nombre_completo
├─ correo_electronico
├─ ciudad / provincia / pais
├─ fecha_inicio (SCD)
├─ fecha_fin (SCD)
├─ es_vigente (SCD)
└─ version (SCD)
```
**Cambios Tracked:** Email, dirección, estado cliente

### dim_producto (144 filas) - SCD Type 2
```
id_producto (PK)
├─ nombre_producto
├─ categoria
├─ precio_actual
├─ descripcion
├─ fecha_inicio (SCD)
├─ fecha_fin (SCD)
├─ es_vigente (SCD)
└─ version (SCD)
```
**Cambios Tracked:** Precio, categoría, disponibilidad

### dim_fecha (3,651 filas)
```
id_fecha (PK - YYYYMMDD)
├─ fecha (DATE)
├─ dia_mes (1-31)
├─ mes (1-12)
├─ trimestre (1-4)
├─ ano (2020-2030)
├─ dia_semana_num (1-7)
├─ dia_semana_nombre (Monday-Sunday)
├─ es_feriado (BOOLEAN)
└─ semana_ano (1-53)
```
**Cobertura:** 10 años completos para análisis histórico

### dim_ubicacion (1,000 filas)
```
id_ubicacion (PK)
├─ pais
├─ provincia
├─ ciudad
├─ region
├─ codigo_postal
└─ fecha_carga
```
**Análisis:** Concentración geográfica de clientes

### dim_metodo_pago (0 filas - Vacío)
```
id_metodo_pago (PK)
├─ nombre
├─ categoria (Tarjeta/Billetera/Efectivo)
├─ es_activo
└─ fecha_carga
```
**Estado:** Sin datos en staging (0 pagos registrados)

---

## Relaciones y Cardinalidades

| Relación | Tipo | Descripción |
|----------|------|-------------|
| hecho_ventas → dim_cliente | N:1 | Muchas ventas por cliente |
| hecho_ventas → dim_producto | N:1 | Muchas ventas del mismo producto |
| hecho_ventas → dim_fecha | N:1 | Muchas ventas por fecha |
| hecho_ventas → dim_ubicacion | N:1 | Muchas ventas por región |
| dim_producto → dim_categoria | N:1 | Muchos productos por categoría |

---

## Tabla de Hechos Secundaria: hecho_pago

**Granularidad:** Pago por orden
**Registros:** 0 (sin datos)
**Medidas:** monto_pagado

```
hecho_pago
├─ id_hecho_pago (PK)
├─ orden_id (FK)
├─ id_metodo_pago (FK → dim_metodo_pago)
├─ id_fecha (FK → dim_fecha)
└─ monto_pagado (MEASURE)
```

---

## KPIs Agregados

### mart_kpi_ventas_diarias
- Granularidad: Día
- Métricas: total_ordenes, monto_total, ticket_promedio

### mart_kpi_productos_top
- Ranking de productos por volumen vendido
- Incluye: cantidad_ordenes, monto_total, segmento

### mart_kpi_clientes_segmentacion
- Segmentación: Premium / Gold / Silver / Bronze
- Criterio: Monto total gastado

### mart_kpi_categorias_performance
- % de ventas totales por categoría
- Incluye: cantidad_productos, clientes_unicos

---

## Justificación del Diseño

### ¿Por qué Star Schema?
- **Velocidad:** Mínimo JOINs (1 hecho + N dimensiones)
- **Simplicidad:** Fácil para analistas SQL
- **Escalabilidad:** Soporta millones de hechos

### ¿Por qué SCD Type 2?
- **Trazabilidad:** Histórico completo de cambios
- **Análisis:** Comparar precios históricos, migración clientes
- **Auditoría:** Quién cambió qué y cuándo

### ¿Por qué 2 Tablas de Hechos?
- **fact_sales:** Análisis de productos, clientes, categorías
- **fact_payments:** Análisis de métodos pago, reconciliación
- **Granularidades diferentes:** Línea vs pago por orden

---

## Diagrama Visual

Ver:
- `DIAGRAMA_ER_DIMENSIONAL.png` - Modelo visual en dbdiagram.io
- `DIAGRAMA_ER_TRANSACCIONAL.png` - Modelo OLTP comparativo

---

## Estadísticas del Modelo

| Componente | Métrica | Valor |
|-----------|---------|-------|
| Tablas Hechos | Cantidad | 2 |
| Tablas Dimensiones | Cantidad | 5 |
| Total Filas (Hechos) | Cantidad | 40,000 |
| Total Filas (Dimensiones) | Cantidad | ~5,500 |
| Campos SCD | Cantidad | 4 (fecha_inicio, fecha_fin, es_vigente, version) |
| Tests Automatizados | Cantidad | 29 |
| Cobertura Temporal | Rango | 10 años (2020-2030) |

---

## Escalabilidad Futura

**Si llega a 1M de órdenes:**
- Particionar hecho_ventas por año
- Agregar índices en FKs
- Considerar columna store_id (si multitienda)

**Si nuevo data source:**
- Agregar dim_proveedor, dim_promocion
- Extender fact_inventory con stock histórico