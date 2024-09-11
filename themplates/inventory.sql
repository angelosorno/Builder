-- Crear base de datos si no existe (opcional)
CREATE DATABASE IF NOT EXISTS inventory;

-- Seleccionar la base de datos
USE inventory;

-- Tabla de ubicaciones con jerarquía y tipos de ubicación
CREATE TABLE IF NOT EXISTS act_ubicaciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    tipo_ubicacion ENUM('bodega', 'sub-bodega', 'oficina', 'otro') NOT NULL,
    padre_id BIGINT,
    direccion TEXT,
    FOREIGN KEY (padre_id) REFERENCES act_ubicaciones(id)
);

-- Tabla de terceros (responsables)
CREATE TABLE IF NOT EXISTS terceros (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    informacion_contacto TEXT
);

-- Tabla de usuarios corporativos
CREATE TABLE IF NOT EXISTS usuarios_corp (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de marcas con jerarquía
CREATE TABLE IF NOT EXISTS act_marcas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    tipo TEXT NOT NULL,
    padre_id BIGINT,
    FOREIGN KEY (padre_id) REFERENCES act_marcas(id)
);

-- Tabla de categorías con jerarquía
CREATE TABLE IF NOT EXISTS act_categorias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    tipo TEXT NOT NULL,
    padre_id BIGINT,
    FOREIGN KEY (padre_id) REFERENCES act_categorias(id)
);

-- Tabla de categorías para el CLA
CREATE TABLE IF NOT EXISTS act_cla_categorias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    tipo TEXT NOT NULL,
    padre_id BIGINT,
    FOREIGN KEY (padre_id) REFERENCES act_cla_categorias(id)
);

-- Tabla de anexos para almacenar información de archivos adjuntos
CREATE TABLE IF NOT EXISTS act_anexos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre_archivo TEXT NOT NULL,
    ruta_archivo TEXT NOT NULL,
    tipo TEXT NOT NULL,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    es_fotografia BOOLEAN DEFAULT FALSE,
    ruta_thumbnail TEXT,
    tipo_documento ENUM('Factura', 'Garantia', 'Orden de Compra', 'Intencion de Donacion', 'Documento de Importacion', 'Fotografia') NOT NULL
);

-- Tabla de áreas y líneas (asegúrate que esta tabla exista y esté correctamente definida)
CREATE TABLE IF NOT EXISTS estructura_organizacional (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL
);

-- Tabla de activos fijos
CREATE TABLE IF NOT EXISTS act_inventarios_fijos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    fecha_compra DATE,
    fecha_vencimiento DATE,
    ubicacion_id BIGINT,
    responsable_id BIGINT,
    prestado BOOLEAN DEFAULT FALSE,
    es_prestable BOOLEAN DEFAULT FALSE,
    marca_id BIGINT,
    categoria_id BIGINT,
    valor_compra DECIMAL(12, 2),
    estado ENUM('Activo', 'Depreciado', 'Eliminado', 'Devuelto', 'Baja') DEFAULT 'Activo',
    importado BOOLEAN DEFAULT FALSE,
    origen VARCHAR(50) NOT NULL DEFAULT 'Compra',
    foto_principal_id BIGINT,
    nombre_generico TEXT,
    estado_salud ENUM('Buen estado', 'Mal estado', 'Regular') NOT NULL DEFAULT 'Buen estado',
    estructura_organizacional_id BIGINT,
    clasificacion ENUM('Activo Fijo', 'Elemento de Control') DEFAULT NULL,
    FOREIGN KEY (ubicacion_id) REFERENCES act_ubicaciones(id),
    FOREIGN KEY (responsable_id) REFERENCES terceros(id),
    FOREIGN KEY (marca_id) REFERENCES act_marcas(id),
    FOREIGN KEY (categoria_id) REFERENCES act_categorias(id),
    FOREIGN KEY (foto_principal_id) REFERENCES act_anexos(id),
    FOREIGN KEY (estructura_organizacional_id) REFERENCES estructura_organizacional(id)
);


-- Crear tabla de asignación de activos a trabajadores (terceros)
CREATE TABLE IF NOT EXISTS act_asignaciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL,
    tercero_id BIGINT NOT NULL,
    fecha_asignacion DATE NOT NULL,
    fecha_devolucion DATE,
    estado_entrega ENUM('Entrega incompleta', 'Entrega con avería', 'Entrega sin asepcia', 'Mantenimiento', 'Novedad', 'Dado de baja') DEFAULT 'Entrega incompleta',
    codigo_acta TEXT,
    observaciones TEXT,
    FOREIGN KEY (activo_id) REFERENCES act_inventarios_fijos(id),
    FOREIGN KEY (tercero_id) REFERENCES terceros(id)
);

-- Tabla de relación muchos a muchos entre activos y anexos
CREATE TABLE IF NOT EXISTS act_inventario_anexos (
    id_inventario_fijo BIGINT,
    id_anexo BIGINT,
    PRIMARY KEY (id_inventario_fijo, id_anexo),
    FOREIGN KEY (id_inventario_fijo) REFERENCES act_inventarios_fijos(id),
    FOREIGN KEY (id_anexo) REFERENCES act_anexos(id)
);

-- Crear tabla de categorías para el CLA y modificar la tabla de inventarios CLA
CREATE TABLE IF NOT EXISTS act_cla_inventarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    fecha_ingreso DATE,
    fecha_vencimiento DATE,
    ubicacion_id BIGINT,
    prestado BOOLEAN DEFAULT FALSE,
    es_prestable BOOLEAN DEFAULT FALSE,
    marca_id BIGINT,
    cla_categoria_id BIGINT,
    estado ENUM('Disponible', 'En Uso', 'Dañado') DEFAULT 'Disponible',
    usuario_id BIGINT,
    nombre_generico TEXT,
    FOREIGN KEY (ubicacion_id) REFERENCES act_ubicaciones(id),
    FOREIGN KEY (marca_id) REFERENCES act_marcas(id),
    FOREIGN KEY (cla_categoria_id) REFERENCES act_cla_categorias(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios_corp(id)
);

-- Tabla de historial de préstamos de activos
CREATE TABLE IF NOT EXISTS act_historial_prestamos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL,
    tercero_id BIGINT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    destino TEXT,
    estado_prestamo ENUM('Prestado', 'Devuelto', 'Perdido', 'Dañado') DEFAULT 'Prestado',
    observaciones TEXT,
    FOREIGN KEY (activo_id) REFERENCES act_inventarios_fijos(id),
    FOREIGN KEY (tercero_id) REFERENCES terceros(id)
);

-- Tabla de conjuntos de activos
CREATE TABLE IF NOT EXISTS act_conjuntos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    estado ENUM('Activo', 'Inactivo', 'Mantenimiento') DEFAULT 'Activo'
);

-- Relación entre conjuntos y activos
CREATE TABLE IF NOT EXISTS act_conjunto_activos (
    conjunto_id BIGINT,
    activo_id BIGINT,
    PRIMARY KEY (conjunto_id, activo_id),
    FOREIGN KEY (conjunto_id) REFERENCES act_conjuntos(id),
    FOREIGN KEY (activo_id) REFERENCES act_inventarios_fijos(id)
);

-- Tabla de productos (inventario de productos en bodega)
CREATE TABLE IF NOT EXISTS act_productos (
    id_producto BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto TEXT NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2),
    stock_minimo INTEGER
);

-- Tabla de inventario con auditoría de movimientos
CREATE TABLE IF NOT EXISTS act_inventario (
    id_inventario BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_producto BIGINT NOT NULL,
    id_bodega BIGINT NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha_ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES act_productos(id_producto),
    FOREIGN KEY (id_bodega) REFERENCES act_ubicaciones(id)
);

-- Registro de movimientos de inventario (entradas y salidas)
CREATE TABLE IF NOT EXISTS act_inventario_movimientos (
    id_movimiento BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_producto BIGINT NOT NULL,
    id_bodega BIGINT NOT NULL,
    tipo_movimiento ENUM('entrada', 'salida') NOT NULL,
    cantidad INTEGER NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES act_productos(id_producto),
    FOREIGN KEY (id_bodega) REFERENCES act_ubicaciones(id)
);

-- Tabla de auditoría general de cambios
CREATE TABLE IF NOT EXISTS act_auditoria_cambios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tabla TEXT NOT NULL,
    operacion TEXT NOT NULL,
    registro_id BIGINT NOT NULL,
    usuario_id BIGINT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores TEXT,
    datos_nuevos TEXT
);

-- Tabla de proveedores de mantenimiento
CREATE TABLE IF NOT EXISTS proveedores (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    contacto TEXT,
    direccion TEXT
);

-- Tabla de mantenimientos para activos
CREATE TABLE IF NOT EXISTS act_mantenimientos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL,
    proveedor_id BIGINT NOT NULL,
    fecha_ultimo_mantenimiento DATE NOT NULL,
    fecha_siguiente_mantenimiento DATE,
    observaciones TEXT,
    FOREIGN KEY (activo_id) REFERENCES act_inventarios_fijos(id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Crear tabla para almacenar los accesorios de los activos
CREATE TABLE IF NOT EXISTS act_accesorios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT,
    nombre_accesorio TEXT NOT NULL,
    FOREIGN KEY (activo_id) REFERENCES act_inventarios_fijos(id)
);

-- Insertar las categorías base en la tabla act_categorias
INSERT INTO act_categorias (nombre, tipo, padre_id) VALUES
('Muebles y Enseres', 'Categoria', NULL),
('Equipo de Computo', 'Categoria', NULL),
('Maquinaria y Equipo', 'Categoria', NULL),
('Vehículos', 'Categoria', NULL),
('Equipo de Comunicación', 'Categoria', NULL);

-- Crear tabla para almacenar SMLV y UVT por año
CREATE TABLE IF NOT EXISTS uvts (
    year INT PRIMARY KEY,
    valor_smlv DECIMAL(12, 2) NOT NULL,
    valor_uvt DECIMAL(12, 2) NOT NULL
);