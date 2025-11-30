-- Crear esquema
DROP SCHEMA IF EXISTS staging CASCADE;
CREATE SCHEMA staging;

-----------------------------------------------------------
-- USUARIOS
-----------------------------------------------------------
CREATE TABLE staging.usuarios (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    dni VARCHAR(20),
    email VARCHAR(255),
    contrasena VARCHAR(255)
);

-----------------------------------------------------------
-- CATEGORIAS
-----------------------------------------------------------
CREATE TABLE staging.categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion TEXT
);

-----------------------------------------------------------
-- PRODUCTOS
-----------------------------------------------------------
CREATE TABLE staging.productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion TEXT,
    precio NUMERIC(10,2),
    stock INTEGER,
    categoria_id INTEGER
);

-----------------------------------------------------------
-- ORDENES
-----------------------------------------------------------
CREATE TABLE staging.ordenes (
    orden_id SERIAL PRIMARY KEY,
    usuario_id INTEGER,
    fecha_orden DATE,
    total NUMERIC(10,2),
    estado VARCHAR(50)
);

-----------------------------------------------------------
-- DETALLE ORDENES
-----------------------------------------------------------
CREATE TABLE staging.detalle_ordenes (
    orden_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER,
    precio_unitario NUMERIC(10,2)
);

-----------------------------------------------------------
-- DIRECCIONES ENVIO
-----------------------------------------------------------
CREATE TABLE staging.direcciones_envio (
    usuario_id INTEGER,
    calle VARCHAR(255),
    ciudad VARCHAR(100),
    departamento VARCHAR(100),
    provincia VARCHAR(100),
    estado VARCHAR(100),
    distrito VARCHAR(100),
    pais VARCHAR(100),
    codigo_postal VARCHAR(20)
);

-----------------------------------------------------------
-- CARRITO
-----------------------------------------------------------
CREATE TABLE staging.carrito (
    carrito_id SERIAL PRIMARY KEY,
    usuario_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER,
    fecha_agregado TIMESTAMP
);

-----------------------------------------------------------
-- METODOS DE PAGO
-----------------------------------------------------------
CREATE TABLE staging.metodos_pago (
    metodo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT
);

-----------------------------------------------------------
-- ORDENES - METODOS DE PAGO (PAGOS ASOCIADOS)
-----------------------------------------------------------
CREATE TABLE staging.ordenes_metodos_pago (
    pago_id SERIAL PRIMARY KEY,
    orden_id INTEGER,
    metodo_id INTEGER,
    monto_pagado NUMERIC(10,2)
);

-----------------------------------------------------------
-- RESENAS PRODUCTOS
-----------------------------------------------------------
CREATE TABLE staging.resenas_productos (
    resena_id SERIAL PRIMARY KEY,
    usuario_id INTEGER,
    producto_id INTEGER,
    calificacion INTEGER,
    comentario TEXT,
    fecha DATE
);

-----------------------------------------------------------
-- HISTORIAL PAGOS
-- Se adapta a tu CSV exacto
-----------------------------------------------------------
CREATE TABLE staging.historial_pagos (
    historial_id SERIAL PRIMARY KEY,
    orden_id INTEGER,
    metodo_id INTEGER,
    monto NUMERIC(10,2),
    fecha_pago DATE,
    estado_pago VARCHAR(50)
);
