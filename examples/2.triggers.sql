-- Seleccionar la base de datos
USE appminub_colombia;

-- -------------------------
-- Eliminación de Triggers y Funciones si existen
-- -------------------------
DELIMITER $$

-- Eliminar triggers y funciones si existen
-- DROP TRIGGER IF EXISTS clasificar_activo_insert;
-- DROP TRIGGER IF EXISTS clasificar_activo_update;
-- DROP TRIGGER IF EXISTS act_auditar_cambios_cla;
-- DROP TRIGGER IF EXISTS act_auditar_borrado_cla;
-- DROP TRIGGER IF EXISTS trg_prestamo_nuevo;
-- DROP TRIGGER IF EXISTS trg_prestamo_actualizar;
-- DROP TRIGGER IF EXISTS trg_prevent_duplicate_prestamo;
-- DROP TRIGGER IF EXISTS actualizar_stock_producto;
-- DROP TRIGGER IF EXISTS trg_after_insert_compras;
-- DROP TRIGGER IF EXISTS trg_after_insert_devoluciones;
-- DROP TRIGGER IF EXISTS trg_after_insert_ajustesinventario;
-- DROP TRIGGER IF EXISTS trg_registrar_depreciacion_anual;
-- DROP TRIGGER IF EXISTS trg_before_insert_historial_prestamos;

-- Eliminar funciones si existen
-- DROP FUNCTION IF EXISTS calcular_clasificacion;
-- DROP FUNCTION IF EXISTS calcular_depreciacion_anual;

-- Función para calcular clasificación de activos
CREATE FUNCTION calcular_clasificacion(fecha_compra DATE, valor_compra DECIMAL(12, 2))
RETURNS VARCHAR(20)
BEGIN
    DECLARE year_compra INT;
    DECLARE smlv_year DECIMAL(12, 2);

    -- Extraer el año de la fecha de compra
    SET year_compra = YEAR(fecha_compra);

    -- Obtener el valor del SMLV para el año correspondiente
    SELECT valor_smlv INTO smlv_year FROM uvts WHERE year = year_compra;

    -- Clasificar el activo
    IF valor_compra >= (smlv_year * 10) THEN
        RETURN 'Activo Fijo';
    ELSE
        RETURN 'Elemento de Control';
    END IF;
END$$

-- Función para calcular la depreciación anual utilizando el método de línea recta
CREATE FUNCTION calcular_depreciacion_anual(activo_id BIGINT) RETURNS DECIMAL(12,2)
BEGIN
    DECLARE valor_compra DECIMAL(12,2);
    DECLARE vida_util_anios INT;
    DECLARE valor_residual_act DECIMAL(12,2);
    DECLARE depreciacion_anual DECIMAL(12,2);
    
    -- Obtener el valor de compra, vida útil y valor residual del activo
    SELECT valor_compra, vida_util, valor_residual INTO valor_compra, vida_util_anios, valor_residual_act
    FROM act_activosfijos
    WHERE id = activo_id;
    
    -- Calcular la depreciación anual
    SET depreciacion_anual = (valor_compra - valor_residual_act) / vida_util_anios;
    
    RETURN depreciacion_anual;
END$$

-- Trigger para clasificar automáticamente el activo al insertarlo
CREATE TRIGGER clasificar_activo_insert
BEFORE INSERT ON act_activosfijos
FOR EACH ROW
BEGIN
    SET NEW.clasificacion = calcular_clasificacion(NEW.fecha_compra, NEW.valor_compra);
END$$

-- Trigger para clasificar automáticamente el activo al actualizarlo
CREATE TRIGGER clasificar_activo_update
BEFORE UPDATE ON act_activosfijos
FOR EACH ROW
BEGIN
    SET NEW.clasificacion = calcular_clasificacion(NEW.fecha_compra, NEW.valor_compra);
END$$

-- Trigger para auditar cambios en act_cla_movimientos (actualización)
CREATE TRIGGER act_auditar_cambios_cla
AFTER UPDATE ON act_cla_movimientos
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoriacambios (
        tabla,
        operacion,
        registro_id,
        usuario_id,
        datos_anteriores,
        datos_nuevos
    )
    VALUES (
        'act_cla_movimientos',
        'UPDATE',
        OLD.id_movimiento,
        NULL, 
        CONCAT('Producto ID: ', OLD.id_producto, ', Bodega ID: ', OLD.id_bodega, ', Tipo Movimiento: ', OLD.tipo_movimiento, ', Cantidad: ', OLD.cantidad),
        CONCAT('Producto ID: ', NEW.id_producto, ', Bodega ID: ', NEW.id_bodega, ', Tipo Movimiento: ', NEW.tipo_movimiento, ', Cantidad: ', NEW.cantidad)
    );
END$$

-- Trigger para auditar borrados en act_cla_movimientos
CREATE TRIGGER act_auditar_borrado_cla
AFTER DELETE ON act_cla_movimientos
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoriacambios (
        tabla,
        operacion,
        registro_id,
        usuario_id,
        datos_anteriores,
        datos_nuevos
    )
    VALUES (
        'act_cla_movimientos',
        'DELETE',
        OLD.id_movimiento,
        NULL, 
        CONCAT('Producto ID: ', OLD.id_producto, ', Bodega ID: ', OLD.id_bodega, ', Tipo Movimiento: ', OLD.tipo_movimiento, ', Cantidad: ', OLD.cantidad),
        NULL
    );
END$$

-- Trigger para registrar un nuevo préstamo
CREATE TRIGGER trg_prestamo_nuevo
AFTER INSERT ON act_historial_prestamos
FOR EACH ROW
BEGIN
    IF NEW.estado_prestamo = 'Prestado' THEN
        UPDATE act_activosfijos
        SET prestado = TRUE
        WHERE id = NEW.activo_id;
    END IF;
END$$

-- Trigger para actualizar un préstamo cuando se devuelve un activo
CREATE TRIGGER trg_prestamo_actualizar
AFTER UPDATE ON act_historial_prestamos
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion IS NOT NULL AND NEW.estado_prestamo = 'Devuelto' THEN
        UPDATE act_activosfijos
        SET prestado = FALSE
        WHERE id = NEW.activo_id;
    END IF;
END$$

-- Trigger para evitar préstamos duplicados
CREATE TRIGGER trg_prevent_duplicate_prestamo
BEFORE INSERT ON act_historial_prestamos
FOR EACH ROW
BEGIN
    DECLARE activo_prestado BOOLEAN;
    SELECT prestado INTO activo_prestado FROM act_activosfijos WHERE id = NEW.activo_id;
    IF activo_prestado = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El activo ya está prestado y no puede ser prestado nuevamente.';
    END IF;
END$$

-- Trigger para auditar movimientos de inventario en el CLA
CREATE TRIGGER auditar_movimientos_inventario_cla
AFTER INSERT ON act_cla_movimientos
FOR EACH ROW
BEGIN
    INSERT INTO act_auditoriacambios (
        tabla,
        operacion,
        registro_id,
        usuario_id,
        datos_anteriores,
        datos_nuevos
    )
    VALUES (
        'act_cla_movimientos',
        'INSERT',
        NEW.id_movimiento,
        NULL,
        NULL,
        JSON_OBJECT('Producto ID', NEW.id_producto, 'Bodega ID', NEW.id_bodega, 'Tipo Movimiento', NEW.tipo_movimiento, 'Cantidad', NEW.cantidad)
    );
END$$

-- Trigger para actualizar el stock de productos en el CLA
CREATE TRIGGER actualizar_stock_producto
AFTER INSERT ON act_cla_movimientos
FOR EACH ROW
BEGIN
    IF NEW.tipo_movimiento = 'entrada' THEN
        UPDATE act_cla_productos
        SET stock_actual = stock_actual + NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    ELSEIF NEW.tipo_movimiento = 'salida' THEN
        UPDATE act_cla_productos
        SET stock_actual = stock_actual - NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    END IF;
END$$

-- Triggers para actualizar el stock después de compras, devoluciones y ajustes
CREATE TRIGGER trg_after_insert_compras
AFTER INSERT ON act_detalles_compras
FOR EACH ROW
BEGIN
    UPDATE act_cla_productos
    SET stock_actual = stock_actual + NEW.cantidad
    WHERE id_producto = NEW.producto_id;
END$$

CREATE TRIGGER trg_after_insert_devoluciones
AFTER INSERT ON act_devoluciones
FOR EACH ROW
BEGIN
    UPDATE act_cla_productos
    SET stock_actual = stock_actual + NEW.cantidad
    WHERE id_producto = (
        SELECT id_producto 
        FROM act_cla_movimientos 
        WHERE id_movimiento = NEW.movimiento_id
    );
END$$

CREATE TRIGGER trg_after_insert_ajustesinventario
AFTER INSERT ON act_cla_ajustesinventario
FOR EACH ROW
BEGIN
    IF NEW.tipo_ajuste = 'Incremento' THEN
        UPDATE act_cla_productos
        SET stock_actual = stock_actual + NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    ELSE
        UPDATE act_cla_productos
        SET stock_actual = stock_actual - NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    END IF;
END$$

-- Trigger para registrar depreciación anual automáticamente
CREATE TRIGGER trg_registrar_depreciacion_anual
AFTER UPDATE ON act_activosfijos
FOR EACH ROW
BEGIN
    IF YEAR(NEW.fecha_compra) < YEAR(CURDATE()) THEN
        -- Insertar un registro de depreciación
        INSERT INTO act_depreciacion (
            activo_id,
            fecha_depreciacion,
            valor_depreciado,
            valor_restante
        )
        VALUES (
            NEW.id,
            CURDATE(),
            calcular_depreciacion_anual(NEW.id),
            NEW.valor_compra - (calcular_depreciacion_anual(NEW.id) * (YEAR(CURDATE()) - YEAR(NEW.fecha_compra)))
        );
        
        -- Actualizar el estado del activo si es necesario
        IF (NEW.valor_compra - (calcular_depreciacion_anual(NEW.id) * (YEAR(CURDATE()) - YEAR(NEW.fecha_compra)))) <= NEW.valor_residual THEN
            UPDATE act_activosfijos
            SET estado = 'Depreciado'
            WHERE id = NEW.id;
        END IF;
    END IF;
END$$

-- Trigger para validar fechas de devoluciones en historial de préstamos
CREATE TRIGGER trg_before_insert_historial_prestamos
BEFORE INSERT ON act_historial_prestamos
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion < NEW.fecha_prestamo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de devolución no puede ser anterior a la fecha de préstamo.';
    END IF;
END$$

-- Restablecer el delimitador a punto y coma
DELIMITER ;

-- -------------------------
-- Creación de Vistas
-- -------------------------

-- Vista de activos prestables
CREATE OR REPLACE VIEW activos_prestables AS
SELECT *
FROM act_activosfijos
WHERE es_prestable = TRUE AND prestado = FALSE;

-- Vista de activos actualmente prestados
CREATE OR REPLACE VIEW activos_prestados AS
SELECT h.*, t.nombre AS nombre_tercero, a.nombre AS nombre_activo
FROM act_historial_prestamos h
JOIN terceros t ON h.tercero_id = t.id
JOIN act_activosfijos a ON h.activo_id = a.id
WHERE h.fecha_devolucion IS NULL AND h.estado_prestamo = 'Prestado';
