-- ScopeStack Database Initialization Script
-- This script runs when the PostgreSQL container starts for the first time

-- Create the products table
CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    category VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create index on category for better performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);

-- Create index on name for search functionality
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);

-- Insert sample data
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('iPhone 15 Pro', 'Latest iPhone with advanced camera system and A17 Pro chip', 999.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('MacBook Air M2', 'Ultra-thin laptop with M2 chip and all-day battery life', 1199.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Samsung Galaxy S24', 'Android flagship with AI features and excellent camera', 899.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Nike Air Max 270', 'Comfortable running shoes with Air Max technology', 150.00, 'SPORTS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Adidas Ultraboost 22', 'Premium running shoes with responsive cushioning', 180.00, 'SPORTS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('The Pragmatic Programmer', 'Essential guide for software developers', 49.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Clean Code', 'Best practices for writing clean, maintainable code', 44.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Design Patterns', 'Gang of Four design patterns book', 54.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Levi''s 501 Jeans', 'Classic straight-fit denim jeans', 89.99, 'CLOTHING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Uniqlo T-Shirt', 'Comfortable cotton t-shirt in various colors', 19.99, 'CLOTHING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant permissions (if needed for different users)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres; 