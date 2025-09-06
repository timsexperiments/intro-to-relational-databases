# Lesson 2: Database Fundamentals

## What You’ll Learn

- How to design and create tables in a relational database
- How to choose appropriate data types for your columns
- How to use constraints to keep your data clean and reliable
- How to modify tables as your needs change
- The basics of relationships and foreign keys
- How to practice these skills hands-on

## 1. Understanding Tables, Rows, and Columns

A **table** is like a spreadsheet:

- Each **row** is a record (e.g., a customer).
- Each **column** is a field (e.g., name, email).

**Example Table:**

| id  | name        | email           | created_at          |
| --- | ----------- | --------------- | ------------------- |
| 1   | Alice Smith | alice@email.com | 2023-01-15 10:00:00 |
| 2   | Bob Johnson | bob@email.com   | 2023-02-20 14:30:00 |

**Key Points:**

- Each table should represent a single entity or concept (e.g., customers, orders).
- Each row should represent one instance of that entity (e.g., one customer).
- Each column should represent a single attribute (e.g., name, email).

## 2. Data Types in SQL

Choosing the right data type for each column is crucial for data integrity, performance, and storage efficiency.

| Data Type            | Description                                | Example Value        | When to Use                     |
| -------------------- | ------------------------------------------ | -------------------- | ------------------------------- |
| INT                  | Integer number                             | 42                   | IDs, counts, ages               |
| BIGINT               | Large integer                              | 1234567890123        | Large IDs, big counts           |
| VARCHAR(n)           | Variable-length string (max n)             | 'Alice'              | Names, emails, short text       |
| TEXT                 | Long text                                  | 'This is a comment.' | Descriptions, comments          |
| DATE                 | Date only                                  | 2024-05-01           | Birthdays, due dates            |
| DATETIME             | Date and time                              | 2024-05-01 14:30:00  | Timestamps, event times         |
| BOOLEAN / TINYINT(1) | True/False (0 or 1)                        | 1                    | Flags, status (active/inactive) |
| DECIMAL(a, b)        | Decimal number (a digits, b after decimal) | 19.99                | Money, precise values           |
| FLOAT/DOUBLE         | Floating-point number                      | 3.14159              | Scientific, approximate values  |

**Best Practices:**

- Use `INT` for IDs and counts.
- Use `VARCHAR` for IDs, names, emails, and short text.
- Use `DECIMAL` for money (recommended over `FLOAT`/`DOUBLE` for currency due to precision).
- Use `DATETIME` for timestamps.
- Use `BOOLEAN` or `TINYINT(1)` for true/false values.

## 3. Constraints: Keeping Data Clean and Reliable

**Constraints** are rules that the database enforces to keep your data valid and consistent.

| Constraint  | What it does                            | Example Use               |
| ----------- | --------------------------------------- | ------------------------- |
| PRIMARY KEY | Uniquely identifies each row            | `id` column               |
| UNIQUE      | No duplicate values allowed             | `email` column            |
| NOT NULL    | Value must be provided                  | `name` column             |
| CHECK       | Value must meet a condition             | `amount > 0`              |
| DEFAULT     | Sets a value if none is provided        | `created_at` timestamp    |
| FOREIGN KEY | Links to a primary key in another table | `customer_id` in `orders` |

**Why Constraints Matter:**

- Prevents duplicate or missing data (e.g., two customers with the same email).
- Ensures data is always valid (e.g., no negative order amounts).
- Maintains relationships between tables (e.g., every order must belong to a real customer).
- Records that violate constraints cannot be added to the database table.

## 4. Creating Tables in SQL

### Why Create a Table for Customers?

In most real-world applications, you need to keep track of people or organizations that interact with your system. For example, in an online store, you need to store information about each customer so you can: track their orders and purchases; send them notifications or receipts; analyze customer behavior; ensure each customer’s data is unique and secure. A **customers** table is a foundational building block for any business, e-commerce, or CRM application.

### What is the `CREATE TABLE` Command?

The `CREATE TABLE` command in SQL is used to define a new table in your database. When you create a table, you specify: the table’s name; the columns (fields) it will have; the data type for each column; any constraints (rules) for each column.

**General Syntax:**

```sql
CREATE TABLE <table_name> (
  <column1> <datatype> [constraints],
  <column2> <datatype> [constraints],
  ...
);
```

- **table_name:** The name you want to give your table (e.g., `customers`)
- **column1, column2, ...:** The names of the fields (e.g., `id`, `name`, `email`)
- **datatype:** The type of data each column will store (e.g., `INT`, `VARCHAR(100)`, `DATETIME`)
- **constraints:** Optional rules for the column (e.g., `PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`)

### Building the `customers` Table

Let’s begin by defining the basic structure—just the columns and their data types, no constraints yet.

```sql
CREATE TABLE customers (
  id INT,
  name VARCHAR(100),
  email VARCHAR(100),
  birthdate DATE,
  created_at DATETIME
);
```

**Explanation:** We have five columns: `id`, `name`, `email`, `birthdate`, and `created_at`. Each column has a data type that matches the kind of data we want to store.

#### Add a Primary Key

Every table should have a primary key to uniquely identify each row. Let’s make `id` the primary key.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  birthdate DATE,
  created_at DATETIME
);
```

**Why?** The primary key ensures each customer is unique and makes lookups fast and reliable.

#### Make the Primary Key Auto-Increment

We want the database to automatically assign a new, unique `id` for each customer.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100),
  birthdate DATE,
  created_at DATETIME
);
```

**Why?** `AUTO_INCREMENT` saves you from manually picking unique IDs and prevents accidental duplicates.

#### Add NOT NULL Constraints

Some fields should always have a value. Let’s require that `name` and `email` are always provided.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  birthdate DATE,
  created_at DATETIME
);
```

**Why?** `NOT NULL` ensures you don’t accidentally create a customer without a name or email.

#### Add a UNIQUE Constraint

No two customers should have the same email address.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  birthdate DATE,
  created_at DATETIME
);
```

**Why?** `UNIQUE` on `email` prevents duplicate accounts and helps with login or communication.

#### Add a Default Value

Let’s make `created_at` automatically record when the customer was added.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  birthdate DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Why?** `DEFAULT CURRENT_TIMESTAMP` means you don’t have to specify the creation time—it’s set automatically.

### Naming Constraints: Why and How

#### Why Name Constraints?

- **Clarity:** Named constraints make your schema easier to read and understand, especially in large databases.
- **Maintenance:** If you need to modify or drop a constraint later, having a name makes it much easier.
- **Debugging:** When a constraint is violated, the error message will include the constraint name, making it easier to identify the issue.

#### How to Name Constraints

You can name constraints using the `CONSTRAINT <name>` syntax. There are two main ways to specify constraints in SQL:

**1. Inline (Column-Level) Named Constraint**

You can name a constraint directly after the column definition (supported for some constraint types):

```sql
CREATE TABLE customers (
  email VARCHAR(100) CONSTRAINT unique_email UNIQUE
);
```

Here, `unique_email` is the name of the unique constraint on the `email` column.

**2. Table-Level Named Constraint**

You can also define and name constraints after all the columns, which works for all constraint types:

```sql
CREATE TABLE customers (
  id INT,
  email VARCHAR(100),
  CONSTRAINT pk_customers PRIMARY KEY (id),
  CONSTRAINT unique_email UNIQUE (email)
);
```

`pk_customers` is the name of the primary key constraint. `unique_email` is the name of the unique constraint.

**Tip:** Table-level constraints are more flexible and always allow naming, so they are often preferred for clarity and maintainability.

**Summary:** Start with columns and data types. Add a primary key for uniqueness. Use `AUTO_INCREMENT` for automatic ID assignment. Add `NOT NULL` for required fields. Use `UNIQUE` to prevent duplicates. Set `DEFAULT` values for convenience and consistency. Name your constraints for clarity and easier maintenance.

**Try It Yourself:** Create the table in your MySQL shell, and use `DESCRIBE customers;` to see the structure. Experiment by omitting constraints and see what errors or issues you encounter when inserting data. Try naming your constraints both inline and at the table level.

You got it! Here’s **Section 5: Relationships and Foreign Keys**—in-depth, self-serve, and ready to go:

## 5. Relationships and Foreign Keys

### Why Relate Tables?

In real-world applications, data is rarely isolated. You often need to connect information across different tables. For example:

- Customers place orders.
- Students enroll in courses.
- Books have authors.

Relating tables allows you to:

- Avoid data duplication.
- Keep your data organized and normalized.
- Enforce data integrity (e.g., every order must belong to a real customer).

### What is a Foreign Key?

A **foreign key** is a column (or set of columns) in one table that refers to the primary key in another table.  
Foreign keys enforce **referential integrity**: you can’t have a reference to a record that doesn’t exist.

### Types of Relationships

#### One-to-One

**Definition:**  
Each row in Table A relates to one and only one row in Table B, and vice versa.

**Real-World Example:**  
Suppose each customer has exactly one profile, and each profile belongs to exactly one customer.

**Where Does the Foreign Key Go?**

- The foreign key typically goes on the table that is considered the **child** or the more optional/secondary entity.
- In a customer/profile example, the profile is often considered the child (not all customers may have a profile), so the foreign key usually goes in the `customer_profiles` table.
- However, you can also design it the other way, depending on your data model.

**A. Foreign Key in the Child Table (Most Common)**

Here, the `customer_profiles` table (the child) has a `customer_id` column that is both a foreign key to `customers.id` and is marked `UNIQUE` to enforce one-to-one.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE customer_profiles (
  profile_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20),
  CONSTRAINT fk_profile_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

- `customer_profiles.customer_id` is a foreign key to `customers.id` and is marked `UNIQUE` to ensure each profile is linked to only one customer, and each customer can have at most one profile.

**B. Foreign Key in the Parent Table**

Alternatively, you can put the foreign key in the `customers` table, referencing the `customer_profiles.profile_id`.

```sql
CREATE TABLE customer_profiles (
  profile_id INT PRIMARY KEY AUTO_INCREMENT,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  profile_id INT UNIQUE,
  CONSTRAINT fk_customer_profile FOREIGN KEY (profile_id) REFERENCES customer_profiles(profile_id)
);
```

- `customers.profile_id` is a foreign key to `customer_profiles.profile_id` and is marked `UNIQUE` to ensure each customer is linked to only one profile, and each profile can be linked to only one customer.

**Summary:**  
The foreign key typically goes on the child (secondary) table, but it can be placed on either side depending on your design. Always use a `UNIQUE` constraint (or make it the primary key) to enforce the one-to-one relationship.

#### One-to-Many

**Definition:**  
A row in Table A can relate to many rows in Table B, but each row in Table B relates to only one row in Table A.

**Example:**  
A customer can have many orders, but each order belongs to one customer.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  customer_id INT NOT NULL,
  CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

#### Many-to-Many (Using a Join/Gerund Table)

**Definition:**  
Rows in Table A can relate to many rows in Table B, and vice versa.

**Example:**  
Customers can belong to many loyalty programs, and each loyalty program can have many customers.

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE loyalty_programs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  program_name VARCHAR(100) NOT NULL
);

CREATE TABLE customer_loyalty_programs (
  customer_id INT NOT NULL,
  program_id INT NOT NULL,
  PRIMARY KEY (customer_id, program_id),
  CONSTRAINT fk_clp_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
  CONSTRAINT fk_clp_program FOREIGN KEY (program_id) REFERENCES loyalty_programs(id)
);
```

- The `customer_loyalty_programs` table is a **join table** (also called a gerund table) that connects customers and loyalty programs.

### How Foreign Keys Enforce Data Integrity

- The database will **prevent you from inserting a row** in the child table (e.g., `orders`) if the referenced row in the parent table (e.g., `customers`) does not exist.
- The database will **prevent you from deleting a row** in the parent table if there are related rows in the child table, unless you specify `ON DELETE CASCADE` or similar options.

### What Happens if You Violate a Foreign Key Constraint?

- If you try to insert an order with a `customer_id` that doesn’t exist in `customers`, you’ll get an error.
- If you try to delete a customer who still has orders, you’ll get an error (unless you use cascading deletes).

## 6. Altering Tables

### Why Alter Tables?

As your application evolves, your data requirements will change. You might need to:

- Add new columns for new features
- Remove columns you no longer need
- Change data types to better fit your data
- Add or remove constraints (like `UNIQUE`, `NOT NULL`, or foreign keys)
- Rename columns or tables for clarity

The `ALTER TABLE` command lets you make these changes **without losing your existing data**.

### Common `ALTER TABLE` Operations

#### 1. Add a Column

Add a new column to an existing table.

```sql
ALTER TABLE customers ADD COLUMN phone_number VARCHAR(20) UNIQUE;
```

- Adds a `phone_number` column that must be unique for each customer.

#### 2. Remove a Column

Remove a column you no longer need.

```sql
ALTER TABLE customers DROP COLUMN phone_number;
```

- Removes the `phone_number` column from the table.

#### 3. Change a Column’s Data Type or Constraints

Modify a column’s data type, length, or constraints.

```sql
ALTER TABLE customers MODIFY COLUMN name VARCHAR(150) NOT NULL;
```

- Changes the `name` column to allow up to 150 characters and ensures it cannot be null.

#### 4. Rename a Column (MySQL 8+)

Change the name of a column for clarity.

```sql
ALTER TABLE customers RENAME COLUMN name TO full_name;
```

- Renames the `name` column to `full_name`.

#### 5. Add a Constraint

Add a new constraint to an existing column or set of columns.

**Add a unique constraint:**

```sql
ALTER TABLE customers ADD CONSTRAINT unique_email UNIQUE (email);
```

**Add a foreign key:**

```sql
ALTER TABLE orders ADD CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(id);
```

#### 6. Remove a Constraint

Remove a constraint by its name.  
**Note:** You must know the constraint’s name (which is why naming constraints is helpful!).

**Drop a unique constraint (MySQL treats it as an index):**

```sql
ALTER TABLE customers DROP INDEX unique_email;
```

**Drop a foreign key:**

```sql
ALTER TABLE orders DROP FOREIGN KEY fk_order_customer;
```

#### 7. Rename a Table

Change the name of a table.

```sql
RENAME TABLE customers TO clients;
```

### Best Practices

- **Always back up your data** before making structural changes, especially in production.
- **Test your changes** in a development environment first.
- **Name your constraints** so they’re easy to reference and manage later.
- **Be careful with dropping columns or constraints**—you may lose important data or break application logic.

## 7. Hands-On Practice

This section will guide you through practical exercises to reinforce everything you’ve learned in this lesson. You’ll create tables, define relationships, add and remove constraints, and experiment with altering your schema.

### Step 1: Open MySQL Shell

If using Docker:

```
docker exec -it mysql-db mysql -uroot -psecret
```

### Step 2: Create the Database and Tables

**Create a new database for this lesson:**

```sql
CREATE DATABASE IF NOT EXISTS lesson_db;
USE lesson_db;
```

**Create the `customers` table (build up step by step):**

```sql
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  birthdate DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Create the `orders` table with a foreign key:**

```sql
CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  customer_id INT NOT NULL,
  CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

### Step 3: One-to-One Relationship Example

**Create a `customer_profiles` table with a one-to-one relationship:**

```sql
CREATE TABLE customer_profiles (
  profile_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20),
  CONSTRAINT fk_profile_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

- Each profile is linked to one customer, and each customer can have at most one profile.

### Step 4: Many-to-Many Relationship Example

**Create a `loyalty_programs` table and a join table:**

```sql
CREATE TABLE loyalty_programs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  program_name VARCHAR(100) NOT NULL
);

CREATE TABLE customer_loyalty_programs (
  customer_id INT NOT NULL,
  program_id INT NOT NULL,
  PRIMARY KEY (customer_id, program_id),
  CONSTRAINT fk_clp_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
  CONSTRAINT fk_clp_program FOREIGN KEY (program_id) REFERENCES loyalty_programs(id)
);
```

- This allows each customer to join multiple programs, and each program to have multiple customers.

### Step 5: Test Constraints and Relationships

**Try to insert an order with a non-existent customer:**

```sql
INSERT INTO orders (amount, customer_id) VALUES (50.00, 9999);
-- Should fail: foreign key constraint violation
```

**Insert a valid customer and order:**

```sql
INSERT INTO customers (name, email) VALUES ('Alice Smith', 'alice@email.com');
SELECT * FROM customers;
-- Suppose Alice's id is 1:
INSERT INTO orders (amount, customer_id) VALUES (99.99, 1);
```

**Try to insert a customer with a duplicate email:**

```sql
INSERT INTO customers (name, email) VALUES ('Bob Johnson', 'alice@email.com');
-- Should fail: unique constraint violation
```

**Try to delete a customer who has orders:**

```sql
DELETE FROM customers WHERE id = 1;
-- Should fail: foreign key constraint violation
```

### Step 6: Alter Your Tables

**Add a new column:**

```sql
ALTER TABLE customers ADD COLUMN membership_level VARCHAR(20) DEFAULT 'bronze';
```

**Change a column’s data type:**

```sql
ALTER TABLE customers MODIFY COLUMN membership_level VARCHAR(50) DEFAULT 'bronze';
```

**Add a unique constraint:**

```sql
ALTER TABLE customers ADD CONSTRAINT unique_phone UNIQUE (phone);
```

**Remove a constraint:**

```sql
ALTER TABLE customers DROP INDEX unique_phone;
```

**Rename a column:**

```sql
ALTER TABLE customers RENAME COLUMN membership_level TO loyalty_tier;
```

**Remove a column:**

```sql
ALTER TABLE customers DROP COLUMN loyalty_tier;
```

### Step 7: Advanced Practice

- Add a `shipped_at` column to `orders` (nullable DATETIME).
- Add a `loyalty_points` column to `customers` (integer, default 0, must be >= 0).
- Try to insert invalid data (e.g., negative loyalty points or order amount) and observe the errors.
- Draw an entity-relationship diagram (ERD) for the tables you created.

**Congratulations!**  
You’ve now practiced designing, relating, and altering tables, and enforcing data integrity with constraints and foreign keys.  
You’re ready to move on to querying and joining data!

Absolutely! Here’s how you can wrap up your Database Fundamentals lesson with a **Recap**, **Practice**, and **Next Steps** section:

## 8. Recap

- **Tables, rows, and columns** are the foundation of relational databases.
- **Data types** define what kind of data each column can store.
- **Constraints** keep your data accurate and consistent.
- The `CREATE TABLE` and `ALTER TABLE` commands let you design and evolve your schema.
- **Foreign keys** create relationships between tables and enforce referential integrity.
- You’ve practiced building, relating, and modifying tables, and enforcing data integrity.

## 9. Next Steps

You’ve completed the Database Fundamentals lesson!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 2: Database Fundamentals](../homework/hw2.md)**

If you have questions or want to try more examples, feel free to experiment with your tables or ask for help.
