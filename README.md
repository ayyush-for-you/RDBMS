# RDBMS

Lab programs for the RDBMS course, with the SQL and the output of each experiment.

**Name:** Ayush Kumar  
**Section:** AIML-4(B)  
**Roll number:** 25LBCS3142  

---

## Overview

The experiments in this repository cover database design and SQL programming across six relational databases:

1. **`IndianEcommerceDB`** (Experiments 1–2): E-commerce domain modeling, relational schema conversion, primary & foreign keys, constraints, and referential integrity violations (`ON DELETE CASCADE`, `ON DELETE SET NULL`).
2. **`CompanyDB`** (Experiments 3–6): Enterprise Employee–Department–Project schema demonstrating advanced SQL constructs, query execution plans, updatable views, recursive common table expressions (CTEs), transactions, stored procedures, and triggers.
3. **`NormalizationDB`** (Experiment 7): Functional dependencies and schema normalization from Unnormalized Form (UNF) through 1NF, 2NF, 3NF, to BCNF, with SQL verification of lossless join and dependency preservation.
4. **`BankingDB`** (Experiment 8): Transaction processing and ACID compliance using `START TRANSACTION`, `COMMIT`, `ROLLBACK`, and `SAVEPOINT`, along with concurrency anomalies (Dirty Read, Non-Repeatable Read, Phantom Read) and transaction isolation levels.
5. **`RailwayDB`** (Experiment 9): Performance benchmarking on 5,000+ railway reservation records comparing single-column and composite B-tree indexes against full table scans using `EXPLAIN`.
6. **`OptimizationDB`** (Experiment 10): SQL performance tuning and anti-pattern optimization on 14,000+ e-commerce records, optimizing non-SARGable functions, leading wildcards, inefficient subqueries (`NOT IN` to Anti-Join), filesorts, and temporary tables.

---

## Execution Order

Run the scripts in numerical order using MySQL:

1. [Experiment 1 — ER Diagram](experiment-01/README.md)
2. [Experiment 2 — Relational Schema & Constraints (`IndianEcommerceDB`)](experiment-02/queries.sql)
3. [Experiment 3 — Basic Queries & Aggregations (`CompanyDB`)](experiment-03/queries.sql)
4. [Experiment 4 — Joins & Subqueries (`CompanyDB`)](experiment-04/queries.sql)
5. [Experiment 5 — Views & Recursive CTE (`CompanyDB`)](experiment-05/queries.sql)
6. [Experiment 6 — Stored Procedures & Triggers (`CompanyDB`)](experiment-06/queries.sql)
7. [Experiment 7 — Normalization, Lossless Join & Dependency Preservation (`NormalizationDB`)](experiment-07/queries.sql)
8. [Experiment 8 — Transactions, ACID Properties, Savepoints & Isolation Levels (`BankingDB`)](experiment-08/queries.sql)
9. [Experiment 9 — Single-Column & Composite Indexing Benchmarks (`RailwayDB`)](experiment-09/queries.sql)
10. [Experiment 10 — Query Optimization, Anti-Patterns & Execution Plans (`OptimizationDB`)](experiment-10/queries.sql)

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

---

### Experiment 7 — Normalization, Lossless Join & Dependency Preservation

Identify functional dependencies in a denormalized Sales relation and normalize it progressively from Unnormalized Form (UNF) through 1NF, 2NF, 3NF, and Boyce–Codd Normal Form (BCNF). Verify lossless join reconstruction using natural joins and row-count / `EXCEPT` difference checks, and verify dependency preservation by ensuring all original functional dependencies remain enforceable within decomposed relations without cross-table joins.

- Program: [experiment-07/queries.sql](experiment-07/queries.sql)
- Output: [experiment-07/output](experiment-07/output)

---

### Experiment 8 — Transactions, ACID Properties & Concurrency Isolation

Implement transactional banking operations on `BankingDB` (`Accounts` and `Transaction_Logs`) guaranteeing ACID properties. Demonstrate full transaction rollback via `ROLLBACK` on constraint violations and partial failure recovery via `SAVEPOINT` and `ROLLBACK TO SAVEPOINT`. Simulate concurrency anomalies (Dirty Read under `READ UNCOMMITTED`, Non-Repeatable Read under `READ COMMITTED`, and Phantom Read under `REPEATABLE READ`) across concurrent sessions, and verify strict serial order using `SERIALIZABLE`.

- Program: [experiment-08/queries.sql](experiment-08/queries.sql)
- Output: [experiment-08/output](experiment-08/output)

---

### Experiment 9 — Single-Column & Composite Indexing Performance

Design a railway reservation schema (`Railway_Bookings`) in `RailwayDB` and populate 5,000 synthetic records using a bulk stored procedure generator. Benchmark single-column B-tree index lookup (`pnr_no`) and multi-column composite index filtering (`train_no`, `travel_date`, `booking_status`) adhering to the Leftmost Prefix Rule against baseline Full Table Scans (`type: ALL`). Analyze execution paths, key usage, and scanned rows using `EXPLAIN`.

- Program: [experiment-09/queries.sql](experiment-09/queries.sql)
- Output: [experiment-09/output](experiment-09/output)

---

### Experiment 10 — Query Optimization & Anti-Pattern Refactoring

Populate an e-commerce schema (`Customers` and `Orders`) in `OptimizationDB` with over 14,000 synthetic records using a data generator procedure. Formulate five slow queries exhibiting common database performance anti-patterns: non-SARGable date function (`YEAR()`), leading wildcard pattern match (`LIKE '%...'`), quadratic `NOT IN` subquery, unindexed filesort with `LIMIT`, and unindexed multi-table join with temporary aggregation. Optimize each query using SARGable predicates, prefix search, left anti-joins, composite sorting indexes, and covering indexes, achieving speedups up to 135x.

- Program: [experiment-10/queries.sql](experiment-10/queries.sql)
- Output: [experiment-10/output](experiment-10/output)
