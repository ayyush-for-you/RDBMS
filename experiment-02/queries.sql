-- =====================================================
-- Experiment 2: Relational Schema & Integrity Constraints
-- Database: IndianEcommerceDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS IndianEcommerceDB;
USE IndianEcommerceDB;

-- =====================================================
-- 1. TABLE CREATION WITH CONSTRAINTS
-- =====================================================

-- Category Table
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Seller Table
CREATE TABLE Seller (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(50),
    state VARCHAR(50),
    gst_number VARCHAR(20) NOT NULL UNIQUE
);

-- Product Table
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_qty INT DEFAULT 0,
    seller_id INT,
    category_id INT,
    FOREIGN KEY (seller_id) REFERENCES Seller(seller_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL
);

-- Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(12, 2),
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

-- Order_Item Table
CREATE TABLE Order_Item (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE SET NULL
);

-- Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    order_id INT UNIQUE,
    payment_date DATE,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

-- Review Table
CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    rating INT NOT NULL,
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

-- =====================================================
-- 2. INSERT SAMPLE DATA
-- =====================================================

-- Insert Categories
INSERT INTO Category (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home & Kitchen'),
(4, 'Books'),
(5, 'Beauty & Health'),
(6, 'Sports & Fitness');

-- Insert Sellers
INSERT INTO Seller (seller_id, seller_name, email, phone, city, state, gst_number) VALUES
(1, 'DigitalWorld', 'sales@digitalworld.in', '9812345670', 'Pune', 'Maharashtra', '27ABCDE1234F1Z5'),
(2, 'StyleHub', 'contact@stylehub.in', '9823456781', 'Delhi', 'Delhi', '07FGHIJ5678K2Y6'),
(3, 'HomeComfort', 'info@homecomfort.in', '9834567892', 'Jaipur', 'Rajasthan', '08KLMNO9012L3X7'),
(4, 'BookNest', 'orders@booknest.in', '9845678903', 'Patna', 'Bihar', '10PQRST3456M4W8'),
(5, 'NatureCare', 'support@naturecare.in', '9856789014', 'Bhopal', 'Madhya Pradesh', '23UVWXY7890N5V9');

-- Insert Products
INSERT INTO Product (product_id, product_name, price, stock_qty, seller_id, category_id) VALUES
(101, 'Samsung Galaxy Buds FE', 4999.00, 100, 1, 1),
(102, 'OnePlus Nord CE 4', 24999.00, 50, 1, 1),
(103, 'Fire-Boltt Phoenix Smartwatch', 1799.00, 90, 1, 1),
(104, 'Peter England Casual Shirt', 1499.00, 180, 2, 2),
(105, 'Biba Printed Kurti Set', 2199.00, 130, 2, 2),
(106, 'Bajaj Electric Kettle', 1299.00, 75, 3, 3),
(107, 'Cello Stainless Steel Bottle 1L', 599.00, 250, 3, 3),
(108, 'Hawkins Pressure Cooker 5L', 2299.00, 85, 3, 3),
(109, 'The Alchemist by Paulo Coelho', 350.00, 400, 4, 4),
(110, 'Atomic Habits by James Clear', 450.00, 300, 4, 4),
(111, 'Nivea Men Face Wash 100ml', 175.00, 350, 5, 5),
(112, 'Lakme Vitamin C Serum', 699.00, 220, 5, 5),
(113, 'Cosco Football Size 5', 799.00, 110, 1, 6),
(114, 'Strauss Anti-Slip Yoga Mat', 649.00, 160, 3, 6),
(115, 'Adidas Running Shoes', 4999.00, 65, 2, 6);

-- Insert Customers
INSERT INTO Customer (customer_id, name, email, phone, city, state, registration_date) VALUES
(1, 'Rahul Verma', 'rahul.verma@gmail.com', '9810012001', 'Mumbai', 'Maharashtra', '2023-02-15'),
(2, 'Priya Shah', 'priya.shah@yahoo.com', '9810012002', 'Surat', 'Gujarat', '2023-04-12'),
(3, 'Amit Kumar', 'amit.kumar@gmail.com', '9810012003', 'Patna', 'Bihar', '2022-10-20'),
(4, 'Sneha Menon', 'sneha.menon@outlook.com', '9810012004', 'Kozhikode', 'Kerala', '2023-07-25'),
(5, 'Vikram Rao', 'vikram.rao@gmail.com', '9810012005', 'Warangal', 'Telangana', '2022-09-18'),
(6, 'Pooja Nair', 'pooja.nair@gmail.com', '9810012006', 'Coimbatore', 'Tamil Nadu', '2024-02-10'),
(7, 'Karan Malhotra', 'karan.malhotra@yahoo.com', '9810012007', 'Amritsar', 'Punjab', '2023-10-05'),
(8, 'Riya Sen', 'riya.sen@gmail.com', '9810012008', 'Siliguri', 'West Bengal', '2023-05-19'),
(9, 'Aditya Jain', 'aditya.jain@outlook.com', '9810012009', 'Nagpur', 'Maharashtra', '2022-12-10'),
(10, 'Neha Singh', 'neha.singh@gmail.com', '9810012010', 'Indore', 'Madhya Pradesh', '2024-06-21');

-- Insert Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, order_status) VALUES
(1001, 1, '2024-05-12', 29998.00, 'Delivered'),
(1002, 2, '2024-05-20', 2199.00, 'Delivered'),
(1003, 3, '2024-06-05', 800.00, 'Shipped'),
(1004, 4, '2024-06-18', 1799.00, 'Delivered'),
(1005, 5, '2024-07-02', 3598.00, 'Processing'),
(1006, 6, '2024-07-15', 599.00, 'Delivered'),
(1007, 7, '2024-07-28', 9998.00, 'Shipped'),
(1008, 8, '2024-08-10', 2299.00, 'Delivered'),
(1009, 9, '2024-08-25', 24999.00, 'Delivered'),
(1010, 10, '2024-09-08', 799.00, 'Cancelled'),
(1011, 1, '2024-09-19', 450.00, 'Delivered'),
(1012, 3, '2024-10-05', 4999.00, 'Processing');

-- Insert Order Items
INSERT INTO Order_Item (item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 102, 1, 24999.00),
(2, 1001, 101, 1, 4999.00),
(3, 1002, 105, 1, 2199.00),
(4, 1003, 109, 1, 350.00),
(5, 1003, 110, 1, 450.00),
(6, 1004, 103, 1, 1799.00),
(7, 1005, 106, 1, 1299.00),
(8, 1005, 108, 1, 2299.00),
(9, 1006, 107, 1, 599.00),
(10, 1007, 101, 2, 4999.00),
(11, 1008, 108, 1, 2299.00),
(12, 1009, 102, 1, 24999.00),
(13, 1010, 113, 1, 799.00),
(14, 1011, 110, 1, 450.00),
(15, 1012, 101, 1, 4999.00);

-- Insert Payments
INSERT INTO Payment (payment_id, order_id, payment_date, payment_method, amount, payment_status) VALUES
(1, 1001, '2024-05-12', 'UPI', 29998.00, 'Success'),
(2, 1002, '2024-05-20', 'Credit Card', 2199.00, 'Success'),
(3, 1003, '2024-06-05', 'Debit Card', 800.00, 'Success'),
(4, 1004, '2024-06-18', 'UPI', 1799.00, 'Success'),
(5, 1005, '2024-07-02', 'Net Banking', 3598.00, 'Success'),
(6, 1006, '2024-07-15', 'Cash on Delivery', 599.00, 'Success'),
(7, 1007, '2024-07-28', 'UPI', 9998.00, 'Success'),
(8, 1008, '2024-08-10', 'Credit Card', 2299.00, 'Success'),
(9, 1009, '2024-08-25', 'EMI', 24999.00, 'Success'),
(10, 1010, '2024-09-08', 'UPI', 799.00, 'Refunded'),
(11, 1011, '2024-09-19', 'UPI', 450.00, 'Success'),
(12, 1012, '2024-10-05', 'Debit Card', 4999.00, 'Pending');

-- Insert Reviews
INSERT INTO Review (review_id, product_id, customer_id, rating, review_text, review_date) VALUES
(1, 102, 1, 5, 'Excellent phone with impressive performance.', '2024-05-22'),
(2, 101, 1, 4, 'Clear audio and comfortable fit.', '2024-05-24'),
(3, 105, 2, 5, 'Beautiful design and great fabric quality!', '2024-05-28'),
(4, 109, 3, 4, 'An interesting and inspiring book.', '2024-06-12'),
(5, 103, 4, 4, 'Good smartwatch with useful features.', '2024-06-25'),
(6, 106, 5, 3, 'Works well but takes time to boil water.', '2024-07-10'),
(7, 107, 6, 5, 'Durable bottle with excellent insulation.', '2024-07-20'),
(8, 108, 8, 4, 'Reliable cooker and easy to use.', '2024-08-18'),
(9, 102, 9, 5, 'Smooth performance and excellent battery life.', '2024-09-02'),
(10, 101, 7, 5, 'Great sound quality for everyday use.', '2024-08-05');

-- =====================================================
-- 3. INTEGRITY CONSTRAINT VIOLATIONS & DEMONSTRATION
-- =====================================================

-- 3.1 FOREIGN KEY Violation
-- Attempting to insert an order with non-existent customer_id (99)
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, order_status)
VALUES (1099, 99, '2024-10-15', 2500.00, 'Processing');

-- Attempting to insert a product with non-existent seller_id (50)
INSERT INTO Product (product_id, product_name, price, stock_qty, seller_id, category_id)
VALUES (200, 'Fake Product', 999.00, 10, 50, 1);

-- 3.2 UNIQUE Constraint Violation
-- Attempting to duplicate an existing customer's email
INSERT INTO Customer (customer_id, name, email, phone, city, state, registration_date)
VALUES (11, 'Duplicate User', 'aarav.sharma@gmail.com', '9999999999', 'Delhi', 'Delhi', '2024-10-20');

-- 3.3 NOT NULL Constraint Violation
-- Attempting to insert a seller with a NULL GST number
INSERT INTO Seller (seller_id, seller_name, email, phone, city, state, gst_number)
VALUES (6, 'NoGST Seller', 'nogst@seller.in', '9000000001', 'Patna', 'Bihar', NULL);

-- 3.4 ON DELETE CASCADE Demonstration
-- Verify products of Seller ID 4 (BookNest) before deletion
SELECT product_id, product_name, seller_id FROM Product WHERE seller_id = 4;

-- Delete Seller ID 4 (should automatically delete associated products)
DELETE FROM Seller WHERE seller_id = 4;

-- Verify that products of Seller ID 4 were automatically deleted
SELECT product_id, product_name, seller_id FROM Product WHERE seller_id = 4;

-- 3.5 ON DELETE SET NULL Demonstration
-- Verify products in Category ID 6 (Sports & Fitness) before deletion
SELECT product_id, product_name, category_id FROM Product WHERE category_id = 6;

-- Delete Category ID 6 (should set category_id to NULL on associated products)
DELETE FROM Category WHERE category_id = 6;

-- Verify that category_id was updated to NULL
SELECT product_id, product_name, category_id FROM Product
WHERE product_id IN (113, 114, 115);

-- 3.6 UNIQUE Constraint Violation (Duplicate Payment)
-- Attempting to insert a second payment for an order that already has one
INSERT INTO Payment (payment_id, order_id, payment_date, payment_method, amount, payment_status)
VALUES (99, 1001, '2024-10-20', 'UPI', 19498.00, 'Success');
