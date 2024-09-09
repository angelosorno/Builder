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

-- Tabla de usuarios corporativos (preexistente)
CREATE TABLE IF NOT EXISTS usuarios_corp (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de anexos para almacenar información de archivos adjuntos
CREATE TABLE IF NOT EXISTS act_anexos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre_archivo TEXT NOT NULL,
    ruta_archivo TEXT NOT NULL,
    tipo TEXT NOT NULL,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    usuario_id BIGINT,
    placa TEXT UNIQUE,
    FOREIGN KEY (ubicacion_id) REFERENCES act_ubicaciones(id),
    FOREIGN KEY (responsable_id) REFERENCES terceros(id),
    FOREIGN KEY (marca_id) REFERENCES act_marcas(id),
    FOREIGN KEY (categoria_id) REFERENCES act_categorias(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios_corp(id)
);

-- Tabla de relación muchos a muchos entre activos y anexos
CREATE TABLE IF NOT EXISTS act_inventario_anexos (
    id_inventario_fijo BIGINT,
    id_anexo BIGINT,
    PRIMARY KEY (id_inventario_fijo, id_anexo),
    FOREIGN KEY (id_inventario_fijo) REFERENCES act_inventarios_fijos(id),
    FOREIGN KEY (id_anexo) REFERENCES act_anexos(id)
);

-- Tabla de inventarios rotativos (CLA) con auditoría y estados
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
    categoria_id BIGINT,
    estado ENUM('Disponible', 'En Uso', 'Dañado') DEFAULT 'Disponible',
    usuario_id BIGINT,
    FOREIGN KEY (ubicacion_id) REFERENCES act_ubicaciones(id),
    FOREIGN KEY (marca_id) REFERENCES act_marcas(id),
    FOREIGN KEY (categoria_id) REFERENCES act_categorias(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios_corp(id)
);

-- Tabla de historial de préstamos de activos
CREATE TABLE IF NOT EXISTS act_historial_prestamos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_activo BIGINT,
    nombre_prestatario TEXT NOT NULL,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    observacion TEXT,
    FOREIGN KEY (id_activo) REFERENCES act_inventarios_fijos(id)
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

-- Función de auditoría para inventarios rotativos (CLA)
DELIMITER $$

CREATE TRIGGER act_auditar_cambios_cla
AFTER UPDATE ON act_cla_inventarios
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoria_cambios (tabla, operacion, registro_id, usuario_id, datos_anteriores, datos_nuevos)
    VALUES ('act_cla_inventarios', 'UPDATE', OLD.id, NEW.usuario_id, OLD.nombre, NEW.nombre);
END$$

CREATE TRIGGER act_auditar_borrado_cla
AFTER DELETE ON act_cla_inventarios
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoria_cambios (tabla, operacion, registro_id, usuario_id, datos_anteriores, datos_nuevos)
    VALUES ('act_cla_inventarios', 'DELETE', OLD.id, OLD.usuario_id, OLD.nombre, NULL);
END$$

DELIMITER ;
