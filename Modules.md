
# Resumen de Módulos y Funcionalidades 🚀

A continuación se detalla cada uno de los módulos del sistema de gestión de inventarios, junto con sus funcionalidades clave:

## 1. Módulo de Ubicaciones 🗺️
Este módulo gestiona la jerarquía de ubicaciones dentro de la organización. Estas ubicaciones pueden ser bodegas, oficinas, sub-bodegas, o cualquier otro tipo de ubicación relevante para el inventario.

**Funciones principales:**
- Gestión de ubicaciones jerárquicas.
- Crear, actualizar, eliminar ubicaciones.
- Asignar una ubicación a un activo.

## 2. Módulo de Responsables (Terceros) 👤
Este módulo gestiona la información de las personas o terceros responsables de los activos, como empleados o entidades externas que tienen activos asignados.

**Funciones principales:**
- Registro de responsables (terceros).
- Actualización de la información de contacto.
- Asignación de activos a responsables.

## 3. Módulo de Usuarios Corporativos 👥
Este módulo gestiona los usuarios corporativos que tienen acceso al sistema, con sus respectivos correos electrónicos y fecha de creación de cuentas.

**Funciones principales:**
- Registro de usuarios corporativos.
- Autenticación de usuarios para acceder al sistema.
- Gestión del correo y detalles de contacto de usuarios.

## 4. Módulo de Activos Fijos 🏢
Este es el módulo central del sistema, donde se gestionan los activos fijos de la organización. Cada activo tiene un conjunto de atributos, como su nombre, descripción, fecha de compra, responsable, ubicación, valor de compra, entre otros.

**Funciones principales:**
- Registro de activos fijos.
- Clasificación automática de activos en *"Activo Fijo"* o *"Elemento de Control"* según su valor y año de compra.
- Actualización de información de los activos.
- Control de inventarios, como la ubicación y estado de los activos.
- Auditoría de cambios en los activos.

## 5. Módulo de Marcas 🏷️
Este módulo gestiona las marcas de los activos, permitiendo crear una jerarquía de marcas según sea necesario.

**Funciones principales:**
- Registro y actualización de marcas de activos.
- Creación de relaciones jerárquicas entre marcas.

## 6. Módulo de Categorías de Activos 📦
Este módulo permite organizar los activos por categorías, como muebles, equipo de cómputo, vehículos, entre otros.

**Funciones principales:**
- Creación y actualización de categorías de activos.
- Clasificación jerárquica de categorías (categorías padre e hijo).
- Asignación de categorías a activos.

## 7. Módulo de Estructura Organizacional 🏛️
Este módulo gestiona la estructura interna de la organización, permitiendo que los activos se asignen a diferentes áreas o líneas dentro de la empresa.

**Funciones principales:**
- Registro de las áreas o divisiones dentro de la organización.
- Asignación de activos a áreas específicas.

## 8. Módulo de Gestión de Anexos 📎
Este módulo permite el almacenamiento y gestión de archivos relacionados con los activos, como facturas, órdenes de compra, fotos, documentos de garantía, etc.

**Funciones principales:**
- Subida y gestión de anexos para cada activo.
- Clasificación de los anexos por tipo (facturas, fotos, etc.).
- Visualización y descarga de documentos adjuntos.

## 9. Módulo de Gestión de Préstamos 🔄
Este módulo permite registrar y controlar el préstamo de activos a terceros, así como su devolución. También se realizan auditorías de préstamos.

**Funciones principales:**
- Registro de préstamos de activos.
- Control del estado del préstamo (prestado, devuelto, perdido).
- Actualización del estado de los activos prestados.
- Prevención de duplicados de préstamos.
- Visualización de activos actualmente prestados.

## 10. Módulo de Auditoría 📊
Este módulo implementa auditorías automáticas para registrar los cambios que se realizan sobre los activos y el inventario en general, proporcionando un historial detallado de cada operación.

**Funciones principales:**
- Registro de cambios realizados en los activos.
- Auditoría de operaciones de actualización y eliminación de activos del inventario.
- Mantener un historial de las operaciones con detalles de los datos anteriores y nuevos.

## 11. Módulo de Inventarios del CLA 📑
Este módulo gestiona el inventario específico del CLA (Centro de Logística Avanzada), permitiendo clasificar activos, gestionar auditorías y cambios de activos del CLA.

**Funciones principales:**
- Registro y clasificación de activos del CLA.
- Auditoría de cambios y eliminaciones en el inventario del CLA.
- Asignación de activos del CLA a categorías y usuarios específicos.

## 12. Módulo de Gestión de Productos en Bodega 🏗️
Este módulo controla el inventario de productos almacenados en bodega, permitiendo gestionar el stock y los movimientos de inventario (entradas y salidas).

**Funciones principales:**
- Gestión del inventario de productos en bodega.
- Registro de movimientos de productos (entradas y salidas).
- Auditoría de movimientos de inventario.
- Control de stock mínimo para evitar desabastecimiento.

## 13. Módulo de Mantenimientos 🛠️
Este módulo permite gestionar los mantenimientos de los activos, registrando las fechas de mantenimiento y programando los mantenimientos futuros.

**Funciones principales:**
- Registro de mantenimientos realizados a los activos.
- Planificación de mantenimientos futuros.
- Asignación de proveedores de mantenimiento.
- Registro de observaciones y fechas de mantenimiento.

## 14. Módulo de Gestión de Conjuntos de Activos 🔗
Este módulo permite agrupar varios activos en conjuntos, facilitando la gestión de activos relacionados entre sí.

**Funciones principales:**
- Creación de conjuntos de activos.
- Gestión del estado de los conjuntos (activo, inactivo, en mantenimiento).
- Asignación de activos a conjuntos.

## 15. Módulo de Proveedores 🛎️
Este módulo gestiona la información de los proveedores de mantenimiento, permitiendo asignarlos a activos específicos.

**Funciones principales:**
- Registro y gestión de proveedores de mantenimiento.
- Asignación de proveedores a los activos que reciben mantenimiento.

## 16. Módulo de Vistas y Consultas 👓
Este módulo define vistas preconfiguradas para facilitar la consulta del estado de los activos, préstamos y auditorías. Las vistas proporcionan una forma rápida de acceder a información relevante del inventario.

**Funciones principales:**
- Vista de activos prestables (disponibles para ser prestados).
- Vista de activos actualmente prestados.
- Consultas sobre activos no asignados a ningún responsable.
