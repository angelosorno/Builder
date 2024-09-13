
# Gestión de Inventarios - SQL Schema y Funciones

Este repositorio contiene los scripts SQL necesarios para la creación y configuración del esquema de la base de datos, junto con triggers y funciones relacionados con la gestión de inventarios. Los scripts están organizados en dos archivos principales: `inventory.sql` y `functions.sql`.

## Tabla de Contenidos
- [Gestión de Inventarios - SQL Schema y Funciones](#gestión-de-inventarios---sql-schema-y-funciones)
  - [Tabla de Contenidos](#tabla-de-contenidos)
  - [Descripción General](#descripción-general)
  - [Requisitos](#requisitos)
  - [Instalación](#instalación)
    - [1. Configuración del Esquema de Inventario](#1-configuración-del-esquema-de-inventario)
    - [2. Creación de Funciones y Triggers](#2-creación-de-funciones-y-triggers)
  - [Detalles del Script](#detalles-del-script)
    - [1. inventory.sql](#1-inventorysql)
    - [2. functions.sql](#2-functionssql)
  - [Explicación de las Tablas](#explicación-de-las-tablas)
    - [1. act\_ubicaciones](#1-act_ubicaciones)
    - [2. terceros](#2-terceros)
    - [3. usuarios\_corp](#3-usuarios_corp)
    - [4. act\_marcas](#4-act_marcas)
    - [5. act\_categorias](#5-act_categorias)
    - [6. act\_activosfijos](#6-act_activosfijos)
    - [7. act\_historial\_prestamos](#7-act_historial_prestamos)
    - [8. estructura\_organizacional](#8-estructura_organizacional)
    - [Otras Tablas](#otras-tablas)
  - [Vistas y Funciones Incluidas](#vistas-y-funciones-incluidas)
    - [Vistas](#vistas)
    - [Funciones y Triggers](#funciones-y-triggers)
  - [Consideraciones Finales](#consideraciones-finales)

## Descripción General
Este sistema está diseñado para gestionar inventarios de activos, permitiendo la asignación de ubicaciones, responsables, y gestión de préstamos, junto con una auditoría de cambios. Se incluyen tablas para manejar información jerárquica de ubicaciones, marcas, categorías, así como también anexos y auditorías para el control de cambios.

## Requisitos
Para ejecutar estos scripts SQL, necesitarás:
- MySQL 5.7+ o MariaDB.
- Privilegios suficientes para crear y modificar bases de datos, funciones y triggers.
- Un servidor MySQL o MariaDB configurado y operativo.

## Instalación

### 1. Configuración del Esquema de Inventario

1. Abre el archivo `inventory.sql` y ejecútalo en tu base de datos MySQL.
   
2. Este archivo:
   - Crea la base de datos `inventory` si no existe.
   - Define las tablas para gestionar ubicaciones, activos fijos, responsables (terceros), usuarios corporativos, marcas, categorías, anexos y más.
   - Incluye relaciones jerárquicas entre ubicaciones, marcas y categorías.

Para ejecutar el archivo `inventory.sql` desde la línea de comandos de MySQL, usa:

```bash
mysql -u usuario -p < inventory.sql
```

### 2. Creación de Funciones y Triggers

A continuación, ejecuta el archivo `functions.sql` para agregar funciones y triggers que automatizan el comportamiento del sistema.

Este archivo:
- Implementa la función `calcular_clasificacion` para clasificar los activos como "Activo Fijo" o "Elemento de Control" según su valor y el salario mínimo vigente.
- Crea triggers para clasificar activos automáticamente al insertarlos o actualizarlos.
- Implementa triggers de auditoría para cambios y eliminaciones en el inventario de CLA.
- Define triggers para gestionar los préstamos de activos y evitar duplicados.

Para ejecutar el archivo `functions.sql`:

```bash
mysql -u usuario -p < functions.sql
```

## Detalles del Script

### 1. inventory.sql
Este archivo contiene la definición de todas las tablas necesarias para la gestión del inventario. Las tablas están relacionadas jerárquicamente y con múltiples dependencias para garantizar una gestión integral de los activos.

### 2. functions.sql
Este archivo contiene la lógica de negocio aplicada a los activos, así como funciones y triggers clave:

- `calcular_clasificacion`: Función que clasifica un activo basándose en su valor y el salario mínimo vigente en el año de su compra.
- `clasificar_activo_insert/update`: Triggers que aplican la clasificación automática en las operaciones de inserción y actualización de activos.
- `trg_prestamo_nuevo / trg_prestamo_actualizar`: Gestionan el estado prestado de los activos cuando se registran préstamos o devoluciones.
- `act_auditar_cambios_cla / act_auditar_borrado_cla`: Triggers de auditoría que registran cualquier cambio o eliminación en el inventario CLA.

## Explicación de las Tablas

### 1. act_ubicaciones
Esta tabla almacena las ubicaciones jerárquicas donde se encuentran los activos. Cada ubicación tiene un `tipo_ubicacion` (bodega, oficina, etc.) y puede tener un `padre_id` para crear relaciones jerárquicas.

**Campos principales:**
- `id`: Identificador único de la ubicación.
- `nombre`: Nombre de la ubicación.
- `tipo_ubicacion`: Define el tipo de ubicación (bodega, oficina, etc.).
- `padre_id`: Referencia a otra ubicación, formando una jerarquía de ubicaciones.

### 2. terceros
Almacena información sobre los responsables o terceras personas asociadas con los activos.

**Campos principales:**
- `id`: Identificador único del tercero.
- `nombre`: Nombre del tercero.
- `informacion_contacto`: Información de contacto del tercero.

### 3. usuarios_corp
Registra a los usuarios corporativos que pueden interactuar con el sistema, incluyendo la fecha de creación.

**Campos principales:**
- `id`: Identificador único del usuario.
- `nombre`: Nombre del usuario corporativo.
- `email`: Correo electrónico único del usuario.

### 4. act_marcas
Almacena información sobre las marcas de los activos, con la posibilidad de crear jerarquías entre marcas.

**Campos principales:**
- `id`: Identificador único de la marca.
- `nombre`: Nombre de la marca.
- `padre_id`: Referencia a otra marca, permitiendo jerarquías.

### 5. act_categorias
Define categorías de activos, con la posibilidad de crear relaciones jerárquicas.

**Campos principales:**
- `id`: Identificador único de la categoría.
- `nombre`: Nombre de la categoría.
- `padre_id`: Referencia a otra categoría, permitiendo jerarquías.

### 6. act_activosfijos
Tabla central del inventario que almacena los activos fijos y sus características. Incluye referencias a la ubicación, responsable, marca, categoría, entre otros.

**Campos principales:**
- `id`: Identificador único del activo.
- `nombre`: Nombre del activo.
- `fecha_compra`: Fecha de compra del activo.
- `ubicacion_id`: Referencia a la ubicación del activo.
- `responsable_id`: Referencia al tercero responsable del activo.
- `clasificacion`: Clasificación automática del activo (Activo Fijo o Elemento de Control).

### 7. act_historial_prestamos
Registra el historial de préstamos de los activos, incluyendo fechas de préstamo y devolución, estado del préstamo y destino.

**Campos principales:**
- `id`: Identificador único del préstamo.
- `activo_id`: Referencia al activo prestado.
- `tercero_id`: Referencia al tercero que tiene el activo.
- `fecha_prestamo`: Fecha en la que se realizó el préstamo.
- `fecha_devolucion`: Fecha de devolución (si aplica).

### 8. estructura_organizacional
Esta tabla reemplaza a la anterior `area_linea` y define la estructura organizacional donde se encuentran los activos. Se usa para identificar áreas dentro de la organización.

**Campos principales:**
- `id`: Identificador único de la estructura organizacional.
- `nombre`: Nombre de la estructura o área.

### Otras Tablas
- `act_anexos`: Almacena información sobre archivos adjuntos relacionados con los activos (facturas, garantías, fotos, etc.).
- `act_cla_inventarios`: Gestiona el inventario de activos del CLA, con categorías especializadas.
- `act_auditoria_cambios`: Registra todos los cambios en los activos, con detalles sobre la operación realizada, el usuario que la realizó y los datos anteriores/nuevos.
- `act_productos`: Almacena productos que se manejan en bodega, con auditoría de movimientos de inventario.
- `tercero_juridico`: Almacena los proveedores de mantenimiento asociados a los activos.
- `act_mantenimientos`: Registra las actividades de mantenimiento de los activos, incluyendo fechas y observaciones.

## Vistas y Funciones Incluidas

### Vistas
- `activos_prestables`: Muestra todos los activos que son prestables y no están prestados actualmente.

### Funciones y Triggers
- Implementación de triggers y funciones para automatización de clasificación, auditoría y gestión de préstamos.

## Consideraciones Finales
Este sistema de gestión de inventarios de activos es ideal para empresas que requieren llevar un control exhaustivo de sus activos fijos, préstamos y auditoría de movimientos.
