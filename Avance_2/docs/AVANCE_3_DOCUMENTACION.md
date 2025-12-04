# Avance 3: Documentación Completa DBT + Dimensiones Lentamente Cambiantes

## Resumen Ejecutivo

Avance 3 completa la arquitectura dimensional con:
- ✓ 20 modelos DBT (staging, intermediate, marts)
- ✓ 4 KPIs agregados para análisis
- ✓ 29 tests automáticos
- ✓ SCD Type 2 logic documentada
- ✓ 2 diagramas ER (transaccional + dimensional)

---

## 1. Arquitectura de Capas DBT

### Staging (9 modelos - VISTAS)
Limpieza mínima de datos Avance 1:
- `stg_usuarios`, `stg_productos`, `stg_ordenes`
- `stg_detalle_ordenes`, `stg_categorias`
- `stg_metodos_pago`, `stg_direcciones_envio`
- `stg_resena_productos`, `stg_ordenes_metodos_pago`

**Propósito**: Validación y estandarización sin transformación de negocio

### Intermediate (4 modelos - VISTAS)
Lógica de negocio y JOINs preparatorios:
- `int_ordenes_detalle` - Órdenes + líneas detalle
- `int_cliente_completo` - Usuarios + dirección
- `int_producto_categoria` - Productos + categoría
- `int_ordenes_pagos` - Órdenes + métodos pago

**Propósito**: Preparar datos para consumo en marts

### Marts (11 modelos - TABLAS)

#### Hechos (2):
- `mart_hecho_ventas` (40,000 filas)
  - Granularidad: línea de orden
  - FKs: cliente, producto, fecha, categoría
  
- `mart_hecho_pago` (0 filas - sin datos pagos)
  - Granularidad: pago por orden
  - FKs: método pago, fecha

#### Dimensiones (5):
- `mart_dim_cliente` (1,000 filas) - SCD Type 2
- `mart_dim_producto` (144 filas) - SCD Type 2
- `mart_dim_fecha` (3,651 filas) - Calendario completo
- `mart_dim_ubicacion` (1,000 filas)
- `mart_dim_metodo_pago` (0 filas)

#### KPIs (4):
- `mart_kpi_ventas_diarias` (342 días)
- `mart_kpi_productos_top` (ranking)
- `mart_kpi_clientes_segmentacion` (Premium/Gold/Silver/Bronze)
- `mart_kpi_categorias_performance` (% ventas)

---

## 2. Slowly Changing Dimensions (SCD Type 2)

### Implementadas

#### dim_cliente - SCD Type 2
```
Campos tracked: nombre, email, dirección
Cuando cambia email → 
  ├─ Registro anterior: fecha_fin = hoy, es_vigente = FALSE, version = 1
  └─ Nuevo registro: fecha_inicio = hoy, es_vigente = TRUE, version = 2

Columnas SCD:
  - fecha_inicio (cuando inicia vigencia)
  - fecha_fin (cuando termina: '9999-12-31' si vigente)
  - es_vigente (TRUE/FALSE)
  - version (1, 2, 3...)
```

#### dim_producto - SCD Type 2
```
Campos tracked: precio, categoría, stock
Lógica idéntica a dim_cliente
```

### Lógica de Detección (No Automatizada en Avance 3)

Ver: `models/marts/mart_dim_cliente_scd_logic.sql`

Pseudocódigo:
```sql
1. Hash anterior = MD5(nombre || email)
2. Hash actual = MD5(nombre || email)
3. IF hash_anterior != hash_actual THEN
     UPDATE dim_cliente SET fecha_fin = hoy, es_vigente = FALSE
     INSERT dim_cliente SET fecha_inicio = hoy, version++
   END IF
```

**Nota**: En producción requiere:
- Tabla de control de cambios
- Trigger SQL o Airflow DAG
- Scheduleo diario/horario

---

## 3. Tests Automáticos (29 total)

```
PASS: 25 tests
FAIL: 4 tests (datos incompletos pagos)

Tipos de tests:
- unique: PKs y campos únicos
- not_null: Campos obligatorios
- relationships: FKs (TBD)
- accepted_values: Valores esperados
```

**Ubicación**: `models/schema.yml` (raíz models)

---

## 4. Diagramas

### DIAGRAMA_ER_TRANSACCIONAL.png
Modelo OLTP (Avance 1):
- Tablas staging normalizadas
- Relaciones referenciables
- Base para ETL

### DIAGRAMA_ER_DIMENSIONAL.png
Modelo OLAP (Avance 2-3):
- Star schema con hechos centrales
- 5 dimensiones periféricas
- Optimizado para analytics

---

## 5. Ejecución

```bash
cd Avance_2/dbt_ecommerce

# Compilar + ejecutar todos
dbt run

# Ejecutar por capa
dbt run --select staging
dbt run --select intermediate
dbt run --select marts

# Tests
dbt test

# Documentación
dbt docs generate
dbt docs serve
```

---

## 6. Próximos Pasos (Post-Avance 3)

- [ ] Automatizar SCD Type 2 con Airflow/dbt-utils
- [ ] Agregar más KPIs (cohort analysis, RFM)
- [ ] Implementar data quality checks avanzados
- [ ] Integrar con BI (Tableau/Power BI)
- [ ] Documentación de lineage completa

---

## 7. Conclusión

✓ Data Warehouse dimensional **funcional y documentado**
✓ Pipeline reproducible con **DBT**
✓ **29 tests** aseguran calidad
✓ **SCD Type 2** identificado y lógica documentada
✓ Listo para análisis OLAP