-- =====================================================
-- Experiment 7: Schema Normalization (UNF to BCNF)
-- Lossless Join & Dependency Preservation Verification
-- Database: NormalizationDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS NormalizationDB;
USE NormalizationDB;

-- =====================================================
-- 1. DENORMALIZED SALES TABLE (UNF)
-- =====================================================

CREATE TABLE IF NOT EXISTS Sales_UNF (
    order_id         INT,
    order_date       DATE,
    customer_id      INT,
    customer_name    VARCHAR(100),
    customer_city    VARCHAR(100),
    city_state       VARCHAR(100),
    product_id       INT,
    product_name     VARCHAR(100),
    category         VARCHAR(50),
    unit_price       DECIMAL(10,2),
    quantity         INT,
    salesperson_id   INT,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2)
);

-- =====================================================
-- 2. INSERT SAMPLE DATA (DENORMALIZED)
-- =====================================================

INSERT INTO Sales_UNF VALUES
(2001, '2026-06-10', 401, 'Ananya Gupta',   'Bengaluru',  'Karnataka',     601, 'Tablet',  'Electronics', 32000.00, 1, 701, 'Aditya Verma',  4.75),
(2001, '2026-06-10', 401, 'Ananya Gupta',   'Bengaluru',  'Karnataka',     602, 'Webcam',  'Accessories', 2200.00,  2, 701, 'Aditya Verma',  4.75),
(2002, '2026-07-04', 402, 'Rohan Malhotra', 'Chandigarh', 'Punjab',        601, 'Tablet',  'Electronics', 32000.00, 2, 702, 'Divya Nair',    5.25),
(2003, '2026-07-19', 401, 'Ananya Gupta',   'Bengaluru',  'Karnataka',     603, 'USB Hub', 'Accessories', 1200.00,  4, 701, 'Aditya Verma',  4.75),
(2004, '2026-08-02', 403, 'Meera Krishnan', 'Chennai',    'Tamil Nadu',    604, 'Printer', 'Electronics', 14500.00, 1, 703, 'Manish Kapoor', 6.50),
(2005, '2026-08-15', 404, 'Siddharth Rao',  'Hyderabad',  'Telangana',     602, 'Webcam',  'Accessories', 2200.00,  6, 702, 'Divya Nair',    5.25),
(2006, '2026-09-03', 402, 'Rohan Malhotra', 'Chandigarh', 'Punjab',        605, 'Speaker', 'Accessories', 3500.00,  3, 702, 'Divya Nair',    5.25),
(2007, '2026-09-18', 405, 'Kavita Das',     'Kolkata',    'West Bengal',   601, 'Tablet',  'Electronics', 32000.00, 1, 704, 'Shreya Sen',    5.00),
(2008, '2026-10-07', 403, 'Meera Krishnan', 'Chennai',    'Tamil Nadu',    603, 'USB Hub', 'Accessories', 1200.00,  5, 703, 'Manish Kapoor', 6.50),
(2009, '2026-10-22', 406, 'Nikhil Tiwari',  'Lucknow',    'Uttar Pradesh', 604, 'Printer', 'Electronics', 14500.00, 2, 705, 'Varun Bansal',  3.75);

-- View the denormalized table
SELECT * FROM Sales_UNF;

-- =====================================================
-- 3. FIRST NORMAL FORM (1NF)
-- Eliminate repeating groups & define composite primary key
-- Candidate Key: {order_id, product_id}
-- =====================================================

CREATE TABLE IF NOT EXISTS Sales_1NF (
    order_id         INT,
    order_date       DATE,
    customer_id      INT,
    customer_name    VARCHAR(100),
    customer_city    VARCHAR(100),
    city_state       VARCHAR(100),
    product_id       INT,
    product_name     VARCHAR(100),
    category         VARCHAR(50),
    unit_price       DECIMAL(10,2),
    quantity         INT,
    salesperson_id   INT,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2),
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO Sales_1NF SELECT * FROM Sales_UNF;

SELECT * FROM Sales_1NF;

-- =====================================================
-- 4. SECOND NORMAL FORM (2NF)
-- Remove partial dependencies on candidate key {order_id, product_id}
-- =====================================================

-- Table: Orders_2NF (attributes fully dependent on order_id)
CREATE TABLE IF NOT EXISTS Orders_2NF (
    order_id         INT PRIMARY KEY,
    order_date       DATE,
    customer_id      INT,
    customer_name    VARCHAR(100),
    customer_city    VARCHAR(100),
    city_state       VARCHAR(100),
    salesperson_id   INT,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2)
);

INSERT INTO Orders_2NF
SELECT DISTINCT order_id, order_date, customer_id, customer_name,
       customer_city, city_state, salesperson_id, salesperson_name, commission_pct
FROM Sales_1NF;

-- Table: Products_2NF (attributes fully dependent on product_id)
CREATE TABLE IF NOT EXISTS Products_2NF (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    unit_price   DECIMAL(10,2)
);

INSERT INTO Products_2NF
SELECT DISTINCT product_id, product_name, category, unit_price
FROM Sales_1NF;

-- Table: OrderDetails_2NF (attributes dependent on full composite key)
CREATE TABLE IF NOT EXISTS OrderDetails_2NF (
    order_id   INT,
    product_id INT,
    quantity   INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id)   REFERENCES Orders_2NF(order_id),
    FOREIGN KEY (product_id) REFERENCES Products_2NF(product_id)
);

INSERT INTO OrderDetails_2NF
SELECT order_id, product_id, quantity
FROM Sales_1NF;

-- =====================================================
-- 5. THIRD NORMAL FORM (3NF) & BCNF
-- Remove transitive dependencies from Orders_2NF
-- customer_id -> customer_name, customer_city
-- customer_city -> city_state
-- salesperson_id -> salesperson_name, commission_pct
-- =====================================================

-- Table: Customers_3NF
CREATE TABLE IF NOT EXISTS Customers_3NF (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_city VARCHAR(100)
);

INSERT INTO Customers_3NF
SELECT DISTINCT customer_id, customer_name, customer_city
FROM Orders_2NF;

-- Table: Cities_3NF
CREATE TABLE IF NOT EXISTS Cities_3NF (
    customer_city VARCHAR(100) PRIMARY KEY,
    city_state    VARCHAR(100)
);

INSERT INTO Cities_3NF
SELECT DISTINCT customer_city, city_state
FROM Orders_2NF;

-- Table: Salespersons_3NF
CREATE TABLE IF NOT EXISTS Salespersons_3NF (
    salesperson_id   INT PRIMARY KEY,
    salesperson_name VARCHAR(100),
    commission_pct   DECIMAL(4,2)
);

INSERT INTO Salespersons_3NF
SELECT DISTINCT salesperson_id, salesperson_name, commission_pct
FROM Orders_2NF;

-- Table: Orders_3NF
CREATE TABLE IF NOT EXISTS Orders_3NF (
    order_id       INT PRIMARY KEY,
    order_date     DATE,
    customer_id    INT,
    salesperson_id INT,
    FOREIGN KEY (customer_id)    REFERENCES Customers_3NF(customer_id),
    FOREIGN KEY (salesperson_id) REFERENCES Salespersons_3NF(salesperson_id)
);

INSERT INTO Orders_3NF
SELECT DISTINCT order_id, order_date, customer_id, salesperson_id
FROM Orders_2NF;

-- Products_3NF and OrderDetails_3NF
CREATE TABLE IF NOT EXISTS Products_3NF AS SELECT * FROM Products_2NF;
ALTER TABLE Products_3NF ADD PRIMARY KEY (product_id);

CREATE TABLE IF NOT EXISTS OrderDetails_3NF AS SELECT * FROM OrderDetails_2NF;
ALTER TABLE OrderDetails_3NF ADD PRIMARY KEY (order_id, product_id);

-- =====================================================
-- 6. VERIFY LOSSLESS JOIN
-- Reconstruct original data via natural joins
-- =====================================================

CREATE TABLE IF NOT EXISTS Sales_Reconstructed AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.customer_city,
    ct.city_state,
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    od.quantity,
    s.salesperson_id,
    s.salesperson_name,
    s.commission_pct
FROM OrderDetails_3NF od
JOIN Orders_3NF o       ON od.order_id       = o.order_id
JOIN Customers_3NF c    ON o.customer_id     = c.customer_id
JOIN Cities_3NF ct      ON c.customer_city   = ct.customer_city
JOIN Products_3NF p     ON od.product_id     = p.product_id
JOIN Salespersons_3NF s ON o.salesperson_id  = s.salesperson_id;

-- Row count verification
SELECT 'Original' AS source, COUNT(*) AS row_count FROM Sales_1NF
UNION ALL
SELECT 'Reconstructed', COUNT(*) FROM Sales_Reconstructed;

-- Difference check for spurious or missing tuples
(SELECT * FROM Sales_1NF)
EXCEPT
(SELECT * FROM Sales_Reconstructed);

(SELECT * FROM Sales_Reconstructed)
EXCEPT
(SELECT * FROM Sales_1NF);

-- =====================================================
-- 7. VERIFY DEPENDENCY PRESERVATION
-- Ensure each functional dependency is preserved in a single table
-- =====================================================

-- FD1: order_id -> order_date, customer_id, salesperson_id
SELECT order_id
FROM Orders_3NF
GROUP BY order_id
HAVING COUNT(DISTINCT order_date) > 1
    OR COUNT(DISTINCT customer_id) > 1
    OR COUNT(DISTINCT salesperson_id) > 1;

-- FD2: customer_id -> customer_name, customer_city
SELECT customer_id
FROM Customers_3NF
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_name) > 1
    OR COUNT(DISTINCT customer_city) > 1;

-- FD3: customer_city -> city_state
SELECT customer_city
FROM Cities_3NF
GROUP BY customer_city
HAVING COUNT(DISTINCT city_state) > 1;

-- FD4: product_id -> product_name, category, unit_price
SELECT product_id
FROM Products_3NF
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1
    OR COUNT(DISTINCT category) > 1
    OR COUNT(DISTINCT unit_price) > 1;

-- FD5: salesperson_id -> salesperson_name, commission_pct
SELECT salesperson_id
FROM Salespersons_3NF
GROUP BY salesperson_id
HAVING COUNT(DISTINCT salesperson_name) > 1
    OR COUNT(DISTINCT commission_pct) > 1;

-- FD6: order_id, product_id -> quantity
SELECT order_id, product_id
FROM OrderDetails_3NF
GROUP BY order_id, product_id
HAVING COUNT(DISTINCT quantity) > 1;
