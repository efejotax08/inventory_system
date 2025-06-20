DROP DATABASE  inventory_system;
CREATE DATABASE inventory_system;
USE inventory_system;

-- Tabla de usuarios
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uniqueIdentifier VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    settings JSON,
    permissions JSON
);
INSERT INTO users (uniqueIdentifier, name, settings, permissions)
VALUES (
    'user-12345',
    'Juan Pérez',
    JSON_OBJECT(
        'theme', 'dark',
        'language', 'es',
        'notifications', JSON_OBJECT('email', true, 'sms', false)
    ),
    JSON_ARRAY('read', 'write', 'delete')
);

-- Tabla de asistencia
CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL,
    notes TEXT,
    userId INT,
    hasEntered BOOLEAN,
    FOREIGN KEY (userId) REFERENCES users(id)
);

INSERT INTO attendance (datetime, notes, userId, hasEntered)
VALUES 
-- Día 1 (hoy - 2)
(DATE_SUB(CURDATE(), INTERVAL 2 DAY) + INTERVAL '08:00:00' HOUR_SECOND, 'Entrada puntual', 1, TRUE),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY) + INTERVAL '17:00:00' HOUR_SECOND, 'Salida puntual', 1, FALSE),

-- Día 2 (hoy - 1)
(DATE_SUB(CURDATE(), INTERVAL 1 DAY) + INTERVAL '08:05:00' HOUR_SECOND, 'Entrada con leve retraso', 1, TRUE),
(DATE_SUB(CURDATE(), INTERVAL 1 DAY) + INTERVAL '17:10:00' HOUR_SECOND, 'Salida después de hora', 1, FALSE),

-- Día 3 (hoy)
(CURDATE() + INTERVAL '07:50:00' HOUR_SECOND, 'Entrada antes de hora', 1, TRUE),
(CURDATE() + INTERVAL '16:45:00' HOUR_SECOND, 'Salida anticipada', 1, FALSE);


-- Tabla de auditorías de inventario
CREATE TABLE stock_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL,
    notes TEXT,
    handledBy INT,
    FOREIGN KEY (handledBy) REFERENCES users(id)
);

INSERT INTO stock_audit (datetime, notes, handledBy)
VALUES 
-- Día 1 (hoy - 2)
(DATE_SUB(CURDATE(), INTERVAL 2 DAY) + INTERVAL '10:00:00' HOUR_SECOND, 'Revisión general del inventario', 1),

-- Día 2 (hoy - 1)
(DATE_SUB(CURDATE(), INTERVAL 1 DAY) + INTERVAL '11:30:00' HOUR_SECOND, 'Conteo de productos en bodega A', 1),

-- Día 3 (hoy)
(CURDATE() + INTERVAL '09:15:00' HOUR_SECOND, 'Verificación de mercancía entrante', 1);


-- Tabla de proveedores
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uniqueIdentifier VARCHAR(255) UNIQUE,
    name VARCHAR(255),
    contact TEXT
);
INSERT INTO suppliers (uniqueIdentifier, name, contact)
VALUES 
('SUP-001', 'Distribuidora Andina S.A.', 'Tel: +593 2 222 3344, Email: ventas@andina.com'),
('SUP-002', 'Importadora GlobalTech', 'Tel: +593 4 445 6677, Email: contacto@globaltech.ec'),
('SUP-003', 'AgroIndustrial El Campo', 'Tel: +593 3 334 5566, Email: info@elcampo.com'),
('SUP-004', 'Alimentos Ecuatorianos', 'Tel: +593 2 998 7765, Email: alimentos@ec.com'),
('SUP-005', 'Suministros Médicos Quito', 'Tel: +593 9 876 5432, Email: ventas@medquito.ec');




-- Tabla de productos
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productId VARCHAR(255) UNIQUE,
    name VARCHAR(255),
    description TEXT,
    lastAudit DATETIME,
    stockQuantity INT,
    lowStockThreshold INT,
    acquisitionPrice DECIMAL(10,2),
    supplierId INT,
    photoUrl TEXT,
    subscribeToInventory BOOLEAN,
    packagingUnit VARCHAR(100),
    stats JSON,
    FOREIGN KEY (supplierId) REFERENCES suppliers(id)
);

INSERT INTO products (
    productId, name, description, lastAudit, stockQuantity, lowStockThreshold,
    acquisitionPrice, supplierId, photoUrl, subscribeToInventory, packagingUnit, stats
)
VALUES 
('PROD-001', 'Laptop Dell Inspiron 15', 'Laptop con procesador Intel i5 y 8GB RAM.', '2025-06-18 10:00:00', 25, 10, 550.00, 1, NULL, TRUE, '1', JSON_OBJECT('sold', 120, 'returned', 2)),

('PROD-002', 'Mouse Inalámbrico Logitech', 'Mouse ergonómico inalámbrico con conexión USB.', '2025-06-19 09:30:00', 100, 30, 18.75, 2, NULL, TRUE, '1', JSON_OBJECT('sold', 350, 'returned', 5)),

('PROD-003', 'Fertilizante Orgánico 10kg', 'Ideal para cultivos de ciclo corto.', '2025-06-17 14:45:00', 40, 20, 22.50, 3, NULL, TRUE, '3', JSON_OBJECT('sold', 85, 'returned', 1)),

('PROD-004', 'Aceite de Girasol 1L', 'Aceite vegetal comestible extra filtrado.', '2025-06-20 08:10:00', 200, 50, 2.90, 4, NULL, TRUE, '4', JSON_OBJECT('sold', 540, 'returned', 8)),

('PROD-005', 'Guantes Quirúrgicos Talla M', 'Guantes descartables, caja con 100 unidades.', '2025-06-19 16:00:00', 300, 100, 12.00, 5, NULL, TRUE, '2', JSON_OBJECT('sold', 430, 'returned', 12));



-- Tabla de pedidos
CREATE TABLE request (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    price DECIMAL(10,2),
    received BOOLEAN,
    handledBy INT,
    notes TEXT,
    FOREIGN KEY (handledBy) REFERENCES users(id)
);

INSERT INTO request (date, price, received, handledBy, notes)
VALUES
('2025-06-18', 1500.75, TRUE, 1, 'Pedido recibido completo y revisado.'),
('2025-06-19', 820.40, FALSE, 1, 'Pedido pendiente de llegada, esperando confirmación.'),
('2025-06-20', 430.00, TRUE, 1, 'Entrega parcial recibida, faltan algunos productos.');


-- Detalle de pedidos
CREATE TABLE request_detail (
    productId INT,
    amount INT,
    supplierId INT,
    requestId INT,
    PRIMARY KEY (productId, requestId),
    FOREIGN KEY (productId) REFERENCES products(id),
    FOREIGN KEY (supplierId) REFERENCES suppliers(id),
    FOREIGN KEY (requestId) REFERENCES request(id)
);
INSERT INTO request_detail (productId, amount, supplierId, requestId)
VALUES
(1, 10, 1, 1),
(2, 5, 2, 1),
(3, 20, 3, 2),
(4, 15, 4, 2),
(5, 30, 5, 3),
(1, 7, 1, 3);



-- Tabla intermedia entre stock_audit y productos
CREATE TABLE stock_audit_products (
    stockAuditId INT,
    productId INT,
    PRIMARY KEY (stockAuditId, productId),
    FOREIGN KEY (stockAuditId) REFERENCES stock_audit(id),
    FOREIGN KEY (productId) REFERENCES products(id)
);

INSERT INTO stock_audit_products (stockAuditId, productId)
VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 1),
(3, 5);



-- Tabla de etiquetas
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO tags (name)
VALUES
('Electrónica'),
('Agrícola'),
('Alimentos'),
('Medicina'),
('Hogar'),
('Oficina'),
('Urgente'),
('Revisión'),
('Pendiente'),
('Completado');




-- Tabla intermedia entre productos y etiquetas
CREATE TABLE product_tag (
    tagId INT,
    productId INT,
    PRIMARY KEY (tagId, productId),
    FOREIGN KEY (tagId) REFERENCES tags(id),
    FOREIGN KEY (productId) REFERENCES products(id)
);

INSERT INTO product_tag (tagId, productId)
VALUES
(1, 1),  -- Electrónica -> Laptop Dell Inspiron 15
(1, 2),  -- Electrónica -> Mouse Inalámbrico Logitech
(2, 3),  -- Agrícola -> Fertilizante Orgánico 10kg
(3, 4),  -- Alimentos -> Aceite de Girasol 1L
(4, 5),  -- Medicina -> Guantes Quirúrgicos Talla M
(5, 1),  -- Hogar -> Laptop Dell Inspiron 15 (ejemplo adicional)
(8, 3),  -- Revisión -> Fertilizante Orgánico 10kg
(9, 2);  -- Pendiente -> Mouse Inalámbrico Logitech


-- Tabla intermedia entre solicitudes y etiquetas
CREATE TABLE request_tag (
    tagId INT,
    requestId INT,
    PRIMARY KEY (tagId, requestId),
    FOREIGN KEY (tagId) REFERENCES tags(id),
    FOREIGN KEY (requestId) REFERENCES request(id)
);

INSERT INTO request_tag (tagId, requestId)
VALUES
(7, 1),  -- Urgente -> Pedido 1
(9, 2),  -- Pendiente -> Pedido 2
(10, 3), -- Completado -> Pedido 3
(8, 2),  -- Revisión -> Pedido 2
(5, 3);  -- Hogar -> Pedido 3 (ejemplo adicional)



-- Tabla intermedia entre proveedores y etiquetas
CREATE TABLE supplier_tag (
    tagId INT,
    supplierId INT,
    PRIMARY KEY (tagId, supplierId),
    FOREIGN KEY (tagId) REFERENCES tags(id),
    FOREIGN KEY (supplierId) REFERENCES suppliers(id)
);

INSERT INTO supplier_tag (tagId, supplierId)
VALUES
(1, 1),  -- Electrónica -> Distribuidora Andina S.A.
(2, 3),  -- Agrícola -> AgroIndustrial El Campo
(3, 4),  -- Alimentos -> Alimentos Ecuatorianos
(4, 5),  -- Medicina -> Suministros Médicos Quito
(5, 2),  -- Hogar -> Importadora GlobalTech
(8, 3),  -- Revisión -> AgroIndustrial El Campo
(9, 4);  -- Pendiente -> Alimentos Ecuatorianos




































