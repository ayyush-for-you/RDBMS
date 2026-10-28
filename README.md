# RDBMS

Lab programs for the RDBMS course, with the SQL and the output of each experiment.

**Name:** Ayush Kumar  
**Section:** AIML-4(B)  
**Roll number:** 25LBCS3142  

---

## Overview

The experiments in this repository cover database design and SQL programming across two relational databases:

1. **`IndianEcommerceDB`** (Experiments 1–2): E-commerce domain modeling, relational schema conversion, primary & foreign keys, constraints, and referential integrity violations (`ON DELETE CASCADE`, `ON DELETE SET NULL`).
2. **`CompanyDB`** (Experiments 3–6): Enterprise Employee–Department–Project schema demonstrating advanced SQL constructs, query execution plans, updatable views, recursive common table expressions (CTEs), transactions, stored procedures, and triggers.

---

## Execution Order

Run the scripts in numerical order using MySQL:

1. [Experiment 1 — ER Diagram](experiment-01/README.md)
2. [Experiment 2 — Relational Schema & Constraints (`IndianEcommerceDB`)](experiment-02/queries.sql)
3. [Experiment 3 — Basic Queries & Aggregations (`CompanyDB`)](experiment-03/queries.sql)
4. [Experiment 4 — Joins & Subqueries (`CompanyDB`)](experiment-04/queries.sql)
5. [Experiment 5 — Views & Recursive CTE (`CompanyDB`)](experiment-05/queries.sql)
6. [Experiment 6 — Stored Procedures & Triggers (`CompanyDB`)](experiment-06/queries.sql)

---

## Experiments

### Experiment 1 — ER Diagram for Indian E-Commerce Platform

Design an Entity-Relationship (ER) diagram for an Indian e-commerce platform incorporating Customer, Product, Order, OrderItem, Seller, Category, Payment, Delivery, and Address entities. Models composite and multi-valued attributes, weak entities (`order_item`), specialization of `Product` into `electronics` and `clothing` with disjoint total `(d, t)` constraints, and relationship cardinalities.

- Documentation & Diagram: [experiment-01/README.md](experiment-01/README.md)
- ER Diagram Image: [experiment-01/er-diagram.png](experiment-01/er-diagram.png)

---

### Experiment 2 — Relational Schema & Integrity Constraints

Convert the e-commerce ER diagram into a normalized relational schema (`IndianEcommerceDB`). Implement DDL statements with primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `ON DELETE CASCADE`, and `ON DELETE SET NULL`. Insert sample records across 8 relations and demonstrate referential integrity violations.

- Program: [experiment-02/queries.sql](experiment-02/queries.sql)
- Output: [experiment-02/output](experiment-02/output)

---

### Experiment 3 — Selection, Projection, Aggregates, and Grouping

Create an Employee–Department–Project relational schema (`CompanyDB`) with 5 departments, 8 projects, and 30 employees. Formulate SQL queries demonstrating Selection, Projection, Aggregate functions (`COUNT`, `AVG`, `MAX`, `MIN`, `SUM`), `GROUP BY`, `HAVING`, `CASE` conditional expressions, and `ORDER BY`.

- Program: [experiment-03/queries.sql](experiment-03/queries.sql)
- Output: [experiment-03/output](experiment-03/output)

---

### Experiment 4 — Joins, Subqueries, and Execution Plans

Execute relational joins (`INNER JOIN`, `LEFT JOIN`, self-join, 3-way join) on the Company database. Implement correlated subqueries, existence checks using `EXISTS`, and simulate set operations (`INTERSECT`, `EXCEPT`) using nested `IN` / `NOT IN` subqueries. Inspect query performance and execution paths using `EXPLAIN`.

- Program: [experiment-04/queries.sql](experiment-04/queries.sql)
- Output: [experiment-04/output](experiment-04/output)

---

### Experiment 5 — Views and Recursive CTE

Create SQL views for department salary summaries and employee hierarchy. Evaluate view updatability rules against joined and aggregate views. Implement a `WITH RECURSIVE` Common Table Expression (CTE) to traverse self-referencing manager hierarchies and display hierarchical reporting chains.

- Program: [experiment-05/queries.sql](experiment-05/queries.sql)
- Output: [experiment-05/output](experiment-05/output)

---

### Experiment 6 — Stored Procedures, Triggers, and Audit Logging

Implement the stored procedure `transfer_employee(emp_id, new_dept_id)` with input validation, exception handling, and transaction control (`START TRANSACTION`, `COMMIT`, `ROLLBACK`). Define `BEFORE INSERT` and `BEFORE UPDATE` triggers to enforce salary bounds (30,000 to 1,50,000) and an `AFTER UPDATE` trigger to log salary history in `Employee_Salary_Audit`.

- Program: [experiment-06/queries.sql](experiment-06/queries.sql)
- Output: [experiment-06/output](experiment-06/output)
