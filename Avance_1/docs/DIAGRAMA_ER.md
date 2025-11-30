# Diagrama ER - Modelo Transaccional Avance 1

## Relaciones Principales

```
┌─────────────────────────────────────────────────────────────┐
│                     USUARIOS                                │
├─────────────────────────────────────────────────────────────┤
│ PK: usuario_id (SERIAL)                                     │
│    nombre, apellido, dni, email, contraseña                │
└─────────────────────────────────────────────────────────────┘
         │
         ├──── 1:N ───→ ORDENES
         │              ├─ orden_id (PK)
         │              ├─ usuario_id (FK)
         │              ├─ fecha_orden
         │              ├─ total
         │              └─ estado
         │
         ├──── 1:N ───→ CARRITO
         │              ├─ carrito_id (PK)
         │              ├─ usuario_id (FK)
         │              ├─ producto_id (FK)
         │              ├─ cantidad
         │              └─ fecha_agregado
         │
         ├──── 1:N ───→ RESENAS_PRODUCTOS
         │              ├─ resena_id (PK)
         │              ├─ usuario_id (FK)
         │              ├─ producto_id (FK)
         │              ├─ calificacion
         │              ├─ comentario
         │              └─ fecha
         │
         └──── 1:1 ───→ DIRECCIONES_ENVIO
                        ├─ usuario_id (PK/FK)
                        ├─ ciudad
                        ├─ provincia
                        ├─ pais
                        └─ codigo_postal

┌─────────────────────────────────────────────────────────────┐
│                     CATEGORIAS                              │
├─────────────────────────────────────────────────────────────┤
│ PK: categoria_id (SERIAL)                                   │
│    nombre, descripcion                                      │
└─────────────────────────────────────────────────────────────┘
         │
         └──── 1:N ───→ PRODUCTOS
                        ├─ producto_id (PK)
                        ├─ nombre
                        ├─ descripcion
                        ├─ precio
                        ├─ stock
                        └─ categoria_id (FK)

┌─────────────────────────────────────────────────────────────┐
│                     PRODUCTOS                               │
├─────────────────────────────────────────────────────────────┤
│ PK: producto_id (SERIAL)                                    │
│    nombre, descripcion, precio, stock, categoria_id (FK)   │
└─────────────────────────────────────────────────────────────┘
         │
         └──── N:N ───→ DETALLE_ORDENES
                        ├─ orden_id (FK)
                        ├─ producto_id (FK)
                        ├─ cantidad
                        └─ precio_unitario

┌─────────────────────────────────────────────────────────────┐
│                     ORDENES                                 │
├─────────────────────────────────────────────────────────────┤
│ PK: orden_id (SERIAL)                                       │
│ FK: usuario_id                                              │
│    fecha_orden, total, estado                               │
└─────────────────────────────────────────────────────────────┘
         │
         ├──── 1:N ───→ DETALLE_ORDENES
         │              ├─ orden_id (FK)
         │              ├─ producto_id (FK)
         │              ├─ cantidad
         │              └─ precio_unitario
         │
         └──── 1:N ───→ ORDENES_METODOSPAGO
                        ├─ pago_id (PK)
                        ├─ orden_id (FK)
                        ├─ metodo_id (FK)
                        └─ monto_pagado

┌─────────────────────────────────────────────────────────────┐
│                    METODOS_PAGO                             │
├─────────────────────────────────────────────────────────────┤
│ PK: metodo_id (SERIAL)                                      │
│    nombre, descripcion                                      │
└─────────────────────────────────────────────────────────────┘
         │
         └──── 1:N ───→ ORDENES_METODOSPAGO
                        ├─ pago_id (PK)
                        ├─ orden_id (FK)
                        ├─ metodo_id (FK)
                        └─ monto_pagado

┌─────────────────────────────────────────────────────────────┐
│                  HISTORIAL_PAGOS                            │
├─────────────────────────────────────────────────────────────┤
│ PK: historial_id (SERIAL)                                   │
│ FK: orden_id, metodo_id                                     │
│    monto, fecha_pago, estado_pago                           │
└─────────────────────────────────────────────────────────────┘
```

## Cardinalidades

| Relación | Tipo | Descripción |
|----------|------|-------------|
| USUARIOS → ORDENES | 1:N | Un usuario múltiples órdenes |
| USUARIOS → CARRITO | 1:N | Un usuario múltiples items carrito |
| USUARIOS → DIRECCIONES | 1:1 | Una dirección por usuario |
| USUARIOS → RESEÑAS | 1:N | Un usuario múltiples reseñas |
| CATEGORIAS → PRODUCTOS | 1:N | Una categoría múltiples productos |
| PRODUCTOS → DETALLE_ORDENES | 1:N | Un producto en múltiples órdenes |
| ORDENES → DETALLE_ORDENES | 1:N | Una orden múltiples líneas |
| ORDENES → METODOSPAGO | N:M | Una orden múltiples métodos pago |
| METODOS_PAGO → ORDENES_METODOSPAGO | 1:N | Un método en múltiples pagos |

## Entidades Clave

### Entidad USUARIOS (1,000 registros)
- Centro del modelo
- Todas las transacciones asociadas a usuario
- Email único (identificador natural)

### Entidad ORDENES (10,000 registros)
- Hechos de negocio principal
- Vincula usuarios → productos
- Estados: Completed, Pending, Cancelled

### Entidad DETALLE_ORDENES (10,000 registros)
- Desglose de cada orden
- Múltiples productos por orden
- Grano: línea de orden

### Entidad ORDENES_METODOSPAGO (10,000 registros)
- Relación N:M explícita
- Una orden puede usar múltiples métodos
- Histórico de pagos

## Notas del Modelo Transaccional

✓ Diseño 3NF (normalizado)
✓ Sin redundancias
✓ Preparado para consultas OLTP

![Diagrama ER](../screenshots/DIAGRAMA_ER.png)

⚠ Próximo: Avance 2 transformará a star schema dimensional (OLAP)