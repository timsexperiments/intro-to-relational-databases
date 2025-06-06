# Homework 7: Joins

## Objectives

- Practice combining data from multiple tables in your library schema
- Use table and column aliases for clarity
- Interpret and explain join results, including NULLs

## Instructions

Write a SQL script (`hw7.sql`) that answers the following questions using your existing library schema and test data from previous homeworks.  
For each question, include a comment with the question number and a brief description.

### 1. List all members and the books they have checked out (show member name, book title, checkout date).

### 2. List all books and their authors (show book title and author name).

### 3. List all books, and for each, show the title and the name of any member who has checked it out.

_(Books that have never been checked out should still appear, with NULL for member name.)_

### 4. List all authors and the books they have written, including authors who have not written any books.

### 5. List all checkouts, showing the member name, book title, and review text if a review exists for that checkout.

### 6. List all members and all reviews they have written, including members who have never written a review.

### 7. List all books and all members, showing every possible combination.

_(Limit to 10 results.)_

### 8. List all members and all checkouts, showing member name and checkout date, including members with no checkouts and checkouts with no matching member.

_(If your database does not support FULL JOIN, you may need to use another approach.)_

## Submission

- Save your SQL queries in a file named `hw7.sql`.
- Place the file in:  
  `submissions/homework_7/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_7/
    your-github-username/
      hw7.sql
```

## Tips

- Use your test data from previous homeworks.
- Use comments (`--`) to label each query and explain your approach if needed.
- Use table and column aliases for clarity.
- If you get stuck, review the lesson or ask for help!
