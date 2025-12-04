# Decisiones Técnicas - Proyecto Data Warehouse

## 1. Elección del Modelo Dimensional: Kimball vs Inmon

### Decisión: **KIMBALL**

**Justificación:**
- **Kimball (Star Schema):** Diseño centrado en hechos + dimensiones periféricas
- **Inmon (3NF):** Diseño normalizado, complejo, lento para consultas analíticas

**Por qué Kimball:**
1. **Performance**: Queries más rápidas (menos JOINs)
2. **Simplicidad**: Fácil de entender para analistas SQL
3. **Escalabilidad**: Soporta 40k+ filas sin degradación
4. **Negocio**: Preguntas orientadas a análisis (ventas, clientes, categorías)

**Trade-off:** Mayor redundancia de datos vs. velocidad de consulta (ganador: velocidad)

---

## 2. Granularidad de fact_sales

### Decisión: **LÍNEA DE ORDEN** (detalle_ordenes)

**Por qué no "Orden Completa":**
- Una orden puede tener múltiples productos
- Necesitamos análisis por producto (top vendidos)
- Responder "¿productos más vendidos?" requiere granularidad línea

**Estructura:**
```
Una orden = múltiples líneas
Orden_ID: 1
  ├─ Producto_ID: 10 | Cantidad: 2 | Monto: 100
  ├─ Producto_ID: 15 | Cantidad: 1 | Monto: 50
  └─ Total: 150

Hecho_Ventas tendrá 2 filas (una por producto)
```

**Implicación:** 10k órdenes × promedio 4 productos = 40k filas fact_sales ✓

---

## 3. Aplicación de SCD Type 2

### Decisión: **SCD Type 2 en dim_cliente + dim_producto**

**Por qué Type 2 (no Type 1 o 3):**

| SCD | Método | Uso |
|-----|--------|-----|
| Type 1 | Sobrescribir | ✗ Perderíamos histórico |
| **Type 2** | **Nuevo registro + fecha** | ✓ **Histórico completo** |
| Type 3 | Anterior + actual | ✗ Solo 1 cambio anterior |

**Campos SCD Type 2:**
```sql
fecha_inicio    -- Cuando inicia vigencia
fecha_fin       -- Cuando termina (9999-12-31 si vigente)
es_vigente      -- TRUE/FALSE
version         -- 1, 2, 3...
```

**Ejemplo dim_cliente:**
```
Cliente ID: 100 | Email: old@mail.com | Version: 1 | fecha_fin: 2024-06-15 | es_vigente: FALSE
Cliente ID: 100 | Email: new@mail.com | Version: 2 | fecha_fin: 9999-12-31 | es_vigente: TRUE
```

**Casos de Uso:**
- Análisis de retención (clientes que cambiaron email = riesgo)
- Tendencias de precios (productos que subieron/bajaron)
- Trazabilidad completa de cambios

---

## 4. Arquitectura de Capas DBT (Medallón)

### Decisión: **3 CAPAS**

```
Staging (9 modelos)
    ↓ Limpieza básica
Intermediate (4 modelos)
    ↓ Lógica negocio + JOINs
Marts (11 modelos: 7 dims + 2 hechos + 4 KPIs)
    ↓ Consumo Analytics
```

**Por qué 3 capas vs 2:**
- **2 capas:** Staging + Marts = lógica dispersa, difícil mantener
- **3 capas:** Separación clara, reutilización (int_cliente_completo)

**Responsabilidad por capa:**
- **Staging:** Raw → Validar + estandarizar
- **Intermediate:** Lógica de negocio + joins preparatorios
- **Marts:** Tablas finales para consumo (hechos + dimensiones)

---

## 5. Herramientas Seleccionadas

### DBT (vs Talend, Informatica, Python puro)

**Por qué DBT:**
1. **SQL-first**: Lenguaje que entienden analistas
2. **Modular**: Reutilizar transformaciones (ref)
3. **Tests automatizados**: Calidad garantizada
4. **Documentación autogenerada**: Bajo mantenimiento
5. **Open source**: Costo cero

**Alternativas rechazadas:**
- **Python puro**: Sin versionado de transformaciones
- **Talend**: Costo alto, overkill para este volumen
- **Airflow**: Orquestación, no transformación (complementario)

---

## 6. Decisiones de Modelado Dimensional

### Dimensiones Incluidas:
1. **dim_cliente** - Segmentación, análisis por tipo cliente
2. **dim_producto** - Top productos, margen por categoría
3. **dim_fecha** - Análisis temporal (mensual, trimestral, diario)
4. **dim_ubicacion** - Análisis geográfico (provincias)
5. **dim_metodo_pago** - Análisis de canales (actualmente vacío)

### Dimensiones No Incluidas:
- **dim_campaña_marketing**: No hay datos en CSVs
- **dim_canal_venta**: No diferenciado en data
- **dim_promocion**: No mencionado en fuentes

---

## 7. Decisiones de Data Quality

### Validaciones Implementadas (29 tests):
```
✓ NOT NULL: Campos obligatorios (cliente_id, producto_id)
✓ UNIQUE: PKs y campos únicos (email)
✓ RELATIONSHIPS: FKs sin huérfanos (TBD con constraints)
✓ ACCEPTED_VALUES: Rango esperado (cantidad 1-100)
```

### Datos Incompletos Tolerados:
- **hecho_pago**: Vacío (0 registros pagos)
  - Razón: CSVs staging tienen 0 pagos
  - Impacto: KPI pagos no disponible (WARN, no FAIL)

---

## 8. Decisiones de Performance

### Tablas en MARTS (no VISTAS):
- **Por qué:** 40k+ filas, queries frecuentes
- **Trade-off:** Redundancia de datos vs. velocidad

### Índices Recomendados (No Implementados):
```sql
CREATE INDEX idx_hecho_ventas_cliente ON marts_marts.mart_hecho_ventas(usuario_id);
CREATE INDEX idx_hecho_ventas_producto ON marts_marts.mart_hecho_ventas(producto_id);
CREATE INDEX idx_dim_cliente_email ON marts_marts.mart_dim_cliente(correo_electronico);
```

---

## 9. Justificación de KPIs

| KPI | Pregunta Negocio | Cálculo |
|-----|-----------------|---------|
| Ventas Diarias | Evolución ingresos | SUM(monto_neto) BY fecha |
| Top Productos | ¿Más vendidos? | RANK() BY cantidad |
| Segmentación Clientes | ¿Premium vs Bronze? | CASE WHEN gasto > 10k THEN Premium |
| Performance Categorías | ¿Margen por categoría? | % SUM(ventas) BY categoria |

---

## 10. Limitaciones Conocidas

1. **SCD Type 2 No Automatizado**
   - Solución: Requerirá DAG Airflow + trigger SQL
   
2. **Sin Datos Pagos**
   - Impacto: No se puede analizar métodos pago
   - Solución: Completar CSVs ordenes_metodospago

3. **Sin Datos de Reseñas en Hechos**
   - Se cargaron pero no vinculadas a fact_sales
   - Mejora: Crear fact_reviews con SUM(calificacion)

---

## Conclusión

Decisiones tomadas maximizan **velocidad analítica** y **claridad para usuarios SQL** sobre normalización matemática. Star Schema + DBT + 3 capas = arquitectura robusta, escalable y mantenible.