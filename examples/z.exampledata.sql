-- Seleccionar la base de datos
USE appminub_colombia;

-- -------------------------
-- Configuración Inicial
-- -------------------------

-- Desactivar temporalmente las verificaciones de claves foráneas para evitar conflictos durante la eliminación e inserción de datos
SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------
-- Eliminación de Datos Existentes
-- -------------------------

-- Eliminar datos en orden inverso de dependencias para evitar conflictos de claves foráneas
DELETE FROM act_cla_ajustesinventario;
DELETE FROM act_depreciacion;
DELETE FROM act_historial_prestamos;
DELETE FROM act_cla_ajustesinventario;
DELETE FROM act_devoluciones;
DELETE FROM act_auditoriacambios;
DELETE FROM act_detalles_compras;
DELETE FROM act_compras;
DELETE FROM act_cla_productos;
DELETE FROM act_anexos_documentos;
DELETE FROM usuarios_corp;
DELETE FROM terceros;
DELETE FROM tercero_juridico;
DELETE FROM act_ubicaciones;
DELETE FROM act_cla_categorias;
DELETE FROM act_categorias;
DELETE FROM act_marcas;
DELETE FROM estructura_organizacional;
DELETE FROM act_activosfijos;

-- Resetear AUTO_INCREMENT donde sea necesario
ALTER TABLE act_activosfijos AUTO_INCREMENT = 1;
ALTER TABLE act_cla_productos AUTO_INCREMENT = 1;
ALTER TABLE act_cla_ajustesinventario AUTO_INCREMENT = 1;
ALTER TABLE act_depreciacion AUTO_INCREMENT = 1;
ALTER TABLE act_historial_prestamos AUTO_INCREMENT = 1;
ALTER TABLE act_cla_ajustesinventario AUTO_INCREMENT = 1;
ALTER TABLE act_devoluciones AUTO_INCREMENT = 1;
ALTER TABLE act_cla_movimientos AUTO_INCREMENT = 1;
ALTER TABLE act_detalles_compras AUTO_INCREMENT = 1;
ALTER TABLE act_compras AUTO_INCREMENT = 1;
ALTER TABLE act_anexos_documentos AUTO_INCREMENT = 1;
ALTER TABLE usuarios_corp AUTO_INCREMENT = 1;
ALTER TABLE terceros AUTO_INCREMENT = 1;
ALTER TABLE tercero_juridico AUTO_INCREMENT = 1;
ALTER TABLE act_ubicaciones AUTO_INCREMENT = 1;
ALTER TABLE act_cla_categorias AUTO_INCREMENT = 1;
ALTER TABLE act_categorias AUTO_INCREMENT = 1;
ALTER TABLE act_marcas AUTO_INCREMENT = 1;
ALTER TABLE estructura_organizacional AUTO_INCREMENT = 1;

-- -------------------------
-- Inserción de Datos de Ejemplo
-- -------------------------

-- 1. Estructura Organizacional
INSERT INTO estructura_organizacional (id, nombre) VALUES
(1, 'Administración'),
(2, 'Recursos Humanos'),
(3, 'Tecnología de la Información'),
(4, 'Finanzas');

-- 2. Marcas
INSERT INTO act_marcas (id, nombre, tipo) VALUES
(1, 'Dell', 'Computo'),
(2, 'HP', 'Computo'),
(3, 'Samsung', 'Electrónica'),
(4, 'Toyota', 'Vehículos');

-- 3. Categorías
INSERT INTO act_categorias (id, nombre, tipo) VALUES
(1, 'Muebles y Enseres', 'Categoria'),
(2, 'Equipo de Computo', 'Categoria'),
(3, 'Maquinaria y Equipo', 'Categoria'),
(4, 'Vehículos', 'Categoria'),
(5, 'Equipo de Comunicación', 'Categoria');

-- 4. Categorías Especializadas del CLA
INSERT INTO act_cla_categorias (id, nombre, tipo) VALUES
(1, 'Software', 'Tipo'),
(2, 'Hardware', 'Tipo'),
(3, 'Redes', 'Tipo'),
(4, 'Impresoras', 'Tipo');

-- 5. Ubicaciones
INSERT INTO act_ubicaciones (id, nombre, descripcion, direccion) VALUES
(1, 'Oficina Central', 'Descripción de la oficina central', 'Calle Principal #123, Ciudad'),
(2, 'Bodega Principal', 'Descripción de la bodega principal', 'Avenida Secundaria #456, Ciudad'),
(3, 'Sucursal Norte', 'Descripción de la sucursal norte', 'Boulevard Norte #789, Ciudad');

-- 6. Proveedores de Mantenimiento (Tercero Jurídico)
INSERT INTO tercero_juridico (id, nombre, contacto, direccion) VALUES
(1, 'Proveedor XYZ S.A.', 'Contacto de XYZ', 'Dirección de XYZ'),
(2, 'Mantenimiento ABC Ltda.', 'Contacto de ABC', 'Dirección de ABC');

-- 7. Terceros
INSERT INTO terceros (id, nombre, informacion_contacto) VALUES
(1, 'Juan Pérez', 'Correo: juan.perez@example.com, Tel: 123456789'),
(2, 'María Gómez', 'Correo: maria.gomez@example.com, Tel: 987654321');

-- 8. Usuarios Corporativos
INSERT INTO usuarios_corp (id, nombre, email) VALUES
(1, 'Administrador', 'admin@example.com'),
(2, 'Usuario1', 'usuario1@example.com'),
(3, 'Usuario2', 'usuario2@example.com');

-- 9. Anexos y Documentos
INSERT INTO act_anexos_documentos (id, nombre_archivo, ruta_archivo, tipo, es_fotografia, tipo_documento) VALUES
(1, 'Factura_Laptop_Dell.pdf', '/path/to/Factura_Laptop_Dell.pdf', 'PDF', FALSE, 'Factura'),
(2, 'Garantia_Laptop_Dell.pdf', '/path/to/Garantia_Laptop_Dell.pdf', 'PDF', FALSE, 'Garantia'),
(3, 'Foto_Oficina_Central.jpg', '/path/to/Foto_Oficina_Central.jpg', 'JPEG', TRUE, 'Fotografia');

-- 10. Activos Fijos
INSERT INTO act_activosfijos (
    nombre, descripcion, fecha_compra, fecha_vencimiento, ubicacion_id, responsable_id,
    prestado, es_prestable, marca_id, categoria_id, valor_compra, estado, importado,
    origen, foto_principal_id, estado_salud, estructura_organizacional_id,
    clasificacion, placa, vida_util, valor_residual
) VALUES
('Laptop Dell', 'Laptop para uso corporativo', '2024-01-15', '2029-01-15', 1, 1,
FALSE, TRUE, 1, 2, 1500.00, 'Activo', FALSE,
'Compra', 1, 'Buen estado', 1,
'Activo Fijo', 'ABC123', 5, 300.00),
('Impresora HP', 'Impresora multifuncional', '2023-06-10', '2028-06-10', 2, 2,
FALSE, TRUE, 2, 4, 800.00, 'Activo', FALSE,
'Compra', 2, 'Buen estado', 2,
'Activo Fijo', 'DEF456', 5, 200.00),
('Router Cisco', 'Router para la red de la oficina', '2022-03-20', '2027-03-20', 3, 1,
FALSE, TRUE, NULL, 4, 500.00, 'Activo', FALSE,
'Compra', 3, 'Buen estado', 3,
'Elemento de Control', 'GHI789', 5, 100.00),
('Monitor Samsung', 'Monitor LED de 24 pulgadas', '2024-02-10', '2029-02-10', 1, 2,
FALSE, TRUE, 3, 5, 300.00, 'Activo', FALSE,
'Compra', 3, 'Buen estado', 1,
'Activo Fijo', 'JKL012', 5, 50.00);

-- 11. Productos del CLA
-- Nota: No incluimos la columna 'id' si no existe en la tabla. Permitimos que MySQL maneje el auto-incremento.
INSERT INTO act_cla_productos (
    nombre_producto, descripcion, precio, stock_minimo, stock_actual, unidad_medida,
    codigo_barra, peso, volumen, estado, fecha_creacion, fecha_ultima_compra,
    marca_id, proveedor_id
) VALUES
('Memoria RAM 16GB', 'Memoria RAM DDR4 de 16GB', 80.00, 10, 50, 'Unidad',
'1234567890123', 0.50, 0.05, 'Disponible', CURRENT_TIMESTAMP, '2024-01-20',
1, 1),
('Disco Duro SSD 512GB', 'Disco Duro SSD SATA de 512GB', 120.00, 5, 20, 'Unidad',
'1234567890124', 0.30, 0.03, 'Disponible', CURRENT_TIMESTAMP, '2024-01-22',
1, 1),
('Cables Ethernet Cat6', 'Cables de red Ethernet categoría 6', 10.00, 50, 200, 'Metro',
'1234567890125', 0.10, 0.02, 'Disponible', CURRENT_TIMESTAMP, '2024-01-25',
NULL, 2);

-- 12. Compras
INSERT INTO act_compras (id, proveedor_id, fecha_compra, total, estado) VALUES
(1, 1, '2024-01-20', 2000.00, 'Completada'),
(2, 2, '2024-02-15', 1500.00, 'Completada');

-- 13. Detalles de Compras
INSERT INTO act_detalles_compras (id, compra_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 20, 80.00),
(2, 1, 2, 10, 120.00),
(3, 2, 3, 100, 10.00);

-- 14. Movimientos de Inventario en el CLA
-- Nota: No incluimos la columna 'id' si no existe en la tabla.
INSERT INTO act_cla_movimientos (
    id_producto, id_bodega, tipo_movimiento, cantidad, fecha_movimiento
) VALUES
(1, 2, 'entrada', 20, '2024-01-20 10:00:00'),
(2, 2, 'entrada', 10, '2024-01-20 10:05:00'),
(3, 2, 'entrada', 100, '2024-02-15 11:00:00'),
(1, 2, 'salida', 5, '2024-03-01 09:00:00');

-- 15. Devoluciones
INSERT INTO act_devoluciones (id, movimiento_id, motivo, fecha_devolucion, cantidad) VALUES
(1, 4, 'Producto defectuoso', '2024-03-05', 2);

-- 16. Ajustes de Inventario
INSERT INTO act_cla_ajustesinventario (id, id_producto, tipo_ajuste, cantidad, motivo, fecha_ajuste, usuario_id) VALUES
(1, 1, 'Decremento', 1, 'Pérdida accidental', '2024-04-10', 1),
(2, 3, 'Incremento', 10, 'Reajuste de stock', '2024-04-12', 2);

-- 17. Historial de Préstamos
INSERT INTO act_historial_prestamos (id, activo_id, tercero_id, fecha_prestamo, fecha_devolucion, destino, estado_prestamo, observaciones) VALUES
(1, 1, 2, '2024-05-01', NULL, 'Proyecto Especial', 'Prestado', 'Laptop para proyecto de desarrollo'),
(2, 2, 1, '2024-05-03', '2024-05-10', 'Mantenimiento', 'Devuelto', 'Impresora para mantenimiento de red');

-- 18. Depreciación
INSERT INTO act_depreciacion (id, activo_id, fecha_depreciacion, valor_depreciado, valor_restante) VALUES
(1, 1, '2024-12-31', 240.00, 1260.00),
(2, 2, '2024-12-31', 160.00, 640.00),
(3, 3, '2024-12-31', 100.00, 400.00);

-- 19. Auditoría de Cambios
INSERT INTO act_auditoriacambios (tabla, operacion, registro_id, usuario_id, datos_anteriores, datos_nuevos) VALUES
('act_activosfijos', 'INSERT', 1, 1, NULL, '{"clasificacion":"Activo Fijo"}'),
('act_cla_movimientos', 'INSERT', 1, NULL, NULL, '{"tipo_movimiento":"entrada","cantidad":20}'),
('act_cla_movimientos', 'INSERT', 2, NULL, NULL, '{"tipo_movimiento":"entrada","cantidad":10}'),
('act_cla_movimientos', 'INSERT', 3, NULL, NULL, '{"tipo_movimiento":"entrada","cantidad":100}'),
('act_cla_movimientos', 'INSERT', 4, NULL, NULL, '{"tipo_movimiento":"salida","cantidad":5}'),
('act_cla_movimientos', 'UPDATE', 4, NULL, '{"cantidad":5}', '{"cantidad":5}'),
('act_cla_movimientos', 'DELETE', 4, NULL, '{"tipo_movimiento":"salida","cantidad":5}', NULL);


-- -------------------------
-- Restaurar Configuración Inicial
-- -------------------------

-- Reactivar las verificaciones de claves foráneas
SET FOREIGN_KEY_CHECKS = 1;
