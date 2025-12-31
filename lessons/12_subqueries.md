# Lesson 12: Subqueries

## What You’ll Learn

- What a subquery is and its role in complex queries.
- The different types of subqueries and where they can be used (`WHERE`, `FROM`, `SELECT`).
- The performance implications of each subquery type.
- The concept of a correlated subquery and its performance trade-offs.
- A practical guide on when to choose a subquery versus a `JOIN`.

## 1. Introduction to Subqueries

### What is a Subquery?

A **subquery**, also known as a nested query or inner query, is a complete `SELECT` statement that is nested inside another SQL statement (like `SELECT`, `INSERT`, `UPDATE`, or `DELETE`). It's a powerful tool for building sophisticated queries by breaking down a complex problem into smaller, logical steps.

### Why Use Them?

Subqueries are essential when a query's criteria depend on the result of another query. For example, you can't answer "Which products are more expensive than our average priced product?" with a single, simple query because you first need to _calculate_ the average price. A subquery lets you perform that calculation and use its result to filter the main query, all in one statement.

## 2. Subqueries in the `WHERE` Clause

This is the most common place to use a subquery. It allows you to filter the rows returned by the main (outer) query based on the result set of the inner query.

### Scalar Subqueries (Returning a Single Value)

A scalar subquery is an inner query that returns exactly one column and one row—a single value. You can use this single value with standard comparison operators (`=`, `>`, `<`, `>=`, `<=`, `!=`).

**Performance:** This type of subquery is generally very efficient because the inner query is executed only once. Its single result is then used to evaluate the `WHERE` clause for all rows in the outer query.

**Example:** Find all products that are more expensive than the average product price.

```sql
-- First, find the average price (this is our subquery)
-- SELECT AVG(price) FROM products;  -- Let's say this returns 35.50

-- Now, use that result to filter the main query
SELECT name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

### Multi-row Subqueries (Returning a List of Values)

These subqueries return a single column with multiple rows (a list of values). They are used with operators designed to handle lists, such as `IN`, `NOT IN`, and `EXISTS`.

#### Using `IN` and `NOT IN`

The `IN` operator checks if a value from the outer query matches any value in the list returned by the subquery.

**Example:** Find the names of all customers who have placed at least one order.

```sql
SELECT name, email
FROM customers
WHERE id IN (SELECT DISTINCT customer_id FROM orders);
```

_The subquery `(SELECT DISTINCT customer_id FROM orders)` creates a list of all unique customer IDs that have orders. The outer query then finds all customers whose `id` is in that list._

#### Using `EXISTS` and `NOT EXISTS`

The `EXISTS` operator checks if the subquery returns _any rows at all_. It returns `TRUE` if the subquery returns one or more rows, and `FALSE` otherwise. It doesn't care about the _values_ in the rows, only their existence.

**Example:** Find all products that have been ordered at least once.

```sql
SELECT name, price
FROM products p
WHERE EXISTS (
  SELECT 1 -- (Using SELECT 1 is a common convention, as we don't care about the value)
  FROM order_line_items oli
  WHERE oli.product_id = p.id
);
```

_For each product `p` in the outer query, the subquery runs and checks if there's any matching `product_id` in `order_line_items`. If it finds even one, `EXISTS` returns `TRUE` and the product is included._

#### Performance: `IN` vs. `EXISTS`

While modern optimizers can often rewrite `IN` to be more efficient, the classic and still generally true advice is that **`EXISTS` is often more performant**, especially for large subqueries.

- **`IN`** often requires the database to first run the subquery completely, build a temporary list of all its results, and then check each outer row against that entire list.
- **`EXISTS`** can "short-circuit." For each outer row, it runs the inner query and stops the moment it finds the _first_ matching row, which can be much faster.

**Best Practice:** When checking for the existence of related data, `EXISTS` is a safer and often more performant choice than `IN`.

## 3. Subqueries in the `FROM` Clause (Derived Tables)

You can use a subquery in the `FROM` clause of a query. The result set of this subquery is treated as a temporary, virtual table, which is often called a **derived table**.

**Crucial Rule:** A derived table **must** be given an alias using `AS`.

This technique is extremely useful when you need to perform an aggregation first and then join that aggregated result back to another table.

**Example:** Find the name of the customer who has placed the most valuable order.

```sql
-- Step 1: The subquery calculates the total value of each order.
-- This becomes our derived table, which we alias as 'order_totals'.
SELECT
  c.name,
  order_totals.total_value
FROM customers c
JOIN (
    SELECT
        o.id,
        o.customer_id,
        SUM(oli.quantity * p.price) AS total_value
    FROM orders o
    JOIN order_line_items oli ON o.id = oli.order_id
    JOIN products p ON oli.product_id = p.id
    GROUP BY o.id, o.customer_id
) AS order_totals ON c.id = order_totals.customer_id
ORDER BY order_totals.total_value DESC
LIMIT 1;
```

## 4. Subqueries in the `SELECT` Clause

A subquery can be used as a column in the `SELECT` list. This is only possible if the subquery is a **scalar subquery** (returns a single value).

**Performance Warning:** This is a major performance trap. A scalar subquery in the `SELECT` list is often executed **for every single row** returned by the outer query. This can be extremely slow on large result sets. A `LEFT JOIN` is almost always a better-performing alternative.

**Example:** For each customer, display their name and the date of their most recent order.

**Using a Subquery (Often Slow):**

```sql
SELECT
  c.name,
  (
    SELECT MAX(o.order_date)
    FROM orders o
    WHERE o.customer_id = c.id
  ) AS latest_order_date
FROM customers c;
```

**Using a `LEFT JOIN` (Better Performance):**

```sql
SELECT
  c.name,
  MAX(o.order_date) AS latest_order_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;
```

## 5. Correlated Subqueries

A **correlated subquery** is an inner query that depends on the outer query for its values. It uses values from the outer query in its `WHERE` clause, meaning it cannot be executed independently.

**How it Works:** The subquery is evaluated once for _every row_ processed by the outer query.

**Performance Warning:** Because they run repeatedly, correlated subqueries can be very slow if not structured carefully. The key to performance is ensuring the inner query's filter condition (the part that links to the outer query) is on an indexed column. The `EXISTS` operator is a common and often efficient use of correlated subqueries.

**Example:** Find all orders that contain a specific, high-value product (e.g., product_id = 1).

```sql
SELECT id, order_date
FROM orders o
WHERE EXISTS (
  SELECT 1
  FROM order_line_items oli
  WHERE oli.order_id = o.id -- This correlates the subquery to the outer query
    AND oli.product_id = 1
);
```

_For each order `o`, the subquery checks if an entry exists in `order_line_items` for that specific `order_id` and `product_id`._

## 6. Guidelines: When to Use Subqueries vs. `JOIN`s

Many problems can be solved with either a `JOIN` or a subquery. Here’s a guide to help you choose.

### When Subqueries are Necessary or Preferred

1.  **Filtering with an Aggregated Value:** This is the most common and necessary use case. You cannot use a `JOIN` to filter based on an aggregate function in a `WHERE` clause.
    - `WHERE price > (SELECT AVG(price) FROM products)`
2.  **Complex `EXISTS` Checks:** For checking existence in a set of data derived from a complex query that is difficult to express as a direct join.

### When to Prefer a `JOIN`

1.  **Retrieving Columns from Multiple Tables:** If you need columns from both tables in your final `SELECT` list, a `JOIN` is the standard, most readable, and usually most performant method.
2.  **Readability and Clarity:** Standard `JOIN` syntax is often easier for other developers to read and understand than a complex subquery.
3.  **General Performance:** Database optimizers are highly tuned for `JOIN` operations. In most cases where a query can be written with either a `JOIN` or a subquery, the `JOIN` will perform better.

### A General Rule of Thumb

- **Start with a `JOIN`.** If you can express the logic clearly and efficiently with a `JOIN`, that is usually the best path.
- **Use a subquery when you must.** If you need to filter based on an aggregate (`AVG`, `SUM`, etc.), a subquery is your tool.
- **For checking existence, prefer `EXISTS`** over `IN` with a subquery.
- **Avoid subqueries in the `SELECT` list** if a `LEFT JOIN` can achieve the same result.

## 7. Next Steps

You’ve completed the lesson on subqueries. To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 12: Subqueries](../homework/hw12.md)**

**Next Up:** We'll learn about **Common Table Expressions (CTEs)**, a modern and often more readable alternative to complex subqueries and derived tables.
