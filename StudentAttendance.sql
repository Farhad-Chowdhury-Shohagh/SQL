CREATE DATABASE student_attendance_db;
USE student_attendance_db;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    semester INT
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    attendance_date DATE,
    status ENUM('Present', 'Absent') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (name, department, semester)
VALUES
('Farhad Chowdhury', 'CSE', 10),
('Nadir Hossen', 'CSE', 10),
('Tareq', 'CSE', 10studentstudent);

INSERT INTO attendance (student_id, attendance_date, status)
VALUES
(1, '2026-06-26', 'Present'),
(2, '2026-06-26', 'Absent'),
(3, '2026-06-26', 'Present');

SELECT s.name, a.attendance_date, a.status
FROM students s
JOIN attendance a ON s.student_id = a.student_id;