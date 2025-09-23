-- Application-specific tables for Spring Boot application
-- Flyway migration V2

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id BIGINT,
    sort_order INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Create items table
CREATE TABLE IF NOT EXISTS items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category_id BIGINT,
    price DECIMAL(10,2),
    quantity INTEGER DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    active BOOLEAN DEFAULT TRUE,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipped_date TIMESTAMP NULL,
    delivered_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

-- Create application_settings table
CREATE TABLE IF NOT EXISTS application_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    description VARCHAR(255),
    data_type VARCHAR(20) DEFAULT 'STRING',
    is_encrypted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample categories
INSERT INTO categories (name, description, sort_order) VALUES 
('Electronics', 'Electronic devices and accessories', 1),
('Books', 'Books and publications', 2),
('Clothing', 'Apparel and accessories', 3),
('Home & Garden', 'Home improvement and garden supplies', 4);

-- Insert sample application settings
INSERT INTO application_settings (setting_key, setting_value, description, data_type) VALUES 
('app.version', '1.0.0', 'Application version', 'STRING'),
('app.maintenance_mode', 'false', 'Enable maintenance mode', 'BOOLEAN'),
('app.max_upload_size', '10485760', 'Maximum file upload size in bytes', 'INTEGER'),
('app.session_timeout', '3600', 'Session timeout in seconds', 'INTEGER'),
('app.email_notifications', 'true', 'Enable email notifications', 'BOOLEAN');

-- Create indexes for performance
CREATE INDEX idx_categories_parent_id ON categories(parent_id);
CREATE INDEX idx_categories_active ON categories(active);
CREATE INDEX idx_items_category_id ON items(category_id);
CREATE INDEX idx_items_sku ON items(sku);
CREATE INDEX idx_items_active ON items(active);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_item_id ON order_items(item_id);
CREATE INDEX idx_application_settings_key ON application_settings(setting_key);

-- Add comments for documentation
COMMENT ON TABLE categories IS 'Product categories with hierarchical structure';
COMMENT ON TABLE items IS 'Product items/inventory';
COMMENT ON TABLE orders IS 'Customer orders';
COMMENT ON TABLE order_items IS 'Line items for each order';
COMMENT ON TABLE application_settings IS 'Application configuration settings';