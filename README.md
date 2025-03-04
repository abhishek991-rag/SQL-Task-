# SQL-Task-
E-commerce Database Setup

Overview

This SQL script creates a simple e-commerce database system with tables for customers, products, orders, and order items. It also includes sample data and queries for retrieving relevant business insights.

Database Structure

Tables

customers

id (Primary Key, Auto Increment)

name (VARCHAR, NOT NULL)

email (VARCHAR, UNIQUE, NOT NULL)

address (TEXT)

products

id (Primary Key, Auto Increment)

name (VARCHAR, NOT NULL)

price (DECIMAL, NOT NULL, must be >= 0)

description (TEXT)

discount (DECIMAL, DEFAULT 0.00)

orders

id (Primary Key, Auto Increment)

customer_id (Foreign Key referencing customers.id, ON DELETE CASCADE)

order_date (DATE, NOT NULL)

total_amount (DECIMAL, NOT NULL, must be >= 0)

order_items (Normalization of orders)

id (Primary Key, Auto Increment)

order_id (Foreign Key referencing orders.id, ON DELETE CASCADE)

product_id (Foreign Key referencing products.id, ON DELETE CASCADE)

quantity (INT, NOT NULL, must be > 0)

price (DECIMAL, NOT NULL, must be >= 0)

Sample Data

Customers: 3 entries

Products: 3 entries

Orders: 3 entries

Key Queries

Retrieve all customers who placed an order in the last 30 days.

Get total amount of all orders placed by each customer.

Update the price of "Product C" to 45.00.

Retrieve the top 3 products with the highest price.

Get names of customers who ordered "Product A".

Retrieve order details with customer names.

Retrieve orders with total amount > 150.00.

Retrieve the average order total.

Execution Steps

Copy and execute the script in a MySQL environment.

Verify database creation using SHOW DATABASES;.

Verify table creation using SHOW TABLES;.

Run queries as needed for data analysis.

Notes

ON DUPLICATE KEY UPDATE ensures existing records are updated instead of duplicated.

IF NOT EXISTS prevents redundant table creation.

Constraints ensure data integrity and consistency.

This SQL script provides a foundation for an e-commerce system, allowing further enhancements like user authentication, order tracking, and inventory management.

