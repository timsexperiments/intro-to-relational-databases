# Lesson 14: Window Functions

## What You’ll Learn

- How window functions analyze sets of rows without collapsing them
- Syntax of `OVER`, `PARTITION BY`, `ORDER BY`, and frame clauses
- Ranking functions such as `ROW_NUMBER`, `RANK`, and `DENSE_RANK`
- Aggregate window functions for running totals and moving averages
- Offset functions like `LAG` and `LEAD` to compare rows
- Distribution functions such as `NTILE` and `PERCENT_RANK`
- Practical scenarios where window functions shine and performance tips

## 1. Introduction

Window functions perform calculations across a set of rows **related to the current row**, returning a value for each row. Unlike aggregate queries, they do not collapse results; every input row produces an output row. This makes window functions ideal for tasks such as ranking, running totals, and comparing one row to another without losing detail.

## 2. Window Function Syntax

Every window function has the form `function_name(...) OVER ( <window_spec> )`. The `OVER` clause controls which rows are visible to the function.

```sql
SELECT id,
       total_amount,
       SUM(total_amount) OVER () AS total_sales
FROM orders;
```

| id  | total_amount | total_sales |
| --- | ------------ | ----------- |
| 10  | 40.00        | 190.00      |
| 11  | 75.00        | 190.00      |
| 12  | 25.00        | 190.00      |
| 13  | 50.00        | 190.00      |

- `OVER ()` turns `SUM` into a window function that sees all rows.
- No `GROUP BY` is required; each row keeps its original columns.

To limit the window to related rows, use `PARTITION BY` and optionally `ORDER BY`:

```sql
SELECT customer_id,
       total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id) AS customer_total
FROM orders;
```

| customer_id | total_amount | customer_total |
| ----------- | ------------ | -------------- |
| 1           | 40.00        | 115.00         |
| 1           | 75.00        | 115.00         |
| 2           | 25.00        | 75.00          |
| 2           | 50.00        | 75.00          |

Each customer gets their own total, while the original `orders` rows remain intact.

## 3. Window Functions vs. Aggregates

Traditional aggregates collapse rows:

```sql
SELECT customer_id, SUM(total_amount) AS customer_total
FROM orders
GROUP BY customer_id;
```

Aggregations return one row per group, removing individual order rows. Use them when you only need the grouped totals.

| customer_id | customer_total |
| ----------- | -------------- |
| 1           | 115.00         |
| 2           | 75.00          |

With a window function you can keep the detail and still show the total:

```sql
SELECT customer_id,
       total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id) AS customer_total
FROM orders;
```

## 4. Ranking Functions

| customer_id | total_amount | customer_total |
| ----------- | ------------ | -------------- |
| 1           | 40.00        | 115.00         |
| 1           | 75.00        | 115.00         |
| 2           | 25.00        | 75.00          |
| 2           | 50.00        | 75.00          |

### When to Use Which

Use an aggregate when you only need a summary per group; it collapses many rows into one row per group. Use a window function when you need to keep each row but add group-aware context (a rank, a running total, a moving average, etc.).

Aggregates are a good fit for:

- Summaries where detail isn’t needed (e.g., sales per customer, daily totals)
- Reports that filter by grouped results using `HAVING`
- Scenarios where grouped output alone is sufficient and fastest

Window functions are a good fit for:

- Keeping row-level detail while adding per-group metrics (ranks, percentiles)
- Running totals and moving averages that depend on order
- Top-N per group and de-duplication with `ROW_NUMBER`
- Comparing adjacent rows with `LAG`/`LEAD`

Filtering and performance tips: filter on window outputs in an outer query (or with `QUALIFY` if supported), since window values aren’t available in `WHERE`. Aggregates can be cheaper when you only need grouped output; window queries often require sorting/partitioning, so index `ORDER BY`/`PARTITION BY` columns when possible.

## 4. Ranking Functions

Ranking functions assign a position to each row within a group, without collapsing rows. The group is defined by `PARTITION BY`, and the ordering within each group is defined by `ORDER BY`.

- Partition: ranking restarts for each group (e.g., per customer).
- Order: controls which values are “higher” or “lower” for the rank.
- Ties: `ROW_NUMBER` breaks ties arbitrarily, `RANK` leaves gaps after ties, and `DENSE_RANK` does not leave gaps.

```sql
SELECT c.name,
       o.total_amount,
       ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY o.total_amount DESC) AS row_num,
       RANK()       OVER (PARTITION BY c.id ORDER BY o.total_amount DESC) AS rank_num,
       DENSE_RANK() OVER (PARTITION BY c.id ORDER BY o.total_amount DESC) AS dense_rank
FROM customers c
JOIN orders o ON o.customer_id = c.id;
```

| name        | total_amount | row_num | rank_num | dense_rank |
| ----------- | ------------ | ------- | -------- | ---------- |
| Alice Smith | 120.00       | 1       | 1        | 1          |
| Alice Smith | 100.00       | 2       | 2        | 2          |
| Alice Smith | 100.00       | 3       | 2        | 2          |
| Bob Johnson | 200.00       | 1       | 1        | 1          |
| Bob Johnson | 80.00        | 2       | 2        | 2          |

- `ROW_NUMBER` assigns a unique sequence within each partition.
- `RANK` leaves gaps after ties (1,2,2,4).
- `DENSE_RANK` produces consecutive numbers (1,2,2,3).

## 5. Aggregate Window Functions

```sql
SELECT c.name,
       o.placed_at,
       o.total_amount,
       SUM(o.total_amount) OVER (PARTITION BY c.id ORDER BY o.placed_at) AS running_total
FROM customers c
JOIN orders o ON o.customer_id = c.id;
```

| name        | placed_at           | total_amount | running_total |
| ----------- | ------------------- | ------------ | ------------- |
| Alice Smith | 2024-01-05 09:12:00 | 45.00        | 45.00         |
| Alice Smith | 2024-01-20 14:30:00 | 30.00        | 75.00         |
| Alice Smith | 2024-02-02 10:10:00 | 50.00        | 125.00        |
| Bob Johnson | 2024-01-10 08:05:00 | 80.00        | 80.00         |
| Bob Johnson | 2024-01-28 16:45:00 | 20.00        | 100.00        |

This query produces a running total of order amounts per customer. Other aggregates like `AVG`, `MIN`, and `MAX` work similarly.

## 6. Offset Functions

Offset functions let you peek at preceding or following rows within the window. They are useful for calculating differences or detecting trends.

```sql
SELECT c.name,
       o.placed_at,
       o.total_amount,
       LAG(o.total_amount)  OVER (PARTITION BY c.id ORDER BY o.placed_at) AS prev_amount,
       LEAD(o.total_amount) OVER (PARTITION BY c.id ORDER BY o.placed_at) AS next_amount
FROM customers c
JOIN orders o ON o.customer_id = c.id;
```

| name        | placed_at           | total_amount | prev_amount | next_amount |
| ----------- | ------------------- | ------------ | ----------- | ----------- |
| Alice Smith | 2024-01-05 09:12:00 | 45.00        | NULL        | 30.00       |
| Alice Smith | 2024-01-20 14:30:00 | 30.00        | 45.00       | 50.00       |
| Alice Smith | 2024-02-02 10:10:00 | 50.00        | 30.00       | NULL        |

- `LAG` returns the previous row’s value.
- `LEAD` returns the next row’s value.

## 7. Distribution Functions

Distribution functions help slice data into percentiles or buckets.

```sql
SELECT o.id,
       o.total_amount,
       NTILE(4) OVER (ORDER BY o.total_amount) AS quartile,
       PERCENT_RANK() OVER (ORDER BY o.total_amount) AS pct_rank
FROM orders o;
```

| id   | total_amount | quartile | pct_rank |
| ---- | ------------ | -------- | -------- |
| 2001 | 10.00        | 1        | 0.00     |
| 2002 | 25.00        | 1        | 0.25     |
| 2003 | 50.00        | 2        | 0.50     |
| 2004 | 80.00        | 3        | 0.75     |
| 2005 | 120.00       | 4        | 1.00     |

- `NTILE(4)` assigns each row to a quartile.
- `PERCENT_RANK` returns a 0–1 value showing the relative standing of each row.

## 8. Frame Clauses

Frames narrow the set of rows used in a window calculation. The default frame is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` when an `ORDER BY` is present.

```sql
SELECT c.name,
       o.placed_at,
       o.total_amount,
       AVG(o.total_amount) OVER (
         PARTITION BY c.id
         ORDER BY o.placed_at
         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg
FROM customers c
JOIN orders o ON o.customer_id = c.id;
```

| name        | placed_at           | total_amount | moving_avg |
| ----------- | ------------------- | ------------ | ---------- |
| Alice Smith | 2024-01-05 09:12:00 | 45.00        | 45.00      |
| Alice Smith | 2024-01-20 14:30:00 | 30.00        | 37.50      |
| Alice Smith | 2024-02-02 10:10:00 | 50.00        | 41.67      |

The `ROWS BETWEEN` clause limits the average to the current row and the two prior rows in each partition. Use `RANGE` for logical bounds (e.g., dates) and `ROWS` for physical offsets.

## 9. Performance Notes

- Window functions may require sorting; index the `ORDER BY` columns where possible.
- Avoid unnecessary partitions; fewer partitions can reduce overhead.
- Compare execution plans if a query seems slow.

## 10. Next Steps

You’ve completed the lesson on window functions. To reinforce these concepts, complete the homework for this lesson.

**➡️ [Go to Homework 14: Window Functions](../homework/hw14.md)**

**Next Up:** We’ll look at **views and triggers**, which provide reusable queries and automatic reactions to data changes.
