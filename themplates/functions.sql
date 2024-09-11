-- Seleccionar la base de datos
USE inventory;

-- Drop triggers and function if they exist
DROP TRIGGER IF EXISTS clasificar_activo_insert;
DROP TRIGGER IF EXISTS clasificar_activo_update;
DROP TRIGGER IF EXISTS act_auditar_cambios_cla;
DROP TRIGGER IF EXISTS act_auditar_borrado_cla;
DROP TRIGGER IF EXISTS trg_prestamo_nuevo;
DROP TRIGGER IF EXISTS trg_prestamo_actualizar;
DROP TRIGGER IF EXISTS trg_prevent_duplicate_prestamo;

-- Drop the function if it exists
DROP FUNCTION IF EXISTS calcular_clasificacion;

-- Función para calcular clasificación de activos
DELIMITER $$

CREATE FUNCTION calcular_clasificacion(fecha_compra DATE, valor_compra DECIMAL(12, 2))
RETURNS ENUM('Activo Fijo', 'Elemento de Control')
BEGIN
    DECLARE year_compra INT;
    DECLARE smlv_year DECIMAL(12, 2);

    -- Extraer el año de la fecha de compra
    SET year_compra = YEAR(fecha_compra);

    -- Obtener el valor del SMLV para el año correspondiente
    SELECT valor_smlv INTO smlv_year FROM uvt_smlv WHERE year = year_compra;

    -- Clasificar el activo
    IF valor_compra >= (smlv_year * 10) THEN
        RETURN 'Activo Fijo';
    ELSE
        RETURN 'Elemento de Control';
    END IF;
END$$

DELIMITER ;

-- Trigger para clasificar automáticamente el activo al insertarlo o actualizarlo
DELIMITER $$

CREATE TRIGGER clasificar_activo_insert
BEFORE INSERT ON act_inventarios_fijos
FOR EACH ROW
    SET NEW.clasificacion = IF(
        NEW.valor_compra >= ((SELECT valor_smlv FROM uvt_smlv WHERE year = YEAR(NEW.fecha_compra)) * 10),
        'Activo Fijo',
        'Elemento de Control'
    );
$$

CREATE TRIGGER clasificar_activo_update
BEFORE UPDATE ON act_inventarios_fijos
FOR EACH ROW
    SET NEW.clasificacion = IF(
        NEW.valor_compra >= ((SELECT valor_smlv FROM uvt_smlv WHERE year = YEAR(NEW.fecha_compra)) * 10),
        'Activo Fijo',
        'Elemento de Control'
    );
$$

DELIMITER $$

-- Trigger para manejar la auditoría en inventarios CLA
CREATE TRIGGER act_auditar_cambios_cla
AFTER UPDATE ON act_cla_inventarios
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoria_cambios (tabla, operacion, registro_id, usuario_id, datos_anteriores, datos_nuevos)
    VALUES ('act_cla_inventarios', 'UPDATE', OLD.id, NEW.usuario_id, OLD.nombre, NEW.nombre);
END$$

DELIMITER $$

CREATE TRIGGER act_auditar_borrado_cla
AFTER DELETE ON act_cla_inventarios
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoria_cambios (tabla, operacion, registro_id, usuario_id, datos_anteriores, datos_nuevos)
    VALUES ('act_cla_inventarios', 'DELETE', OLD.id, OLD.usuario_id, OLD.nombre, NULL);
END$$

DELIMITER $$

-- Vista de activos prestables
CREATE OR REPLACE VIEW activos_prestables AS
SELECT *
FROM act_inventarios_fijos
WHERE es_prestable = TRUE AND prestado = FALSE;

-- Vista de activos actualmente prestados
CREATE OR REPLACE VIEW activos_prestados AS
SELECT h.*, t.nombre AS nombre_tercero, a.nombre AS nombre_activo
FROM act_historial_prestamos h
JOIN terceros t ON h.tercero_id = t.id
JOIN act_inventarios_fijos a ON h.activo_id = a.id
WHERE h.fecha_devolucion IS NULL AND h.estado_prestamo = 'Prestado';

-- Trigger para registrar un nuevo préstamo
DELIMITER $$

CREATE TRIGGER trg_prestamo_nuevo
AFTER INSERT ON act_historial_prestamos
FOR EACH ROW
BEGIN
    IF NEW.estado_prestamo = 'Prestado' THEN
        UPDATE act_inventarios_fijos
        SET prestado = TRUE
        WHERE id = NEW.activo_id;
    END IF;
END$$

DELIMITER $$

-- Trigger para actualizar un préstamo cuando se devuelve un activo
CREATE TRIGGER trg_prestamo_actualizar
AFTER UPDATE ON act_historial_prestamos
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion IS NOT NULL AND NEW.estado_prestamo = 'Devuelto' THEN
        UPDATE act_inventarios_fijos
        SET prestado = FALSE
        WHERE id = NEW.activo_id;
    END IF;
END$$

DELIMITER $$

-- Trigger para evitar préstamos duplicados
CREATE TRIGGER trg_prevent_duplicate_prestamo
BEFORE INSERT ON act_historial_prestamos
FOR EACH ROW
BEGIN
    DECLARE activo_prestado BOOLEAN;
    SELECT prestado INTO activo_prestado FROM act_inventarios_fijos WHERE id = NEW.activo_id;
    IF activo_prestado = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El activo ya está prestado y no puede ser prestado nuevamente.';
    END IF;
END$$

DELIMITER $$

-- Consulta para obtener activos que no están asignados a ningún usuario
SELECT a.id, a.nombre
FROM act_inventarios_fijos a
LEFT JOIN act_asignaciones asign ON a.id = asign.activo_id AND asign.fecha_devolucion IS NULL
WHERE asign.id IS NULL;