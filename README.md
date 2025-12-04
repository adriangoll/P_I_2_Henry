# Data Warehouse E-Commerce - Proyecto Integrador

**Objetivo:** Construir un modelo de datos dimensional que integre múltiples fuentes CSV para facilitar análisis y reportes a nivel ejecutivo.

**Stack Tecnológico:** PostgreSQL • Docker • Python • DBT • SQL • Kimball Dimensional Modeling

---

## 📁 Estructura del Proyecto

```
P_I_2_Henry/
├── Avance_1/          # Carga y Exploración
├── Avance_2/          # Modelado Dimensional con DBT
└── README.md          # Este archivo
```

---

## 🎯 Avance 1: Carga y Exploración de Datos

**Objetivo:** Cargar 11 CSVs, validar integridad, realizar EDA inicial.

**Deliverables:**
- ✓ Docker Compose (PostgreSQL + PgAdmin)
- ✓ 55,068 registros en 11 tablas staging
- ✓ Notebook Jupyter con análisis exploratorio
- ✓ EDA con gráficos (top productos, métodos pago)
- ✓ 20 preguntas de negocio identificadas
- ✓ Diccionario de datos
- ✓ Diagrama ER transaccional

**Documentación:**
- `Avance_1/README.md`
- `Avance_1/docs/AVANCE_1_REPORTE.md`
- `Avance_1/docs/DICCIONARIO_DATOS.md`
- `Avance_1/docs/DIAGRAMA_ER.md`

**Setup:**
```bash
cd Avance_1/docker
docker-compose up -d
cd ../scripts
python loader.py
cd ../notebooks
jupyter lab  # Abrir 01_EDA_Exploracion.ipynb
```

---

## 🏗️ Avance 2-3: Modelado Dimensional + KPIs

**Objetivo:** Transformar datos staging a star schema dimensional con DBT, agregar KPIs y documentación técnica.

### Star Schema Dimensional

**Hechos (2):**
- `mart_hecho_ventas` (40,000 filas) - Granularidad: línea de orden
- `mart_hecho_pago` (0 filas) - Granularidad: pago por orden

**Dimensiones (5):**
- `mart_dim_cliente` (1,000 filas) - SCD Type 2
- `mart_dim_producto` (144 filas) - SCD Type 2
- `mart_dim_fecha` (3,651 filas) - Calendario 10 años
- `mart_dim_ubicacion` (1,000 filas)
- `mart_dim_metodo_pago` (0 filas)

**KPIs (4):**
- `mart_kpi_ventas_diarias`
- `mart_kpi_productos_top`
- `mart_kpi_clientes_segmentacion`
- `mart_kpi_categorias_performance`

### DBT Architecture

**3 Capas:**
```
Staging (9 modelos)
    ↓ Limpieza básica
Intermediate (4 modelos)
    ↓ Lógica negocio + JOINs
Marts (11 modelos: 2 hechos + 5 dims + 4 KPIs)
    ↓ Consumo Analytics
```

**Tests:** 29 automáticos (25 PASS, 4 FAIL por datos incompletos)

**Setup:**
```bash
cd Avance_2/dbt_ecommerce
dbt run                    # Compilar todos los modelos
dbt test                   # Ejecutar validaciones
dbt run --select staging   # Por capa
dbt docs generate         # Documentación autogenerada
```

### Documentación

- `Avance_2/README.md`
- `Avance_2/docs/AVANCE_2_MODELADO.md` - Star schema diseño
- `Avance_2/docs/AVANCE_3_DOCUMENTACION.md` - SCD Type 2, arquitectura
- `Avance_2/docs/DECISIONES_TECNICAS.md` - Justificación técnica (Kimball vs Inmon, Granularidad, SCD)
- `Avance_2/docs/DIAGRAMA_DIMENSIONAL.md` - Modelo visual documentado

### Consultas SQL - Preguntas de Negocio

9 consultas respondiendo:
1. Productos más vendidos por categoría
2. Clientes con mayor gasto
3. Rotación de productos
4. Evolución mensual de ingresos
5. Margen de ganancia por categoría
6. Concentración geográfica
7. Ticket promedio
8. % clientes recurrentes vs nuevos
9. Productos peor calificados

**Ubicación:** `Avance_2/sql/preguntas_negocio_respuestas.sql`

---

## 📊 Diagramas

**ER Transaccional (Avance 1):**
- Modelo OLTP con tablas staging normalizadas
- Archivo: `Avance_2/docs/screenshots/DIAGRAMA_ER_TRANSACCIONAL.png`

**ER Dimensional (Avance 2):**
- Star schema con hechos + dimensiones
- Archivo: `Avance_2/docs/screenshots/DIAGRAMA_ER_DIMENSIONAL.png`

---

## 🔍 Decisiones Técnicas Clave

### 1. Modelo Dimensional: Kimball
- **Por qué:** Performance, simplicidad, análisis OLAP
- **Trade-off:** Redundancia vs velocidad

### 2. Granularidad: Línea de Orden
- **Por qué:** Análisis por producto, responder "top vendidos"
- **Impacto:** 10k órdenes × 4 productos = 40k filas fact

### 3. SCD Type 2 en Cliente + Producto
- **Por qué:** Histórico completo de cambios
- **Implementación:** fecha_inicio, fecha_fin, es_vigente, version
- **Caso uso:** Análisis de retención, tendencia de precios

### 4. Arquitectura 3 Capas
- **Staging:** Raw → estandarizar
- **Intermediate:** Lógica negocio
- **Marts:** Tablas finales (consumo)

Ver: `Avance_2/docs/DECISIONES_TECNICAS.md`

---

## 📈 Estadísticas del Modelo

| Métrica | Valor |
|---------|-------|
| Registros Staging | 55,068 |
| Registros Hechos | 40,000 |
| Registros Dimensiones | ~5,500 |
| Modelos DBT | 20 |
| Tests Automáticos | 29 |
| Documentación .md | 8 archivos |
| Cobertura Temporal | 10 años |

---

## 🚀 Ejecución Rápida

```bash
# 1. Clonar repo
git clone https://github.com/tuusuario/P_I_2_Henry.git
cd P_I_2_Henry

# 2. Levantar Docker
cd Avance_1/docker
docker-compose up -d
cd ../..

# 3. Cargar datos
cd Avance_1/scripts
python loader.py
cd ../..

# 4. Transformar con DBT
cd Avance_2/dbt_ecommerce
dbt run
dbt test

# 5. Consultar (en DBeaver/pgAdmin)
SELECT * FROM marts_marts.mart_hecho_ventas LIMIT 10;
SELECT * FROM marts_marts.mart_kpi_ventas_diarias;
```

---

## 📋 Requerimientos.

| Criterio | Estado |
|----------|---------|
| Modelado Dimensional (Hechos/Dims/Granularidad) | ✓ |
| Aplicación SCD Type 2 | ✓ |
| Transformaciones DBT (3 capas + documentación)  | ✓ |
| KPIs & Consultas SQL (9 preguntas negocio) | ✓ |
| Presentación/Estructura | ✓ |


---

## ⚙️ Stack Tecnológico

- **Base de Datos:** PostgreSQL 15
- **Contenedorización:** Docker + Docker Compose
- **Transformación:** DBT 1.11.0
- **Python:** 3.9+ (Pandas, SQLAlchemy, Jupyter)
- **Control Versión:** Git/GitHub
- **Análisis:** SQL + Jupyter Notebooks
- **Diagramas:** dbdiagram.io

---

## 📚 Documentación Completa

1. **Avance 1:** `Avance_1/README.md`
2. **Avance 2-3:** `Avance_2/README.md`
3. **Modelado:** `Avance_2/docs/DIAGRAMA_DIMENSIONAL.md`
4. **Decisiones:** `Avance_2/docs/DECISIONES_TECNICAS.md`
5. **Consultas SQL:** `Avance_2/sql/preguntas_negocio_respuestas.sql`
6. **DER:** `Avance_2/docs/screenshots/DIAGRAMA_ER_*.png`

---

## 🤝 Autor

**Marcelo Adrian Sosa** | Data Engineer
- GitHub: github.com/tuusuario/P_I_2_Henry
- LinkedIn: linkedin.com/in/tuusuario

---

## 📅 Timeline

| Hito | Fecha | Estado |
|------|-------|--------|
| Avance 1 - Exploración | Nov 2024 | ✓ Completado |
| Avance 2 - DBT Inicial | Nov 2024 | ✓ Completado |
| Avance 3 - KPIs + Docs | Dic 2024 | ✓ Completado |

---

**Última actualización:** Diciembre 2024