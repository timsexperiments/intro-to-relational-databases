# Lesson 4: Database Normalization

## What You’ll Learn

- Why normalization matters in relational databases
- The concepts of functional dependency, determinant, and candidate key
- The rules and reasoning behind 1NF, 2NF, 3NF, and BCNF
- How to spot and fix normalization problems in real-world tables
- How to create well-structured, maintainable schemas

## 1. What is Normalization?

**Normalization** is the process of organizing data in a database to reduce redundancy and improve data integrity.

### Why Normalize?

- **Avoid Data Redundancy:** Prevent storing the same information in multiple places.
- **Prevent Update Anomalies:** Make sure changes in one place don’t require changes in many places.
- **Ensure Data Integrity:** Keep your data accurate and consistent.
- **Make Maintenance Easier:** Well-structured tables are easier to update, query, and extend.

### What Happens Without Normalization?

Imagine a table that stores all information about customers, orders, products, and order line items in a single row:

| order_id | customer_name | customer_email  | order_date | product_names      | product_prices | quantities | shipping_address1 | shipping_address2 |
| -------- | ------------- | --------------- | ---------- | ------------------ | -------------- | ---------- | ----------------- | ----------------- |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget A, Widget B | 19.99, 9.99    | 2, 1       | 123 Main St       | 456 Oak Ave       |
| 1002     | Bob Johnson   | bob@email.com   | 2024-05-02 | Widget A           | 19.99          | 1          | 789 Pine Rd       |                   |

- If Alice’s email changes, you have to update it in every row for every order and product she’s ever bought.
- If the price of Widget A changes, old orders might show the wrong price if you update all rows.
- If you delete an order, you might accidentally lose customer or product information.

**Normalization** solves these problems by splitting data into related tables (like customers, orders, products, and order_line_items) and defining clear relationships.

## 2. What Are Normal Forms?

**Normal forms** are a set of rules or guidelines for structuring relational database tables to minimize redundancy and avoid common data anomalies.

### Why Do We Have Normal Forms?

- To provide a step-by-step process for improving a database design.
- To help you spot and fix problems like repeating groups, partial dependencies, and hidden redundancies.
- To ensure your tables are flexible, efficient, and easy to maintain.

### Key Concepts

- **Functional Dependency:**  
  A **functional dependency** exists when the value of one column (or set of columns) determines the value of another column.  
  Example: If you know the `order_id`, you know the `order_date`.  
  Notation: `order_id → order_date`
- **Determinant:**  
  The column(s) on the left side of a functional dependency (the “determiner”).  
  In `order_id → order_date`, `order_id` is the determinant.
- **Candidate Key:**  
  Any column or set of columns that can uniquely identify a row in a table.  
  There can be multiple candidate keys; the primary key is one you choose to use.

### The Most Important Normal Forms

- **First Normal Form (1NF):**
  - Eliminate repeating groups and ensure each field contains only atomic (indivisible) values.
- **Second Normal Form (2NF):**
  - Remove partial dependencies; every non-key attribute must depend on the whole primary key (applies to tables with composite keys).
- **Third Normal Form (3NF):**
  - Remove transitive dependencies; non-key attributes should not depend on other non-key attributes.
- **Boyce-Codd Normal Form (BCNF):**
  - A stricter version of 3NF. Every determinant must be a candidate key.

> **Note:** There are higher normal forms (like 4NF and 5NF), but 1NF–3NF and BCNF are the foundation for most real-world designs.

### How This Lesson Will Work

- We’ll start with a “bad” (unnormalized) table using our store example (customers, orders, products, order_line_items).
- We’ll walk through each normal form, step by step, showing how to improve the design and why each step matters.
- We’ll also see a case where BCNF is needed, and how to fix it.

## 3. First Normal Form (1NF)

### What is 1NF?

A table is in **First Normal Form (1NF)** if:

- Every field contains only **atomic** (indivisible) values—no lists, arrays, or repeating groups.
- Each record (row) is unique and identified by a primary key.
- The order of rows and columns does not matter.

**In other words:**

- No multiple values in a single cell.
- No repeating columns for the same type of data.

### Examples

#### Customers, Orders, Products, and Order Line Items

| order_id | customer_name | customer_email  | order_date | product_names      | product_prices | quantities | shipping_address1 | shipping_address2 |
| -------- | ------------- | --------------- | ---------- | ------------------ | -------------- | ---------- | ----------------- | ----------------- |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget A, Widget B | 19.99, 9.99    | 2, 1       | 123 Main St       | 456 Oak Ave       |
| 1002     | Bob Johnson   | bob@email.com   | 2024-05-02 | Widget A           | 19.99          | 1          | 789 Pine Rd       |                   |

**What’s wrong?**

- The `product_names`, `product_prices`, and `quantities` columns contain **lists** (comma-separated values).
- There are **repeating columns** for shipping addresses (`shipping_address1`, `shipping_address2`).
- Each cell should contain only a single value, not a list or a repeating group.
- **Tip:** Always check the data inside the table, not just the schema. Even if the column names look reasonable, the way data is stored in the cells can reveal normalization problems.

#### Student Courses

| student_id | name  | courses            |
| ---------- | ----- | ------------------ |
| 1          | Alice | Math, English, Art |
| 2          | Bob   | Science, Math      |

**What’s wrong?**

- The `courses` column contains a **list** of values in a single cell (not atomic).
- This makes it hard to query, update, or enforce data integrity.

#### Employee Phone Numbers

| emp_id | name  | phone1   | phone2   | phone3 |
| ------ | ----- | -------- | -------- | ------ |
| 1      | Alice | 555-1234 | 555-5678 |        |
| 2      | Bob   | 555-8765 |          |        |

**What’s wrong?**

- There are **repeating columns** for the same type of data (`phone1`, `phone2`, `phone3`).
- This structure doesn’t scale and makes it hard to enforce constraints or search for a phone number.

### How to Fix a Table to Be in 1NF

**Goal:**

- Each field contains only a single, atomic value.
- No repeating groups or lists.

**Fixed Example (in 1NF, but not yet in 2NF):**

| order_id | customer_name | customer_email  | order_date | product_name | product_price | quantity | shipping_address |
| -------- | ------------- | --------------- | ---------- | ------------ | ------------- | -------- | ---------------- |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget A     | 19.99         | 2        | 123 Main St      |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget A     | 19.99         | 2        | 456 Oak Ave      |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget B     | 9.99          | 1        | 123 Main St      |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget B     | 9.99          | 1        | 456 Oak Ave      |
| 1002     | Bob Johnson   | bob@email.com   | 2024-05-02 | Widget A     | 19.99         | 1        | 789 Pine Rd      |

- Now, each row contains only one product per order and one shipping address per row.
- No lists or repeating groups.
- **Note:** This table is in 1NF, but still has redundancy (customer and order info repeated for each product and address). We’ll fix that in 2NF.

### Tips for Achieving 1NF

- **Never store lists or arrays in a single cell.**
- **Don’t use repeating columns for the same type of data.**
- **Each row should represent one “thing” or relationship.**
- **If you see a comma, semicolon, or multiple columns for the same attribute, it’s probably not in 1NF.**
- **Always check the data inside the table, not just the schema.**  
  Even if the column names look reasonable, the way data is stored in the cells can reveal normalization problems.

## 4. Second Normal Form (2NF)

### What is 2NF?

A table is in **Second Normal Form (2NF)** if:

- It is already in **1NF**.
- **Every non-key attribute is fully functionally dependent on the whole primary key** (not just part of it).
- This mainly applies to tables with **composite primary keys** (i.e., primary keys made up of more than one column).

**What does “depends on” mean?**  
A column “depends on” a key if you can determine its value **uniquely** from that key.

- If you know the key, you know the value.
- If you only need part of a composite key to know the value, that’s a **partial dependency** (which 2NF forbids).

### Examples

#### Customers, Orders, Products, and Order Line Items

Let’s start with the 1NF version of our table:

| order_id | customer_name | customer_email  | order_date | product_name | product_price | quantity | shipping_address |
| -------- | ------------- | --------------- | ---------- | ------------ | ------------- | -------- | ---------------- |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget A     | 19.99         | 2        | 123 Main St      |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget A     | 19.99         | 2        | 456 Oak Ave      |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget B     | 9.99          | 1        | 123 Main St      |
| 1001     | Alice Smith   | alice@email.com | 2024-05-01 | Widget B     | 9.99          | 1        | 456 Oak Ave      |
| 1002     | Bob Johnson   | bob@email.com   | 2024-05-02 | Widget A     | 19.99         | 1        | 789 Pine Rd      |

**What’s wrong?**

Suppose the (composite) key is (`order_id`, `product_name`, `shipping_address`).  
Let’s look at each non-key column:

- **customer_name, customer_email, order_date:**

  - If you know the `order_id`, you know the customer and order date—**regardless of product or shipping address**.
  - For example, every row with `order_id = 1001` has `customer_name = Alice Smith`, `customer_email = alice@email.com`, and `order_date = 2024-05-01`.
  - **These columns depend only on part of the key (`order_id`), not the whole key.**

- **product_price:**

  - If you know the `product_name`, you know the price—**regardless of order or shipping address**.
  - For example, every row with `product_name = Widget A` has `product_price = 19.99`.
  - **This column depends only on part of the key (`product_name`), not the whole key.**

- **quantity:**

  - You need the whole key (`order_id`, `product_name`, `shipping_address`) to know the quantity for that specific product in that order to that address.
  - **This is a full dependency.**

- **shipping_address:**
  - Part of the key, so not a non-key attribute.

**Summary:**

- **Partial dependencies** exist: some columns depend only on part of the composite key.
- This leads to redundancy: if Alice’s email changes, you have to update it in every row for every product and address in her order.

### How to Fix a Table to Be in 2NF

**Goal:**

- Remove partial dependencies by splitting the table into multiple tables, so every non-key attribute depends on the whole key.

**Normalized Example (in 2NF, but not yet in 3NF):**

- **Customers Table:**

  | customer_id | customer_name | customer_email  |
  | ----------- | ------------- | --------------- |
  | 1           | Alice Smith   | alice@email.com |
  | 2           | Bob Johnson   | bob@email.com   |

- **Orders Table:**

  | order_id | customer_id | order_date |
  | -------- | ----------- | ---------- |
  | 1001     | 1           | 2024-05-01 |
  | 1002     | 2           | 2024-05-02 |

- **Products Table:**

  | product_id | product_name | product_price |
  | ---------- | ------------ | ------------- |
  | 1          | Widget A     | 19.99         |
  | 2          | Widget B     | 9.99          |

- **Order Line Items Table:**

  | order_id | product_id | shipping_address | quantity |
  | -------- | ---------- | ---------------- | -------- |
  | 1001     | 1          | 123 Main St      | 2        |
  | 1001     | 1          | 456 Oak Ave      | 2        |
  | 1001     | 2          | 123 Main St      | 1        |
  | 1001     | 2          | 456 Oak Ave      | 1        |
  | 1002     | 1          | 789 Pine Rd      | 1        |

- Now, every non-key attribute in each table depends on the whole primary key of that table.
- **Note:** There may still be transitive dependencies (e.g., if product_price can change over time for different orders), which we’ll address in 3NF.

### Tips for Achieving 2NF

- **Identify the primary key** (especially if it’s composite).
- **Check each non-key column:** Can you determine its value from only part of the key? If so, it’s a partial dependency.
- **Split the table** so that each non-key attribute depends on the whole key.
- **Don’t “over-normalize”**—make sure your tables still make sense for your application.

## 5. Third Normal Form (3NF)

### What is 3NF?

A table is in **Third Normal Form (3NF)** if:

- It is already in **2NF**.
- **Every non-key attribute is non-transitively dependent on the primary key**—that is, no non-key attribute depends on another non-key attribute.

**What does “transitively dependent” mean?**  
A column is **transitively dependent** if it depends on another non-key column, which in turn depends on the primary key.

- In other words: If you need to go through another non-key column to get the value, that’s a transitive dependency.

### Examples

#### Customers, Orders, Products, and Order Line Items

Let’s start with the 2NF version of our tables:

- **Customers Table:**

  | customer_id | customer_name | customer_email  |
  | ----------- | ------------- | --------------- |
  | 1           | Alice Smith   | alice@email.com |
  | 2           | Bob Johnson   | bob@email.com   |

- **Orders Table:**

  | order_id | customer_id | order_date |
  | -------- | ----------- | ---------- |
  | 1001     | 1           | 2024-05-01 |
  | 1002     | 2           | 2024-05-02 |

- **Products Table:**

  | product_id | product_name | product_price |
  | ---------- | ------------ | ------------- |
  | 1          | Widget A     | 19.99         |
  | 2          | Widget B     | 9.99          |

- **Order Line Items Table:**

  | order_id | product_id | shipping_address | quantity | product_price |
  | -------- | ---------- | ---------------- | -------- | ------------- |
  | 1001     | 1          | 123 Main St      | 2        | 19.99         |
  | 1001     | 1          | 456 Oak Ave      | 2        | 19.99         |
  | 1001     | 2          | 123 Main St      | 1        | 9.99          |
  | 1001     | 2          | 456 Oak Ave      | 1        | 9.99          |
  | 1002     | 1          | 789 Pine Rd      | 1        | 19.99         |

**What’s wrong?**

- The primary key for **Order Line Items** is (`order_id`, `product_id`, `shipping_address`).
- **product_price** is a non-key attribute.
- If you know the `product_id`, you know the `product_price` (from the Products table).
- So, `product_price` depends on `product_id`, which is part of the key, but not the whole key.
- This is a **transitive dependency**:  
  (`order_id`, `product_id`, `shipping_address`) → `product_id` → `product_price`

**Why is this a problem?**

- If the price of Widget A changes, you have to update it in every order line item where it appears.
- This can lead to inconsistencies and update anomalies.

### How to Fix a Table to Be in 3NF

**Goal:**

- Remove transitive dependencies by moving columns that depend on non-key attributes to their own tables.

**Normalized Example (in 3NF):**

- **Customers Table:** (unchanged)
- **Orders Table:** (unchanged)
- **Products Table:** (unchanged)
- **Order Line Items Table:** (no more product_price)

  | order_id | product_id | shipping_address | quantity |
  | -------- | ---------- | ---------------- | -------- |
  | 1001     | 1          | 123 Main St      | 2        |
  | 1001     | 1          | 456 Oak Ave      | 2        |
  | 1001     | 2          | 123 Main St      | 1        |
  | 1001     | 2          | 456 Oak Ave      | 1        |
  | 1002     | 1          | 789 Pine Rd      | 1        |

- Now, `product_price` is stored only in the Products table, and you can always look it up by joining on `product_id`.

### Tips for Achieving 3NF

- **For each non-key column, ask:** Does it depend only on the primary key, or does it depend on another non-key column?
- **If you find a transitive dependency,** move the dependent column to a new table.
- **Don’t duplicate data** that can be looked up via a key.

## 6. Boyce-Codd Normal Form (BCNF)

### What is BCNF?

A table is in **Boyce-Codd Normal Form (BCNF)** if:

- It is already in **3NF**.
- **For every non-trivial functional dependency X → Y, X is a superkey.**
- In simpler terms:
  - **Every determinant must be a candidate key.**
  - (A determinant is any column or set of columns on the left side of a functional dependency.)

**Why do we need BCNF?**

- Sometimes, even a table in 3NF can have anomalies if there are overlapping candidate keys or unusual dependencies.
- BCNF is a stricter version of 3NF that fixes these edge cases.

### Examples

#### Orders, Products, and Shipping Addresses

Suppose you have this table:

| product_id | shipping_address | shipping_cost | product_name |
| ---------- | ---------------- | ------------- | ------------ |
| 1          | 123 Main St      | 5.00          | Widget A     |
| 1          | 456 Oak Ave      | 7.00          | Widget A     |
| 2          | 123 Main St      | 6.00          | Widget B     |
| 2          | 456 Oak Ave      | 8.00          | Widget B     |

#### What’s wrong? (Let’s prove the dependencies)

- The candidate keys are (`product_id`, `shipping_address`) and (`product_name`, `shipping_address`), assuming product_name is unique.
- **Functional dependencies:**
  - `product_id` → `product_name` (product_name is determined by product_id)
  - (`product_id`, `shipping_address`) → `shipping_cost`
- **Problem:**
  - `product_id` is not a candidate key, but it determines `product_name`.
  - This violates BCNF: a non-candidate key (`product_id`) is a determinant.

**Definitions Recap:**

- **Functional Dependency:** If you know the value of column(s) X, you know the value of column Y (X → Y).
- **Determinant:** The column(s) on the left side of a functional dependency (X in X → Y).
- **Candidate Key:** Any column or set of columns that can uniquely identify a row in a table.

**Why is this a problem?**

- If the name of a product changes, you have to update it in every row for every shipping address.
- This can lead to inconsistencies and update anomalies.

### How to Fix a Table to Be in BCNF

**Goal:**

- For every functional dependency, the determinant must be a candidate key.

**Normalized Example (in BCNF):**

- **Products Table:**

  | product_id | product_name |
  | ---------- | ------------ |
  | 1          | Widget A     |
  | 2          | Widget B     |

- **Shipping Costs Table:**

  | product_id | shipping_address | shipping_cost |
  | ---------- | ---------------- | ------------- |
  | 1          | 123 Main St      | 5.00          |
  | 1          | 456 Oak Ave      | 7.00          |
  | 2          | 123 Main St      | 6.00          |
  | 2          | 456 Oak Ave      | 8.00          |

- Now, all non-key attributes depend only on candidate keys, and every determinant is a candidate key.

### Tips for Achieving BCNF

- **Identify all candidate keys** for your table.
- **For every functional dependency,** make sure the determinant is a candidate key.
- **If not,** decompose the table so that all determinants are candidate keys.

## 7. Recap

- **Normalization** is the process of organizing your database to reduce redundancy and prevent anomalies.
- **1NF:** No repeating groups or lists—every field contains only atomic values.
- **2NF:** No partial dependencies—every non-key attribute depends on the whole primary key.
- **3NF:** No transitive dependencies—non-key attributes depend only on the key.
- **BCNF:** Every determinant is a candidate key—fixes edge cases not covered by 3NF.
- At each step, we saw how to spot violations by looking at the data, not just the schema, and how to fix them by splitting tables appropriately.
- **Key terms:**
  - **Functional dependency:** X → Y means knowing X tells you Y.
  - **Determinant:** The “X” in X → Y.
  - **Candidate key:** Any column(s) that can uniquely identify a row.

## Next Steps

You’ve completed the lesson on normalization!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 4: Database Normalization](../homework/hw4.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.
