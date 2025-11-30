# Diccionario de Datos - Avance 1

## staging.usuarios
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| usuario_id | SERIAL PK | ID único del usuario | No |
| nombre | VARCHAR(255) | Nombre del usuario | Sí |
| apellido | VARCHAR(255) | Apellido del usuario | Sí |
| dni | VARCHAR(20) | DNI/ID documento | Sí |
| email | VARCHAR(255) UNIQUE | Email única | Sí |
| contrasena | VARCHAR(255) | Contraseña (hasheada) | Sí |

## staging.categorias
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| categoria_id | SERIAL PK | ID única categoría | No |
| nombre | VARCHAR(255) UNIQUE | Nombre categoría | Sí |
| descripcion | TEXT | Descripción detallada | Sí |

## staging.productos
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| producto_id | SERIAL PK | ID único producto | No |
| nombre | VARCHAR(255) | Nombre producto | Sí |
| descripcion | TEXT | Descripción detallada | Sí |
| precio | NUMERIC(10,2) | Precio unitario | Sí |
| stock | INTEGER | Cantidad en stock | Sí |
| categoria_id | INTEGER FK | Referencia categorias | Sí |

## staging.ordenes
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| orden_id | SERIAL PK | ID única orden | No |
| usuario_id | INTEGER FK | Referencia usuarios | Sí |
| fecha_orden | DATE | Fecha creación orden | Sí |
| total | NUMERIC(10,2) | Monto total orden | Sí |
| estado | VARCHAR(50) | Status: Completed/Pending/Cancelled | Sí |

## staging.detalle_ordenes
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| orden_id | INTEGER FK | Referencia ordenes | No |
| producto_id | INTEGER FK | Referencia productos | No |
| cantidad | INTEGER | Unidades vendidas | Sí |
| precio_unitario | NUMERIC(10,2) | Precio en momento compra | Sí |

## staging.direcciones_envio
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| usuario_id | INTEGER PK FK | Referencia usuarios | No |
| ciudad | VARCHAR(100) | Ciudad envío | Sí |
| provincia | VARCHAR(100) | Provincia/Estado | Sí |
| pais | VARCHAR(100) | País envío | Sí |
| codigo_postal | VARCHAR(20) | Código postal | Sí |
| estado | VARCHAR(100) | Provincia/Estado | Sí |
| distrito | VARCHAR(100) | Distrito | Sí |
| departamento | VARCHAR(20) | departamento | Sí |

## staging.carrito
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| carrito_id | SERIAL PK | ID carrito | No |
| usuario_id | INTEGER FK | Referencia usuarios | Sí |
| producto_id | INTEGER FK | Referencia productos | Sí |
| cantidad | INTEGER | Items en carrito | Sí |
| fecha_agregado | TIMESTAMP | Cuándo se agregó | Sí |

## staging.metodos_pago
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| metodo_id | SERIAL PK | ID método pago | No |
| nombre | VARCHAR(100) | Nombre: Visa, Efectivo, etc | Sí |
| descripcion | TEXT | Detalles método | Sí |

## staging.ordenes_metodospago
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| pago_id | SERIAL PK | ID pago | No |
| orden_id | INTEGER FK | Referencia ordenes | Sí |
| metodo_id | INTEGER FK | Referencia metodos_pago | Sí |
| monto_pagado | NUMERIC(10,2) | Monto procesado | Sí |

## staging.resenas_productos
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| resena_id | SERIAL PK | ID reseña | No |
| usuario_id | INTEGER FK | Referencia usuarios | Sí |
| producto_id | INTEGER FK | Referencia productos | Sí |
| calificacion | INTEGER | Rating 1-5 | Sí |
| comentario | TEXT | Comentario usuario | Sí |
| fecha | DATE | Fecha reseña | Sí |

## staging.historial_pagos
| Columna | Tipo | Descripción | Nulo |
|---------|------|-------------|------|
| historial_id | SERIAL PK | ID registro | No |
| orden_id | INTEGER FK | Referencia ordenes | Sí |
| metodo_id | INTEGER FK | Referencia metodos_pago | Sí |
| monto | NUMERIC(10,2) | Monto movimiento | Sí |
| fecha_pago | DATE | Cuándo se pagó | Sí |
| estado_pago | VARCHAR(50) | Status: Processed/Failed/Pending | Sí |

---

## Notas Importantes
- Todas las tablas están en schema `staging`
- Sin transformaciones aplicadas
- PKs generadas automáticamente (SERIAL)
- FKs sin constraints explícitos (validar en Avance 2)
- Tipos de datos preparados para próxima capa