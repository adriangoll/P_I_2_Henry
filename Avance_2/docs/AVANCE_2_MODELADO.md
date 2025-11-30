# Diseño Star Schema - Avance 2

## Objetivo
Transformar modelo transaccional (Avance 1) a modelo dimensional optimizado para análisis OLAP.

---

## TABLA DE HECHOS: hecho_ventas

### Definición
**Granularidad**: Línea de orden (cada producto en cada orden = 1 fila)

### Columnas
```sql
hecho_ventas (
  -- PKs/FKs
  id_hecho_venta       BIGINT PK,
  id_orden             INTEGER,
  id_producto          INTEGER,
  id_cliente           INTEGER FK dim_cliente,
  id_categoria         INTEGER FK dim_categoria,
  id_fecha             INTEGER FK dim_fecha,
  id_metodo_pago       INTEGER FK dim_metodo_pago,
  id_ubicacion         INTEGER FK dim_ubicacion,
  
  -- Medidas
  cantidad             INTEGER,
  precio_unitario      NUMERIC(10,2),
  monto_linea          NUMERIC(10,2),  -- cantidad * precio_unitario
  descuento            NUMERIC(10,2) DEFAULT 0,
  monto_neto           NUMERIC(10,2),  -- monto_linea - descuento
  
  -- Dimensiones degeneradas
  estado_orden         VARCHAR(50),
  estado_pago          VARCHAR(50),
  
  -- Auditoría
  fecha_carga          TIMESTAMP,
  fecha_actualizacion  TIMESTAMP
)
```

### Cálculos
- `monto_linea` = `cantidad` × `precio_unitario`
- `monto_neto` = `monto_linea` - `descuento`

---

## DIMENSIÓN: dim_cliente (SCD Type 2)

### Propósito
Análisis por cliente, compras recurrentes, segmentación.

### Columnas
```sql
dim_cliente (
  id_cliente           INTEGER PK,
  nombre_completo      VARCHAR(500),
  correo_electronico   VARCHAR(255),
  fecha_registro       DATE,
  pais                 VARCHAR(100),
  provincia            VARCHAR(100),
  ciudad               VARCHAR(100),
  
  -- SCD Type 2
  fecha_inicio         DATE,
  fecha_fin            DATE DEFAULT '9999-12-31',
  es_vigente           BOOLEAN DEFAULT TRUE,
  version              INTEGER DEFAULT 1,
  
  -- Auditoría
  fecha_carga          TIMESTAMP
)
```

### Cambios Tracked (SCD Type 2)
- Cambio de correo
- Cambio de dirección
- Cambio de estado (activo/inactivo)

---

## DIMENSIÓN: dim_producto (SCD Type 2)

### Propósito
Análisis por producto, performance, categoría.

### Columnas
```sql
dim_producto (
  id_producto          INTEGER PK,
  nombre_producto      VARCHAR(500),
  categoria            VARCHAR(255),
  precio_actual        NUMERIC(10,2),
  stock_actual         INTEGER,
  
  -- SCD Type 2
  fecha_inicio         DATE,
  fecha_fin            DATE DEFAULT '9999-12-31',
  es_vigente           BOOLEAN DEFAULT TRUE,
  version              INTEGER DEFAULT 1,
  
  -- Auditoría
  fecha_carga          TIMESTAMP
)
```

### Cambios Tracked (SCD Type 2)
- Cambio de precio
- Cambio de categoría
- Cambio de stock crítico

---

## DIMENSIÓN: dim_fecha

### Propósito
Análisis temporal: día semana, mes, trimestre, año.

### Columnas
```sql
dim_fecha (
  id_fecha             INTEGER PK,  -- YYYYMMDD
  fecha                DATE UNIQUE,
  dia_mes              INTEGER,
  mes                  INTEGER,
  trimestre            INTEGER,
  ano                  INTEGER,
  dia_semana_num       INTEGER,     -- 1=Lunes, 7=Domingo
  dia_semana_nombre    VARCHAR(20),
  es_feriado           BOOLEAN DEFAULT FALSE,
  semana_ano           INTEGER
)
```

### Cobertura
Calendario completo: 2020-2030 (~4,000 filas)

---

## DIMENSIÓN: dim_metodo_pago

### Propósito
Análisis por método de pago, adopción, mix pagos.

### Columnas
```sql
dim_metodo_pago (
  id_metodo_pago       INTEGER PK,
  nombre_metodo        VARCHAR(100),
  descripcion          VARCHAR(500),
  categoria            VARCHAR(50),  -- e.g., "Tarjeta", "Billetera", "Efectivo"
  es_activo            BOOLEAN DEFAULT TRUE,
  
  -- Auditoría
  fecha_carga          TIMESTAMP
)
```

---

## DIMENSIÓN: dim_ubicacion

### Propósito
Análisis geográfico: país, provincia, ciudad.

### Columnas
```sql
dim_ubicacion (
  id_ubicacion         INTEGER PK,
  pais                 VARCHAR(100),
  provincia            VARCHAR(100),
  ciudad               VARCHAR(100),
  region               VARCHAR(100),  -- Agrupamiento custom (Cuyo, NOA, etc)
  codigo_postal        VARCHAR(20),
  
  -- Auditoría
  fecha_carga          TIMESTAMP
)
```

---

## Diagrama Star Schema

```
                  dim_fecha
                     │
                     ├─────────────────┐
                     │                 │
  dim_cliente ──→ hecho_ventas    hecho_pago ←── dim_metodo_pago
                     │                 │
                     ├── dim_producto   │
                     │                 │
                     └── dim_ubicacion ┘
```

---

## Ventajas de este Diseño

✓ **Granularidad clara**: línea de orden = fila hecho
✓ **Medidas aditivas**: cantidad, monto (sumar directamente)
✓ **SCD Type 2**: historial completo de cambios
✓ **Denormalización controlada**: balance performance vs flexibilidad
✓ **Escalable**: soporta ~100M filas hecho

---

## Transformación Avance 1 → Avance 2

| Avance 1 (Staging) | Avance 2 (Marts) |
|------------------|-----------------|
| staging.usuarios | dim_cliente (con SCD) |
| staging.productos | dim_producto (con SCD) |
| staging.metodos_pago | dim_metodo_pago |
| staging.direcciones_envio | dim_ubicacion |
| staging.ordenes + staging.detalle_ordenes | hecho_ventas |
| (nueva) | dim_fecha |

---

## TABLA DE HECHOS 2: hecho_pago

### Definición
**Granularidad**: Pago por orden (cada método de pago en cada orden = 1 fila)

### Columnas
```sql
hecho_pago (
  -- PKs/FKs
  id_hecho_pago        BIGINT PK,
  id_orden             INTEGER,
  id_metodo_pago       INTEGER FK dim_metodo_pago,
  id_fecha             INTEGER FK dim_fecha,
  id_cliente           INTEGER FK dim_cliente,
  
  -- Medidas
  monto_pagado         NUMERIC(10,2),
  
  -- Dimensión degenerada
  estado_pago          VARCHAR(50),  -- Procesado, Pendiente, Fallido
  
  -- Auditoría
  fecha_carga          TIMESTAMP,
  fecha_actualizacion  TIMESTAMP
)
```

### Propósito
- Análisis de métodos de pago
- Performance por canal pago
- Estados de pagos fallidos
- Reconciliación financiera

---