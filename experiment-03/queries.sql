-- =====================================================
-- Experiment 3: Employee-Department-Project Schema
-- Selection, Projection, Aggregates, GROUP BY, HAVING, CASE, ORDER BY
-- Database: CompanyDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- =====================================================
-- 1. TABLE CREATION
-- =====================================================

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget DECIMAL(12,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    hire_date DATE,
    dept_id INT,
    project_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

-- =====================================================
-- 2. INSERT SAMPLE DATA
-- =====================================================

-- Insert 5 Departments
INSERT INTO Department VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations');

-- Insert 8 Projects
INSERT INTO Project VALUES
(101, 'Cloud Migration', 150000, 1),
(102, 'AI Analytics', 200000, 1),
(103, 'Recruitment Portal', 80000, 2),
(104, 'Financial Dashboard', 120000, 3),
(105, 'Digital Campaign', 90000, 4),
(106, 'Supply Chain System', 180000, 5),
(107, 'Mobile Application', 140000, 1),
(108, 'Employee Wellness', 60000, 2);

-- Insert 30 Employees
INSERT INTO Employee VALUES
(1, 'Rahul', 68000, '2022-02-14', 1, 101),
(2, 'Kunal', 75000, '2021-04-20', 1, 102),
(3, 'Amit', 61000, '2023-07-12', 1, 107),
(4, 'Siddharth', 85000, '2020-09-18', 1, 101),
(5, 'Varun', 71000, '2022-12-08', 1, 102),
(6, 'Harsh', 64000, '2024-03-21', 1, 107),
(7, 'Pooja', 53000, '2022-05-16', 2, 103),
(8, 'Neha', 49000, '2023-02-25', 2, 108),
(9, 'Kavya', 62000, '2021-08-23', 2, 103),
(10, 'Simran', 56000, '2022-10-11', 2, 108),
(11, 'Naina', 48000, '2024-04-17', 2, 103),
(12, 'Ritika', 60000, '2020-12-15', 2, 108),
(13, 'Mohit', 78000, '2021-03-19', 3, 104),
(14, 'Akash', 70000, '2022-06-13', 3, 104),
(15, 'Gaurav', 86000, '2019-11-25', 3, 104),
(16, 'Deepak', 65000, '2023-09-14', 3, 104),
(17, 'Varsha', 73000, '2021-12-05', 3, 104),
(18, 'Rakesh', 57000, '2024-02-12', 3, 104),
(19, 'Shreya', 55000, '2022-03-28', 4, 105),
(20, 'Isha', 65000, '2021-07-22', 4, 105),
(21, 'Payal', 58000, '2023-05-15', 4, 105),
(22, 'Anjali', 68000, '2020-10-09', 4, 105),
(23, 'Sneha', 52000, '2024-03-08', 4, 105),
(24, 'Radhika', 72000, '2023-01-17', 4, 105),
(25, 'Abhishek', 62000, '2021-02-16', 5, 106),
(26, 'Saurabh', 75000, '2020-05-27', 5, 106),
(27, 'Nitin', 69000, '2022-08-21', 5, 106),
(28, 'Prateek', 61000, '2023-06-30', 5, 106),
(29, 'Sumit', 79000, '2019-09-12', 5, 106),
(30, 'Akshat', 66000, '2024-02-22', 5, 106);

-- =====================================================
-- 3. SQL QUERIES
-- =====================================================

-- 3.1 Selection
-- Display employees whose salary is greater than 70,000
SELECT *
FROM Employee
WHERE salary > 70000;

-- 3.2 Projection
-- Display only employee names and salaries
SELECT emp_name, salary
FROM Employee;

-- 3.3 Aggregate Functions
-- Find total employees, average salary, maximum salary, minimum salary, and total salary
SELECT
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary,
    SUM(salary) AS total_salary
FROM Employee;

-- 3.4 GROUP BY
-- Display the number of employees and average salary in each department
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- 3.5 HAVING
-- Display departments whose average salary is greater than 65,000
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department d
JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 65000;

-- 3.6 CASE Expression
-- Classify employees according to their salary
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 75000 THEN 'High Salary'
        WHEN salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;

-- 3.7 ORDER BY
-- Display employees in descending order of salary
SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC;

-- 3.8 JOIN (Employee, Department, Project)
-- Display employee name, department, project, and salary
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id
JOIN Project p ON e.project_id = p.project_id
ORDER BY d.dept_name, e.emp_name;
