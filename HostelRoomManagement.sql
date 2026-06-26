-- Project 08: Hostel Room Management System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS hostel_management;
USE hostel_management;

DROP TABLE IF EXISTS allocations;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS rooms;

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(20),
    room_type VARCHAR(50),
    capacity INT
);

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100),
    department VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE allocations (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    room_id INT,
    allocation_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO rooms (room_number, room_type, capacity) VALUES
('A101', 'Single', 1),
('B202', 'Double', 2),
('C303', 'Triple', 3);

INSERT INTO students (student_name, department, phone) VALUES
('Farhad', 'CSE', '01711111111'),
('Zidan', 'CSE', '01822222222');

INSERT INTO allocations (student_id, room_id, allocation_date) VALUES
(1, 1, '2026-06-26'),
(2, 2, '2026-06-26');

-- Show room allocation details
SELECT s.student_name, s.department, s.phone, r.room_number,
       r.room_type, r.capacity, a.allocation_date
FROM allocations a
JOIN students s ON a.student_id = s.student_id
JOIN rooms r ON a.room_id = r.room_id;
