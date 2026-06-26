-- Project 03: Hospital Patient Management System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100)
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    disease VARCHAR(100)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    fee DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

INSERT INTO doctors (doctor_name, specialization) VALUES
('Dr. Rahman', 'Cardiology'),
('Dr. Karim', 'Medicine');

INSERT INTO patients (patient_name, age, gender, disease) VALUES
('Aminul Islam', 45, 'Male', 'Heart Problem'),
('Nusrat Jahan', 25, 'Female', 'Fever');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, fee) VALUES
(1, 1, '2026-06-26', 800.00),
(2, 2, '2026-06-27', 500.00);

-- Show appointment details
SELECT p.patient_name, p.age, p.gender, p.disease,
       d.doctor_name, d.specialization, a.appointment_date, a.fee
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;
