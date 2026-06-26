-- Project 10: Vehicle Rental Management System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS vehicle_rental;
USE vehicle_rental;

DROP TABLE IF EXISTS rentals;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS vehicles;

CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_name VARCHAR(100),
    vehicle_type VARCHAR(50),
    rent_per_day DECIMAL(10,2),
    availability ENUM('Available', 'Rented') DEFAULT 'Available'
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    phone VARCHAR(20),
    license_number VARCHAR(50)
);

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    vehicle_id INT,
    rental_date DATE,
    return_date DATE,
    total_days INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

INSERT INTO vehicles (vehicle_name, vehicle_type, rent_per_day) VALUES
('Toyota Corolla', 'Car', 2500.00),
('Yamaha R15', 'Bike', 1200.00),
('Hiace Microbus', 'Microbus', 5000.00);

INSERT INTO customers (customer_name, phone, license_number) VALUES
('Farhad', '01711111111', 'DL1001'),
('Zidan', '01822222222', 'DL1002');

INSERT INTO rentals (customer_id, vehicle_id, rental_date, return_date, total_days) VALUES
(1, 1, '2026-06-26', '2026-06-28', 2),
(2, 2, '2026-06-26', '2026-06-27', 1);

UPDATE vehicles SET availability = 'Rented' WHERE vehicle_id IN (1, 2);

-- Show rental details and total cost
SELECT c.customer_name, c.phone, c.license_number,
       v.vehicle_name, v.vehicle_type, r.rental_date, r.return_date,
       r.total_days, v.rent_per_day,
       (r.total_days * v.rent_per_day) AS total_cost
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN vehicles v ON r.vehicle_id = v.vehicle_id;
