You're absolutely right! Making the "Book Title Initials" clearer and adding specific queries that _require_ functions/`CASE WHEN` in `UPDATE ... SET`, `WHERE`, and `ORDER BY` will significantly strengthen the homework.

Here’s the revised **Homework 9: Expressions and Functions**, with these crucial additions and clarifications.

# Homework 9: Expressions and Functions

## Objectives

- Apply arithmetic, string, date/time, and mathematical functions to your library data
- Utilize conditional logic (`CASE WHEN` or `IF`) to categorize and transform data
- Use common utility functions like `COALESCE` and `LAST_INSERT_ID()`
- Format and derive new insights from your existing data
- Practice applying aliases to complex expressions for readability
- **Demonstrate the use of functions/expressions in `UPDATE ... SET`, `WHERE`, and `ORDER BY` clauses**

## Instructions

Write a SQL script (`hw9.sql`) that answers the following questions using your existing library schema and test data from previous homeworks. For each question, include a comment with the question number and a brief description.

### Part 1: Arithmetic & Basic Calculations

1.  **Book Age:** List all books, showing their title, published year, and a new column named `book_age` which is the number of years since the book was published (current year minus published year).
2.  **Overdue Days:** For all checkouts, show the `checkout_id`, `book_id`, `member_id`, and a new column `days_overdue` calculated as the difference in days between `CURRENT_DATE()` and the `due_date`. (Do not worry about negative numbers for now).
3.  **Review Score Transformation:** List all reviews, showing `review_id`, `rating`, and a `normalized_rating` where the original rating (1-5) is scaled to a 0-100 scale (with 1 mapping to 0, and 5 mapping to 100) (e.g., rating of 3 = 50). Use arithmetic.

### Part 2: String & Text Manipulation

4.  **Formatted Member Names:** List all members, displaying their name as "LASTNAME, FirstName" (e.g., "SMITH, Alice") using string functions. Assume names are "FirstName LastName".
5.  **Book Title Initials:** For each book, display the title and its initials. A book's initials are the first letter of the first two words of the book (e.g., "The Hobbit" -> "TH", "Concurrency in Go" -> "CG"). You may need to use `SUBSTRING` and `LOCATE` or `INSTR` to find the space between words.
6.  **Censored Review Text:** List all reviews, showing `review_id`, `rating`, and the `review_text` where all occurrences of the word "bad" (case-insensitive) are replaced with "\*\*\*" (use `REPLACE` and `LOWER` functions).
7.  **Email Domain:** For each member, list their `name`, `email`, and a new column `email_domain` (e.g., `dragonrider42@game.com` -> `game.com`).

### Part 3: Date & Time Operations

8.  **Formatted Checkout Date:** List all checkouts, showing `checkout_id` and the `checkout_date` formatted as "Month Day, Year (Hour:Minute AM/PM)" (e.g., "May 01, 2024 (10:30 AM)").
9.  **Checkout Month:** List all checkouts, showing `checkout_id`, `book_id`, and the `month_of_checkout` (as a number, e.g., 5 for May).
10. **Book Due Status:** For each checkout, show `checkout_id`, `due_date`, and a new column `return_deadline` which is the `due_date` plus 7 days.

### Part 4: Conditional Logic (`CASE WHEN` / `IF`)

11. **Book Popularity Category:** List all books, showing their title and a new column `popularity_category`. If the book has `3 or more` checkouts (you'll need to use a subquery or make an assumption on data if aggregation is not allowed yet), categorize it as 'Highly Popular', if `1-2` checkouts 'Moderately Popular', otherwise 'Not Popular'. (Assume you can count checkouts, or just classify based on some other condition for now if aggregation is strictly next lesson).
12. **Review Sentiment:** List all reviews, showing `review_id`, `rating`, and a `sentiment` column: 'Positive' if rating is 4 or 5, 'Neutral' if 3, and 'Negative' if 1 or 2.
13. **Member Status:** List all members, showing their name and a `member_status` column: 'Active' if they have any current checkouts (returned_date IS NULL), otherwise 'Inactive'.

### Part 5: Mathematical & Utility Functions

14. **Rounded Ratings:** For all reviews, show `review_id`, original `rating`, and a `rounded_rating` (round the rating to the nearest whole number if it were a decimal, for practice using `ROUND`).
15. **Random Book Selection:** Select any 3 book titles in a random order (use `RAND()` in your `ORDER BY` and `LIMIT`).
16. **Handle Missing Phone Number:** List all members, showing their `name` and their `contact_info`. If `member_profiles.phone` exists, use that. Otherwise, use `member.email`. If neither exist, display 'No contact provided'. (Requires `COALESCE` and a `LEFT JOIN` to `member_profiles`).
17. **New Unique ID:** Show a new UUID for a hypothetical new book entry (use `UUID()`).

### Part 6: Applying Functions Across Commands

18. **Update Checkout Due Dates:**  
    Update the `due_date` for all checkouts to be 21 days from their `checkout_date` if they were checked out before '2024-01-01', otherwise set it to 14 days from `checkout_date`.
19. **Select Overdue Checkouts:**  
    Select all `checkout_id`s, `book_id`s, and `member_id`s for checkouts that are currently overdue (i.e., `CURRENT_DATE()` is past the `due_date` and `returned_date` is `NULL`).
20. **Order Members by Email Length:**  
    Select all members, showing their `name` and `email`, but order them by the `LENGTH` of their email address (shortest to longest).

## Submission

- Save your SQL queries in a file named `hw9.sql`.
- Place the file in:
  `submissions/homework_9/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_9/
    your-github-username/
      hw9.sql
```

## Tips

- Use your test data from previous homeworks.
- Use comments (`--`) to label each query and explain your approach.
- Use aliases (`AS`) for all calculated or transformed columns for readability.
- Remember to use `JOIN` where necessary to access data from related tables.
- For `CASE WHEN` and `IF`, consider all possible scenarios for your data.
- For Task 5 (Book Title Initials), remember `SUBSTRING` and `LOCATE` or `INSTR` are your friends! Look for the first space.
- If you get stuck, review the lesson or ask for help!
