-- =========================================
-- DATABASE CREATION
-- =========================================

CREATE DATABASE IF NOT EXISTS budget_tracker;

USE budget_tracker;

-- =========================================
-- USERS TABLE
-- =========================================

CREATE TABLE users (
id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(100),
username VARCHAR(50) UNIQUE,
email VARCHAR(100) UNIQUE,
phone VARCHAR(20),
password VARCHAR(255),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- INCOME TABLE
-- =========================================

CREATE TABLE income (


income_id INT PRIMARY KEY AUTO_INCREMENT,

user_id INT,

amount DECIMAL(10,2),

source VARCHAR(100),

income_date DATE,

description TEXT,

FOREIGN KEY (user_id)
REFERENCES users(id)


);

-- =========================================
-- EXPENSE TABLE
-- =========================================

CREATE TABLE expenses (


expense_id INT PRIMARY KEY AUTO_INCREMENT,

user_id INT,

amount DECIMAL(10,2),

category VARCHAR(100),

expense_date DATE,

description TEXT,

FOREIGN KEY (user_id)
REFERENCES users(id)


);

-- =========================================
-- MONTHLY BUDGET TABLE
-- =========================================

CREATE TABLE budget (


budget_id INT PRIMARY KEY AUTO_INCREMENT,

user_id INT,

monthly_budget DECIMAL(10,2),

month_name VARCHAR(20),

year_value INT,

FOREIGN KEY (user_id)
REFERENCES users(id)


);

-- =========================================
-- SAVINGS GOALS TABLE
-- =========================================

CREATE TABLE savings_goals (


goal_id INT PRIMARY KEY AUTO_INCREMENT,

user_id INT,

target_amount DECIMAL(10,2),

current_amount DECIMAL(10,2),

target_date DATE,

FOREIGN KEY (user_id)
REFERENCES users(id)
);

-- =========================================
-- USEFUL QUERIES
-- =========================================

SHOW DATABASES;

USE budget_tracker;

SHOW TABLES;

DESCRIBE users;

DESCRIBE income;

DESCRIBE expenses;

DESCRIBE budget;

DESCRIBE savings_goals;

SELECT * FROM users;

SELECT * FROM income;

SELECT * FROM expenses;

SELECT * FROM budget;

DELETE FROM budget;

DELETE FROM budget;
COMMIT;
SELECT * FROM budget;
DELETE FROM budget
WHERE budget_id = 1;


SELECT * FROM savings_goals;

SELECT SUM(amount) AS total_income
FROM income;

SELECT SUM(amount) AS total_expense
FROM expenses;


INSERT INTO budget
(user_id, monthly_budget, month_name, year_value)

VALUES
(1,10000,'June',2026);

ALTER TABLE users
ADD profile_picture VARCHAR(255);

ALTER TABLE users
ADD reset_token VARCHAR(255);

SELECT email,password
FROM users;


