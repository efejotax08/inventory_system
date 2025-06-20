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

-- Tabla de asistencia
CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL,
    notes TEXT,
    userId INT,
    hasEntered BOOLEAN,
    FOREIGN KEY (userId) REFERENCES users(id)
);

-- Tabla de auditorías de inventario
CREATE TABLE stock_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL,
    notes TEXT,
    handledBy INT,
    FOREIGN KEY (handledBy) REFERENCES users(id)
);

-- Tabla de proveedores
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uniqueIdentifier VARCHAR(255) UNIQUE,
    name VARCHAR(255),
    contact TEXT
);

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



-- Tabla intermedia entre stock_audit y productos
CREATE TABLE stock_audit_products (
    stockAuditId INT,
    productId INT,
    PRIMARY KEY (stockAuditId, productId),
    FOREIGN KEY (stockAuditId) REFERENCES stock_audit(id),
    FOREIGN KEY (productId) REFERENCES products(id)
);

-- Tabla de etiquetas
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);

-- Tabla intermedia entre productos y etiquetas
CREATE TABLE product_tag (
    tagId INT,
    productId INT,
    PRIMARY KEY (tagId, productId),
    FOREIGN KEY (tagId) REFERENCES tags(id),
    FOREIGN KEY (productId) REFERENCES products(id)
);


-- Tabla intermedia entre solicitudes y etiquetas
CREATE TABLE request_tag (
    tagId INT,
    requestId INT,
    PRIMARY KEY (tagId, requestId),
    FOREIGN KEY (tagId) REFERENCES tags(id),
    FOREIGN KEY (requestId) REFERENCES request(id)
);
-- Tabla intermedia entre proveedores y etiquetas
CREATE TABLE supplier_tag (
    tagId INT,
    supplierId INT,
    PRIMARY KEY (tagId, supplierId),
    FOREIGN KEY (tagId) REFERENCES tags(id),
    FOREIGN KEY (supplierId) REFERENCES suppliers(id)
);


































