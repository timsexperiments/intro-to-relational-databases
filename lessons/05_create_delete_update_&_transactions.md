# Lesson 5: Inserting, Deleting, and Updating Data

## What You’ll Learn

- How to insert single and multiple rows into a table
- How to delete data using the WHERE clause (and why soft deletes are often used)
- How to update data using SET and WHERE
- The basics of WHERE clause filtering and standard operators
- The order of execution for DELETE and UPDATE
- How to use transactions to keep your data safe
- Common pitfalls and best practices

## 1. Introduction

Inserting, deleting, and updating data are the most common ways you’ll interact with a database after creating your tables.

- **INSERT** adds new data.
- **DELETE** removes data.
- **UPDATE** changes existing data.

Understanding how these commands work—and how the WHERE clause controls which rows are affected—is essential for safe, effective database work.

## 2. Inserting Data

### a. Inserting a Single Row

**Syntax:**

```sql
INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);
```

**Example:**  
Add a new customer:

```sql
INSERT INTO customers (name, email) VALUES ('Alice Smith', 'alice@email.com');
```

- If a column has a default value, allows `NULL`, or is auto-incremented (like `id`), you can omit it from the column list and the database will fill it in automatically.

**Example:**  
Add a new product, letting the database assign the product ID and use the default for `created_at`:

```sql
INSERT INTO products (name, price) VALUES ('Widget A', 19.99);
```

- If you want to explicitly insert a `NULL` value (for a nullable column), you can do so:
  ```sql
  INSERT INTO customers (name, email, phone) VALUES ('Bob Johnson', 'bob@email.com', NULL);
  ```

### b. Inserting Multiple Rows

**Syntax:**

```sql
INSERT INTO table_name (column1, column2, ...) VALUES
  (value1a, value2a, ...),
  (value1b, value2b, ...),
  ...;
```

**Example:**  
Add several products at once:

```sql
INSERT INTO products (name, price) VALUES
  ('Widget B', 9.99),
  ('Widget C', 14.99),
  ('Widget D', 29.99);
```

- Multi-row inserts are efficient and reduce round-trips to the database.

### c. Tips and Best Practices

- The order of columns in the `INSERT` statement must match the order of values.
- You can use `DEFAULT` for columns with default values:
  ```sql
  INSERT INTO products (name, price) VALUES ('Widget E', DEFAULT);
  ```
- For auto-increment columns, omit the column or use `NULL`/`DEFAULT`:
  ```sql
  INSERT INTO customers (id, name, email) VALUES (DEFAULT, 'Bob Johnson', 'bob@email.com');
  ```
- **Columns that allow `NULL` or have a default value can be omitted from the column list.**

## 3. Deleting Data

### a. Basic DELETE Syntax

**Syntax:**

```sql
DELETE FROM table_name WHERE condition;
```

**Example:**  
Delete a customer by name:

```sql
DELETE FROM customers WHERE name = 'Alice Smith';
```

- The `WHERE` clause specifies which rows to delete.

**Example:**  
Delete all products with a price less than $10:

```sql
DELETE FROM products WHERE price < 10;
```

- **Warning:** If you omit the WHERE clause, all rows in the table will be deleted!

### b. The WHERE Clause

The `WHERE` clause filters which rows are affected by the DELETE.

**Standard operators:**

- `=` (equals)
- `<>` or `!=` (not equal)
- `>` (greater than), `<` (less than), `>=`, `<=`
- `IS NULL`, `IS NOT NULL`
- `NOT`, `AND`, `OR`

**Examples:**

- Delete all orders that have not been shipped:
  ```sql
  DELETE FROM orders WHERE shipped_at IS NULL;
  ```
- Delete a specific product by ID:
  ```sql
  DELETE FROM products WHERE id = 3;
  ```
- Delete customers with no email:
  ```sql
  DELETE FROM customers WHERE email IS NULL;
  ```
- Delete all products with a price greater than $50 or less than $5:
  ```sql
  DELETE FROM products WHERE price > 50 OR price < 5;
  ```

### c. Order of Execution in DELETE

1. The database **finds all rows matching the WHERE clause**.
2. The matching rows are **deleted**.

**Why does this matter?**

- The WHERE clause is evaluated on the data as it exists **before** the delete.

### d. Common Pitfalls

- **Forgetting the WHERE clause:**  
  Deletes all rows in the table!
- **Using the wrong operator:**  
  `=` vs. `<>`/`!=`, or mixing up AND/OR logic.

### e. Soft Delete Pattern

**What is a soft delete?**  
Instead of actually removing a row from the table, you “soft delete” it—marking it as deleted but keeping the data for auditing, recovery, or compliance.

**Why use it?**

- Keeps a record for auditing, recovery, or compliance.
- Allows you to “undelete” if needed.
- Prevents accidental data loss.

**How is it done?**  
You add a column like `deleted_at` (timestamp) or `is_deleted` (boolean) and update that column instead of deleting the row.  
(See the UPDATE section for how to do this in SQL.)

## 4. Updating Data

### a. Basic UPDATE Syntax

**Syntax:**

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

**Example:**  
Update a customer’s email:

```sql
UPDATE customers
SET email = 'alice.new@email.com'
WHERE name = 'Alice Smith';
```

- The `WHERE` clause specifies which rows to update.

**Example:**  
Increase all product prices by $1:

```sql
UPDATE products
SET price = price + 1;
```

- **Warning:** Without a WHERE clause, all rows are updated!

### b. The WHERE Clause

The `WHERE` clause filters which rows are affected by the UPDATE.

**Standard operators:**

- `=` (equals)
- `<>` or `!=` (not equal)
- `>` (greater than), `<` (less than), `>=`, `<=`
- `IS NULL`, `IS NOT NULL`
- `NOT`, `AND`, `OR`

**Examples:**

- Update only products with a price less than $20:
  ```sql
  UPDATE products
  SET price = price + 2
  WHERE price < 20;
  ```
- Update all orders that have not been shipped, and set the shipped date:
  ```sql
  UPDATE orders
  SET status = 'shipped',
      shipped_at = CURRENT_TIMESTAMP
  WHERE shipped_at IS NULL;
  ```
- Update with multiple conditions:
  ```sql
  UPDATE customers
  SET email = 'bob.new@email.com'
  WHERE name = 'Bob Johnson' AND email = 'bob@email.com';
  ```

**Tip:**  
To update a specific record, it’s best to use the primary key or a unique key in your WHERE clause.  
For example:

```sql
UPDATE customers
SET email = 'alice.latest@email.com'
WHERE id = 1;
```

This ensures you only update the intended row—this is a common and safe practice in application code.

### c. Order of Execution in UPDATE

1. The database **finds all rows matching the WHERE clause**.
2. The **SET clause is applied** to those rows.

**Why does this matter?**

- You cannot use SET to change a value and then filter on the new value in the same statement.
- The WHERE clause always works on the data as it exists **before** the update.

**Example:**

```sql
UPDATE products
SET price = price + 5
WHERE price < 20;
```

- Only products with a price less than $20 **before** the update will be changed.

### d. Common Pitfalls

- **Forgetting the WHERE clause:**  
  Updates all rows in the table!
- **Using the wrong operator:**  
  `=` vs. `<>`/`!=`, or mixing up AND/OR logic.
- **Not understanding order of execution:**  
  The WHERE clause is evaluated before SET is applied.

### e. Soft Delete with UPDATE

**How to implement a soft delete:**

```sql
-- Mark a customer as deleted (soft delete)
UPDATE customers SET deleted_at = CURRENT_TIMESTAMP WHERE id = 2;
```

- Most application code will filter out soft-deleted rows by default:
  ```sql
  SELECT * FROM customers WHERE deleted_at IS NULL;
  ```

## 5. Practical Examples

- **Insert a new customer:**
  ```sql
  INSERT INTO customers (name, email) VALUES ('Charlie Lee', 'charlie@email.com');
  ```
- **Insert multiple products:**
  ```sql
  INSERT INTO products (name, price) VALUES
    ('Widget F', 24.99),
    ('Widget G', 34.99);
  ```
- **Delete a customer by primary key:**
  ```sql
  DELETE FROM customers WHERE id = 2;
  ```
- **Delete all products with a price less than $10:**
  ```sql
  DELETE FROM products WHERE price < 10;
  ```
- **Update a customer’s email by primary key:**
  ```sql
  UPDATE customers
  SET email = 'charlie.new@email.com'
  WHERE id = 3;
  ```
- **Update all products with a price increase:**
  ```sql
  UPDATE products
  SET price = price * 1.10;
  ```
- **Update all orders that are not shipped, and set the shipped date:**
  ```sql
  UPDATE orders
  SET status = 'shipped',
      shipped_at = CURRENT_TIMESTAMP
  WHERE shipped_at IS NULL;
  ```
- **Update with multiple conditions:**
  ```sql
  UPDATE products
  SET price = price - 2
  WHERE price > 30 AND name LIKE 'Widget%';
  ```
- **Soft delete a customer:**
  ```sql
  UPDATE customers SET deleted_at = CURRENT_TIMESTAMP WHERE id = 2;
  ```

## 6. Transactions: Making Changes Safely

### What is a Transaction?

A **transaction** is a sequence of one or more SQL statements that are executed as a single unit of work.

- Either **all** the changes in a transaction are saved (**committed**), or **none** are (**rolled back**).
- Transactions help ensure your data stays consistent, even if something goes wrong partway through a set of changes.

**Key properties (ACID):**

- **Atomicity:** All or nothing.
- **Consistency:** The database moves from one valid state to another.
- **Isolation:** Transactions don’t interfere with each other.
- **Durability:** Once committed, changes are permanent.

### Basic Transaction Syntax (MySQL)

```sql
START TRANSACTION;
-- or BEGIN;

-- Your SQL statements here
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;   -- Save all changes
-- or
ROLLBACK; -- Undo all changes since START TRANSACTION
```

### Why Use Transactions?

- To ensure **data integrity** when making multiple related changes.
- To prevent partial updates if something fails (e.g., a power outage, a constraint violation).
- To group changes that must succeed or fail together.

### Practical Examples

**Example 1: Transferring Money Between Accounts**

```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

- If either update fails, you can `ROLLBACK` to undo both.

**Example 2: Placing an Order**

```sql
START TRANSACTION;
INSERT INTO orders (customer_id, order_date) VALUES (1, CURRENT_TIMESTAMP);
-- Assume LAST_INSERT_ID() returns the new order_id
INSERT INTO order_line_items (order_id, product_id, quantity) VALUES (LAST_INSERT_ID(), 2, 3);
UPDATE products SET stock = stock - 3 WHERE id = 2;
COMMIT;
```

- If any step fails (e.g., not enough stock), you can `ROLLBACK` and the order won’t be partially created.

### Tips and Best Practices

- Always use transactions when making multiple related changes.
- If you’re only making a single change, a transaction is not strictly necessary (but won’t hurt).
- In most SQL clients, you must explicitly start a transaction; otherwise, each statement is auto-committed.
- Remember to `COMMIT` to save changes, or `ROLLBACK` to undo them.

**Note:**  
If you start a transaction and the script or session ends (for example, due to an error or disconnect) **without a COMMIT**, the database will automatically roll back the transaction.  
This helps prevent partial or inconsistent changes from being saved.

## 7. Recap

- Use `INSERT` to add data, `DELETE` (or soft delete) to remove it, and `UPDATE` to change it.
- The WHERE clause controls which rows are affected—use it carefully!
- Standard operators let you filter rows for deletes and updates.
- The database finds rows to delete or update **before** applying the change.
- For updates, use the primary key or a unique key in your WHERE clause to target specific records.
- Transactions let you group changes and keep your data safe.
- If a transaction is not committed and the session ends, the database will roll it back.

## Next Steps

You’ve completed the lesson on inserting, deleting, and updating data!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 5: Inserting, Deleting, and Updating Data](../homework/hw5.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.
