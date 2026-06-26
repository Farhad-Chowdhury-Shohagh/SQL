-- Project 04: Restaurant Food Ordering System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS restaurant_ordering;
USE restaurant_ordering;

DROP TABLE IF EXISTS food_orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS menu;

CREATE TABLE menu (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE food_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    food_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (food_id) REFERENCES menu(food_id)
);

INSERT INTO menu (food_name, category, price) VALUES
('Chicken Burger', 'Fast Food', 180.00),
('Beef Pizza', 'Fast Food', 450.00),
('Fried Rice', 'Chinese', 220.00);

INSERT INTO customers (customer_name, phone) VALUES
('Farhad', '01700000000'),
('Zidan', '01800000000');

INSERT INTO food_orders (customer_id, food_id, quantity, order_date) VALUES
(1, 1, 2, '2026-06-26'),
(2, 3, 1, '2026-06-26');

-- Show food order bills
SELECT c.customer_name, c.phone, m.food_name, m.category, o.quantity,
       m.price, (o.quantity * m.price) AS total_bill
FROM food_orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN menu m ON o.food_id = m.food_id;
