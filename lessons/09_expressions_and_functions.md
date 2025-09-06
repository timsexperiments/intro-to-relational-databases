# Lesson 9: Expressions and Functions

## What You’ll Learn

- How to use arithmetic operations
- Common string manipulation functions, including regular expressions
- Essential date and time functions
- How to use conditional logic (`CASE WHEN`)
- Basic mathematical functions
- Converting data types
- Common utility functions for specific tasks
- Applying aliases to complex expressions for readability
- **How these expressions and functions are applied across `SELECT`, `UPDATE`, `DELETE`, and `JOIN` clauses**

## 1. Introduction

You've learned to select columns, filter rows, sort results, and combine data with `JOIN`s. But SQL offers much more power through **expressions** and **functions**.

Expressions allow you to perform calculations, combine data, or derive new values from existing columns. Functions provide built-in operations for manipulating numbers, strings, dates, and more.

Mastering expressions and functions will unlock powerful capabilities, not just for retrieving data in `SELECT` statements, but also for filtering data in `WHERE` clauses (for `SELECT`, `UPDATE`, `DELETE`) and for setting new values in `UPDATE` statements. They are fundamental tools for flexible and dynamic data manipulation in your database.

## 2. Arithmetic Expressions

You can perform basic arithmetic operations directly within your SQL statements to calculate new values based on existing columns. The standard arithmetic operators include `+` (addition), `-` (subtraction), `*` (multiplication), `/` (division), and `%` (modulo - the remainder of division).

**Syntax Example (in SELECT):**

```sql
SELECT column1, column2 <operator> column3 AS alias FROM table_name;
```

**Example: Calculating Price After Markup**
Let's calculate the price of each product if its current price were increased by 10%.

**Sample Data (products):**
| id | name | price |
|----|----------|-------|
| 1 | Widget A | 19.99 |
| 2 | Widget B | 9.99 |

**Query:**

```sql
SELECT name, price, price * 1.10 AS price_after_markup
FROM products;
```

**Sample Result:**
| name | price | price_after_markup |
|----------|-------|--------------------|
| Widget A | 19.99 | 21.989 |
| Widget B | 9.99 | 10.989 |

**Example: Calculating Line Item Total**
We can also combine arithmetic with joins to get more complex calculations, such as the total for each individual item within an order.

**Sample Data (order_line_items & products):**
| order_id | product_id | quantity | (from products) name | (from products) price |
|----------|------------|----------|----------------------|-----------------------|
| 1001 | 1 | 2 | Widget A | 19.99 |
| 1001 | 2 | 1 | Widget B | 9.99 |

**Query:**

```sql
SELECT
  oli.order_id,
  p.name AS product_name,
  oli.quantity,
  p.price,
  (oli.quantity * p.price) AS line_item_total
FROM order_line_items oli
JOIN products p ON oli.product_id = p.id;
```

**Sample Result:**
| order_id | product_name | quantity | price | line_item_total |
|----------|--------------|----------|-------|-----------------|
| 1001 | Widget A | 2 | 19.99 | 39.98 |
| 1001 | Widget B | 1 | 9.99 | 9.99 |

## 3. String Functions

SQL provides a rich set of functions specifically designed for manipulating text (string) data. These allow you to format, extract, or modify string values directly within your queries.

### String Concatenation: Different Operators

Combining strings is a very common operation. SQL offers a few ways to do this, depending on the database dialect:

- **`CONCAT(str1, str2, ...)` Function:** This is the most widely supported and recommended method, especially in MySQL. It's clear and works across many different SQL databases.
- **`||` Operator (Standard SQL / PostgreSQL / SQLite):** In standard SQL, the double pipe `||` is the concatenation operator. If you use PostgreSQL or SQLite, you'll see this commonly.
- **`+` Operator (SQL Server):** In SQL Server, the plus sign `+` is a common operator for string concatenation (though it can also perform arithmetic if types are ambiguous).

**We will primarily use the `CONCAT()` function in our examples** as it's explicitly supported and common in MySQL.

### Common String Functions Table

| Function                                   | Description                                                                  |
| :----------------------------------------- | :--------------------------------------------------------------------------- |
| `CONCAT(str1, str2, ...)`                  | Joins two or more strings together.                                          |
| `UPPER(str)`                               | Converts a string to uppercase.                                              |
| `LOWER(str)`                               | Converts a string to lowercase.                                              |
| `LENGTH(str)`                              | Returns the length of a string in characters.                                |
| `SUBSTRING(str, start, length)`            | Extracts a portion of a string. `start` is 1-indexed.                        |
| `TRIM(str)`                                | Removes leading and trailing spaces.                                         |
| `REPLACE(str, from_str, to_str)`           | Replaces all occurrences of `from_str` with `to_str`.                        |
| `LEFT(str, length)` / `RIGHT(str, length)` | Returns a specified number of characters from the beginning/end of a string. |

### Examples Using Common String Functions

**Example 1: Formatting Customer Display Information**
Let's combine customer name and email, convert product names to uppercase, and find the length of a customer's name.

**Sample Data (customers & products):**
| (customers) name | (customers) email | (products) name |
| :--------------- | :----------------------- | :-------------- |
| Alice Smith | dragonrider42@game.com | Widget A |

**Query:**

```sql
SELECT
  CONCAT(c.name, ' (', c.email, ')') AS customer_display,
  UPPER(p.name) AS product_name_upper,
  LENGTH(c.name) AS name_length
FROM customers c, products p
LIMIT 1; -- Limit to 1 row for illustrative purposes
```

**Sample Result:**
| customer_display | product_name_upper | name_length |
| :----------------------------------- | :----------------- | :---------- |
| Alice Smith (dragonrider42@game.com) | WIDGET A | 11 |

**Example 2: Manipulating Product Names and Emails**
Let's extract parts of a product name, replace characters, and trim a substring of an email.

**Sample Data (products & customers):**
| (products) name | (customers) email |
| :---------------- | :----------------------- |
| Awesome Widget | bob @example.com |
| Simple Gadget | |

**Query:**

```sql
SELECT
  p.name AS original_product_name,
  LEFT(p.name, 6) AS first_six_chars,
  REPLACE(p.name, 'Widget', 'Tool') AS name_replaced,
  TRIM(SUBSTRING(c.email, 0, 4)) AS trimmed_email_substring
FROM products p, customers c
LIMIT 1; -- For illustration
```

**Sample Result:**
| original_product_name | first_six_chars | name_replaced | trimmed_email_substring |
| :-------------------- | :-------------- | :------------ | :---------------------- |
| Awesome Widget | Awesom | Awesome Tool | bob |

### Advanced Pattern Matching: `REGEXP` / `RLIKE`

For more complex pattern matching than `LIKE` provides, SQL offers regular expression capabilities. In MySQL, this is done using the `REGEXP` or `RLIKE` operator, and a suite of `REGEXP_` functions (available in MySQL 8.0+).

**Common REGEXP Operators/Functions (MySQL):**

| Operator/Function                                        | Description                                                       |
| :------------------------------------------------------- | :---------------------------------------------------------------- |
| `REGEXP 'pattern'` / `RLIKE 'pattern'`                   | Checks if a string matches a regular expression pattern.          |
| `REGEXP_REPLACE(str, pattern, replacement)` (MySQL 8.0+) | Replaces occurrences of a pattern with a replacement string.      |
| `REGEXP_SUBSTR(str, pattern)` (MySQL 8.0+)               | Extracts the substring that matches a regular expression pattern. |

**Example: Finding Emails with Specific Domain Patterns**
Let's find customer emails that contain specific patterns using regular expressions.

**Sample Data (customers):**
| id | name | email |
|----|-------------|------------------------|
| 1 | Alice Smith | dragonrider42@game.com |
| 2 | Bob Johnson | bob@myco.net |
| 3 | Charlie Lee | charlie.tech@example.com |
| 4 | Dana | dana@personal.info |
| 5 | Eve | eve123@work.org |

**Query:**

```sql
-- Find emails that end with '.com' OR '.net'
SELECT name, email FROM customers WHERE email REGEXP '(\.com|\.net)$';
```

**Sample Result:**
| name | email |
| :---------- | :----------------------- |
| Alice Smith | dragonrider42@game.com |
| Bob Johnson | bob@myco.net |
| Charlie Lee | charlie.tech@example.com |

**Query:**

```sql
-- Find emails that start with 'a' or 'e' and contain a number
SELECT name, email FROM customers WHERE email REGEXP '^[ae].*[0-9]';
```

**Sample Result:**
| name | email |
| :---- | :--------------------- |
| Alice | dragonrider42@game.com |
| Eve | eve123@work.org |

**Note on `REGEXP` Performance:**  
While powerful, regular expression functions can be computationally intensive and may not use indexes efficiently, especially when the pattern starts with a wildcard (e.g., `^` anchors to the beginning for efficiency). Use them judiciously on large datasets.

## 4. Date and Time Functions

Working with dates and times is a common task in databases. SQL provides a variety of functions to extract parts of dates, format them, or perform date arithmetic.

**Common Date & Time Functions:**

| Function                                                                     | Description                                                       |
| :--------------------------------------------------------------------------- | :---------------------------------------------------------------- |
| `CURDATE()` / `CURRENT_DATE()`                                               | Returns the current date (YYYY-MM-DD).                            |
| `NOW()` / `CURRENT_TIMESTAMP()`                                              | Returns the current date and time (YYYY-MM-DD HH:MM:SS).          |
| `YEAR(date)` / `MONTH(date)` / `DAY(date)`                                   | Extracts the year, month, or day from a date.                     |
| `DATE_FORMAT(date, format)`                                                  | Formats a date/datetime into a specified string format.           |
| `DATEDIFF(date1, date2)`                                                     | Returns the number of days between two dates (`date1` - `date2`). |
| `ADDDATE(date, INTERVAL value unit)` / `DATE_ADD(date, INTERVAL value unit)` | Adds a specified interval to a date.                              |

**Example: Analyzing Order Dates**
Let's format the `order_date` for better readability and calculate how many days have passed since each order was placed.

**Sample Data (orders):**
| order_id | order_date |
|----------|---------------------|
| 1001 | 2024-05-01 10:30:00 |

**Query:**

```sql
SELECT
  id AS order_id,
  DATE_FORMAT(order_date, '%Y-%m-%d %H:%i') AS formatted_date,
  DATEDIFF(CURRENT_DATE(), order_date) AS days_since_order
FROM orders;
```

**Sample Result (assuming current date is 2024-05-15):**
| order_id | formatted_date | days_since_order |
| :------- | :------------------ | :--------------- |
| 1001 | 2024-05-01 10:30 | 14 |

## 5. Conditional Expressions (`CASE WHEN`)

The `CASE WHEN` statement allows you to embed `IF-THEN-ELSE` logic directly within your query. This is incredibly powerful for categorizing data, creating custom labels, or implementing complex business rules.

**Syntax:**

```sql
CASE
  WHEN condition1 THEN result1
  WHEN condition2 THEN result2
  ELSE result_else
END AS new_column_name
```

You can have multiple `WHEN` conditions. The first `WHEN` condition that evaluates to true will have its `result` returned. If no `WHEN` condition is true, the `ELSE` result is returned (or `NULL` if `ELSE` is omitted).

**Example: Categorizing Products by Price**
Let's classify products into 'Economy', 'Standard', or 'Premium' based on their price.

**Sample Data (products):**
| id | name | price |
|----|----------|-------|
| 1 | Widget A | 19.99 |
| 2 | Widget B | 9.99 |
| 3 | Widget C | 24.99 |

**Query:**

```sql
SELECT
  name,
  price,
  CASE
    WHEN price < 15.00 THEN 'Economy'
    WHEN price >= 15.00 AND price < 30.00 THEN 'Standard'
    ELSE 'Premium'
  END AS product_category
FROM products;
```

**Sample Result:**
| name | price | product_category |
| :------- | :---- | :--------------- |
| Widget A | 19.99 | Standard |
| Widget B | 9.99 | Economy |
| Widget C | 24.99 | Standard |

## 6. Mathematical Functions

SQL provides a set of common mathematical functions for numerical operations beyond basic arithmetic.

**Common Mathematical Functions:**

| Function                                        | Description                                              |
| :---------------------------------------------- | :------------------------------------------------------- |
| `ROUND(number, decimals)`                       | Rounds a number to a specified number of decimal places. |
| `CEIL(number)` / `CEILING(number)`              | Rounds a number up to the nearest integer.               |
| `FLOOR(number)`                                 | Rounds a number down to the nearest integer.             |
| `ABS(number)`                                   | Returns the absolute (positive) value of a number.       |
| `SQRT(number)`                                  | Returns the square root of a non-negative number.        |
| `POWER(base, exponent)` / `POW(base, exponent)` | Returns the `base` raised to the `exponent` power.       |
| `RAND()`                                        | Returns a random floating-point value between 0 and 1.   |

**Example: Rounding Product Prices**
Let's ensure our displayed product prices are perfectly rounded to two decimal places.

**Query:**

```sql
SELECT name, price, ROUND(price, 2) AS rounded_price
FROM products;
```

**Sample Result:**
| name | price | rounded_price |
| :------- | :---- | :------------ |
| Widget A | 19.99 | 19.99 |
| Widget B | 9.99 | 9.99 |

**Example: Using SQRT and POWER**
Let's calculate the square root of a product's price and its price raised to a certain power.

**Query:**

```sql
SELECT
  name,
  price,
  SQRT(price) AS price_sqrt,
  POWER(price, 2) AS price_squared -- price ^ 2
FROM products
WHERE price > 0; -- SQRT requires non-negative numbers
```

**Sample Result:**
| name | price | price_sqrt | price_squared |
| :------- | :---- | :---------------- | :------------ |
| Widget A | 19.99 | 4.470905908075775 | 399.6001 |
| Widget B | 9.99 | 3.160709062325376 | 99.8001 |

## 7. Conversion Functions

Sometimes you need to change data from one type to another (e.g., a number to a string, or a string to a date). Conversion functions allow you to do this explicitly.

**Common Conversion Functions:**

| Function                   | Description                     |
| :------------------------- | :------------------------------ |
| `CAST(value AS datatype)`  | Converts `value` to `datatype`. |
| `CONVERT(value, datatype)` | Similar to `CAST`.              |

**Example: Converting Data Types**
Let's see how to convert an integer ID to a string and a string to a date.

**Query:**

```sql
SELECT
  id,
  CAST(id AS CHAR) AS id_as_string,
  CAST('2024-05-15' AS DATE) AS cast_date
FROM customers LIMIT 1;
```

**Sample Result:**
| id | id_as_string | cast_date |
| :-- | :----------- | :--------- |
| 1 | 1 | 2024-05-15 |

## 8. Common Utility Functions

Beyond category-specific functions, SQL offers several general-purpose utility functions that are extremely useful for common database tasks, often related to unique identifiers or handling missing data.

### `CURRENT_TIMESTAMP()` / `NOW()`

These functions return the current date and time. `CURRENT_TIMESTAMP()` is standard SQL, while `NOW()` is common in MySQL. They are frequently used for timestamps of creation or last modification.

**Example:**

```sql
SELECT CURRENT_TIMESTAMP() AS current_datetime, NOW() AS now_datetime;
```

### `UUID()`

Generates a Universally Unique Identifier (UUID), which is a 128-bit number used to create unique IDs across distributed systems. Useful if you're using UUIDs as primary keys instead of auto-incrementing integers.

**Example:**

```sql
SELECT UUID() AS new_unique_id;
```

### `LAST_INSERT_ID()`

Returns the `AUTO_INCREMENT` value generated by the last `INSERT` statement for an `AUTO_INCREMENT` column. This is crucial for retrieving the ID of a newly inserted row, especially when performing chained inserts (like an `orders` table then `order_line_items`).

**Example (within a transaction):**

```sql
START TRANSACTION;
INSERT INTO orders (customer_id) VALUES (1);
SET @last_order_id = LAST_INSERT_ID(); -- Store the ID of the new order
INSERT INTO order_line_items (order_id, product_id, quantity) VALUES (@last_order_id, 101, 2);
COMMIT;
SELECT @last_order_id;
```

### `COALESCE(expr1, expr2, ...)`

Returns the first non-`NULL` expression in a list of expressions. This is very useful for handling `NULL` values gracefully in your output.

**Example:**
Suppose `customers.phone` can be `NULL`.

**Sample Data (customers):**
| name | email | phone |
|----------|------------------|------------|
| Alice | alice@example.com| 555-1234 |
| Bob | bob@example.com | NULL |

**Query:**

```sql
SELECT
  name,
  COALESCE(phone, email, 'No Contact Info') AS preferred_contact
FROM customers;
```

**Sample Result:**
| name | preferred_contact |
|-------|-------------------|
| Alice | 555-1234 |
| Bob | bob@example.com |

### `IF(condition, true_value, false_value)` (MySQL Specific)

A shorthand for `CASE WHEN` if you only have two possible outcomes (a true value and a false value).

**Example:**

```sql
SELECT name, IF(price > 20, 'Expensive', 'Affordable') AS price_status
FROM products;
```

## 9. Using Aliases with Expressions

It is **crucial to use aliases** (with `AS`) to give meaningful and descriptive names to columns created using expressions or functions. This dramatically improves the **readability** of your query results, making them easier to understand and use in applications.

**Example: Combined Aliasing**
Here, we combine string concatenation, arithmetic, and date functions, all with clear aliases.

**Query:**

```sql
SELECT
  CONCAT(c.name, ' (', c.email, ')') AS full_contact_info,
  p.name AS product_name,
  (p.price * 1.08) AS estimated_cost_with_tax, -- Assuming 8% tax
  DATEDIFF(CURRENT_DATE(), o.order_date) AS days_old_order
FROM customers c, orders o, products p; -- Illustrative; typically joined in a complex query
```

## 10. Expressions and Functions in Action: Across SQL Commands

Expressions and functions are highly versatile and can be used in various SQL commands beyond just `SELECT` statements, enabling powerful data manipulation and filtering.

- **`SELECT` statement:** (As seen throughout this lesson) For retrieving and transforming data for display.

- **`UPDATE ... SET`:** You can use expressions and functions on the **right side** of the `SET` clause to calculate new values for columns before updating.

  ```sql
  UPDATE products SET price = ROUND(price * 1.05, 2) WHERE name = 'Widget B';
  ```

- **`WHERE` clause (in `SELECT`, `UPDATE`, `DELETE`):** You can use expressions and functions within the `WHERE` clause to filter rows based on calculated or transformed values. This allows for dynamic filtering conditions.

  ```sql
  -- Select customers whose email is from a specific domain (case-insensitive)
  SELECT * FROM customers WHERE LOWER(email) LIKE '%@example.com%';

  -- Delete orders older than one year
  DELETE FROM orders WHERE DATEDIFF(CURRENT_DATE(), order_date) > 365;

  -- Update products whose name length is more than 10 characters
  UPDATE products SET description = 'Long name product' WHERE LENGTH(name) > 10;
  ```

- **`ON` clause (in `JOIN`s):** As seen in Lesson 7, expressions and functions can be used in `ON` clauses to join tables on transformed or derived values.
  ```sql
  -- Joining on a calculated value (product name in uppercase with prefix)
  SELECT p.name, pc.description
  FROM products p
  JOIN product_codes pc ON pc.code = CONCAT('PROD_', UPPER(p.name));
  ```

## 11. Practical Examples (Combining Concepts)

Let's look at more complex queries that combine several of the concepts we've learned in this lesson, along with `JOIN`s from the previous lesson.

**Example 1: Displaying Orders with Calculated Line Item Totals and Status**
Show each item in an order, its quantity, unit price, and a calculated line total. Also, categorize orders by their age.

**Query:**

```sql
SELECT
  o.id AS order_id,
  DATE_FORMAT(o.order_date, '%Y-%m-%d') AS order_date_formatted,
  c.name AS customer_name,
  p.name AS product_name,
  oli.quantity,
  p.price AS unit_price,
  (oli.quantity * p.price) AS line_total,
  CASE
    WHEN DATEDIFF(CURRENT_DATE(), o.order_date) < 30 THEN 'Recent'
    WHEN DATEDIFF(CURRENT_DATE(), o.order_date) < 90 THEN 'Standard'
    ELSE 'Old'
  END AS order_age_category
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_line_items oli ON o.id = oli.order_id
JOIN products p ON oli.product_id = p.id;
```

**Example 2: Listing Products with Price Adjustments and Length**
Display product names, their original price, a discounted price (if > $20), and the length of their name.

**Query:**

```sql
SELECT
  name AS product_name,
  price AS original_price,
  LENGTH(name) AS name_length,
  CASE
    WHEN price > 20 THEN ROUND(price * 0.90, 2) -- 10% discount
    ELSE price
  END AS adjusted_price
FROM products;
```

## 12. Common Pitfalls

- **Data Type Mismatch:** Functions might expect specific data types. Always use `CAST` or `CONVERT` if needed to ensure compatibility (e.g., `CAST(id AS CHAR)`).
- **Performance in `WHERE`/`ON`:** Applying functions to columns in `WHERE` or `ON` conditions can prevent indexes from being used, leading to slower queries (e.g., `WHERE SUBSTRING(name, 1, 3) = 'ABC'` might not use an index on `name`). This is why functional indexes (as covered in Lesson 8) are useful.
- **Locale/Character Set Issues:** String functions can behave differently with various character sets or collations, impacting results.
- **Date Format Strings:** Getting `DATE_FORMAT` strings correct requires careful attention to the specific format codes (`%Y`, `%m`, `%d`, etc.). Refer to MySQL documentation if unsure.
- **`CASE WHEN` Exhaustiveness:** If an `ELSE` clause is omitted in `CASE WHEN` and no `WHEN` condition is met, the result for that row will be `NULL`. Always consider your `ELSE` condition.

## 13. Recap

- Expressions and functions transform data directly in your SQL queries.
- You can perform arithmetic, manipulate strings, work with dates/times, apply conditional logic (`CASE WHEN`), and perform mathematical operations.
- Common utility functions like `CURRENT_TIMESTAMP()`, `UUID()`, `LAST_INSERT_ID()`, `COALESCE()`, and `IF()` provide specific functionalities.
- Use `CAST`/`CONVERT` to change data types.
- Use `AS` to alias complex expressions and functions for clarity.
- **Expressions and functions are versatile and can be used in `SELECT`, `UPDATE` (right side of `SET`), `DELETE` (`WHERE` clause), and `JOIN` (`ON` clause).**
- Be mindful of performance impacts when using functions in `WHERE` or `ON` clauses without functional indexes.

## Next Steps

You’ve completed the lesson on expressions and functions!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 9: Expressions and Functions](../homework/hw9.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.

---
