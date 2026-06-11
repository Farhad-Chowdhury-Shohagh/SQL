CREATE DATABASE BankMS;
USE BankMS;
Drop database BankMS;







/* Tables Create */

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    city VARCHAR(30),
    phone VARCHAR(15)
);

CREATE TABLE Branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    branch_id INT,
    account_type VARCHAR(20),
    balance DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    trans_type VARCHAR(10),
    amount DECIMAL(10,2),
    trans_date DATE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_type VARCHAR(20),
    loan_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    branch_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);







/* Demo Data Insert */

INSERT INTO Customers VALUES
(1,'Rahim','Dhaka','017118743398'),
(2,'Karim','Chittagong','01822672387'),
(3,'Salma','Sylhet','01933676538'),
(4,'Rafi','Rajshahi','01644375693'),
(5,'Nila','Khulna','01555674378'),
(6,'Farhad','Dhaka','01675464308'),
(7,'Nadir','Dhaka','01775464308'),
(8,'Tareq','Dhaka','01975464308');

INSERT INTO Branches VALUES
(1,'Main Branch','Dhaka'),
(2,'North Branch','Rajshahi'),
(3,'South Branch','Khulna'),
(4,'East Branch','Sylhet'),
(5,'West Branch','Chittagong');

INSERT INTO Accounts VALUES
(1,1,1,'Savings',5000),
(2,2,2,'Current',8000),
(3,3,3,'Savings',12000),
(4,4,4,'Current',3000),
(5,5,5,'Savings',15000);

INSERT INTO Transactions VALUES
(1,1,'Deposit',2000,'2025-01-01'),
(2,2,'Withdraw',1000,'2025-01-02'),
(3,3,'Deposit',3000,'2025-01-03'),
(4,4,'Withdraw',500,'2025-01-04'),
(5,5,'Deposit',4000,'2025-01-05');

INSERT INTO Loans VALUES
(1,1,'Home',200000),
(2,2,'Car',500000),
(3,3,'Education',100000),
(4,4,'Personal',150000),
(5,5,'Business',300000);

INSERT INTO Employees VALUES
(1,'Arif',1,30000),
(2,'Sumi',2,28000),
(3,'Hasan',3,32000),
(4,'Mitu',4,29000),
(5,'Rana',5,35000);







/* Views Create & Show */

CREATE VIEW v_customer_accounts AS
SELECT c.name AS customer_name, a.account_type, a.balance
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id;

SELECT * FROM v_customer_accounts;


CREATE VIEW v_branch_employees AS
SELECT b.branch_name, e.emp_name, e.salary
FROM Branches b
JOIN Employees e
ON b.branch_id = e.branch_id;

SELECT * FROM v_branch_employees;


CREATE VIEW v_loan_details AS
SELECT c.name AS customer_name, l.loan_type, l.loan_amount
FROM Customers c
JOIN Loans l
ON c.customer_id = l.customer_id;

SELECT * FROM v_loan_details;







/* Triggers */

/* Update & check balance is negative or not */
DELIMITER //
CREATE TRIGGER check_balance
BEFORE UPDATE ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'  /* 45000: This is a standard SQL state code reserved for "unhandled user-defined exceptions." */
        SET MESSAGE_TEXT = 'Balance cannot be negative';
    END IF;
END;
// DELIMITER ;

/*check*/
UPDATE Accounts
SET balance = -100
WHERE account_id = 1;



/* Insert if balance is positive */
DELIMITER //
CREATE TRIGGER check_balance_before_insert
BEFORE INSERT ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Balance cannot be negative.';
    END IF;
END;
// DELIMITER ;

/* check */
INSERT INTO Accounts VALUES(6,6,1,'Savings',-5000);



/* Transaction check & update new balance */
DELIMITER //
CREATE TRIGGER update_account_balance
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.trans_type='Deposit' THEN
        UPDATE Accounts SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;
    ELSE
        UPDATE Accounts SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;
    END IF;
END;
// DELIMITER ;

/*check*/
/* check before transaction */
SELECT balance FROM Accounts WHERE account_id = 1;

INSERT INTO Transactions 
(account_id, trans_type, amount, trans_date)
VALUES (1, 'Deposit', 1000, CURDATE());

/* check after transaction */
SELECT balance FROM Accounts WHERE account_id = 1;

INSERT INTO Transactions 
(account_id, trans_type, amount, trans_date)
VALUES (1, 'Withdraw', 500, CURDATE());

/* check before withdraw */
SELECT balance FROM Accounts WHERE account_id = 1;



/* Future date problem */
DELIMITER //
CREATE TRIGGER prevent_future_date
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.trans_date > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Transaction date cannot be in the future.';
    END IF;
END;
// DELIMITER ;

/* check */
INSERT INTO Transactions 
(account_id, trans_type, amount, trans_date)
VALUES (1, 'Withdraw', 500, '2027-01-02');







/* Functions */

/* LOOP */
DELIMITER //
CREATE FUNCTION TotalBranchBalance(b_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE bal DECIMAL(10,2);
    DECLARE total DECIMAL(12,2) DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT balance FROM Accounts WHERE branch_id = b_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    
    bal_loop: LOOP
        FETCH cur INTO bal;
        IF done = 1 THEN
            LEAVE bal_loop;
        END IF;
        SET total = total + bal;
    END LOOP;
    
    CLOSE cur;
    RETURN total;
END;
// DELIMITER ;

/* check before */
SELECT TotalBranchBalance(1) AS Branch_Total_Balance;
SELECT TotalBranchBalance(2) AS Branch_Total_Balance;

INSERT INTO Accounts VALUES(7,7,1,'Savings',5000);
INSERT INTO Accounts VALUES(8,8,2,'Savings',5000);

/* check after */
SELECT TotalBranchBalance(1) AS Branch_Total_Balance;
SELECT TotalBranchBalance(2) AS Branch_Total_Balance;



/* IF-ELSE */
DELIMITER //
CREATE FUNCTION AccountStatus(a_id INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE bal DECIMAL(10,2);
    DECLARE status VARCHAR(30);
    
    SELECT balance INTO bal
    FROM Accounts
    WHERE account_id = a_id;

    IF bal >= 10000 THEN
        SET status = 'Premium Account';
    ELSEIF bal >= 5000 THEN
        SET status = 'Standard Account';
    ELSE
        SET status = 'Low Balance Account';
    END IF;

    RETURN status;
END;
// DELIMITER ;

SELECT AccountStatus(1) AS Account_Type;
SELECT AccountStatus(3) AS Account_Type;



/*CURSOR*/
DELIMITER //
CREATE PROCEDURE TotalTransactionsAmounts()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE amt DECIMAL(10,2);
    DECLARE total DECIMAL(12,2) DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT amount FROM Transactions;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO amt;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        IF amt > 0 THEN
            SET total = total + amt;
        END IF;
    END LOOP;
    CLOSE cur;

    SELECT total AS Total_Transactions_Amounts;
END;
// DELIMITER ;

CALL TotalTransactionsAmounts();

INSERT INTO Transactions 
(account_id, trans_type, amount, trans_date)
VALUES (1, 'Withdraw', 500, '2026-01-02');








/* Queries */

/* DQL */
/* Display */
SELECT * FROM Customers;
SELECT name FROM Customers WHERE city = 'Dhaka';
SELECT * FROM Loans WHERE loan_amount > 200000;
SELECT emp_name, salary
FROM Employees
WHERE salary > 30000;
SELECT DISTINCT city FROM Customers;

/* Aggregates quries */
SELECT AVG(balance) AS Avg_Balance FROM Accounts;
SELECT MAX(balance) AS Max_Balance FROM Accounts;
SELECT COUNT(*) AS Total_Employees FROM Employees;

/* Order or Group By */
SELECT * FROM Accounts ORDER BY balance DESC;
SELECT city, COUNT(*) AS Total_Customers
FROM Customers
GROUP BY city;

SELECT * FROM Transactions
ORDER BY trans_date DESC
LIMIT 3;


SELECT * FROM Accounts
WHERE balance BETWEEN 5000 AND 15000;

SELECT * FROM Customers
WHERE name LIKE 'R%';

/* JOIN */
SELECT 
    c.name AS Customer_Name,
    a.account_type,
    a.balance,
    b.branch_name
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Branches b ON a.branch_id = b.branch_id;

SELECT 
    b.branch_name,
    e.emp_name,
    e.salary
FROM Branches b
JOIN Employees e ON b.branch_id = e.branch_id;

SELECT 
    c.name,
    l.loan_type,
    l.loan_amount
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id;

SELECT 
    b.branch_name,
    COUNT(a.account_id) AS Total_Accounts
FROM Branches b
JOIN Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name;

SELECT 
    c.name,
    SUM(l.loan_amount) AS Total_Loan
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.name;

/* SUBQUERY */
SELECT * FROM Accounts
WHERE balance > (
    SELECT AVG(balance) FROM Accounts
);


UPDATE Accounts 
SET balance = balance + 500 
WHERE account_id = 1;

DELETE FROM Customers 
WHERE city = 'Dhaka';

DELETE FROM Customers
WHERE customer_id = 6;

DROP TABLE Employees;

/* TCL */
START TRANSACTION;
UPDATE Accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE Accounts SET balance = balance + 500 WHERE account_id = 2;
COMMIT;

START TRANSACTION;
UPDATE Accounts SET balance = balance - 500 WHERE account_id = 1;
ROLLBACK;

select * from accounts;

