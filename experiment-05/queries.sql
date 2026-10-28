-- =====================================================
-- Experiment 5: Views, Updatability & Recursive CTE
-- Database: CompanyDB
-- Pre-requisites: Run Experiments 3 and 4 first
-- =====================================================

USE CompanyDB;

-- =====================================================
-- 1. EXTEND SCHEMA: ADD MANAGER COLUMN
-- =====================================================

ALTER TABLE Employee
ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_manager
FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);

-- Assign manager relationships (Gaurav manages Akash and Mohit)
UPDATE Employee SET manager_id = 15 WHERE emp_id IN (13, 14);

-- =====================================================
-- 2. VIEW: DEPARTMENT SALARY SUMMARY
-- =====================================================

-- Create a view showing employee count, average salary, minimum salary,
-- maximum salary, and total salary for each department
CREATE OR REPLACE VIEW department_salary_summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary,
    SUM(e.salary) AS total_salary
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- Display View
SELECT * FROM department_salary_summary;

-- =====================================================
-- 3. VIEW: EMPLOYEE HIERARCHY
-- =====================================================

-- Create an employee hierarchy view combining employee and department details
CREATE OR REPLACE VIEW employee_hierarchy AS
SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id,
    d.dept_name,
    e.salary
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id;

-- Display View
SELECT * FROM employee_hierarchy
ORDER BY emp_id;

-- =====================================================
-- 4. TEST UPDATABILITY OF VIEWS
-- =====================================================

-- Test 1: Updating complex joined view
UPDATE employee_hierarchy
SET salary = salary + 1000
WHERE emp_id = 6;

-- Check Employee record
SELECT emp_id, emp_name, salary
FROM Employee
WHERE emp_id = 6;

-- Test 2: Updating grouped/aggregate view (expected to fail)
UPDATE department_salary_summary
SET average_salary = average_salary + 1000
WHERE dept_id = 1;

-- =====================================================
-- 5. RECURSIVE CTE: REPORTING CHAIN
-- =====================================================

-- Display hierarchical reporting chains starting from Department Heads (manager_id IS NULL)
WITH RECURSIVE reporting_chain AS (
    -- Anchor Member: Department Heads
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        1 AS level,
        CAST(e.emp_name AS CHAR(500)) AS reporting_path
    FROM Employee e
    WHERE e.manager_id IS NULL

    UNION ALL

    -- Recursive Member: Subordinates
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1,
        CONCAT(rc.reporting_path, ' -> ', e.emp_name)
    FROM Employee e
    JOIN reporting_chain rc ON e.manager_id = rc.emp_id
)
SELECT emp_id, emp_name, manager_id, level, reporting_path
FROM reporting_chain
ORDER BY reporting_path;
