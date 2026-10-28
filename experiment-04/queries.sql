-- =====================================================
-- Experiment 4: Joins, Subqueries & Execution Plans
-- Database: CompanyDB
-- Pre-requisite: Run Experiment 3 first
-- =====================================================

USE CompanyDB;

-- =====================================================
-- 1. INNER JOIN
-- Display employee IDs, names, salaries, and department names
-- =====================================================

SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    d.dept_name
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- =====================================================
-- 2. LEFT JOIN
-- Display all departments and any matching employees
-- =====================================================

SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name,
    e.salary
FROM Department d
LEFT JOIN Employee e ON d.dept_id = e.dept_id
ORDER BY d.dept_id, e.emp_id;

-- =====================================================
-- 3. SELF JOIN
-- Compare pairs of employees belonging to the same department
-- =====================================================

SELECT
    e1.emp_name AS employee_1,
    e2.emp_name AS employee_2,
    e1.dept_id,
    e1.salary AS salary_1,
    e2.salary AS salary_2
FROM Employee e1
INNER JOIN Employee e2
    ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id
ORDER BY e1.dept_id, e1.emp_id, e2.emp_id
LIMIT 10;

-- =====================================================
-- 4. 3-WAY JOIN
-- Display employee name, department, project, and salary
-- =====================================================

SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id
INNER JOIN Project p ON e.project_id = p.project_id
ORDER BY d.dept_name, e.emp_name;

-- =====================================================
-- 5. CORRELATED SUBQUERY
-- Display employees whose salary is strictly greater than their department's average salary
-- =====================================================

SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    e.dept_id
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
)
ORDER BY e.dept_id, e.salary DESC;

-- =====================================================
-- 6. EXISTS
-- Find departments that have at least one employee earning over 80,000
-- =====================================================

SELECT
    d.dept_id,
    d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id AND e.salary > 80000
)
ORDER BY d.dept_id;

-- =====================================================
-- 7. SIMULATED INTERSECT
-- Select employees who belong to IT (dept_id = 1) AND earn > 70,000
-- =====================================================

SELECT emp_id, emp_name, salary
FROM Employee
WHERE emp_id IN (
    SELECT emp_id FROM Employee WHERE dept_id = 1
)
AND emp_id IN (
    SELECT emp_id FROM Employee WHERE salary > 70000
)
ORDER BY emp_id;

-- =====================================================
-- 8. SIMULATED EXCEPT
-- Select employees earning > 70,000 EXCEPT those in IT (dept_id = 1)
-- =====================================================

SELECT emp_id, emp_name, salary
FROM Employee
WHERE emp_id IN (
    SELECT emp_id FROM Employee WHERE salary > 70000
)
AND emp_id NOT IN (
    SELECT emp_id FROM Employee WHERE dept_id = 1
)
ORDER BY emp_id;

-- =====================================================
-- 9. EXPLAIN – EXECUTION PLAN COMPARISON
-- =====================================================

-- EXPLAIN for INNER JOIN
EXPLAIN SELECT
    e.emp_name, d.dept_name
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id
WHERE e.salary > 70000;

-- EXPLAIN for Correlated Subquery
EXPLAIN SELECT
    e.emp_name, e.salary
FROM Employee e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

-- EXPLAIN for EXISTS
EXPLAIN SELECT
    d.dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id AND e.salary > 80000
);
