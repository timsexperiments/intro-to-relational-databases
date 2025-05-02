# Homework 2: Database Fundamentals

## Objectives

- Practice designing tables with appropriate data types and constraints
- Define and enforce relationships using foreign keys
- Use `ALTER TABLE` to modify your schema
- Demonstrate understanding of one-to-many and many-to-many relationships

---

## Scenario

You are designing a database for a small library. The library wants to keep track of books, authors, and which books are checked out by which members.

---

## Tasks

### 1. Table Design

- **Create a table for `books`** with at least the following columns:
  - `id` (primary key, auto-increment)
  - `title` (string, required)
  - `isbn` (string, unique, required)
  - `published_year` (integer)
- **Create a table for `authors`** with at least:
  - `id` (primary key, auto-increment)
  - `name` (string, required)
- **Create a join table for `book_authors`** to support books with multiple authors and authors with multiple books.

### 2. Relationships

- Enforce a **many-to-many relationship** between books and authors using the `book_authors` table.
- **Create a table for `members`** (library members) with at least:
  - `id` (primary key, auto-increment)
  - `name` (string, required)
  - `email` (string, unique, required)
- **Create a table for `checkouts`** to track which member has checked out which book, and when:
  - `id` (primary key, auto-increment)
  - `book_id` (foreign key to `books`)
  - `member_id` (foreign key to `members`)
  - `checkout_date` (datetime, default to now)
  - `due_date` (datetime, required)

### 3. Constraints

- Ensure all required fields are `NOT NULL`.
- Ensure `isbn` and `email` are unique.
- Use appropriate foreign keys to enforce relationships.
- Name at least one constraint explicitly.

### 4. Altering Tables

- Add a `returned_date` column (nullable DATETIME) to the `checkouts` table.
- Change the `name` column in `members` to allow up to 150 characters.

### 5. Data Integrity

- Try to insert a checkout for a non-existent book or member and observe the error.
- Try to insert two books with the same ISBN and observe the error.

---

## Submission

- Save your SQL commands in a file named `hw.sql`.
- Write a brief explanation in `hw.md` describing your design choices, any named constraints, and what happened when you tried to violate constraints.
- Place both files in:  
  `submissions/homework_3/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

---

## Example Directory Structure

```
submissions/
  homework_3/
    your-github-username/
      hw.sql
      hw.md
```

---

## Tips

- Use `CREATE TABLE` and `ALTER TABLE` as needed.
- Use `INSERT INTO` to test your constraints.
- Use `DESCRIBE <table_name>;` to check your table structure.
- If you get stuck, review the lesson or ask for help!
