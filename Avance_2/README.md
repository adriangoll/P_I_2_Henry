# Avance 2-3: Modelado Dimensional con DBT + KPIs

## Objetivo
Transformar datos staging (Avance 1) a star schema dimensional con DBT + análisis.

## Deliverables

**Avance 2:**
✓ Star Schema: 2 hechos + 5 dimensiones
✓ DBT: 20 modelos (9 staging + 4 intermediate + 7 marts)
✓ Tests: 29 data tests automáticos

**Avance 3:**
✓ 4 KPIs agregados (ventas diarias, top productos, segmentación clientes, performance categorías)
✓ SCD Type 2 logic documentada (dim_cliente, dim_producto)
✓ 2 Diagramas ER (transaccional + dimensional)
✓ Documentación completa

## Estructura

```
dbt_ecommerce/
├── models/
│   ├── staging/ (9 vistas)
│   ├── intermediate/ (4 vistas)
│   └── marts/ (7 tablas)
├── dbt_project.yml
├── profiles.yml
└── target/
```

## Ejecución

```bash
cd dbt_ecommerce
dbt run          # Crea todos los modelos
dbt test         # Ejecuta 29 tests
dbt docs generate # Documentación
```

## Modelos Marts

**Hechos:**
- `mart_hecho_ventas` (40k filas)
- `mart_hecho_pago` (0 filas)

**Dimensiones:**
- `mart_dim_cliente` (1,000 filas) - SCD Type 2
- `mart_dim_producto` (144 filas) - SCD Type 2
- `mart_dim_fecha` (3,651 filas)
- `mart_dim_ubicacion` (1,000 filas)
- `mart_dim_metodo_pago` (0 filas)

**KPIs (Avance 3):**
- `mart_kpi_ventas_diarias` (342 días)
- `mart_kpi_productos_top` (ranking)
- `mart_kpi_clientes_segmentacion` (Premium/Gold/Silver/Bronze)
- `mart_kpi_categorias_performance` (% ventas)

## Estado Tests

✓ 25 tests PASS
✗ 4 tests FAIL (datos incompletos en pagos)

## Diagramas

- `DIAGRAMA_ER_TRANSACCIONAL.png` - Modelo OLTP staging
- `DIAGRAMA_ER_DIMENSIONAL.png` - Star schema marts

## Documentación

- `AVANCE_3_DOCUMENTACION.md` - SCD Type 2, KPIs, arquitectura completa
- `schema.yml` - Modelos, columnas, tests

## Próximos Pasos (Futuro)
- Automatizar SCD Type 2 con Airflow
- Más KPIs (RFM, cohort analysis)
- Integración con BI