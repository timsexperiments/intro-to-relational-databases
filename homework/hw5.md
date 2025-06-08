# Homework 5: Inserting, Deleting, and Updating Data

## Objectives

- Practice inserting, updating, and deleting data using SQL
- Use WHERE clauses with different operators
- Safely modify data using transactions (commit and rollback)
- Prepare a consistent set of test data for future querying assignments
- Clean up your database before inserting new test data, regardless of your table structure

## General Items in Your Library Database

Your schema (from previous homeworks) should include, at minimum:

- `books` (id, title, isbn, published_year, etc.)
- `authors` (id, name, etc.)
- `book_authors` (for many-to-many books/authors)
- `members` (id, name, email, etc.)
- `member_profiles` (optional, for extra member info)
- `checkouts` (id, book_id, member_id, checkout_date, due_date, returned_date, etc.)
- `reviews` (id, book_id, member_id, review_text, rating, created_at, etc.)

## Instructions

### 1. Clean Up Your Database

- At the **start of your script**, delete all records from every table in your schema (do not drop tables).
- **Do not** assume specific table names—delete from all tables you created in your previous homework(s).
- **Tip:** You may need to temporarily disable or reorder foreign key checks to avoid constraint errors.

### 2. Insert Test Data

Insert at least the following (feel free to add more for richer queries later):

- **4 books** (with different titles, isbns, and published years)
- **3 authors** (with different names)
- **At least 2 books with multiple authors, and at least 1 author with multiple books** (populate `book_authors`)
- **4 members** (with different names and emails)
- **At least 2 member profiles** (for members who have extra info)
- **5 checkouts** (with at least 2 checkouts per member, and at least 1 book checked out by multiple members)
- **3 reviews** (at least 2 members should review at least 2 different books)

**Make sure your data covers:**

- At least one member with no checkouts
- At least one book that is not checked out
- At least one book with no reviews

### 3. Update Data

- Update the email address for one member using their primary key or unique key.
- Update the published year for one book.
- Mark one checkout as returned by setting its `returned_date` to the current timestamp.
- Update the rating of a review.

### 4. Delete Data

- Delete a member who has no checkouts.
- Delete all books published before 2000.
- Demonstrate a **soft delete** by marking a member as deleted (e.g., set `deleted_at` or `is_deleted`).

### 5. Transactions

- Write a transaction that:
  - Inserts a new checkout and a new review for a book
  - Updates the member profile (e.g., change address or phone)
  - Then **rolls back** the transaction (so the data is not saved)
- Write another transaction that:
  - Inserts a new checkout and a new review for a book
  - Updates the member profile
  - Then **commits** the transaction (so the data is saved)

### 6. Submission

- Save all your SQL commands in a file named `hw5.sql`.
- Write a brief explanation in `hw5.md` describing:
  - Any issues you encountered (e.g., with foreign keys or transactions)
  - How you handled cleaning up your tables
  - How you implemented the soft delete
  - What you learned about transactions (commit vs. rollback)
- Place both files in:  
  `submissions/homework_5/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_5/
    your-github-username/
      hw5.sql
      hw5.md
```

## Tips

- Use `DELETE FROM table_name;` to clear tables, and consider disabling foreign key checks with `SET FOREIGN_KEY_CHECKS = 0;` and re-enabling with `SET FOREIGN_KEY_CHECKS = 1;` if needed.
- Use `START TRANSACTION; ... COMMIT;` and `START TRANSACTION; ... ROLLBACK;` to test transactions.
- Use `UPDATE ... WHERE ...` and `DELETE ... WHERE ...` with care—always test on a copy or with a transaction if you’re unsure.
- For soft deletes, use a column like `deleted_at` or `is_deleted` and update it instead of deleting the row.

## Hints (if you need them)

- To delete all records from a table: `DELETE FROM table_name;`
- To update a specific record, use the primary key: `UPDATE members SET email = 'new@email.com' WHERE id = 1;`
- To soft delete: `UPDATE members SET deleted_at = CURRENT_TIMESTAMP WHERE id = 2;`
- To test rollback: Start a transaction, make changes, then use `ROLLBACK;` and check that the changes are not saved.
- To test commit: Start a transaction, make changes, then use `COMMIT;` and check that the changes are saved.
