-- =========================================
-- ESQUEMA SENCILLO + DATOS + 10 CONSULTAS
-- (MySQL/MariaDB - sin CHECK, sin variables)
-- =========================================

-- Crear y usar base (opcional si ya existe)
CREATE DATABASE alquiler_autos;
USE alquiler_autos;

-- Limpieza básica (por si re-ejecutas)
DROP TABLE IF EXISTS pagos;
DROP TABLE IF EXISTS alquileres;
DROP TABLE IF EXISTS vehiculos;
DROP TABLE IF EXISTS clientes;

-- Tablas
CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY,
  nombre     VARCHAR(100) NOT NULL,
  telefono   VARCHAR(30),
  email      VARCHAR(120),
  direccion  VARCHAR(150)
);

CREATE TABLE vehiculos (
  id_vehiculo INT PRIMARY KEY,
  marca       VARCHAR(60) NOT NULL,
  modelo      VARCHAR(60) NOT NULL,
  anio        INT NOT NULL,
  precio_dia  DECIMAL(10,2) NOT NULL
);

CREATE TABLE alquileres (
  id_alquiler  INT PRIMARY KEY,
  id_cliente   INT NOT NULL,
  id_vehiculo  INT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin    DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo)
);

CREATE TABLE pagos (
  id_pago     INT PRIMARY KEY,
  id_alquiler INT NOT NULL,
  monto       DECIMAL(10,2) NOT NULL,
  fecha_pago  DATE NOT NULL,
  FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler)
);

-- Datos de ejemplo
INSERT INTO clientes (id_cliente, nombre, telefono, email, direccion) VALUES
(1,'Juan Pérez','555-1234','juan@mail.com','Calle 123'),
(2,'Laura Gómez','555-5678','laura@mail.com','Calle 456'),
(3,'Carlos Sánchez','555-9101','carlos@mail.com','Calle 789');

INSERT INTO vehiculos (id_vehiculo, marca, modelo, anio, precio_dia) VALUES
(1,'Toyota','Corolla',2020,30.00),
(2,'Honda','Civic',2019,28.00),
(3,'Ford','Focus',2021,35.00);

INSERT INTO alquileres (id_alquiler, id_cliente, id_vehiculo, fecha_inicio, fecha_fin) VALUES
(1,1,2,'2025-03-10','2025-03-15'),
(2,2,1,'2025-03-12','2025-03-16'),
(3,3,3,'2025-03-20','2025-03-22');

INSERT INTO pagos (id_pago, id_alquiler, monto, fecha_pago) VALUES
(1,1,150.00,'2025-03-12'),
(2,2,112.00,'2025-03-13'),
(3,3,70.00,'2025-03-20');

-- =========================================
-- CONSULTAS (10)
-- =========================================

-- 1) Clientes con alquiler activo HOY
SELECT DISTINCT c.nombre, c.telefono, c.email
FROM clientes c
JOIN alquileres a ON a.id_cliente = c.id_cliente
WHERE CURDATE() BETWEEN a.fecha_inicio AND a.fecha_fin;

-- 2) Vehículos alquilados en marzo 2025
SELECT DISTINCT v.marca, v.modelo, v.precio_dia
FROM vehiculos v
JOIN alquileres a ON a.id_vehiculo = v.id_vehiculo
WHERE a.fecha_inicio <= '2025-03-31'
  AND a.fecha_fin   >= '2025-03-01';

-- 3) Precio total del alquiler por cliente (precio_día * días, inclusivo)
SELECT
  c.nombre,
  SUM(v.precio_dia * (DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1)) AS total_estimado
FROM clientes c
JOIN alquileres a ON a.id_cliente = c.id_cliente
JOIN vehiculos  v ON v.id_vehiculo = a.id_vehiculo
GROUP BY c.id_cliente, c.nombre
ORDER BY total_estimado DESC;

-- 4) Clientes que no han realizado ningún pago
SELECT c.nombre, c.email
FROM clientes c
LEFT JOIN alquileres a ON a.id_cliente = c.id_cliente
LEFT JOIN pagos p      ON p.id_alquiler = a.id_alquiler
GROUP BY c.id_cliente, c.nombre, c.email
HAVING COUNT(p.id_pago) = 0;

-- 5) Promedio de pagos por cliente
SELECT
  c.nombre,
  AVG(p.monto) AS promedio_pago
FROM clientes c
JOIN alquileres a ON a.id_cliente = c.id_cliente
JOIN pagos p      ON p.id_alquiler = a.id_alquiler
GROUP BY c.id_cliente, c.nombre
ORDER BY promedio_pago DESC;

-- 6) Vehículos disponibles el 2025-03-18 (cambia la fecha si quieres)
SELECT v.marca, v.modelo, v.precio_dia
FROM vehiculos v
LEFT JOIN alquileres a
  ON a.id_vehiculo = v.id_vehiculo
 AND '2025-03-18' BETWEEN a.fecha_inicio AND a.fecha_fin
WHERE a.id_alquiler IS NULL;

-- 7) Vehículos alquilados más de una vez en marzo 2025
SELECT v.marca, v.modelo, COUNT(*) AS veces
FROM vehiculos v
JOIN alquileres a ON a.id_vehiculo = v.id_vehiculo
WHERE a.fecha_inicio <= '2025-03-31'
  AND a.fecha_fin   >= '2025-03-01'
GROUP BY v.id_vehiculo, v.marca, v.modelo
HAVING COUNT(*) > 1
ORDER BY veces DESC;

-- 8) Total pagado por cada cliente
SELECT
  c.nombre,
  SUM(p.monto) AS total_pagado
FROM clientes c
JOIN alquileres a ON a.id_cliente = c.id_cliente
JOIN pagos p      ON p.id_alquiler = a.id_alquiler
GROUP BY c.id_cliente, c.nombre
ORDER BY total_pagado DESC;

-- 9) Clientes que alquilaron el Ford Focus (id_vehiculo = 3)
SELECT c.nombre, a.fecha_inicio AS fecha_alquiler
FROM clientes c
JOIN alquileres a ON a.id_cliente = c.id_cliente
WHERE a.id_vehiculo = 3
ORDER BY a.fecha_inicio;

-- 10) Total de días alquilados por cliente (desc)
SELECT
  c.nombre,
  SUM(DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1) AS dias_alquilados
FROM clientes c
JOIN alquileres a ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY dias_alquilados DESC, c.nombre ASC;
