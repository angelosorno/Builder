-- DELETE ALERT - Eliminar la base de datos si ya existe
-- DROP DATABASE IF EXISTS appminub_colombia;

-- Crear base de datos si no existe (opcional)
CREATE DATABASE IF NOT EXISTS appminub_colombia;

-- Seleccionar la base de datos
USE appminub_colombia;

-- -------------------------
-- Creación de Tablas
-- -------------------------

-- Tabla de terceros (responsables) optimizada
CREATE TABLE IF NOT EXISTS terceros (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del tercero',
    informacion_contacto TEXT COMMENT 'Información de contacto del tercero'
) ENGINE=InnoDB COMMENT='Tabla que almacena información sobre terceros responsables';

-- Tabla de proveedores de mantenimiento
CREATE TABLE IF NOT EXISTS tercero_juridico (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del proveedor',
    contacto TEXT COMMENT 'Información de contacto del proveedor',
    direccion TEXT COMMENT 'Dirección del proveedor'
) ENGINE=InnoDB COMMENT='Tabla que almacena proveedores de mantenimiento';

-- Tabla de usuarios corporativos
CREATE TABLE IF NOT EXISTS usuarios_corp (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del usuario corporativo',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Correo electrónico único del usuario',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del usuario'
) ENGINE=InnoDB COMMENT='Tabla que almacena usuarios corporativos';

-- Crear tabla para almacenar SMLV y UVT por año
CREATE TABLE IF NOT EXISTS uvts (
    year INT PRIMARY KEY COMMENT 'Año',
    valor_smlv DECIMAL(12, 2) NOT NULL COMMENT 'Valor del SMLV para el año',
    valor_uvt DECIMAL(12, 2) NOT NULL COMMENT 'Valor de la UVT para el año'
) ENGINE=InnoDB COMMENT='Tabla que almacena los valores de SMLV y UVT por año';

-- Tabla de áreas y líneas
CREATE TABLE IF NOT EXISTS estructura_organizacional (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la estructura organizacional'
) ENGINE=InnoDB COMMENT='Tabla que define la estructura organizacional de la empresa';

-- Tabla de ubicaciones (agregada para resolver el error de clave foránea)
CREATE TABLE IF NOT EXISTS act_ubicaciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la ubicación',
    descripcion TEXT COMMENT 'Descripción de la ubicación',
    direccion VARCHAR(500) COMMENT 'Dirección de la ubicación'
) ENGINE=InnoDB COMMENT='Tabla que almacena las ubicaciones de los activos';

-- Tabla de marcas con jerarquía
CREATE TABLE IF NOT EXISTS act_marcas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la marca',
    tipo VARCHAR(100) NOT NULL COMMENT 'Tipo de marca',
    padre_id BIGINT COMMENT 'Referencia a la marca padre para jerarquía',
    FOREIGN KEY (padre_id) REFERENCES act_marcas(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Tabla que almacena las marcas de los activos con jerarquía';

-- Tabla de categorías con jerarquía
CREATE TABLE IF NOT EXISTS act_categorias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la categoría',
    tipo VARCHAR(100) NOT NULL COMMENT 'Tipo de categoría',
    padre_id BIGINT COMMENT 'Referencia a la categoría padre para jerarquía',
    FOREIGN KEY (padre_id) REFERENCES act_categorias(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Tabla que almacena las categorías de los activos con jerarquía';

-- Tabla de categorías para el CLA
CREATE TABLE IF NOT EXISTS act_cla_categorias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre de la categoría del CLA',
    tipo VARCHAR(100) NOT NULL COMMENT 'Tipo de categoría del CLA',
    padre_id BIGINT COMMENT 'Referencia a la categoría padre para jerarquía',
    FOREIGN KEY (padre_id) REFERENCES act_cla_categorias(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Tabla que almacena las categorías especializadas del CLA con jerarquía';

-- Tabla de anexos para almacenar información de archivos adjuntos
CREATE TABLE IF NOT EXISTS act_anexos_documentos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre_archivo VARCHAR(255) NOT NULL COMMENT 'Nombre del archivo',
    ruta_archivo VARCHAR(500) NOT NULL COMMENT 'Ruta del archivo en el sistema',
    tipo VARCHAR(100) NOT NULL COMMENT 'Tipo de archivo',
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de subida del archivo',
    es_fotografia BOOLEAN DEFAULT FALSE COMMENT 'Indica si el archivo es una fotografía',
    ruta_thumbnail VARCHAR(500) COMMENT 'Ruta del thumbnail (si aplica)',
    tipo_documento ENUM('Factura', 'Garantia', 'Orden de Compra', 'Intencion de Donacion', 'Documento de Importacion', 'Fotografia') NOT NULL COMMENT 'Tipo de documento adjunto'
) ENGINE=InnoDB COMMENT='Tabla que almacena anexos y documentos relacionados con los activos';

-- Tabla de activos fijos
CREATE TABLE IF NOT EXISTS act_activosfijos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del activo',
    descripcion TEXT COMMENT 'Descripción del activo',
    fecha_compra DATE COMMENT 'Fecha de compra del activo',
    fecha_vencimiento DATE COMMENT 'Fecha de vencimiento del activo',
    ubicacion_id BIGINT COMMENT 'Referencia a la ubicación del activo',
    responsable_id BIGINT COMMENT 'Referencia al tercero responsable del activo',
    prestado BOOLEAN DEFAULT FALSE COMMENT 'Indica si el activo está prestado',
    es_prestable BOOLEAN DEFAULT FALSE COMMENT 'Indica si el activo es prestable',
    marca_id BIGINT COMMENT 'Referencia a la marca del activo',
    categoria_id BIGINT COMMENT 'Referencia a la categoría del activo',
    valor_compra DECIMAL(12, 2) COMMENT 'Valor de compra del activo',
    estado ENUM('Activo', 'Depreciado', 'Eliminado', 'Devuelto', 'Baja') DEFAULT 'Activo' COMMENT 'Estado actual del activo',
    importado BOOLEAN DEFAULT FALSE COMMENT 'Indica si el activo fue importado',
    origen VARCHAR(50) NOT NULL DEFAULT 'Compra' COMMENT 'Origen del activo',
    foto_principal_id BIGINT COMMENT 'Referencia a la foto principal del activo',
    estado_salud ENUM('Buen estado', 'Mal estado', 'Regular') NOT NULL DEFAULT 'Buen estado' COMMENT 'Estado de salud del activo',
    estructura_organizacional_id BIGINT COMMENT 'Referencia a la estructura organizacional del activo',
    clasificacion ENUM('Activo Fijo', 'Elemento de Control') DEFAULT NULL COMMENT 'Clasificación del activo',
    placa VARCHAR(50) UNIQUE COMMENT 'Placa o identificación única del activo',
    vida_util INT NOT NULL DEFAULT 5 COMMENT 'Vida útil del activo en años',
    valor_residual DECIMAL(12, 2) NOT NULL DEFAULT 0.00 COMMENT 'Valor residual al final de la vida útil',
    FOREIGN KEY (ubicacion_id) REFERENCES act_ubicaciones(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (responsable_id) REFERENCES terceros(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (marca_id) REFERENCES act_marcas(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES act_categorias(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (foto_principal_id) REFERENCES act_anexos_documentos(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (estructura_organizacional_id) REFERENCES estructura_organizacional(id) ON DELETE SET NULL ON UPDATE CASCADE,
    -- Índices adicionales
    INDEX idx_fecha_compra (fecha_compra),
    INDEX idx_ubicacion_id (ubicacion_id),
    INDEX idx_responsable_id (responsable_id)
) ENGINE=InnoDB COMMENT='Tabla central que almacena los activos fijos de la empresa';

-- Tabla de compras
CREATE TABLE IF NOT EXISTS act_compras (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    proveedor_id BIGINT NOT NULL COMMENT 'ID del proveedor que realizó la compra',
    fecha_compra DATE NOT NULL COMMENT 'Fecha de la compra',
    total DECIMAL(12, 2) NOT NULL COMMENT 'Total de la compra',
    estado ENUM('Pendiente', 'Completada', 'Cancelada') DEFAULT 'Pendiente' COMMENT 'Estado de la compra',
    FOREIGN KEY (proveedor_id) REFERENCES tercero_juridico(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_compras_proveedor_id (proveedor_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena las compras realizadas';

-- Tabla de act_cla_productos optimizada con índices
CREATE TABLE IF NOT EXISTS act_cla_productos (
    id_producto BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(255) NOT NULL COMMENT 'Nombre del producto del CLA',
    descripcion TEXT COMMENT 'Descripción del producto',
    precio DECIMAL(10, 2) COMMENT 'Precio del producto',
    stock_minimo INTEGER COMMENT 'Stock mínimo requerido',
    stock_actual INTEGER COMMENT 'Stock actual disponible',
    unidad_medida ENUM('Unidad', 'Kilogramo', 'Litro', 'Caja', 'Metro') NOT NULL COMMENT 'Unidad de medida del producto',
    codigo_barra VARCHAR(50) COMMENT 'Código de barra del producto',
    peso DECIMAL(10, 2) COMMENT 'Peso del producto',
    volumen DECIMAL(10, 2) COMMENT 'Volumen del producto',
    estado ENUM('Disponible', 'Agotado', 'Descontinuado') DEFAULT 'Disponible' COMMENT 'Estado del producto',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del registro del producto',
    fecha_ultima_compra DATE COMMENT 'Fecha de la última compra del producto',
    marca_id BIGINT COMMENT 'Referencia a la marca del producto',
    proveedor_id BIGINT COMMENT 'Referencia al proveedor del producto',
    FOREIGN KEY (marca_id) REFERENCES act_marcas(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (proveedor_id) REFERENCES tercero_juridico(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_act_cla_productos_marca_id (marca_id),
    INDEX idx_act_cla_productos_proveedor_id (proveedor_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena los productos del CLA';

-- Registro de movimientos de inventarios en el CLA (entradas y salidas)
CREATE TABLE IF NOT EXISTS act_cla_movimientos (
    id_movimiento BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_producto BIGINT NOT NULL COMMENT 'ID del producto en el CLA',
    id_bodega BIGINT NOT NULL COMMENT 'ID de la bodega',
    tipo_movimiento ENUM('entrada', 'salida') NOT NULL COMMENT 'Tipo de movimiento de inventario',
    cantidad INTEGER NOT NULL COMMENT 'Cantidad movida',
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del movimiento',
    FOREIGN KEY (id_producto) REFERENCES act_cla_productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_bodega) REFERENCES act_ubicaciones(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_act_cla_movimientos_producto_id (id_producto),
    INDEX idx_act_cla_movimientos_bodega_id (id_bodega)
) ENGINE=InnoDB COMMENT='Tabla que registra los movimientos de inventario en el CLA (entradas y salidas)';

-- Tabla de detalles de compras
CREATE TABLE IF NOT EXISTS act_detalles_compras (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    compra_id BIGINT NOT NULL COMMENT 'ID de la compra a la que pertenece el detalle',
    producto_id BIGINT NOT NULL COMMENT 'ID del producto comprado',
    cantidad INTEGER NOT NULL COMMENT 'Cantidad comprada',
    precio_unitario DECIMAL(12, 2) NOT NULL COMMENT 'Precio unitario del producto',
    FOREIGN KEY (compra_id) REFERENCES  act_compras (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES act_cla_productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_detalles_compras_compra_id (compra_id),
    INDEX idx_detalles_compras_producto_id (producto_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena los detalles de cada compra';

-- Tabla de devoluciones
CREATE TABLE IF NOT EXISTS act_devoluciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    movimiento_id BIGINT NOT NULL COMMENT 'ID del movimiento de inventario al que se realiza la devolución',
    motivo TEXT COMMENT 'Motivo de la devolución',
    fecha_devolucion DATE NOT NULL COMMENT 'Fecha de la devolución',
    cantidad INTEGER NOT NULL COMMENT 'Cantidad devuelta',
    FOREIGN KEY (movimiento_id) REFERENCES act_cla_movimientos(id_movimiento) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_devoluciones_movimiento_id (movimiento_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena las devoluciones de movimientos de inventario';

-- Tabla de ajustes de inventario
CREATE TABLE IF NOT EXISTS act_cla_ajustesinventario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_producto BIGINT NOT NULL COMMENT 'ID del producto a ajustar',
    tipo_ajuste ENUM('Incremento', 'Decremento') NOT NULL COMMENT 'Tipo de ajuste de inventario',
    cantidad INTEGER NOT NULL COMMENT 'Cantidad ajustada',
    motivo TEXT COMMENT 'Motivo del ajuste',
    fecha_ajuste DATE NOT NULL COMMENT 'Fecha del ajuste',
    usuario_id BIGINT COMMENT 'ID del usuario que realizó el ajuste',
    FOREIGN KEY (id_producto) REFERENCES act_cla_productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios_corp(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_ajustesinventario_producto_id (id_producto),
    INDEX idx_ajustesinventario_usuario_id (usuario_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena los ajustes de inventario';

-- Tabla de depreciación
CREATE TABLE IF NOT EXISTS act_depreciacion (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL COMMENT 'ID del activo que se deprecia',
    fecha_depreciacion DATE NOT NULL COMMENT 'Fecha de la depreciación',
    valor_depreciado DECIMAL(12, 2) NOT NULL COMMENT 'Valor depreciado en este período',
    valor_restante DECIMAL(12, 2) NOT NULL COMMENT 'Valor restante del activo después de la depreciación',
    FOREIGN KEY (activo_id) REFERENCES act_activosfijos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_depreciacion_activo_id (activo_id)
) ENGINE=InnoDB COMMENT='Tabla que registra la depreciación anual de los activos';

-- Tabla de asignación de activos a trabajadores (terceros)
CREATE TABLE IF NOT EXISTS act_asignaciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL COMMENT 'ID del activo asignado',
    tercero_id BIGINT NOT NULL COMMENT 'ID del tercero al que se asigna el activo',
    fecha_asignacion DATE NOT NULL COMMENT 'Fecha de asignación del activo',
    fecha_devolucion DATE COMMENT 'Fecha de devolución del activo',
    estado_entrega ENUM('Entrega incompleta', 'Entrega con avería', 'Entrega sin aceptación', 'Mantenimiento', 'Novedad', 'Dado de baja') DEFAULT 'Entrega incompleta' COMMENT 'Estado de la entrega del activo',
    codigo_acta TEXT COMMENT 'Código del acta de entrega',
    observaciones TEXT COMMENT 'Observaciones adicionales sobre la asignación',
    FOREIGN KEY (activo_id) REFERENCES act_activosfijos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (tercero_id) REFERENCES terceros(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_act_asignaciones_activo_id (activo_id),
    INDEX idx_act_asignaciones_tercero_id (tercero_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena las asignaciones de activos a terceros';

-- Tabla de relación muchos a muchos entre activos y anexos
CREATE TABLE IF NOT EXISTS act_documento_relaciones (
    id_activo BIGINT NOT NULL,
    id_documento BIGINT NOT NULL,
    PRIMARY KEY (id_activo, id_documento),
    FOREIGN KEY (id_activo) REFERENCES act_activosfijos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_documento) REFERENCES act_anexos_documentos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_act_documento_relaciones_activo_id (id_activo),
    INDEX idx_act_documento_relaciones_documento_id (id_documento)
) ENGINE=InnoDB COMMENT='Tabla de relación muchos a muchos entre activos y documentos anexos';

-- Tabla de historial de préstamos de activos
CREATE TABLE IF NOT EXISTS act_historial_prestamos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL COMMENT 'ID del activo prestado',
    tercero_id BIGINT NOT NULL COMMENT 'ID del tercero que recibe el préstamo',
    fecha_prestamo DATE NOT NULL COMMENT 'Fecha de préstamo del activo',
    fecha_devolucion DATE COMMENT 'Fecha de devolución del activo',
    destino TEXT COMMENT 'Destino del préstamo',
    estado_prestamo ENUM('Prestado', 'Devuelto', 'Perdido', 'Dañado') DEFAULT 'Prestado' COMMENT 'Estado actual del préstamo',
    observaciones TEXT COMMENT 'Observaciones adicionales sobre el préstamo',
    FOREIGN KEY (activo_id) REFERENCES act_activosfijos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (tercero_id) REFERENCES terceros(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_act_historial_prestamos_activo_id (activo_id),
    INDEX idx_act_historial_prestamos_tercero_id (tercero_id)
) ENGINE=InnoDB COMMENT='Tabla que registra el historial de préstamos de activos';

-- Tabla de conjuntos de activos
CREATE TABLE IF NOT EXISTS act_conjuntos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL COMMENT 'Nombre del conjunto de activos',
    descripcion TEXT COMMENT 'Descripción del conjunto de activos',
    estado ENUM('Activo', 'Inactivo', 'Mantenimiento') DEFAULT 'Activo' COMMENT 'Estado actual del conjunto'
) ENGINE=InnoDB COMMENT='Tabla que almacena conjuntos de activos';

-- Relación entre conjuntos y activos
CREATE TABLE IF NOT EXISTS act_conjunto_activos (
    conjunto_id BIGINT NOT NULL,
    activo_id BIGINT NOT NULL,
    PRIMARY KEY (conjunto_id, activo_id),
    FOREIGN KEY (conjunto_id) REFERENCES act_conjuntos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (activo_id) REFERENCES act_activosfijos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_act_conjunto_activos_conjunto_id (conjunto_id),
    INDEX idx_act_conjunto_activos_activo_id (activo_id)
) ENGINE=InnoDB COMMENT='Tabla de relación muchos a muchos entre conjuntos y activos';

-- Tabla de auditoría general de cambios
CREATE TABLE IF NOT EXISTS act_auditoriacambios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tabla VARCHAR(255) NOT NULL COMMENT 'Nombre de la tabla donde ocurrió el cambio',
    operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL COMMENT 'Tipo de operación realizada',
    registro_id BIGINT NOT NULL COMMENT 'ID del registro afectado',
    usuario_id BIGINT COMMENT 'ID del usuario que realizó la operación',
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del cambio',
    datos_anteriores JSON COMMENT 'Datos anteriores al cambio',
    datos_nuevos JSON COMMENT 'Datos nuevos después del cambio',
    FOREIGN KEY (usuario_id) REFERENCES usuarios_corp(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Tabla de auditoría que registra todos los cambios en las tablas';

-- Tabla de mantenimientos para activos
CREATE TABLE IF NOT EXISTS act_mantenimientos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT NOT NULL COMMENT 'ID del activo a mantener',
    proveedor_id BIGINT NOT NULL COMMENT 'ID del proveedor que realiza el mantenimiento',
    fecha_ultimo_mantenimiento DATE NOT NULL COMMENT 'Fecha del último mantenimiento',
    fecha_siguiente_mantenimiento DATE COMMENT 'Fecha prevista para el siguiente mantenimiento',
    observaciones TEXT COMMENT 'Observaciones sobre el mantenimiento',
    FOREIGN KEY (activo_id) REFERENCES act_activosfijos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (proveedor_id) REFERENCES tercero_juridico(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_act_mantenimientos_activo_id (activo_id),
    INDEX idx_act_mantenimientos_proveedor_id (proveedor_id)
) ENGINE=InnoDB COMMENT='Tabla que registra los mantenimientos de los activos';

-- Crear tabla para almacenar los accesorios de los activos
CREATE TABLE IF NOT EXISTS act_accesorios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    activo_id BIGINT COMMENT 'ID del activo al que pertenece el accesorio',
    nombre_accesorio VARCHAR(255) NOT NULL COMMENT 'Nombre del accesorio',
    FOREIGN KEY (activo_id) REFERENCES act_activosfijos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_act_accesorios_activo_id (activo_id)
) ENGINE=InnoDB COMMENT='Tabla que almacena los accesorios de los activos';

-- Insertar las categorías base en la tabla act_categorias
INSERT INTO act_categorias (nombre, tipo, padre_id) VALUES
('Muebles y Enseres', 'Categoria', NULL),
('Equipo de Computo', 'Categoria', NULL),
('Maquinaria y Equipo', 'Categoria', NULL),
('Vehículos', 'Categoria', NULL),
('Equipo de Comunicación', 'Categoria', NULL);
