# Lesson 8: Indexing & Query Performance

## What You’ll Learn

- How databases find and return your data (query execution basics)
- How data is organized and stored in pages/blocks on disk
- What indexes are, why they matter, and how they work (including how they are stored)
- The different types of indexes and their best use cases
- How to create common index types in MySQL
- When to use indexes and the trade-offs involved (read vs. write performance)
- **Strategic indexing guidelines: when, what, and how to index**
- **How to use the `EXPLAIN` command to analyze query performance**
- What sharding is and why it’s used for scaling

## 1. Introduction

You’ve learned how to write `SELECT` queries to retrieve data and `JOIN`s to combine information from multiple tables. But have you ever wondered how the database actually _finds_ that data so quickly, especially in tables with millions or billions of rows? And why some queries seem instant while others take a long time?

This lesson dives into what happens “under the hood” when you run a query. We’ll explore how data is stored, how indexes dramatically speed up data retrieval, the different types of indexes available, and briefly touch on how very large databases are scaled using techniques like sharding.

Understanding these concepts will empower you to write more efficient queries, troubleshoot slow ones, and design better database schemas from the start.

## 2. The Basic SELECT Statement

Before we go under the hood, let's quickly recap the basic `SELECT` statement syntax we've learned. This is the command that kicks off the data retrieval process we'll be analyzing.

### Selecting Specific Columns

The most basic way to retrieve data is to select specific columns from a table:

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

### Selecting All Columns

To get all columns for all rows in a table, use the wildcard `*`:

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
|----|----------|-------|
| 1 | Widget A | 19.99 |
| 2 | Widget B | 9.99 |
| 3 | Widget C | 24.99 |

**Important Tip: Why Avoid `SELECT *` in Production?**

While `SELECT *` is convenient for quick exploration during development, it's generally considered poor practice for production queries. Here's why:

- **Unnecessary Data Retrieval:** It fetches _all_ columns, including large text (`TEXT`, `BLOB`) or unused columns, leading to higher network bandwidth consumption and more client memory usage.
- **Performance Impact:** The database has to work harder to retrieve and transmit more data than necessary. If your table grows and new columns are added, `SELECT *` will implicitly start fetching those too, potentially slowing down queries without you realizing it.
- **Application Fragility:** If the table schema changes (columns are reordered, renamed, or removed), `SELECT *` can lead to unexpected behavior or errors in your application code that expects columns in a specific order or with specific names.
- **Security Risk:** It exposes more data than needed to the application layer, potentially increasing security risks.

Always specify the columns you need explicitly (`SELECT name, email FROM customers;`) in your production code for clarity, stability, and efficiency.

## 3. How Databases Find and Return Your Data

When you execute a `SELECT` query, the database management system goes to work to find the requested data. This involves interacting with storage and deciding on the most efficient retrieval strategy.

### How Data is Stored and Retrieved: Pages and Blocks

Relational databases store table data persistently on disk. This data is physically organized into fixed-size units called **pages** or **blocks**. The size of a page is typically 8KB or 16KB (e.g., InnoDB, MySQL's default storage engine, uses 16KB pages). A page is the minimum amount of data the database reads from or writes to the disk at a time.

Imagine a table is divided into many of these pages, much like a book is divided into physical pages. Each page contains:

- **Header information:** Metadata about the page, such as page type, free space, and pointers to the next/previous page in a linked list.
- **Row data:** The actual records/rows of your table. Rows are packed sequentially onto pages. A single row might span multiple pages if it's very large, or multiple rows might fit entirely on a single page.
- **Row directory (or slot array):** A structure that helps the database quickly locate individual rows within the page.
- **Free space:** Space available for new rows or updates.

When you query data, the database engine might need to read many pages from disk to find the rows you’re looking for. Reading from disk (Disk I/O) is relatively slow compared to reading from RAM.

```
+-----------------------------------------------------------------------+
|                        Database File on Disk                          |
+-----------------------------------------------------------------------+
|  Page 1 (e.g., 16KB)                                                  |
|  +-----------------------------------------------------------------+  |
|  | Page Header                                                     |  |
|  +-----------------------------------------------------------------+  |
|  | Row 1: | ID:1 | Name:Alice Smith | Email:alice@example.com    |  |
|  | Row 2: | ID:2 | Name:Bob Johnson | Email:bob@example.com      |  |
|  | ...                                                             |  |
|  | Row N: | ID:N | Name:Charlie Lee | Email:charlie@example.com  |  |
|  +-----------------------------------------------------------------+  |
|  | Row Directory / Slot Array (pointers to start of each row)      |  |
|  +-----------------------------------------------------------------+  |
|  | Free Space                                                      |  |
|  +-----------------------------------------------------------------+  |
|  Page 2 (e.g., 16KB)                                                  |
|  +-----------------------------------------------------------------+  |
|  | Page Header                                                     |  |
|  | Row M: | ID:M | Name:David Green | Email:david@example.com    |  |
|  | ...                                                             |  |
|  +-----------------------------------------------------------------+  |
|  ... (more data pages for the table) ...                              |
+-----------------------------------------------------------------------+
```

### Data in Memory (Buffer Pool/Cache)

To speed up data access, databases use a portion of RAM, often called the **buffer pool** or **cache**.

- When data is requested, the database first checks if the relevant pages are already in the buffer pool.
- If they are (**cache hit**), retrieval is very fast.
- If not (**cache miss**), the database performs a slower disk read to load the page into the buffer pool. This loaded page then stays in memory for potential future use, improving subsequent access times for the same data.

The database engine's primary goal is to minimize slow disk reads by efficiently locating and caching the needed data pages.

```
+------------+       +----------------------+       +-------------------+
| SQL Query  | ----> | Query Optimizer/     | ----> |  CPU /            |
| (e.g.,     |       | Execution Engine     |       |  Query Processor  |
| SELECT ...) |       +----------^-----------+       +-------------------+
                               | (requests pages)            |
                               |                             | (returns data)
                               |                             V
                        +------+------------------------------+
                        |      Buffer Pool (RAM / Cache)      |
                        |  (stores frequently accessed pages) |
                        +-------------------------------------+
                                           ^
                                           | (loads pages if not in cache)
                                           V
                                     +----------+
                                     |   Disk   |
                                     | (Table   |
                                     |  Data    |
                                     |  Pages)  |
                                     +----------+
```

### Full Table Scans

The most straightforward way for a database to find data is a **full table scan**. This involves reading _every single page_ (and thus every row) in the table and checking if it matches the conditions in your `WHERE` clause.

For small tables, a full table scan might be fast enough. However, for large tables with millions or billions of rows, reading every single page from disk is extremely inefficient and can take a very long time.

The primary solution to making data retrieval efficient, especially on large tables, is through **indexing**.

## 4. Understanding Indexes: The Speed Boost

### What is an Index?

An **index** is a separate data structure that the database creates based on the values of one or more columns in your table. It stores a copy of the indexed column(s) values and maintains pointers (like memory addresses or disk locations, often to the specific page and offset within a page) to the actual rows in the table where those values are found.

Think of an index like the index you'd find at the back of a non-fiction book. If you want to find all mentions of "SQL", you don't read the entire book. Instead, you go to the book's index, find "SQL", and it gives you page numbers where that term appears. You then go directly to those pages. A database index works on the same principle to avoid time-consuming full table scans.

Indexes are crucial because they allow the database to quickly locate the rows relevant to your query **without** reading the entire table.

### Why Indexes are Important

- **Faster Data Retrieval:** This is the primary benefit. Indexes significantly speed up `SELECT` queries, especially those with `WHERE` clauses filtering on indexed columns, `JOIN` operations using indexed columns, and `ORDER BY` clauses sorting by indexed columns.
- **Enforcing Uniqueness:** As we'll see, indexes are the underlying mechanism used by databases to enforce `PRIMARY KEY` and `UNIQUE` constraints.

## 5. Index Types: How Databases Organize Data for Speed

Databases use different types of indexes, each optimized for particular use cases and query patterns. While MySQL primarily uses B-trees as its default index type, understanding other types and concepts helps grasp the full picture.

### B-Tree Indexes

- **What it is:** A **B-tree (Balanced Tree)** is a widely used and highly efficient data structure for database indexes. It organizes data in a sorted, hierarchical (tree-like) structure where branches balance themselves automatically to ensure efficient access to all data points.
- **How it works:** Each node in the B-tree contains keys and pointers. The database traverses the tree from the root node down to find the desired key value. Because the tree is balanced, the number of steps to find a value is minimal, even for very large datasets. This structure makes them excellent for ordered retrieval.
- **Best for:** B-trees are versatile and excellent for a wide range of queries including:
  - Exact value lookups (`WHERE column = value`)
  - Range queries (`WHERE column > value`, `WHERE column BETWEEN value1 AND value2`)
  - Prefix matching (`WHERE column LIKE 'prefix%'`)
  - Sorting (`ORDER BY column`)
- **Performance:** Search, insertion, and deletion operations in a B-tree have a time complexity of **O(log n)**, where 'n' is the number of entries in the index. This logarithmic growth means that as the number of rows increases, the time to find a specific entry increases very slowly. For instance, finding one row in a million might only require a few more steps than finding one row in a thousand.
- **Use cases:** Primary keys, unique constraints, and most general-purpose indexing.

**Simplified B-Tree Illustration (Conceptual):**
This illustrates how a B-tree maintains sorted order and balance as new values are inserted.

```
       [ 50 ]
       /    \
    [20]     [80]
   /    \   /    \
 [10] [30] [70] [90]

  (Insert 40)

       [ 50 ]
       /    \
    [20, 40]  [80]
   /  |   \   /  \
 [10][30][...][70][90]
```

The tree rebalances itself to ensure efficient access path from any node.

### Hash Indexes

- **What it is:** A **hash index** is based on a hash table data structure.
- **How it works:** It applies a hash function to the index key, which calculates a hash value. This hash value points directly to the location of the data (or a "bucket" containing pointers to data). This direct mapping is what makes it extremely fast.
- **Best for:** Extremely fast **exact equality lookups** (`WHERE column = value` or `WHERE column IN (value1, value2, ...)`). The average lookup time is **O(1)** (constant time), meaning the time to find an entry is theoretically the same regardless of the table size.
- **Not good for:** Range queries (`>`, `<`, `BETWEEN`), sorting, or prefix matching (`LIKE 'prefix%'`). Hash indexes store hash values, not the original data in a sorted order.
- **Usage:** In MySQL, hash indexes are explicitly created when using the `MEMORY` storage engine. The default InnoDB engine primarily uses B-trees but includes an "Adaptive Hash Index" feature it manages automatically in memory for frequently accessed B-tree index lookups. You typically won't explicitly create hash indexes on InnoDB tables yourself.

### Unique Indexes

- **What it is:** A **unique index** is a type of index that serves a dual purpose: speeding up data retrieval and **enforcing uniqueness** on the indexed column(s).
- **How it works:** Typically built on a B-tree structure (in InnoDB), the database checks the index before allowing an `INSERT` or `UPDATE`. If the new value already exists in the unique index, the database rejects the operation, preventing duplicate entries.
- **Best for:** Columns that must have unique values.
- **Use cases:** Implementing `PRIMARY KEY` constraints (which automatically create a unique index) and `UNIQUE` constraints.

### Composite Indexes

- **What it is:** An index created on **two or more columns** in a table.
- **How it works:** The index entries are sorted based on the combination of columns, in the order they are specified when creating the index. A search can efficiently filter based on the first column, then the second, and so on.
- **Best for:** Queries that filter or sort by the leading columns of the index.
- **Use cases:** Speeding up lookups involving multiple criteria (e.g., finding items for a specific order: `WHERE order_id = 123 AND product_id = 45`).

### Covering Indexes

- **What it is:** A **covering index** includes all the columns needed to satisfy a query, directly within the index structure itself.
- **How it works:** If a query's required data is entirely contained within a covering index, the database can retrieve the results directly from the index structure without having to access the main table's data pages. This avoids extra, slower disk reads to the primary data and can be significantly faster.
- **Best for:** Optimizing critical, frequently run `SELECT` queries that only need a subset of columns.

### Fulltext Indexes

- **What it is:** An index type specifically designed for searching text data within columns holding large amounts of text.
- **How it works:** Fulltext indexes typically build an "inverted index," which lists every word that appears in the indexed text columns and then links back to the rows where each word is found. This is similar to the index in a book, listing keywords and their page numbers.
- **Best for:** Natural language text searches, keyword searches within large text fields, and ranking results by relevance (`MATCH AGAINST`).
- **Not good for:** Simple equality matching (`=`).
- **Use cases:** Searching article bodies, product descriptions, customer reviews.

### Spatial Indexes

- **What it is:** An index type optimized for indexing spatial data types (like `POINT`, `LINESTRING`, `POLYGON`) used for geographic or geometric data.
- **How it works:** Spatial indexes divide the spatial area into a grid or use R-tree data structures to efficiently search for objects within a given region or proximity.
- **Best for:** Queries involving spatial relationships (`ST_Within`, `ST_Intersects`, `ST_Distance`).
- **Use cases:** Mapping applications, location-based services, geographical data analysis.

### Functional Indexes

- **What it is:** An index created not on the raw column value, but on the result of a function or expression applied to a column.
- **How it works:** The database calculates the result of the function/expression for each row and stores these results in the index. This allows you to index data that is consistently transformed for searching.
- **Best for:** Indexing transformed data that you query frequently.
- **Use cases:** Case-insensitive searches (`WHERE LOWER(email) = '...'`), indexing parts of strings (`WHERE SUBSTRING(zip_code, 1, 3) = '...'`), indexing JSON data.

### GIN Indexes (General Inverted Index)

- **What it is:** A **GIN (General Inverted Index)** is a specialized index type often used for indexing data types that contain multiple values within a single column, such as arrays, JSONB (binary JSON), or full-text documents.
- **How it works:** A GIN index creates an entry for _each individual item_ within the indexed column's value, pointing back to the row. For example, if a `tags` column contains `['tech', 'programming', 'AI']`, a GIN index would have separate entries for 'tech', 'programming', and 'AI', each pointing to that row.
- **Best for:** Efficiently querying "contains" relationships within multi-valued data.
- **Not good for:** Simple equality or range queries on single-valued columns.
- **Usage:** GIN indexes are a powerful feature primarily found in databases like **PostgreSQL**. They are not directly supported in MySQL as a standalone index type in the same way. MySQL's Fulltext index offers similar capabilities for text search, and its JSON functions can sometimes leverage other indexes, but GIN itself is a distinct concept.

## 6. Creating Specific Index Types in MySQL

Now that we understand the different types of indexes conceptually, let's look at the MySQL syntax for creating some of the most common ones.

### Standard Index (B-Tree)

This is the default and most common type.

**Syntax:**

```sql
CREATE INDEX index_name
ON table_name (column1 [ASC|DESC], column2 [ASC|DESC], ...);
```

You can optionally specify `USING BTREE` for clarity, though it's the default:

```sql
CREATE INDEX index_name
ON table_name (column1) USING BTREE;
```

`ASC` and `DESC` can be specified for sorting within the index, which can help `ORDER BY` performance.

**Example:** Create a standard index on the `order_date` column to speed up queries filtering or sorting by date:

```sql
CREATE INDEX idx_orders_order_date ON orders (order_date);
```

### Unique Index

Ensures uniqueness and speeds up lookups. `PRIMARY KEY` and `UNIQUE` constraints typically create these automatically.

**Syntax:**

```sql
CREATE UNIQUE INDEX index_name
ON table_name (column1, column2, ...);
```

**Example:** Explicitly create a unique index on the `email` column (redundant if a `UNIQUE` constraint is already defined, but shows the syntax):

```sql
CREATE UNIQUE INDEX idx_customers_email_unique ON customers (email);
```

### Composite Index

An index on multiple columns. The order of columns matters for query optimization.

**Syntax:**

```sql
CREATE INDEX index_name
ON table_name (column1, column2, ...);
```

**Example:** Create a composite index on `order_id` and `product_id` in the `order_line_items` table:

```sql
CREATE INDEX idx_order_line_items_order_product ON order_line_items (order_id, product_id);
```

### Hash Index

Only explicitly creatable for `MEMORY` tables in standard MySQL. InnoDB uses adaptive hash indexes automatically.

**Syntax (for MEMORY tables):**

```sql
CREATE INDEX index_name
ON table_name (column1) USING HASH;
```

### Fulltext Index

For searching text columns.

**Syntax:**

```sql
CREATE FULLTEXT INDEX index_name
ON table_name (column1, column2, ...);
```

**Example:** Create a fulltext index on a theoretical `description` column in the `products` table:

```sql
-- Assume products table has a TEXT description column
CREATE FULLTEXT INDEX idx_products_description ON products (description);
```

You would then query using `MATCH AGAINST`.

### Spatial Index

For spatial data types.

**Syntax:**

```sql
CREATE SPATIAL INDEX index_name
ON table_name (column1);
```

Requires that the indexed column is a spatial data type and is `NOT NULL`.

### Functional Indexes (Indexes on Expressions)

Allows indexing the result of an expression. Useful for cases like case-insensitive search or indexing parts of strings.

**Preferred Strategy: Direct Index on Expression (MySQL 5.7+ retrieve capabilities, 8.0+ for direct functional indexing)**

Modern MySQL versions offer a direct syntax for creating indexes on expressions, making this strategy preferred when supported:

```sql
CREATE INDEX index_name ON table_name ((expression));
```

Notice the double parentheses around the expression.

**Example (Direct Index on Expression):**

```sql
CREATE INDEX idx_customers_email_lower_direct ON customers ((LOWER(email)));
```

Now, queries filtering on the lowercase email can use this index:

```sql
SELECT * FROM customers WHERE LOWER(email) = 'alice@example.com';
```

**Alternative Strategy: Using Generated Columns (for older MySQL or specific needs)**

For older MySQL versions (pre-5.7 for direct functional indexes) or for more complex expressions where you might also want to query the generated column directly, adding a **generated column** and then indexing it is a robust alternative. A generated column's value is automatically computed and kept up-to-date. Use `PERSISTENT` if you want the generated column values stored on disk so they can be indexed.

1.  **Add a generated column** (e.g., to store the lowercase version of email):

    ```sql
    ALTER TABLE customers
    ADD COLUMN email_lower VARCHAR(100) AS (LOWER(email)) PERSISTENT;
    ```

    - `AS (LOWER(email))` defines the expression.
    - `PERSISTENT` stores the value on disk.

2.  **Create an index** on this generated column:
    ```sql
    CREATE INDEX idx_customers_email_lower ON customers (email_lower);
    ```

## 7. Index Storage and Write Performance

When you create an index, the database maintains it as a separate, sorted structure. This structure contains the indexed column(s) values and pointers to the actual data rows.

Let's imagine our `products` table and an index created on its `price` column.

**Conceptual Data Storage (Products Table):**

```
+-----------------------------------+
|          Products Table (on disk) |
|  (data pages, not necessarily sorted by price) |
+-----------------------------------+
| ID | Name       | Price | Pointer to Row |
|----|------------|-------|----------------|
| 1  | Widget A   | 19.99 | -> (Page 1, Row 1) |
| 5  | Widget E   | 34.99 | -> (Page 2, Row 3) |
| 3  | Widget C   | 24.99 | -> (Page 1, Row 3) |
| 2  | Widget B   | 9.99  | -> (Page 2, Row 1) |
+-----------------------------------+
```

**Conceptual Index Storage (idx_products_price - a B-Tree index):**

This is a simplified view of how the B-tree index would store the `price` values in sorted order, each pointing to the corresponding full data row.

```
+------------------------------------------------+
|        idx_products_price (on disk)           |
|  (sorted by price, with pointers to data rows) |
+------------------------------------------------+
| Price | Row Pointer                            |
|-------|----------------------------------------|
| 9.99  | -> (Page 2, Row 1 - Widget B)          |
| 19.99 | -> (Page 1, Row 1 - Widget A)          |
| 24.99 | -> (Page 1, Row 3 - Widget C)          |
| 34.99 | -> (Page 2, Row 3 - Widget E)          |
+------------------------------------------------+
```

### How Insertion Slows Down (Write Overhead)

When you **INSERT** a new product into the `products` table (e.g., "Widget F" at 15.99):

1.  **Write to Table:** The new row for "Widget F" is written to the next available space in a data page in the `products` table.
2.  **Update Index:** The database must then also insert "15.99" into the `idx_products_price` index, maintaining its sorted order. This might involve finding the correct spot in the B-tree, potentially updating multiple index pages, and even rebalancing the tree structure (as shown in the B-tree illustration earlier).

This second step (updating the index) adds overhead. The more indexes you have on a table, the more work the database has to do for each `INSERT`, `UPDATE`, or `DELETE`, because each affected index needs to be updated and kept consistent.

This is the "cost" of indexes: faster reads come with slower writes and increased storage.

## 8. Indexing Strategies and Optimization with EXPLAIN

### Guidelines for Strategic Indexing

Indexing is not about indexing _every_ column. It's about indexing _strategically_ to optimize common query patterns without incurring excessive write overhead.

- **Index Columns in `WHERE` Clauses:** If you frequently filter data based on a column (e.g., `WHERE email = '...'`, `WHERE order_date > '...'`), that column is a prime candidate for an index.
- **Index Columns in `JOIN` Conditions:** Columns used in `ON` clauses of `JOIN` statements (especially foreign keys and primary keys) should almost always be indexed. This dramatically speeds up how the database links tables.
- **Index Columns in `ORDER BY` Clauses:** If you frequently sort your results by a particular column or set of columns, an index can help the database retrieve the data already in the desired order, avoiding a costly sort operation.
- **Index Columns in `GROUP BY` Clauses:** Similar to `ORDER BY`, an index can help group operations by ensuring data is already ordered.
- **Consider Composite Indexes:** If you often filter by `(column1 AND column2)`, a composite index on `(column1, column2)` is often more efficient than two separate single-column indexes. The order of columns in the composite index matters – put the most selective (most frequently filtered, with highest uniqueness) columns first.
- **Consider Covering Indexes:** For very frequent, specific `SELECT` queries that only need a few columns, a covering index (that includes all `SELECT`ed columns and `WHERE`ed columns) can be very powerful by avoiding a trip to the main data table.

### The Problem of Over-Indexing

While indexes are good, **over-indexing is bad** and can actually _worsen_ performance, especially for tables with high write traffic.

- **Increased Write Latency:** Every write (INSERT, UPDATE, DELETE) needs to update all relevant indexes, making these operations slower.
- **More Disk Space:** Indexes consume significant disk space.
- **Slower Full Table Scans (sometimes):** The optimizer might get "confused" by too many indexes or choose a suboptimal index.
- **Cache Inefficiency:** Large, unnecessary indexes can push more useful data out of the buffer pool.

**Key Takeaway:** Find the right balance. Index for your common read patterns, but be mindful of the write costs.

### Analyzing Query Performance with `EXPLAIN`

The `EXPLAIN` command (or `EXPLAIN ANALYZE` in some databases) is an indispensable tool for understanding how your database executes a query. It shows you the query plan – how the database optimizer intends to find and process the data.

**Syntax:**

```sql
EXPLAIN <your_select_query_here>;
```

**How to Interpret Basic `EXPLAIN` Output (MySQL):**

After running `EXPLAIN` on a query, you'll see a table with several columns. Here are some key ones:

- **`id`**: The select query's ID.
- **`select_type`**: The type of select query (e.g., `SIMPLE`, `PRIMARY`, `SUBQUERY`).
- **`table`**: The table being queried.
- **`type`**: This is one of the _most important_ columns. It describes how the table is accessed:
  - `ALL`: Full table scan (BAD for large tables, means no suitable index was used).
  - `index`: Full index scan (reading the entire index; better than `ALL` if the index is covering or smaller than table).
  - `range`: Index range scan (GOOD; uses an index to find rows within a range).
  - `ref`: Non-unique index lookup (GOOD; uses an index for non-unique values).
  - `eq_ref`: Unique index lookup (VERY GOOD; uses a unique index for joins).
  - `const`, `system`: Extremely fast, single-row lookups (VERY GOOD).
- **`possible_keys`**: Indexes that _could_ potentially be used.
- **`key`**: The actual index the optimizer _chose_ to use. If this is `NULL`, no index was used.
- **`key_len`**: The length of the key used.
- **`ref`**: Shows which columns or constants are compared to the `key`.
- **`rows`**: An estimate of the number of rows the database expects to examine. Lower is better.
- **`Extra`**: Additional information, like "Using where", "Using index" (covering index), "Using filesort" (sorting without an index, which is slow), "Using temporary" (temporary table, which is also slow).

**Adjusting Your Approach Based on `EXPLAIN` Results:**

1.  **See `type: ALL` on a large table:**

    - **Action:** Consider adding an index to the column(s) used in the `WHERE` clause.
    - **Re-run `EXPLAIN`:** Check if the new index is now used (`type: range`, `ref`, etc.) and `key` is populated.

2.  **See `Extra: Using filesort`:**

    - **Action:** Add an index (often composite) on the column(s) used in the `ORDER BY` clause, in the same order as the `ORDER BY`.

3.  **See `Extra: Using temporary`:**
    - **Action:** This often occurs with `GROUP BY` or `DISTINCT` without a suitable index. Consider an index on the `GROUP BY` column(s).

**Example using `EXPLAIN`:**

Suppose `customers` table has no index on `email`.

```sql
EXPLAIN SELECT * FROM customers WHERE email = 'alice@example.com';
```

**Likely Output (without index on email):**

| id  | select_type | table     | type | possible_keys | key  | key_len | ref  | rows  | Extra       |
| --- | ----------- | --------- | ---- | ------------- | ---- | ------- | ---- | ----- | ----------- |
| 1   | SIMPLE      | customers | ALL  | NULL          | NULL | NULL    | NULL | 10000 | Using where |

- **`type: ALL`** indicates a full table scan. This is bad for large tables.

Now, add an index:

```sql
CREATE INDEX idx_customers_email ON customers (email);
```

Re-run `EXPLAIN`:

```sql
EXPLAIN SELECT * FROM customers WHERE email = 'alice@example.com';
```

**Likely Output (with index on email):**

| id  | select_type | table     | type | possible_keys       | key                 | key_len | ref   | rows | Extra                 |
| --- | ----------- | --------- | ---- | ------------------- | ------------------- | ------- | ----- | ---- | --------------------- |
| 1   | SIMPLE      | customers | ref  | idx_customers_email | idx_customers_email | 403     | const | 1    | Using index condition |

- **`type: ref`** indicates an index lookup.
- **`key`** shows the index was used.
- **`rows`** is much lower (e.g., 1). This is good!

`EXPLAIN` is your best friend for query optimization. It allows you to peek into the database's brain and confirm if your indexing strategy is working as intended.

## 9. Sharding: Scaling Out Your Data (Brief Introduction)

As databases grow very large (terabytes of data, millions of users), a single server might hit its limits in terms of storage, CPU, or I/O. When you need to scale beyond the capabilities of one machine, you generally have two primary options:

1.  **Scale Up (Vertical Scaling):** Get a bigger, more powerful server (more RAM, faster CPU, more storage, faster disks). This is simpler to manage but eventually hits physical and cost limits.
2.  **Scale Out (Horizontal Scaling / Sharding):** Distribute your data across multiple, less powerful servers. This is where **sharding** comes in.

### What is Sharding?

**Sharding** is a technique for horizontally partitioning data across multiple database servers. Instead of one large database, you have several smaller, independent databases (or **shards**), each holding a subset of the total data.

### Why Shard?

- **Massive Scalability:** Overcome the physical limits of a single machine for storage and processing by distributing data and query load across many machines.
- **Improved Performance:** Queries can run faster because they only need to access data on a single shard or a few shards, reducing the working set of data per server.
- **Increased Availability & Resilience:** If one shard goes down, only a portion of your data is affected, and other shards can remain operational. This prevents a single point of failure and improves overall system uptime.
- **Geographic Distribution:** Place data closer to users in different regions for lower latency and compliance.

### Common Sharding Strategies

- **Range-Based Sharding:** Data is partitioned based on a range of values in a specific column (e.g., customers with IDs 1-1,000,000 on Shard A, 1,000,001-2,000,000 on Shard B). Simple to implement, but can lead to "hot spots" (one shard gets all new data or most queries if the range is frequently accessed).
- **Hash-Based Sharding:** A hash function is applied to a chosen sharding key (e.g., `customer_id`), and the result determines which shard the data goes to. This usually provides a very even distribution of data across shards. However, range queries (e.g., "find all customers between X and Y") become difficult as data is scattered across shards.
- **Directory-Based Sharding:** A lookup service (a separate database or service) keeps track of which shard holds which data ranges or specific keys. This offers high flexibility (e.g., easily rebalancing shards, moving data) but adds a dependency on the lookup service.

### Querying Across Shards (The Complexity of Scale-Out)

While sharding solves scalability problems, it introduces significant complexity, particularly for querying:

- **Single-Shard Queries:** Queries that target data entirely within a single shard are relatively straightforward, as they can be routed directly to that shard.
- **Multi-Shard Queries (Fan-Out Queries):** If a query needs data from multiple shards (e.g., "find all products with prices between $10 and $20" in a hash-sharded product database), the application or query router must:
  1.  Send the query to _all_ relevant shards (a "fan-out" operation).
  2.  Wait for responses from all shards.
  3.  Aggregate and combine the results. This can be much slower than a single-shard query.
- **Distributed Joins:** Joining tables where the data for the joined entities lives on _different_ shards is extremely challenging. It often requires:
  - Moving large amounts of data between shards.
  - Complex application logic to perform the join.
  - Careful design to avoid "super-hot" shards that become bottlenecks for these joins.
- **Distributed Aggregation:** Performing `COUNT`, `SUM`, `AVG`, etc., across data on multiple shards requires a two-step process:
  1.  Perform local aggregation on each shard.
  2.  Combine the local aggregated results for a global aggregate.

**Note:** Sharding is an advanced, architectural topic. It's usually considered for very large-scale applications (e.g., social media platforms, large e-commerce sites) facing significant growth challenges. For most applications, optimizing indexing and database design on a single powerful server is the first step and often sufficient for years.

## 10. Recap

- Databases store data in pages on disk and use memory (buffer pool) to cache frequently accessed data.
- A **full table scan** (reading every row) is slow for large tables.
- **Indexes** are like a book's index, helping the database quickly find specific rows based on the values in indexed columns.
- Different index types (B-Tree, Hash, Unique, Composite, Covering, Fulltext, Spatial, Functional, GIN) are optimized for different tasks.
- **B-trees** are the default all-rounder in MySQL.
- **Unique constraints** and **primary keys** are implemented using unique indexes.
- You can create indexes explicitly using `CREATE INDEX`.
- **Functional indexes** (using generated columns or direct syntax) allow indexing transformed data.
- Indexes speed up reads but can slow down writes and consume storage. **Over-indexing can harm performance.**
- The **`EXPLAIN` command** is a crucial tool to analyze how your queries are executed and verify if indexes are being used.
- **Sharding** is a technique to scale very large databases by distributing data across multiple servers, offering better scalability and availability, but introducing significant querying complexity.

## Next Steps

You’ve completed the lesson on querying under the hood and indexing!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 8: Indexing and Query Performance](../homework/hw8.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.
