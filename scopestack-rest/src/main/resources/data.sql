-- Sample product data for ScopeStack Product Catalog API
-- This data will be loaded when the application starts (if using create-drop)

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
('Philips Hue Starter Kit', 'Smart LED lighting system with bridge and bulbs', 199.99, 'HOME_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('KitchenAid Stand Mixer', 'Professional 5-quart stand mixer in red', 379.99, 'HOME_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Dyson V15 Detect', 'Cord-free vacuum with laser dust detection', 699.99, 'HOME_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Weber Gas Grill', '3-burner gas grill with side tables', 449.99, 'HOME_GARDEN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Sports & Outdoors
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('Peloton Bike+', 'Premium indoor cycling bike with rotating HD touchscreen', 2495.00, 'SPORTS_OUTDOORS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Yeti Tundra 45', 'Premium hard cooler with superior ice retention', 299.99, 'SPORTS_OUTDOORS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Garmin Fenix 7', 'Premium multisport GPS watch with maps', 699.99, 'SPORTS_OUTDOORS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Patagonia Down Jacket', 'Lightweight insulated jacket for cold weather', 229.99, 'SPORTS_OUTDOORS', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Other
INSERT INTO products (name, description, price, category, created_at, updated_at) VALUES
('Rare Collectible Item', 'Limited edition collectible with very low stock', 999.99, 'OTHER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Discontinued Product', 'Product being phased out', 29.99, 'OTHER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Seasonal Item', 'Limited seasonal product', 79.99, 'OTHER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); 