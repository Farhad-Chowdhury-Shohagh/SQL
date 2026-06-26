-- Project 07: E-Commerce Product Management System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS ecommerce_product_db;
USE ecommerce_product_db;

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    sale_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

INSERT INTO products (product_name, category_id, price, stock) VALUES
('Laptop', 1, 65000.00, 10),
('T-Shirt', 2, 500.00, 50),
('SQL Guide Book', 3, 350.00, 30);

INSERT INTO sales (product_id, quantity, sale_date) VALUES
(1, 1, '2026-06-26'),
(2, 3, '2026-06-26');

-- Show sales details
SELECT p.product_name, c.category_name, s.quantity,
       p.price, (s.quantity * p.price) AS total_sale
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id;
