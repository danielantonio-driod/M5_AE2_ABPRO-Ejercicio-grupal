# 📂 Proyecto: Plataforma de Alquiler de Automóviles

Este proyecto implementa una base de datos en **MySQL 8+ (InnoDB)** para gestionar clientes, vehículos, alquileres y pagos de un negocio de arriendo de autos.

El archivo [`alquiler_autos_mysql.sql`](./alquiler_autos_mysql.sql) incluye:

- Creación de la base de datos `alquiler_autos`
- Creación de las tablas: `clientes`, `vehiculos`, `alquileres`, `pagos`
- Inserción de datos de ejemplo
- Consultas SQL para responder a 10 requerimientos complejos

---

## 🛠 Requisitos

- MySQL 8.0+ (se recomienda, aunque es compatible con versiones más antiguas sin `CHECK`)
- Cliente de base de datos (HeidiSQL, Workbench, CLI)

---

## ▶️ Ejecución

1. Abrir tu cliente MySQL
2. Ejecutar el archivo:
   ```bash
   source alquiler_autos_mysql.sql;
