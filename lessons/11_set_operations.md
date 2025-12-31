# Lesson 11: Combining Results (Set Operations)

## What You’ll Learn

- The mathematical basis of set operations (Union, Intersection, Difference)
- What set operations are and why they are useful for combining query results
- How to use `UNION` to combine results and remove duplicates
- How to use `UNION ALL` to combine results and keep all duplicates
- How to use `INTERSECT` to find common rows between query results
- How to use `EXCEPT` (or `MINUS`) to find rows unique to one query result
- How to simulate `INTERSECT` and `EXCEPT` in MySQL
- Rules and best practices for combining query results

## 1. Introduction

So far, we've focused on retrieving and manipulating data from single tables or by joining related tables. But what if you have multiple, separate `SELECT` statements, and you want to combine their results into a single output? This is where **set operations** come in.

Set operations allow you to perform set-based logic (like union, intersection, and difference) on the results of two or more `SELECT` queries, treating each query's result set as a mathematical "set" of rows.

## 2. Mathematical Basis of Set Operations and Relational Logic

To truly understand how SQL combines results, it's helpful to look at the foundational concepts of set theory and how they translate into relational database operations.

### What is a Set? (and Multi-sets)

In mathematics, a **set** is a well-defined collection of **distinct (unique)** objects, called **elements**. The order of elements in a set does not matter, and each element appears only once. For example, `{apple, banana, cherry}` is a set.

A **multi-set** (or bag) is a collection where elements _can_ appear more than once. The order still doesn't matter. An example would be `{apple, banana, banana, cherry}`.

**Important Note for SQL:** When we talk about rows as "elements" in a set or multi-set, a row is considered distinct from another only if **all of its column values are identical**. If even one column's value differs, the rows are considered distinct elements.

- For example, in a result set, `(Bob, 20)` and `(Bob, 10)` are **two distinct elements** (or rows), even though 'Bob' is repeated. They would not "cancel out" or be considered the same for set operations unless all their corresponding values were the same.

### Core Set Operations in a Relational Context

Let's imagine our "elements" are entire rows (tuples) from our query result sets. For simplicity, we'll use abstract rows:

- **Query A result (Multi-set A):** { (Alice, 10), (Bob, 20), (Alice, 10) }
- **Query B result (Multi-set B):** { (Bob, 20), (Charlie, 30), (David, 40) }

#### Union (A ∪ B) - Distinct Rows

The **union** of two sets combines all distinct rows from A and B. If a row appears in both, it's only included once. This corresponds to the SQL `UNION` operator.

- **Example with Abstract Rows:**
  If Multi-set A = { (Alice, 10), (Bob, 20), (Alice, 10) }
  and Multi-set B = { (Bob, 20), (Charlie, 30), (David, 40) }
  then A ∪ B (distinct) = { (Alice, 10), (Bob, 20), (Charlie, 30), (David, 40) }

#### Union All (A ∪ B) - All Rows

The **union of multi-sets** combines all rows from A and B, including all duplicates. This corresponds to the SQL `UNION ALL` operator.

- **Example with Abstract Rows:**
  If Multi-set A = { (Alice, 10), (Bob, 20), (Alice, 10) }
  and Multi-set B = { (Bob, 20), (Charlie, 30), (David, 40) }
  then Union All = { (Alice, 10), (Bob, 20), (Alice, 10), (Bob, 20), (Charlie, 30), (David, 40) }

#### Intersection (A ∩ B)

The **intersection** returns only the distinct rows that are present in _both_ A and B. This corresponds to the SQL `INTERSECT` operator.

- **Example with Abstract Rows:**
  If Multi-set A = { (Alice, 10), (Bob, 20), (Alice, 10) }
  and Multi-set B = { (Bob, 20), (Charlie, 30), (David, 40) }
  then A ∩ B (distinct) = { (Bob, 20) }

#### Difference (A \\ B)

The **difference** returns only the distinct rows that are present in A but _not_ in B. This corresponds to the SQL `EXCEPT` or `MINUS` operator.

- **Example with Abstract Rows:**
  If Multi-set A = { (Alice, 10), (Bob, 20), (Alice, 10) }
  and Multi-set B = { (Bob, 20), (Charlie, 30), (David, 40) }
  then A \\ B (distinct) = { (Alice, 10) }

## 3. Basic Rules for Set Operations in SQL

In SQL, the "elements" of our sets are the **rows** returned by `SELECT` statements. When combining these result sets, certain rules apply:

1.  **Same Number of Columns:** Each `SELECT` statement must return the same number of columns.
2.  **Compatible Data Types:** Corresponding columns (e.g., the first column of query 1 and the first column of query 2) must have compatible data types (e.g., both are numbers, both are strings, both are dates).
3.  **Order of Columns:** The order of columns in the `SELECT` list matters, as it defines which columns are compared and combined.

The column names in the final result set are typically taken from the first `SELECT` statement.

## 4. `UNION`: Combining and Removing Duplicates (Mathematical Union)

The `UNION` operator combines the result sets of two or more `SELECT` statements and **removes any duplicate rows** from the final result. This directly corresponds to the mathematical "union" operation.

**Syntax:**

```sql
SELECT column1, column2 FROM table1
UNION
SELECT column1, column2 FROM table2;
```

**Example: A combined list of all customer and supplier cities**
Let's find all unique city locations where we have either a customer or a supplier.

**Sample Data (customers):**
| id | name | city |
|----|-------------|-----------|
| 1 | Alice Smith | New York |
| 2 | Bob Johnson | Los Angeles |

**Sample Data (suppliers):**
| id | supplier_name | city |
|------|---------------|-----------|
| 501 | Global Supply | Chicago |
| 502 | West Coast Parts | Los Angeles |

**Query:**

```sql
SELECT city FROM customers
UNION
SELECT city FROM suppliers;
```

**Sample Result:**
| city |
|-------------|
| New York |
| Los Angeles |
| Chicago |

_Notice that "Los Angeles" appears only once, even though it was in both query results._

## 5. `UNION ALL`: Combining and Keeping Duplicates (Multi-set Union)

The `UNION ALL` operator combines the result sets of two or more `SELECT` statements and **retains all duplicate rows**. If a row exists in both `SELECT` statements, it will appear multiple times in the final output.

**Syntax:**

```sql
SELECT column1, column2 FROM table1
UNION ALL
SELECT column1, column2 FROM table2;
```

**Example: A full list of all customer and supplier cities, including duplicates**
Using the same data as above.

**Query:**

```sql
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;
```

**Sample Result:**
| city |
|-------------|
| New York |
| Los Angeles |
| Chicago |
| Los Angeles |

_Notice "Los Angeles" appears twice. `UNION ALL` is generally faster than `UNION` because the database doesn't have to check for and remove duplicates._

## 6. `INTERSECT`: Finding Common Rows (Mathematical Intersection)

The `INTERSECT` operator returns only the rows that are present in **both** result sets.

**Syntax (Standard SQL - Not supported in MySQL directly):**

```sql
SELECT column1, column2 FROM table1
INTERSECT
SELECT column1, column2 FROM table2;
```

### Simulating `INTERSECT` in MySQL

A common way to achieve the same result is by using an `INNER JOIN` on a subquery or `EXISTS`.

**Example: Find cities where we have BOTH a customer and a supplier.**

**Query (MySQL simulation):**

```sql
SELECT city
FROM customers
WHERE city IN (SELECT city FROM suppliers);
```

**Sample Result:**
| city |
|-------------|
| Los Angeles |

## 7. `EXCEPT` / `MINUS`: Finding Unique Rows (Mathematical Difference)

The `EXCEPT` operator (or `MINUS` in Oracle) returns only the rows that are present in the **first** `SELECT` statement but **not** in the second.

**Syntax (Standard SQL - Not supported in MySQL directly):**

```sql
SELECT column1, column2 FROM table1
EXCEPT
SELECT column1, column2 FROM table2;
```

### Simulating `EXCEPT` in MySQL

The most common way to achieve this is using a `LEFT JOIN` combined with `WHERE ... IS NULL`.

**Example: Find cities that have customers but NO suppliers.**

**Query (MySQL simulation):**

```sql
SELECT c.city
FROM customers c
LEFT JOIN suppliers s ON c.city = s.city
WHERE s.id IS NULL; -- This condition means there was NO matching supplier
```

**Sample Result:**
| city |
|----------|
| New York |

## 8. Common Pitfalls and Best Practices

- **Column Mismatch:** The number and compatible data types of columns in each `SELECT` statement are critical.
- **Order of Columns:** The order of columns in your `SELECT` lists determines how they are matched across combined queries.
- **`UNION` Performance:** `UNION` removes duplicates, which requires extra processing. Use `UNION ALL` if you don't need duplicate removal for better performance.
- **`ORDER BY` and `LIMIT` Placement:** These clauses generally apply to the _final_ combined result set. To sort or limit individual `SELECT`s before combining, enclose them in parentheses.

**Example for `ORDER BY` and `LIMIT` in `UNION`:**

```sql
(SELECT name FROM products ORDER BY name LIMIT 5)
UNION ALL
(SELECT name FROM customers ORDER BY name LIMIT 5);
```

## 9. Practical Examples (Combining Concepts)

**Example 1: Find all entities (customers, products) with 'Widget' in their name/title, and categorize them.**

```sql
SELECT name AS entity_name, 'Product' AS entity_type
FROM products
WHERE name LIKE '%Widget%'
UNION ALL
SELECT name AS entity_name, 'Customer' AS entity_type
FROM customers
WHERE name LIKE '%Widget%';
```

**Example 2: Find customers who have made an order but have no phone number in their profile.**
_(Assumes a `customer_profiles` table with a `phone` column.)_

```sql
-- Customers who have placed an order
SELECT c.name, c.email
FROM customers c
JOIN orders o ON c.id = o.customer_id
-- Minus customers who have a phone number
EXCEPT -- (or MySQL equivalent with LEFT JOIN...IS NULL)
SELECT c.name, c.email
FROM customers c
JOIN customer_profiles cp ON c.id = cp.customer_id
WHERE cp.phone IS NOT NULL;
```

## 10. Recap

- **Set operations** (`UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT`) combine results from multiple `SELECT` queries based on set theory.
- Queries must have the same number of columns with compatible data types.
- **`UNION`** removes duplicates; **`UNION ALL`** keeps duplicates (and is faster).
- MySQL often requires simulations for `INTERSECT` (using `JOIN` / `EXISTS` / `IN`) and `EXCEPT` (using `LEFT JOIN ... IS NULL`).
- `ORDER BY` and `LIMIT` typically apply to the final result, unless applied within subqueries.

## Next Steps

You’ve completed the lesson on combining query results! To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 11: Combining Results](../homework/hw11.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.
