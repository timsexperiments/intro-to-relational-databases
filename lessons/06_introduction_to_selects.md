# Lesson 6: Introduction to SELECT Queries

## What You’ll Learn

- How to retrieve data from a table using SELECT
- How to select specific columns or all columns
- How to use column aliases for clarity and readability
- How to filter results with WHERE (including LIKE)
- How to sort results with ORDER BY (including sorting by non-selected columns)
- How to limit results with LIMIT and OFFSET
- The basic order of execution in a SELECT statement
- Common pitfalls and best practices
- How SQL expressions and WHERE logic are shared across SELECT, UPDATE, and DELETE

## 1. Introduction

The **SELECT** statement is the foundation of querying in SQL.  
It allows you to retrieve, filter, sort, and limit data from your tables.  
Mastering SELECT is essential for working with any relational database.

## 2. The Basic SELECT Statement

### a. Selecting Specific Columns

**Syntax:**

```sql
SELECT column1, column2 FROM table_name;
```

**Example:**  
Get customer names and emails:

```sql
SELECT name, email FROM customers;
```

**Sample Result:**
| name | email |
|-------------|------------------------|
| Alice Smith | dragonrider42@game.com |
| Bob Johnson | applepie@funmail.com |
| Charlie Lee | zeldaquest@play.net |

### b. Selecting All Columns

**Syntax:**

```sql
SELECT * FROM table_name;
```

**Example:**  
Get all columns for all products:

```sql
SELECT * FROM products;
```

**Sample Result:**
| id | name | price |
|----|-----------|-------|
| 1 | Widget A | 19.99 |
| 2 | Widget B | 9.99 |
| 3 | Widget C | 24.99 |

**Tip:**

- Use `*` for quick exploration, but specify columns in production code for clarity and performance.

### c. Aliasing Columns

You can use **aliases** to give columns (or expressions) a temporary name in your result set.  
This is useful for:

- Making results more readable
- Renaming columns for application use
- Naming calculated columns

**Syntax:**

```sql
SELECT column1 AS alias1, column2 AS alias2 FROM table_name;
```

- The `AS` keyword is optional; you can also write `SELECT column1 alias1 ...`

**Examples:**

- Rename a column:
  ```sql
  SELECT name AS customer_name, email AS contact_email FROM customers;
  ```
- Alias an expression:
  ```sql
  SELECT name, price * 1.10 AS price_with_tax FROM products;
  ```

**Sample Result:**
| name | price_with_tax |
|-------------|---------------|
| Widget A | 21.989 |
| Widget B | 10.989 |
| Widget C | 27.489 |

**Tip:**

- Aliases are only for the output of your query—they don’t change the actual table or column names in your database.

### d. Using Expressions in UPDATE and WHERE

> **Tip:**  
> Most expressions and functions you use in a SELECT column list (except for aggregation functions like `SUM`, `COUNT`, etc.) can also be used on the right side of an `UPDATE ... SET` statement.
>
> For example:
>
> ```sql
> UPDATE products
> SET price = price * 1.10
> WHERE name = 'Widget A';
> ```
>
> Similarly, the conditions you use in a SELECT’s WHERE clause can also be used in the WHERE clause of UPDATE and DELETE statements.
>
> For example:
>
> ```sql
> DELETE FROM orders WHERE shipped_at IS NULL;
> UPDATE customers SET email = 'new@email.com' WHERE id = 1;
> ```
>
> - The WHERE logic is the same as in SELECT.

## 3. Filtering Results with WHERE

The **WHERE** clause lets you filter which rows are returned.

**Syntax:**

```sql
SELECT column1, column2 FROM table_name WHERE condition;
```

**Standard operators:**

- `=` (equals)
- `<>` or `!=` (not equal)
- `>` (greater than), `<` (less than), `>=`, `<=`
- `IS NULL`, `IS NOT NULL`
- `NOT`, `AND`, `OR`
- `LIKE` (pattern matching)

**Examples:**

- Get all products with a price greater than $20:

  ```sql
  SELECT * FROM products WHERE price > 20;
  ```

  **Sample Result:**
  | id | name | price |
  |----|-----------|-------|
  | 3 | Widget C | 24.99 |

- Get all customers with a specific email:

  ```sql
  SELECT * FROM customers WHERE email = 'dragonrider42@game.com';
  ```

  **Sample Result:**
  | name | email |
  |-------------|------------------------|
  | Alice Smith | dragonrider42@game.com |

- Get all orders that have not been shipped:

  ```sql
  SELECT * FROM orders WHERE shipped_at IS NULL;
  ```

  **Sample Result:**
  | order_id | customer_id | order_date | shipped_at |
  |----------|-------------|-------------|------------|
  | 1002 | 2 | 2024-05-02 | NULL |

- Get all products with a price between $10 and $30:
  ```sql
  SELECT * FROM products WHERE price >= 10 AND price <= 30;
  ```
  **Sample Result:**
  | id | name | price |
  |----|-----------|-------|
  | 1 | Widget A | 19.99 |
  | 3 | Widget C | 24.99 |

### The LIKE Operator

- Use `LIKE` for pattern matching with `%` (any number of characters) and `_` (single character).
- Example:

  ```sql
  SELECT * FROM products WHERE name LIKE 'Widget%';
  ```

  **Sample Result:**
  | id | name | price |
  |----|-----------|-------|
  | 1 | Widget A | 19.99 |
  | 2 | Widget B | 9.99 |
  | 3 | Widget C | 24.99 |

- Example:

  ```sql
  SELECT * FROM customers WHERE email LIKE '%@game.com';
  ```

  **Sample Result:**
  | name | email |
  |-------------|------------------------|
  | Alice Smith | dragonrider42@game.com |
  | Bob Johnson | applepie@funmail.com |

- **Note:**
  - `ILIKE` is used for case-insensitive matching in some databases (like PostgreSQL), but **not in MySQL**.
  - In MySQL, `LIKE` is case-insensitive for non-binary strings by default.

**Tip:**

- WHERE is evaluated **before** the SELECT clause returns columns.

## 4. Sorting Results with ORDER BY

The **ORDER BY** clause lets you sort your results.

**Syntax:**

```sql
SELECT column1, column2 FROM table_name ORDER BY column3 [ASC|DESC];
```

**Note:**  
You can sort by columns that are not included in your SELECT list.

**Example 1: Sorting by a Non-Selected Column (with Aliasing and Concatenation)**

Suppose your customers table contains:

| name        | email                  |
| ----------- | ---------------------- |
| Alice Smith | dragonrider42@game.com |
| Bob Johnson | applepie@funmail.com   |
| Charlie Lee | zeldaquest@play.net    |

Query:

```sql
SELECT CONCAT(name, ' (', email, ')') AS display_name
FROM customers
ORDER BY email ASC;
```

**Sample Result:**

| display_name                         |
| ------------------------------------ |
| Bob Johnson (applepie@funmail.com)   |
| Alice Smith (dragonrider42@game.com) |
| Charlie Lee (zeldaquest@play.net)    |

- The results are sorted by `email`, not by `name`, even though only the concatenated `display_name` is shown.

**Example 2: Sorting by Price (Descending)**

Query:

```sql
SELECT name, price FROM products ORDER BY price DESC;
```

**Sample Result:**

| name     | price |
| -------- | ----- |
| Widget C | 24.99 |
| Widget A | 19.99 |
| Widget B | 9.99  |

**Example 3: Sorting by Multiple Columns**

Query:

```sql
SELECT order_id, customer_id, order_date
FROM orders
ORDER BY customer_id ASC, order_date DESC;
```

**Sample Result:**

| order_id | customer_id | order_date |
| -------- | ----------- | ---------- |
| 1001     | 1           | 2024-05-01 |
| 1003     | 1           | 2024-05-03 |
| 1002     | 2           | 2024-05-02 |

**Tip:**

- You can use `ASC` (ascending, default) or `DESC` (descending) for each column in ORDER BY.
- Always use ORDER BY if you need your results in a specific order—SQL does not guarantee order unless you specify it.

## 5. Limiting Results with LIMIT and OFFSET

The **LIMIT** clause restricts the number of rows returned.  
**OFFSET** skips a number of rows before returning results.

**Syntax:**

```sql
SELECT * FROM table_name LIMIT n;
SELECT * FROM table_name LIMIT n OFFSET m;
```

**Examples:**

- Get the first 2 products:

  ```sql
  SELECT * FROM products ORDER BY price ASC LIMIT 2;
  ```

  **Sample Result:**
  | id | name | price |
  |----|-----------|-------|
  | 2 | Widget B | 9.99 |
  | 1 | Widget A | 19.99 |

- Get the next 2 products (rows 3–4):

  ```sql
  SELECT * FROM products ORDER BY price ASC LIMIT 2 OFFSET 2;
  ```

  **Sample Result:**
  | id | name | price |
  |----|-----------|-------|
  | 3 | Widget C | 24.99 |

- Get the 2 most recent orders:
  ```sql
  SELECT * FROM orders ORDER BY order_date DESC LIMIT 2;
  ```
  **Sample Result:**
  | order_id | customer_id | order_date | shipped_at |
  |----------|-------------|-------------|------------|
  | 1003 | 1 | 2024-05-03 | 2024-05-04 |
  | 1002 | 2 | 2024-05-02 | NULL |

## 6. Order of Execution in SELECT

Understanding the order in which SQL processes your query helps avoid confusion:

1. **FROM** (which table)
2. **WHERE** (filter rows)
3. **SELECT** (choose columns and expressions)
4. **ORDER BY** (sort)
5. **LIMIT/OFFSET** (restrict output)

**Example:**

```sql
SELECT name, price
FROM products
WHERE price > 10
ORDER BY price DESC
LIMIT 3;
```

- The database first finds all products with price > 10, then sorts them by price, then returns the top 3, and finally selects the name and price columns.

## 7. Practical Examples

- **Select all customers:**
  ```sql
  SELECT * FROM customers;
  ```
- **Select all products with price less than $20, sorted by price:**
  ```sql
  SELECT * FROM products WHERE price < 20 ORDER BY price ASC;
  ```
- **Select the 3 most recent orders:**
  ```sql
  SELECT * FROM orders ORDER BY order_date DESC LIMIT 3;
  ```
- **Select all orders for a specific customer:**
  ```sql
  SELECT * FROM orders WHERE customer_id = 1;
  ```
- **Select product names and prices with an alias:**
  ```sql
  SELECT name AS product_name, price AS product_price FROM products;
  ```
- **Select product names and prices with a calculated column:**
  ```sql
  SELECT name, price, price * 1.10 AS price_with_tax FROM products;
  ```
- **Select customers whose email contains "game":**
  ```sql
  SELECT name, email FROM customers WHERE email LIKE '%game%';
  ```

## 8. Common Pitfalls

- **Forgetting the FROM clause:**  
  Every SELECT must specify a table.
- **Using column names that don’t exist:**  
  Double-check your schema.
- **Not using ORDER BY when you expect sorted results:**  
  SQL does not guarantee order unless you specify it.
- **Using LIMIT without ORDER BY:**  
  The “first N” rows may not be what you expect.

## 9. Recap

- Use SELECT to retrieve data from your tables.
- Use WHERE to filter, ORDER BY to sort, and LIMIT/OFFSET to restrict results.
- Use aliases to make your results more readable.
- The order of execution is FROM → WHERE → SELECT → ORDER BY → LIMIT/OFFSET.
- Most expressions and WHERE logic can be used in SELECT, UPDATE, and DELETE.
- Mastering these basics is essential for all future querying.

## Next Steps

You’ve completed the lesson on basic SELECT queries!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 6: Basic SELECT Queries](../homework/hw6.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.

**Next up:**  
A deep dive into how querying works under the hood, including indexing, storage, and sharding!
