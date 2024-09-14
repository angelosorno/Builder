
# 🗃️ **Gestión de Inventarios - SQL Schema y Funciones**

Este repositorio contiene los scripts SQL necesarios para la creación y configuración@ del esquema de la base de datos, junto con triggers, funciones y eventos relacionados con la **gestión de inventarios**. Los scripts están organizados en dos archivos principales: `setup.sql` (que reemplaza a los antiguos `inventory.sql` y `functions.sql`) y `triggers.sql`.

## 📑 **Tabla de Contenidos**

- [🗃️ **Gestión de Inventarios - SQL Schema y Funciones**](#️-gestión-de-inventarios---sql-schema-y-funciones)
  - [📑 **Tabla de Contenidos**](#-tabla-de-contenidos)
  - [📋 **Descripción General**](#-descripción-general)
  - [⚙️ **Requisitos**](#️-requisitos)
  - [🚀 **Instalación**](#-instalación)
    - [1. **Configuración del Esquema de Inventario**](#1-configuración-del-esquema-de-inventario)
    - [2. **Creación de Triggers y Funciones**](#2-creación-de-triggers-y-funciones)
  - [📜 **Detalles del Script**](#-detalles-del-script)
    - [1. **setup.sql**](#1-setupsql)
    - [2. **triggers.sql**](#2-triggerssql)
  - [🏛️ **Explicación de las Tablas**](#️-explicación-de-las-tablas)
    - [1. **act\_ubicaciones**](#1-act_ubicaciones)
    - [2. **terceros**](#2-terceros)
    - [3. **usuarios\_corp**](#3-usuarios_corp)
    - [4. **act\_marcas**](#4-act_marcas)
    - [5. **act\_categorias**](#5-act_categorias)
    - [6. **act\_activosfijos**](#6-act_activosfijos)
    - [7. **act\_historial\_prestamos**](#7-act_historial_prestamos)
    - [8. **estructura\_organizacional**](#8-estructura_organizacional)
  - [📚 **Otras Tablas**](#-otras-tablas)
  - [🛠️ **Vistas, Funciones y Triggers Incluidos**](#️-vistas-funciones-y-triggers-incluidos)
    - [**Vistas**](#vistas)
    - [**Funciones y Triggers**](#funciones-y-triggers)
  - [🏁 **Consideraciones Finales**](#-consideraciones-finales)

---

## 📋 **Descripción General**

Este sistema está diseñado para gestionar **inventarios de activos**, permitiendo la **asignación de ubicaciones**, responsables, y la gestión de **préstamos** junto con auditoría de cambios. Las tablas manejan información jerárquica de ubicaciones, marcas, categorías, así como también anexos y auditorías para el control de cambios.

## ⚙️ **Requisitos**

Para ejecutar estos scripts SQL, necesitarás:

- 🐬 **MySQL 5.7+** o **MariaDB**
- 🔐 **Privilegios suficientes** para crear y modificar bases de datos, funciones y triggers.
- 🖥️ Un **servidor MySQL o MariaDB** configurado y operativo.

## 🚀 **Instalación**

### 1. **Configuración del Esquema de Inventario**

Abre el archivo `setup.sql` y ejecútalo en tu base de datos MySQL. Este archivo:

- 📦 **Crea** la base de datos `appminub_colombia` si no existe.
- 🗂️ **Define** las tablas para gestionar ubicaciones, activos fijos, responsables, usuarios corporativos, marcas, categorías y más.
- 🏗️ **Incluye** relaciones jerárquicas entre ubicaciones, marcas y categorías.

Ejecuta el archivo `setup.sql` con el siguiente comando:

```bash
mysql -u usuario -p < setup.sql
```

### 2. **Creación de Triggers y Funciones**

Ejecuta el archivo `triggers.sql` para agregar funciones, triggers y eventos que automatizan el comportamiento del sistema. Este archivo:

- 🔧 Implementa la función `calcular_clasificacion` para **clasificar activos**.
- ⚙️ **Crea triggers** para clasificar activos automáticamente al insertarlos o actualizarlos.
- 🔍 **Define triggers de auditoría** para cambios y eliminaciones en el inventario del CLA.
- 📦 **Gestiona los préstamos de activos**, actualizaciones de stock y auditoría de movimientos de inventario.

Ejecuta el archivo `triggers.sql` con:

```bash
mysql -u usuario -p < triggers.sql
```

## 📜 **Detalles del Script**

### 1. **setup.sql**

Este archivo define todas las tablas necesarias para la gestión de inventarios. Las tablas están **relacionadas jerárquicamente** y con múltiples dependencias para garantizar una gestión integral de los activos.

### 2. **triggers.sql**

Este archivo contiene la **lógica de negocio** aplicada a los activos, incluyendo:

- 🧮 **calcular_clasificacion**: Clasifica un activo basándose en su valor y el salario mínimo vigente.
- 📥 **Triggers de clasificación**: Automatiza la clasificación en operaciones de inserción y actualización de activos.
- 🔄 **Triggers de préstamos**: Gestionan el estado prestado de los activos.
- 🔍 **Triggers de auditoría**: Registra cualquier cambio o eliminación en el inventario.
- 📅 **Event Scheduler**: Ejecuta automáticamente funciones de mantenimiento o auditoría.

## 🏛️ **Explicación de las Tablas**

### 1. **act_ubicaciones**
Almacena las ubicaciones jerárquicas donde se encuentran los activos. 

Campos principales:
- 🆔 `id`: Identificador único de la ubicación.
- 🏢 `nombre`: Nombre de la ubicación.

### 2. **terceros**
Almacena información sobre los responsables asociados con los activos.

Campos principales:
- 🆔 `id`: Identificador único del tercero.
- 👤 `nombre`: Nombre del tercero.

### 3. **usuarios_corp**
Registra a los **usuarios corporativos** que interactúan con el sistema.

Campos principales:
- 🆔 `id`: Identificador único del usuario.
- 📧 `email`: Correo electrónico del usuario.

### 4. **act_marcas**
Almacena información sobre las **marcas de los activos**.

Campos principales:
- 🆔 `id`: Identificador único de la marca.
- 🏷️ `nombre`: Nombre de la marca.

### 5. **act_categorias**
Define las **categorías de activos**, con relaciones jerárquicas.

Campos principales:
- 🆔 `id`: Identificador único de la categoría.
- 🏷️ `nombre`: Nombre de la categoría.

### 6. **act_activosfijos**
Tabla central del inventario que almacena los **activos fijos**.

### 7. **act_historial_prestamos**
Registra el **historial de préstamos** de los activos.

### 8. **estructura_organizacional**
Define la **estructura organizacional** donde se encuentran los activos.

## 📚 **Otras Tablas**

- `act_anexos_documentos`: Almacena información sobre archivos adjuntos relacionados con los activos.
- `act_cla_movimientos`: Gestiona los **movimientos de inventario** del CLA.
- `act_cla_ajustesinventario`: Registra todos los **ajustes de inventario**.

## 🛠️ **Vistas, Funciones y Triggers Incluidos**

### **Vistas**
- **activos_prestables**: Muestra todos los activos que son prestables y no están prestados actualmente.
- **activos_prestados**: Muestra todos los activos actualmente prestados, junto con la información del tercero y la fecha de préstamo.

### **Funciones y Triggers**
- **calcular_clasificacion**: Calcula la clasificación de un activo según su valor de compra y el salario mínimo.
- **clasificar_activo_insert/update**: Triggers que automatizan la clasificación de activos.
- **auditar_movimientos_inventario_cla**: Audita los cambios en la tabla de movimientos de inventario.

## 🏁 **Consideraciones Finales**

Este sistema es ideal para empresas que requieren llevar un **control exhaustivo de sus activos fijos**, préstamos y auditoría de movimientos. Los triggers, funciones y vistas incluidas permiten **automatizar muchos procesos**, mejorando la integridad de los datos y reduciendo la intervención manual.
