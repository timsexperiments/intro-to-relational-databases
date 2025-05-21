# Homework 6: Basic SELECT Queries

## Objectives

- Practice writing SELECT queries to retrieve and display data from your library schema
- Use WHERE to filter results with various operators (including LIKE)
- Use ORDER BY to sort results (including by non-selected columns)
- Use LIMIT and OFFSET to restrict results
- Use column aliases and string concatenation
- Prepare for more advanced querying in future assignments

## Instructions

Write a SQL script (`hw6.sql`) that answers the following questions using your existing library schema and test data from previous homeworks.  
For each question, include a comment with the question number and a brief description.

### 1. Select all columns for all members.

### 2. Select only the names and emails of all members, sorted alphabetically by email.

### 3. Select all books with a published year after 2010, showing only the title and published_year.

### 4. Select the 3 most recent checkouts (by checkout_date), showing checkout_id, member_id, book_id, and checkout_date.

### 5. Select all checkouts for a specific member (choose one from your data), showing checkout_id, book_id, and due_date.

### 6. Select all books with "Python" in the title (use LIKE), showing title and isbn.

### 7. Select all members whose email contains "edu" (use LIKE).

### 8. Select all books whose title starts with "The" (use LIKE).

### 9. Select all checkouts that have not been returned (returned_date is NULL).

### 10. Select the names of all members, but display them as "Member: [name]" using an alias.

### 11. Select book titles and published years, and display a new column called "age" (current year minus published_year), sorted by age descending.

_(Hint: In MySQL, use `YEAR(CURDATE()) - published_year` for age.)_

### 12. Select the first 2 books (by ascending title).

### 13. Select the next 2 books (by ascending title), skipping the first 2.

### 14. Select all reviews, showing only review_id, book_id, member_id, and rating, sorted by rating descending and then by created_at ascending.

### 15. Select all members, sorted by email, but only display the name and an alias called "contact" for the email.

### 16. Select all books, showing the title and a column called "title_upper" with the title in uppercase (use the UPPER function).

### 17. Select all members whose name contains an "a" (case-insensitive), using LIKE.

### 18. Select all books, showing the title and the first 4 characters of the ISBN (use the LEFT function).

## Submission

- Save your SQL queries in a file named `hw6.sql`.
- Place the file in:  
  `submissions/homework_6/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_6/
    your-github-username/
      hw6.sql
```

## Tips

- Use your test data from previous homeworks.
- Use comments (`--`) to label each query.
- Use aliases (`AS`) and string concatenation where appropriate.
- Use LIMIT and OFFSET for pagination.
- Use WHERE with different operators, including LIKE.
- Use string functions like UPPER and LEFT where needed.
- If you get stuck, review the lesson or ask for help!
