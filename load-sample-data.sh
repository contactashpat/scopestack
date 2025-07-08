#!/bin/bash

# Sample data loading script for ScopeStack PostgreSQL database
# This script loads sample product data into the PostgreSQL database

echo "Loading sample data into ScopeStack PostgreSQL database..."

# Check if PostgreSQL container is running
if ! docker compose ps postgres | grep -q "Up"; then
    echo "PostgreSQL container is not running. Starting it..."
    docker compose up -d postgres
    sleep 5
fi

# Create temporary SQL file with sample data
cat > /tmp/sample_data.sql << 'EOF'
-- Sample product data for ScopeStack Product Catalog API
-- Insert sample products into the products table

-- Electronics
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('iPhone 15 Pro', 'Latest iPhone with advanced camera system and A17 Pro chip', 999.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('MacBook Air M2', 'Lightweight laptop with M2 chip and all-day battery life', 1199.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Sony WH-1000XM5', 'Premium noise-cancelling wireless headphones', 349.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Samsung 4K Smart TV', '55-inch 4K Ultra HD Smart TV with HDR', 699.99, 'ELECTRONICS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Books
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('The Pragmatic Programmer', 'Your journey to mastery in software development', 49.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Clean Code', 'A handbook of agile software craftsmanship', 44.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Design Patterns', 'Elements of reusable object-oriented software', 54.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Effective Java', 'Programming language guide by Joshua Bloch', 39.99, 'BOOKS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Clothing
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('Nike Air Max 270', 'Comfortable running shoes with Air Max technology', 129.99, 'CLOTHING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Levi''s 501 Jeans', 'Classic straight-fit denim jeans', 89.99, 'CLOTHING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Adidas T-Shirt', 'Moisture-wicking athletic t-shirt', 29.99, 'CLOTHING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('North Face Jacket', 'Waterproof hiking jacket with breathable membrane', 199.99, 'CLOTHING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Home & Garden
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('Philips Hue Starter Kit', 'Smart LED lighting system with bridge and bulbs', 199.99, 'HOME_AND_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('KitchenAid Stand Mixer', 'Professional 5-quart stand mixer in red', 379.99, 'HOME_AND_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Dyson V15 Detect', 'Cord-free vacuum with laser dust detection', 699.99, 'HOME_AND_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Weber Gas Grill', '3-burner gas grill with side tables', 449.99, 'HOME_AND_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Sports
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('Peloton Bike+', 'Premium indoor cycling bike with rotating HD touchscreen', 2495.00, 'SPORTS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Yeti Tundra 45', 'Premium hard cooler with superior ice retention', 299.99, 'SPORTS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Garmin Fenix 7', 'Premium multisport GPS watch with maps', 699.99, 'SPORTS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Patagonia Down Jacket', 'Lightweight insulated jacket for cold weather', 229.99, 'SPORTS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Other
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('Rare Collectible Item', 'Limited edition collectible with very low stock', 999.99, 'OTHER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Discontinued Product', 'Product being phased out', 29.99, 'OTHER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Seasonal Item', 'Limited seasonal product', 79.99, 'OTHER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
EOF

# Execute the SQL script
echo "Executing SQL script..."
docker exec -i scopestack-postgres psql -U postgres -d scopestack < /tmp/sample_data.sql

# Clean up temporary file
rm /tmp/sample_data.sql

# Verify the data was loaded
echo "Verifying data load..."
docker exec -it scopestack-postgres psql -U postgres -d scopestack -c "SELECT COUNT(*) as total_products FROM products;"

echo "Sample data loading completed!"
echo "You can now test the API at: https://localhost:8443/api/products" 