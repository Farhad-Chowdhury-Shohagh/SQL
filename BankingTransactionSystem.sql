-- Project 06: Banking Transaction System
-- DBMS: MySQL

CREATE DATABASE IF NOT EXISTS banking_system;
USE banking_system;

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_holder VARCHAR(100),
    account_number VARCHAR(30) UNIQUE,
    balance DECIMAL(12,2)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_type ENUM('Deposit', 'Withdraw'),
    amount DECIMAL(12,2),
    transaction_date DATE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO accounts (account_holder, account_number, balance) VALUES
('Farhad Chowdhury', 'ACC1001', 10000.00),
('Hasib Zidan', 'ACC1002', 8000.00);

INSERT INTO transactions (account_id, transaction_type, amount, transaction_date) VALUES
(1, 'Deposit', 2000.00, '2026-06-26'),
(2, 'Withdraw', 1000.00, '2026-06-26');

UPDATE accounts SET balance = balance + 2000 WHERE account_id = 1;
UPDATE accounts SET balance = balance - 1000 WHERE account_id = 2;

-- Show transaction history with current balance
SELECT a.account_holder, a.account_number, t.transaction_type,
       t.amount, t.transaction_date, a.balance
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id;
