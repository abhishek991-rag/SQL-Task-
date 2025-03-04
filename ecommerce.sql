-- Create the database
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    address TEXT
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    description TEXT
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- Insert sample data into customers
INSERT INTO customers (name, email, address) VALUES
('Alice Johnson', 'alice@example.com', '123 Main St'),
('Bob Smith', 'bob@example.com', '456 Oak St'),
('Charlie Brown', 'charlie@example.com', '789 Pine St')
ON DUPLICATE KEY UPDATE name=VALUES(name), email=VALUES(email), address=VALUES(address);

-- Insert sample data into products
INSERT INTO products (name, price, description) VALUES
('Product A', 25.00, 'Description of Product A'),
('Product B', 35.00, 'Description of Product B'),
('Product C', 40.00, 'Description of Product C')
ON DUPLICATE KEY UPDATE name=VALUES(name), price=VALUES(price), description=VALUES(description);

-- Insert sample data into orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE(), 100.00),
(2, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 150.00),
(3, DATE_SUB(CURDATE(), INTERVAL 29 DAY), 200.00)
ON DUPLICATE KEY UPDATE customer_id=VALUES(customer_id), order_date=VALUES(order_date), total_amount=VALUES(total_amount);

-- Retrieve all customers who have placed an order in the last 30 days
SELECT DISTINCT c.* 
FROM customers c 
JOIN orders o ON c.id = o.customer_id 
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Get the total amount of all orders placed by each customer
SELECT c.id, c.name, COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c 
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Update the price of Product C to 45.00
UPDATE products 
SET price = 45.00 
WHERE name = 'Product C';

-- Add a new column discount to the products table
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS discount DECIMAL(5,2) DEFAULT 0.00;

-- Retrieve the top 3 products with the highest price
SELECT id, name, price FROM products 
ORDER BY price DESC 
LIMIT 3;

-- Normalize the database: Create order_items table and update orders
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Get the names of customers who have ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- Join orders and customers to retrieve the customer's name and order date for each order
SELECT c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- Retrieve the orders with a total amount greater than 150.00
SELECT * FROM orders 
WHERE total_amount > 150.00;

-- Retrieve the average total of all orders
SELECT AVG(total_amount) AS average_order_total FROM orders;
