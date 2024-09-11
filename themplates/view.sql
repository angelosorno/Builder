-- Seleccionar la base de datos
USE inventory;

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
