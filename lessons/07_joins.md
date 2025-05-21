# Lesson 7: Joins in SQL

## What You’ll Learn

- What a join is and why joins are essential in relational databases
- The different types of joins: JOIN, LEFT JOIN (LEFT OUTER JOIN), RIGHT JOIN (RIGHT OUTER JOIN), FULL JOIN (FULL OUTER JOIN)
- How to write join queries using the store schema
- How to use table and column aliases in joins
- How to use expressions and functions in JOIN conditions
- How to join more than two tables
- Common pitfalls and best practices

## 1. Why Joins Matter

Normalized schemas split data into multiple tables to reduce redundancy and improve integrity.  
**Joins** let you combine data from these tables to answer real-world questions.

**Example questions:**

- Which customers placed which orders?
- What products are included in each order?
- What is the total quantity of each product ordered?

## 2. Types of Joins

### a. JOIN (also called INNER JOIN)

- Returns rows where there is a match in both tables.
- `JOIN` and `INNER JOIN` are the same; `JOIN` is the standard shorthand.

### b. LEFT JOIN (LEFT OUTER JOIN)

- Returns all rows from the left table, and matching rows from the right table.
- If there’s no match, columns from the right table are NULL.
- `LEFT JOIN` and `LEFT OUTER JOIN` are equivalent.

### c. RIGHT JOIN (RIGHT OUTER JOIN)

- Returns all rows from the right table, and matching rows from the left table.
- If there’s no match, columns from the left table are NULL.
- `RIGHT JOIN` and `RIGHT OUTER JOIN` are equivalent.

### d. FULL JOIN (FULL OUTER JOIN)

- Returns all rows from both tables, with NULLs where there is no match.
- **Supported in:** PostgreSQL, SQL Server, Oracle, SQLite (3.39+)
- **Not supported in:** MySQL (simulate with UNION of LEFT and RIGHT JOINs)

## 3. Basic Join Syntax

**Explicit JOIN syntax (recommended):**

```sql
SELECT columns
FROM table1
JOIN table2 ON table1.column = table2.column;
```

**Example:**

```sql
SELECT customers.name, orders.id AS order_id, orders.order_date
FROM customers
JOIN orders ON customers.id = orders.customer_id;
```

- **Tip:** Always use explicit JOIN syntax for clarity and maintainability.

## 4. Using Expressions and Functions in JOIN Conditions

You can use expressions and functions in a JOIN’s ON clause, just like you can in WHERE or SELECT.  
This is useful when the columns you want to join on aren’t a direct match, or when you need to transform data to make the join work.

**Example: Joining on a calculated value**

Suppose you have a table of products and a table of product codes, where the code is the product name in uppercase with a prefix:

**Sample Data:**

**products**

| id  | name     | price |
| --- | -------- | ----- |
| 1   | Widget A | 19.99 |
| 2   | Widget B | 9.99  |

**product_codes**

| code          | description    |
| ------------- | -------------- |
| PROD_WIDGET A | Main product A |
| PROD_WIDGET B | Main product B |

**Query:**

```sql
SELECT p.name, pc.description
FROM products p
JOIN product_codes pc
  ON pc.code = CONCAT('PROD_', UPPER(p.name));
```

**Sample Result:**

| name     | description    |
| -------- | -------------- |
| Widget A | Main product A |
| Widget B | Main product B |

- Here, the join is made by transforming `p.name` to uppercase and adding a prefix to match the `code` in `product_codes`.

**Tip:**

- You can use any expression or function in a JOIN condition, just like in WHERE or SELECT.
- Be aware: using functions or calculations in JOINs can make queries slower, especially on large tables, because indexes may not be used.

## 5. Practical Join Examples (with Sample Data and Output)

**Sample Data:**

**customers**

| id  | name        |
| --- | ----------- |
| 1   | Alice Smith |
| 2   | Bob Johnson |
| 3   | Charlie Lee |

**orders**

| id   | customer_id |
| ---- | ----------- |
| 1001 | 1           |
| 1002 | 2           |
| 1003 | 4           |

### a. JOIN: Customers and Orders

**Query:**

```sql
SELECT customers.name, orders.id AS order_id
FROM customers
JOIN orders ON customers.id = orders.customer_id;
```

**Sample Result:**

| name        | order_id |
| ----------- | -------- |
| Alice Smith | 1001     |
| Bob Johnson | 1002     |

### b. LEFT JOIN (LEFT OUTER JOIN): All Customers and Their Orders

**Query:**

```sql
SELECT customers.name, orders.id AS order_id
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id;
```

**Sample Result:**

| name        | order_id |
| ----------- | -------- |
| Alice Smith | 1001     |
| Bob Johnson | 1002     |
| Charlie Lee | NULL     |

**Equivalent RIGHT JOIN (tables swapped):**

```sql
SELECT customers.name, orders.id AS order_id
FROM orders
RIGHT JOIN customers ON customers.id = orders.customer_id;
```

**Sample Result:**  
(Same as above)

| name        | order_id |
| ----------- | -------- |
| Alice Smith | 1001     |
| Bob Johnson | 1002     |
| Charlie Lee | NULL     |

### c. RIGHT JOIN (RIGHT OUTER JOIN): All Orders and Their Customers

**Query:**

```sql
SELECT orders.id AS order_id, customers.name
FROM orders
RIGHT JOIN customers ON customers.id = orders.customer_id;
```

**Sample Result:**

| order_id | name        |
| -------- | ----------- |
| 1001     | Alice Smith |
| 1002     | Bob Johnson |
| NULL     | Charlie Lee |

**Equivalent LEFT JOIN (tables swapped):**

```sql
SELECT orders.id AS order_id, customers.name
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id;
```

**Sample Result:**  
(Same as above)

| order_id | name        |
| -------- | ----------- |
| 1001     | Alice Smith |
| 1002     | Bob Johnson |
| NULL     | Charlie Lee |

### d. FULL JOIN (FULL OUTER JOIN)

- **Supported in:** PostgreSQL, SQL Server, Oracle, SQLite (3.39+)
- **Not supported in:** MySQL (simulate with UNION of LEFT and RIGHT JOINs)

**Query (in PostgreSQL/SQL Server/Oracle/SQLite):**

```sql
SELECT customers.name, orders.id AS order_id
FROM customers
FULL JOIN orders ON customers.id = orders.customer_id;
```

**Sample Result:**

| name        | order_id |
| ----------- | -------- |
| Alice Smith | 1001     |
| Bob Johnson | 1002     |
| Charlie Lee | NULL     |
| NULL        | 1003     |

**Simulating FULL JOIN in MySQL:**

```sql
SELECT customers.name, orders.id AS order_id
FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id
UNION
SELECT customers.name, orders.id AS order_id
FROM orders
RIGHT JOIN customers ON customers.id = orders.customer_id;
```

**Sample Result:**  
(Same as above)

| name        | order_id |
| ----------- | -------- |
| Alice Smith | 1001     |
| Bob Johnson | 1002     |
| Charlie Lee | NULL     |
| NULL        | 1003     |

## 6. Using Aliases in Joins

- **Table aliases** make queries shorter and clearer, especially with long table names or multiple joins.

**Example:**

```sql
SELECT c.name, o.id AS order_id
FROM customers AS c
JOIN orders AS o ON c.id = o.customer_id;
```

- **Column aliases** clarify your result set, especially when joining tables with columns of the same name.

## 7. Joining More Than Two Tables

You can join as many tables as you need.

**Example: Customers, Orders, Order Line Items, Products**

**Sample Data:**

**order_line_items**

| order_id | product_id | quantity |
| -------- | ---------- | -------- |
| 1001     | 1          | 2        |
| 1001     | 2          | 1        |
| 1002     | 1          | 1        |

**products**

| id  | name     | price |
| --- | -------- | ----- |
| 1   | Widget A | 19.99 |
| 2   | Widget B | 9.99  |

**Query:**

```sql
SELECT c.name AS customer_name, o.id AS order_id, p.name AS product_name, oli.quantity
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_line_items oli ON o.id = oli.order_id
JOIN products p ON oli.product_id = p.id;
```

**Sample Result:**

| customer_name | order_id | product_name | quantity |
| ------------- | -------- | ------------ | -------- |
| Alice Smith   | 1001     | Widget A     | 2        |
| Alice Smith   | 1001     | Widget B     | 1        |
| Bob Johnson   | 1002     | Widget A     | 1        |

## 8. Common Pitfalls

- **Forgetting the ON clause or using the wrong join condition:**  
  Can result in a cartesian product (every row from one table joined to every row from the other).
- **Duplicate column names in result sets:**  
  Use column aliases to avoid confusion.
- **Unexpected NULLs in LEFT/RIGHT/FULL joins:**  
  Remember, NULLs mean “no match” in the joined table.
- **Not using table aliases:**  
  Makes queries harder to read, especially with multiple joins.

### Cartesian Product (Cross Join)

A **cartesian product** (or **cross join**) returns **every possible combination** of rows from two tables.

- If you join two tables without an ON clause, or use `CROSS JOIN`, you get a cartesian product.

**Why is this important?**

- Most of the time, you do **not** want a cartesian product!  
  It can create huge, meaningless result sets if you forget your join condition.

**Example:**

**Sample Data:**

**customers**

| id  | name        |
| --- | ----------- |
| 1   | Alice Smith |
| 2   | Bob Johnson |

**orders**

| id   | customer_id |
| ---- | ----------- |
| 1001 | 1           |
| 1002 | 2           |

**Query (no ON clause):**

```sql
SELECT customers.name, orders.id AS order_id
FROM customers, orders;
```

**or**

```sql
SELECT customers.name, orders.id AS order_id
FROM customers
CROSS JOIN orders;
```

**Sample Result:**

| name        | order_id |
| ----------- | -------- |
| Alice Smith | 1001     |
| Alice Smith | 1002     |
| Bob Johnson | 1001     |
| Bob Johnson | 1002     |

- Every customer is paired with every order (2 customers × 2 orders = 4 rows).

**Tip:**

- Always include a proper join condition (ON clause) unless you really want a cartesian product.

## 9. Recap

- Joins let you combine data from multiple tables in a normalized schema.
- JOIN returns only matching rows; LEFT JOIN (LEFT OUTER JOIN) returns all rows from the left table, even if there’s no match.
- RIGHT JOIN (RIGHT OUTER JOIN) and FULL JOIN (FULL OUTER JOIN) are also available in some databases.
- You can join more than two tables, and use table/column aliases for clarity.
- You can use expressions and functions in JOIN conditions, not just direct column equality.
- Always specify your join conditions to avoid cartesian products.
- Practice writing join queries to answer real-world questions about your data.

## Next Steps

You’ve completed the lesson on joins!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 7: Joins](../homework/hw7.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.
