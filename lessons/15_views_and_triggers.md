# Lesson 15: Views & Triggers

**What You'll Learn**
- How views provide virtual tables for simplified querying and security
- Ways to update data through views and their limitations
- Basic trigger syntax to react automatically to data changes
- Common use cases for BEFORE and AFTER triggers

## 1. Understanding Views
A **view** is a stored `SELECT` statement that appears as a table. Views help hide complexity and restrict access to specific columns or rows.

```sql
CREATE VIEW active_customers AS
SELECT id, name, email
FROM customers
WHERE active = 1;
```
Use `SELECT` against `active_customers` just like a table:

```sql
SELECT * FROM active_customers;
```

### Updating Through Views
Some views are updatable. If a view maps directly to one table without aggregates or joins, MySQL lets you modify the underlying data:

```sql
UPDATE active_customers SET email = 'new@example.com' WHERE id = 1;
```

Complex views (with joins, aggregates, or `GROUP BY`) are read-only. Use them for reporting or as building blocks in other queries.

### Dropping Views
```sql
DROP VIEW active_customers;
```

## 2. Materialized Views
MySQL doesn’t have built-in materialized views. To cache results, create a table and refresh it periodically with a scheduled job or trigger.

## 3. Introduction to Triggers
A **trigger** automatically runs before or after `INSERT`, `UPDATE`, or `DELETE` events on a table. Triggers encapsulate side effects such as audit logging or maintaining denormalized data.

```sql
CREATE TABLE customer_audit (
  customer_id INT,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  action VARCHAR(10)
);

CREATE TRIGGER after_customer_insert
AFTER INSERT ON customers
FOR EACH ROW
INSERT INTO customer_audit (customer_id, action)
VALUES (NEW.id, 'INSERT');
```
Whenever a row is inserted into `customers`, an audit row captures the change.

### BEFORE vs. AFTER
- **BEFORE** triggers validate or modify data before it’s written.
- **AFTER** triggers react to the final state (logging, cascading changes).

### Dropping Triggers
```sql
DROP TRIGGER after_customer_insert;
```

## 4. When to Use Views and Triggers
- **Views** simplify complex joins, centralize business logic, and hide sensitive columns.
- **Triggers** enforce business rules, maintain audit trails, or update derived data.
- Both add server-side logic—use them judiciously to avoid hidden performance costs.

## 5. Practice
- Create views that present subsets of data (e.g., recent orders).
- Build triggers that log changes or prevent invalid updates.
- Measure performance impacts and understand how to disable or drop these objects when no longer needed.

Views and triggers extend SQL beyond basic queries, allowing the database to provide virtual tables and automated reactions to data changes.
