-- =====================================================
-- Experiment 8: Transactions, ACID Properties & Concurrency Isolation
-- START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT & Isolation Levels
-- Database: BankingDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS BankingDB;
USE BankingDB;

-- =====================================================
-- 1. TABLE CREATION & INITIAL SEEDING
-- =====================================================

-- Accounts table storing customer balances
CREATE TABLE IF NOT EXISTS Accounts (
    account_no   INT PRIMARY KEY,
    holder_name  VARCHAR(100) NOT NULL,
    account_type VARCHAR(20)  NOT NULL,
    balance      DECIMAL(12, 2) NOT NULL CHECK (balance >= 0)
);

-- Transaction log table for audit trails
CREATE TABLE IF NOT EXISTS Transaction_Logs (
    log_id       INT AUTO_INCREMENT PRIMARY KEY,
    from_acc     INT,
    to_acc       INT,
    amount       DECIMAL(12, 2),
    status       VARCHAR(20),
    log_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed initial accounts
INSERT INTO Accounts (account_no, holder_name, account_type, balance) VALUES
(101, 'Ananya Gupta',   'Savings',  62000.00),
(102, 'Rohan Malhotra', 'Savings',  41000.00),
(103, 'Divya Nair',     'Current',  88000.00);

SELECT * FROM Accounts;

-- =====================================================
-- 2. SUCCESSFUL TRANSACTION WITH COMMIT
-- Transfer ₹10,000 from Account 101 to Account 102
-- =====================================================

START TRANSACTION;

-- Step 1: Debit from Account 101
UPDATE Accounts 
SET balance = balance - 10000.00 
WHERE account_no = 101;

-- Step 2: Credit to Account 102
UPDATE Accounts 
SET balance = balance + 10000.00 
WHERE account_no = 102;

-- Step 3: Record transaction in audit log
INSERT INTO Transaction_Logs (from_acc, to_acc, amount, status) 
VALUES (101, 102, 10000.00, 'SUCCESS');

-- Commit all changes permanently
COMMIT;

SELECT * FROM Accounts;

-- =====================================================
-- 3. FAILED TRANSACTION WITH COMPLETE ROLLBACK
-- Attempt to transfer ₹60,000 from Account 101 to Account 103 (Insufficient funds)
-- =====================================================

START TRANSACTION;

-- Step 1: Attempt to debit an amount higher than current balance
UPDATE Accounts 
SET balance = balance - 60000.00 
WHERE account_no = 101;

-- If application detects error or constraint check fails:
ROLLBACK;

SELECT * FROM Accounts WHERE account_no IN (101, 103);

-- =====================================================
-- 4. PARTIAL FAILURE RECOVERY USING SAVEPOINT
-- Batch process: Transfer 1 succeeds, Transfer 2 fails, rollback to savepoint
-- =====================================================

START TRANSACTION;

-- Valid Transfer 1: 101 -> 102 (₹5,000)
UPDATE Accounts SET balance = balance - 5000.00 WHERE account_no = 101;
UPDATE Accounts SET balance = balance + 5000.00 WHERE account_no = 102;
INSERT INTO Transaction_Logs (from_acc, to_acc, amount, status) 
VALUES (101, 102, 5000.00, 'SUCCESS');

-- Set Savepoint
SAVEPOINT sp_transfer1;

-- Invalid Transfer 2: Target account does not exist
UPDATE Accounts SET balance = balance - 10000.00 WHERE account_no = 101;
UPDATE Accounts SET balance = balance + 10000.00 WHERE account_no = 999; -- 0 rows affected

-- Application detects that target account does not exist; rolls back Transfer 2 only
ROLLBACK TO SAVEPOINT sp_transfer1;

-- Log the partial failure
INSERT INTO Transaction_Logs (from_acc, to_acc, amount, status) 
VALUES (101, 999, 10000.00, 'FAILED_INVALID_ACC');

-- Commit remaining valid operations
COMMIT;

SELECT * FROM Accounts;
SELECT * FROM Transaction_Logs;

-- =====================================================
-- 5. CONCURRENCY ANOMALIES & ISOLATION LEVELS (TWO SESSIONS)
-- =====================================================

-- Scenario A: Dirty Read Demonstration (READ UNCOMMITTED)
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Accounts SET balance = 90000.00 WHERE account_no = 101;
-- Session 2 reads uncommitted value
-- SELECT balance FROM Accounts WHERE account_no = 101;
-- Session 1 rolls back
ROLLBACK;

-- Scenario B: Non-Repeatable Read Demonstration (READ COMMITTED)
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT balance FROM Accounts WHERE account_no = 102;
-- Session 2 commits an update in between
-- UPDATE Accounts SET balance = balance + 5000.00 WHERE account_no = 102; COMMIT;
-- Session 1 reads again and gets different value
SELECT balance FROM Accounts WHERE account_no = 102;
COMMIT;

-- Scenario C: Phantom Read Demonstration & Resolution (REPEATABLE READ vs SERIALIZABLE)
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM Accounts WHERE balance >= 50000.00;
-- Session 2 attempts insert and blocks waiting for range lock
-- INSERT INTO Accounts VALUES (105, 'Karan Roy', 'Savings', 70000.00);
COMMIT;
