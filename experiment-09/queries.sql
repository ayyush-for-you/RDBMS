-- =====================================================
-- Experiment 9: Single-Column & Composite Indexing Performance
-- Benchmarking Query Execution & EXPLAIN Analysis
-- Database: RailwayDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS RailwayDB;
USE RailwayDB;

-- =====================================================
-- 1. SCHEMA DEFINITION
-- =====================================================

CREATE TABLE IF NOT EXISTS Railway_Bookings (
    booking_id       INT AUTO_INCREMENT PRIMARY KEY,
    pnr_no           VARCHAR(12) NOT NULL,
    train_no         INT NOT NULL,
    train_name       VARCHAR(100) NOT NULL,
    passenger_name   VARCHAR(100) NOT NULL,
    age              INT,
    gender           CHAR(1),
    travel_date      DATE NOT NULL,
    source_station   VARCHAR(50) NOT NULL,
    dest_station     VARCHAR(50) NOT NULL,
    coach_class      VARCHAR(10) NOT NULL,     -- '1A', '2A', '3A', 'SL', 'CC'
    fare             DECIMAL(8,2) NOT NULL,
    booking_status   VARCHAR(15) NOT NULL,     -- 'CONFIRMED', 'RAC', 'WAITLIST'
    booking_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. POPULATE 5,000+ SYNTHETIC RECORDS
-- =====================================================

DELIMITER $$

CREATE PROCEDURE PopulateBookings(IN total_rows INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_pnr VARCHAR(12);
    DECLARE rand_train INT;
    DECLARE rand_class VARCHAR(10);
    DECLARE rand_status VARCHAR(15);
    DECLARE rand_date DATE;
    
    -- Disable autocommit for fast bulk insertion
    SET autocommit = 0;
    
    WHILE i <= total_rows DO
        SET rand_pnr    = LPAD(FLOOR(1000000000 + (RAND() * 9000000000)), 10, '0');
        SET rand_train  = 12000 + FLOOR(RAND() * 50); -- Train numbers 12000 - 12049
        SET rand_class  = ELT(FLOOR(1 + (RAND() * 5)), '1A', '2A', '3A', 'SL', 'CC');
        SET rand_status = ELT(FLOOR(1 + (RAND() * 3)), 'CONFIRMED', 'RAC', 'WAITLIST');
        SET rand_date   = DATE_ADD('2026-06-01', INTERVAL FLOOR(RAND() * 90) DAY);
        
        INSERT INTO Railway_Bookings (
            pnr_no, train_no, train_name, passenger_name, age, gender,
            travel_date, source_station, dest_station, coach_class, fare, booking_status
        ) VALUES (
            rand_pnr,
            rand_train,
            CONCAT('Express-', rand_train),
            CONCAT('Passenger_', i),
            18 + FLOOR(RAND() * 60),
            IF(RAND() > 0.5, 'M', 'F'),
            rand_date,
            ELT(FLOOR(1 + (RAND() * 4)), 'New Delhi', 'Mumbai CST', 'Howrah', 'Chennai Central'),
            ELT(FLOOR(1 + (RAND() * 4)), 'Bangalore City', 'Ahmedabad', 'Pune', 'Secunderabad'),
            rand_class,
            500.00 + (RAND() * 2500.00),
            rand_status
        );
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
    SET autocommit = 1;
END$$

DELIMITER ;

-- Call procedure to insert 5,000 records
CALL PopulateBookings(5000);

-- Verify total row count
SELECT COUNT(*) AS total_bookings FROM Railway_Bookings;

-- =====================================================
-- 3. SINGLE-COLUMN LOOKUP (pnr_no)
-- =====================================================

-- Select a sample PNR from the table for testing
SELECT pnr_no FROM Railway_Bookings LIMIT 1;

-- (A) Before Index (Full Table Scan)
EXPLAIN SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';

-- (B) Create Single-Column Index
CREATE INDEX idx_pnr ON Railway_Bookings (pnr_no);

-- (C) After Index (Const/Ref Lookup)
EXPLAIN SELECT * FROM Railway_Bookings WHERE pnr_no = '4829104821';

-- =====================================================
-- 4. MULTI-COLUMN FILTERING & RANGE QUERY
-- =====================================================

-- Target Query: Chart preparation query fetching confirmed passengers
SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';

-- (A) Before Composite Index
EXPLAIN SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';

-- (B) Create Composite Index
CREATE INDEX idx_train_date_status 
ON Railway_Bookings (train_no, travel_date, booking_status);

-- (C) After Composite Index
EXPLAIN SELECT passenger_name, coach_class, fare 
FROM Railway_Bookings 
WHERE train_no = 12015 
  AND travel_date = '2026-07-15' 
  AND booking_status = 'CONFIRMED';
