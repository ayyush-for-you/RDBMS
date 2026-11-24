-- =====================================================
-- Experiment 10: Query Optimization, Anti-Patterns & Execution Plans
-- 5 Performance Anti-Patterns vs. Optimized Queries
-- Database: OptimizationDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS OptimizationDB;
USE OptimizationDB;

-- =====================================================
-- 1. SCHEMA DEFINITION
-- =====================================================

DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_name   VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    city            VARCHAR(50)  NOT NULL,
    signup_date     DATE         NOT NULL
);

CREATE TABLE Orders (
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      DATETIME NOT NULL,
    order_status    VARCHAR(20) NOT NULL,    -- 'COMPLETED', 'PENDING', 'CANCELLED'
    payment_method  VARCHAR(20) NOT NULL,    -- 'CREDIT_CARD', 'UPI', 'NET_BANKING', 'COD'
    total_amount    DECIMAL(10,2) NOT NULL,
    shipping_city   VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- =====================================================
-- 2. DATA GENERATION: POPULATING 10,000+ ROWS
-- =====================================================

DROP PROCEDURE IF EXISTS GenerateEcommerceData;
DELIMITER $$
CREATE PROCEDURE GenerateEcommerceData()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_cust_id INT;
    DECLARE rand_status VARCHAR(20);
    DECLARE rand_payment VARCHAR(20);
    DECLARE rand_city VARCHAR(50);
    DECLARE rand_amount DECIMAL(10,2);
    DECLARE rand_dt DATETIME;
    SET autocommit = 0;

    -- Insert 2,000 Customers
    WHILE i <= 2000 DO
        INSERT INTO Customers (customer_name, email, city, signup_date)
        VALUES (
            CONCAT('Customer_', i),
            CONCAT('user', i, '@', ELT(FLOOR(1 + RAND() * 4), 'gmail.com', 'yahoo.com', 'outlook.com', 'company.in')),
            ELT(FLOOR(1 + RAND() * 5), 'Mumbai', 'Delhi', 'Bangalore', 'Pune', 'Hyderabad'),
            DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 700) DAY)
        );
        SET i = i + 1;
    END WHILE;
    COMMIT;
    
    -- Insert 12,000 Orders
    SET i = 1;
    WHILE i <= 12000 DO
        SET rand_cust_id = 1 + FLOOR(RAND() * 2000);
        SET rand_status  = ELT(FLOOR(1 + RAND() * 3), 'COMPLETED', 'PENDING', 'CANCELLED');
        SET rand_payment = ELT(FLOOR(1 + RAND() * 4), 'CREDIT_CARD', 'UPI', 'NET_BANKING', 'COD');
        SET rand_city    = ELT(FLOOR(1 + RAND() * 5), 'Mumbai', 'Delhi', 'Bangalore', 'Pune', 'Hyderabad');
        SET rand_amount  = ROUND(100.00 + (RAND() * 9900.00), 2);
        SET rand_dt      = DATE_ADD('2024-01-01 08:00:00', INTERVAL FLOOR(RAND() * 730 * 24 * 60) MINUTE);
        
        INSERT INTO Orders (customer_id, order_date, order_status, payment_method, total_amount, shipping_city)
        VALUES (rand_cust_id, rand_dt, rand_status, rand_payment, rand_amount, rand_city);
        
        SET i = i + 1;
    END WHILE;
    COMMIT;
    
    SET autocommit = 1;
END$$
DELIMITER ;

CALL GenerateEcommerceData();

-- Verify row counts
SELECT 'Customers' AS entity, COUNT(*) AS count FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders;

-- =====================================================
-- 3. QUERY 1: Non-SARGable Function vs. SARGable Range Filter
-- =====================================================

-- SLOW: Function on indexed column prevents index usage
SELECT COUNT(*), SUM(total_amount) 
FROM Orders 
WHERE YEAR(order_date) = 2025;

EXPLAIN SELECT COUNT(*), SUM(total_amount) FROM Orders WHERE YEAR(order_date) = 2025;

-- Optimization:
CREATE INDEX idx_orders_order_date ON Orders(order_date);

-- OPTIMIZED: Range filter enables index seek
SELECT COUNT(*), SUM(total_amount) 
FROM Orders 
WHERE order_date >= '2025-01-01 00:00:00' 
  AND order_date < '2026-01-01 00:00:00';

EXPLAIN SELECT COUNT(*), SUM(total_amount) 
FROM Orders 
WHERE order_date >= '2025-01-01 00:00:00' 
  AND order_date < '2026-01-01 00:00:00';

-- =====================================================
-- 4. QUERY 2: Leading Wildcard vs. Prefix Search
-- =====================================================

-- SLOW: Leading wildcard forces full table scan
SELECT customer_id, customer_name, email 
FROM Customers 
WHERE email LIKE '%@gmail.com';

EXPLAIN SELECT customer_id, customer_name, email FROM Customers WHERE email LIKE '%@gmail.com';

-- Optimization:
CREATE INDEX idx_customers_email ON Customers(email);

-- OPTIMIZED: Prefix search utilizes B-Tree index
SELECT customer_id, customer_name, email 
FROM Customers 
WHERE email LIKE 'user100%';

EXPLAIN SELECT customer_id, customer_name, email 
FROM Customers 
WHERE email LIKE 'user100%';

-- =====================================================
-- 5. QUERY 3: Inefficient NOT IN vs. LEFT JOIN Anti-Join
-- =====================================================

-- SLOW: Customers who have never placed a 'COMPLETED' order
SELECT customer_id, customer_name 
FROM Customers 
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM Orders 
    WHERE order_status = 'COMPLETED'
);

EXPLAIN SELECT customer_id, customer_name 
FROM Customers 
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM Orders 
    WHERE order_status = 'COMPLETED'
);

-- Optimization:
CREATE INDEX idx_orders_cust_status ON Orders(customer_id, order_status);

-- OPTIMIZED: Left anti-join using covering index
SELECT c.customer_id, c.customer_name 
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id 
      AND o.order_status = 'COMPLETED'
WHERE o.order_id IS NULL;

EXPLAIN SELECT c.customer_id, c.customer_name 
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id 
      AND o.order_status = 'COMPLETED'
WHERE o.order_id IS NULL;

-- =====================================================
-- 6. QUERY 4: Unindexed Sort with LIMIT Causing Filesort
-- =====================================================

-- SLOW: Filesort across all completed orders
SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

EXPLAIN SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

-- Optimization:
CREATE INDEX idx_status_amount ON Orders(order_status, total_amount DESC);

-- OPTIMIZED: Directly traverses index in sorted order, stops after 10 rows
SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

EXPLAIN SELECT order_id, customer_id, total_amount, order_date 
FROM Orders 
WHERE order_status = 'COMPLETED' 
ORDER BY total_amount DESC 
LIMIT 10;

-- =====================================================
-- 7. QUERY 5: Unindexed Multi-Table Join & Group By Aggregation
-- =====================================================

-- SLOW: Revenue per customer city with full table join and temp tables
SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;

EXPLAIN SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;

-- Optimization:
CREATE INDEX idx_customers_id_city ON Customers(customer_id, city);
CREATE INDEX idx_orders_covering ON Orders(customer_id, order_status, total_amount);

-- OPTIMIZED: Index-driven join with pre-filtered order aggregate
SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;

EXPLAIN SELECT c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS revenue 
FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
WHERE o.order_status = 'COMPLETED' 
GROUP BY c.city 
ORDER BY revenue DESC;
