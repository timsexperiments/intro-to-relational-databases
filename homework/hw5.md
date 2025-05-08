# Homework 5: Inserting, Deleting, and Updating Data

## Objectives

- Practice inserting, updating, and deleting data using SQL
- Use WHERE clauses with different operators
- Safely modify data using transactions (commit and rollback)
- Prepare a consistent set of test data for future querying assignments
- Clean up your database before inserting new test data, regardless of your table structure

## Instructions

### 1. Clean Up Your Database

- At the **start of your script**, delete all records from every table in your schema (do not drop tables).
- **Do not** assume specific table names—delete from all tables you created in your previous homework(s).
- **Tip:** You may need to temporarily disable or reorder foreign key checks to avoid constraint errors.

### 2. Insert Test Data

- Insert at least **3 customers**, **3 products**, and **3 orders** (with at least 2 order line items per order).
- Use realistic, varied data (names, emails, product names, prices, order dates, etc.).
- Make sure your data covers:
  - At least one customer with no orders
  - At least one product that is not included in any order
  - At least one order with multiple products

### 3. Update Data

- Update the email address for one customer using their primary key or unique key.
- Increase the price of all products by 10%.
- Mark one order as shipped by setting its status and shipped date (use `CURRENT_TIMESTAMP`).

### 4. Delete Data

- Delete a customer who has no orders.
- Delete all products with a price greater than $50 or less than $5.
- Demonstrate a **soft delete** by marking a customer as deleted (e.g., set `deleted_at` or `is_deleted`).

### 5. Transactions

- Write a transaction that:
  - Inserts a new order and at least one order line item
  - Updates the product stock (if you track stock)
  - Then **rolls back** the transaction (so the data is not saved)
- Write another transaction that:
  - Inserts a new order and at least one order line item
  - Updates the product stock (if you track stock)
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
- To update a specific record, use the primary key: `UPDATE customers SET email = 'new@email.com' WHERE id = 1;`
- To soft delete: `UPDATE customers SET deleted_at = CURRENT_TIMESTAMP WHERE id = 2;`
- To test rollback: Start a transaction, make changes, then use `ROLLBACK;` and check that the changes are not saved.
- To test commit: Start a transaction, make changes, then use `COMMIT;` and check that the changes are saved.
