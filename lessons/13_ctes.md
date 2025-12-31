# Lesson 13: Common Table Expressions (CTEs)

## What You’ll Learn

- The purpose and syntax of the `WITH` clause
- How CTEs improve readability over nested subqueries
- Defining and referencing multiple CTEs in one statement
- Recursive CTEs for sequences and hierarchical data
- When to prefer a CTE, a subquery, or a derived table
- Performance considerations and common pitfalls

## 1. Introduction

A **Common Table Expression (CTE)** is a temporary, named result set defined with the `WITH` clause. CTEs exist only for the duration of a single statement and can greatly enhance readability by giving logical names to intermediate results.

CTEs solve many of the readability issues caused by deeply nested subqueries. They also enable self-reference, which allows you to express recursive logic in SQL.

## 2. Basic Syntax

The simplest form of a CTE gives a name to a subquery and then references that name in the main query.

```sql
WITH recent_orders AS (
  SELECT customer_id, placed_at, total_amount
  FROM orders
  WHERE placed_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT c.name, r.total_amount, r.placed_at
FROM customers c
JOIN recent_orders r ON c.id = r.customer_id;
```

**Key Points**

- The CTE name `recent_orders` can be referenced in the main query.
- The CTE is evaluated once, even if referenced multiple times.
- You can think of a CTE as a temporary view that exists just for this statement.

## 3. Multiple CTEs

You can define several CTEs separated by commas. Each subsequent CTE can reference those defined before it.

```sql
WITH order_totals AS (
  SELECT customer_id, SUM(total_amount) AS total
  FROM orders
  GROUP BY customer_id
),
TopCustomers AS (
  SELECT customer_id, total
  FROM order_totals
  WHERE total > 500
)
SELECT c.name, t.total
FROM TopCustomers t
JOIN customers c ON c.id = t.customer_id;
```

**Why use multiple CTEs?** They break complex logic into small, named steps that are easier to follow and maintain.

## 4. Recursive CTEs

A **recursive CTE** references itself. It has two parts:

1. **Anchor member** – the initial result set.
2. **Recursive member** – a query that references the CTE name and runs repeatedly until no new rows are produced.

```sql
WITH RECURSIVE sequence(n) AS (
  SELECT 1          -- anchor
  UNION ALL
  SELECT n + 1      -- recursive member
  FROM sequence
  WHERE n < 5       -- termination
)
SELECT n FROM sequence;
```

Recursive CTEs are useful for generating sequences, traversing organizational charts, bill-of-materials structures, and more.

**Safety tip:** Always include a termination condition (`WHERE n < ...`); otherwise the CTE will recurse infinitely and error out.

## 5. CTEs vs. Subqueries and Derived Tables

| Use Case | CTE | Subquery | Derived Table |
|----------|-----|----------|---------------|
| Readability | ✅ Best for complex logic | ❌ Can be hard to read when nested | ❌ Often verbose |
| Reusability within a statement | ✅ Can reference multiple times | ❌ Must be repeated | ❌ Must be repeated |
| Recursion | ✅ Supported with `WITH RECURSIVE` | ❌ Not supported | ❌ Not supported |
| Performance | ↔ Depends on optimizer | ↔ Depends on optimizer | ↔ Depends on optimizer |

**Guidelines**

- Use CTEs for clarity when a query has multiple stages or needs to reference the same result several times.
- Use subqueries for short, single‑use filtering conditions.
- Use derived tables in the `FROM` clause when you need a result set that behaves exactly like a table and will be joined once.

## 6. Performance Notes

- MySQL materializes non-recursive CTEs, which means the intermediate result is stored in a temporary table. For small datasets this is fine, but large results may impact memory or performance.
- Avoid using a CTE when a simple join would suffice; the optimizer may not inline the CTE, leading to slower queries.
- When performance matters, compare the execution plan of a CTE version to an equivalent query using joins or subqueries.

## 7. Next Steps

You’ve completed the lesson on CTEs. To reinforce these concepts, complete the homework for this lesson.

**➡️ [Go to Homework 13: CTEs](../homework/hw13.md)**

**Next Up:** We’ll explore **window functions**, which enable advanced analytics across sets of rows.

