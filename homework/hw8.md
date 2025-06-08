# Homework 8: Indexing and Query Performance

## Objectives

- Apply strategic indexing techniques to your existing library database schema
- Understand the impact of indexes on query execution and verify with `EXPLAIN`
- Demonstrate comprehension of different index types and their use cases
- Answer conceptual questions about database storage, indexing, and scaling

## Part 1: Indexing Your Library Schema and Testing Queries

Based on your library schema from previous homeworks (books, authors, members, checkouts, reviews, `book_authors`, `member_profiles`), add appropriate indexes and then write queries to test them.

### 1.1 Add Indexes

- **Goal:** Think about common queries you would run in a library system (e.g., searching for books by title, finding a member by email, listing all checkouts for a member, showing books by a specific author).
- **Include `CREATE INDEX` statements for:**

  - At least **one standard index** (B-tree) on a single column not already indexed by a `PRIMARY KEY` or `UNIQUE` constraint.
  - At least **one composite index** on a table that could benefit from filtering/sorting on multiple columns together.
  - At least **one functional index** (e.g., for case-insensitive search on a relevant column like `member.email` or `book.title`).
  - At least **one `FULLTEXT` index** (if applicable to your schema and MySQL's default setup, e.g., on a `review_text` or `book_description` column).
  - Ensure that **all foreign key columns are indexed** for efficient join performance. (You may have done this in previous homeworks; if so, confirm they exist, or add them if missing.)

- **Save your index creation statements** in `hw8.sql`.

### 1.2 Write Queries to Test Indexes

For each of the indexes you created (or confirmed for foreign keys), write a `SELECT` query that you expect to use that index for optimal performance.

- **For each query:**

  1.  Write the `SELECT` query.
  2.  Add a comment above the query explaining which index you expect it to use and why.
  3.  Run `EXPLAIN` on your query in your MySQL shell (e.g., `EXPLAIN SELECT ...;`).
  4.  In your `hw8.md` file, for each query, note down the `type` and `key` columns from the `EXPLAIN` output to confirm the index was used.

- **Save your `SELECT` queries** in `hw8.sql`.

## Part 2: Normal Form and Indexing Questions

Answer the following questions. Write your answers in a file named `hw8.txt`.
For each question, write your answer on a separate line. (For multiple choice, answer with A, B, C, or D. For short answer, provide a concise explanation.) The line number should match the question number.

### Questions

1.  What is a "full table scan" and why is it generally inefficient for large tables?
2.  Explain the difference between a "cache hit" and a "cache miss" in the context of database data retrieval.
3.  What is the primary benefit of a B-tree index?
4.  Describe a scenario where a hash index would be more efficient than a B-tree index. What is a key limitation of hash indexes?
5.  What is a composite index? Provide an example from your library schema and describe a query it would optimize.
6.  How does a `PRIMARY KEY` constraint relate to indexing in MySQL?
7.  Explain the main trade-off involved when adding an index to a database table.
8.  You want to optimize case-insensitive searches on `member.email` in your library. What type of index would you create, and how would you create it in the latest version of MySQL?
9.  Which of the following is true about a covering index?
    A) It helps optimize queries that involve text search.
    B) It contains all columns needed by a query's `SELECT` list and `WHERE` clause.
    C) It enforces uniqueness across multiple columns.
    D) It is only useful for spatial data.
10. What is sharding?
11. Describe one common sharding strategy and a potential drawback of that strategy.
12. Explain why querying data that spans multiple shards can be more complex than querying a single database.
13. Which of the following index types is commonly found in PostgreSQL but not directly supported in MySQL as a standalone type for multi-valued data (like arrays or JSONB)?
    A) B-Tree Index
    B) GIN Index
    C) Fulltext Index
    D) Unique Index
14. You have a `reviews` table with a `review_text` column containing long pieces of text. What type of index would you use to efficiently search for keywords within these texts?
15. In your `book_authors` table, the primary key is typically a composite key on `(book_id, author_id)`. How does this primary key benefit join queries that use `book_id` or `author_id`?
16. What is the time complexity for searching a specific value in a B-tree index?
17. True or False: Adding many indexes to a table will always make all queries faster.
18. In the context of database scaling, what is the fundamental difference between "scaling up" and "scaling out"?

## Submission

- Save your SQL commands for Part 1 in `hw8.sql`.
- Save your answers to Part 2 in `hw8.txt`.
- **In `hw8.md`:** Write a brief explanation of your indexing choices in Part 1. For each query in Part 1.2, write down the `type` and `key` columns from the `EXPLAIN` output to demonstrate your index was used.
- Place all three files in:
  `submissions/homework_8/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_8/
    your-github-username/
      hw8.sql
      hw8.txt
      hw8.md
```

## Tips

- Review Lesson 8 thoroughly before attempting the questions.
- For Part 1.1, think about which columns in your library schema are frequently used in `WHERE`, `ORDER BY`, `JOIN` (foreign key columns), or `GROUP BY` conditions.
- For Part 1.2, ensure your `SELECT` queries' `WHERE` or `ON` clauses align with the indexes you've created. Remember to `EXPLAIN` your query!
- For Part 2, be concise and use your own words for short answers.
- Use the [Mermaid Playground](https://www.mermaidchart.com/play) for any ERD visualizations you need to help your thought process.
- If you get stuck, review the lesson or ask for help!
