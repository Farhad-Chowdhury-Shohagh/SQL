-- Project 05: Library Management System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

DROP TABLE IF EXISTS borrow_records;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS books;

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100),
    department VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_title VARCHAR(150),
    author VARCHAR(100),
    available_copies INT
);

CREATE TABLE borrow_records (
    borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO members (member_name, department, phone) VALUES
('Farhad', 'CSE', '01711111111'),
('Labiba', 'SWE', '01822222222');

INSERT INTO books (book_title, author, available_copies) VALUES
('Artificial Intelligence', 'Stuart Russell', 5),
('Operating System Concepts', 'Silberschatz', 4);

INSERT INTO borrow_records (member_id, book_id, borrow_date, return_date) VALUES
(1, 1, '2026-06-20', '2026-06-27'),
(2, 2, '2026-06-21', '2026-06-28');

-- Show borrowed book records
SELECT m.member_name, m.department, b.book_title, b.author,
       br.borrow_date, br.return_date
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id;
