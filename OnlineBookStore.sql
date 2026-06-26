CREATE DATABASE online_book_store;
USE online_book_store;

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    author VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    book_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO books (title, author, price, stock)
VALUES
('Database Systems', 'Raghu Ramakrishnan', 550.00, 20),
('Clean Code', 'Robert C. Martin', 700.00, 15),
('Computer Networks', 'Andrew Tanenbaum', 600.00, 10);

INSERT INTO customers (name, email)
VALUES
('Farhad', 'farhad@example.com'),
('Zidan', 'zidan@example.com');

INSERT INTO orders (customer_id, book_id, quantity, order_date)
VALUES
(1, 2, 1, '2026-06-26'),
(2, 1, 2, '2026-06-26');

SELECT c.name, b.title, o.quantity, b.price,
       (o.quantity * b.price) AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN books b ON o.book_id = b.book_id;