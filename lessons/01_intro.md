# Lesson 1: Introduction to Relational Databases

## What You’ll Learn

- What a database is and why it’s important
- The main types of databases (with a focus on relational databases)
- Key terminology: table, row, column, primary key
- How to create and view your first table using SQL

## 1. What is a Database?

A **database** is an organized collection of data, stored and accessed electronically.  
Databases help us store, retrieve, and manage data efficiently and safely.

**Real-World Examples:**

- Social media apps store user profiles, posts, and comments in databases.
- Online stores keep track of customers, products, and orders in databases.
- Banks use databases to manage accounts and transactions.

**Analogy:**  
Think of a database as a digital filing cabinet. Each drawer is a table, each folder is a row, and each piece of paper in a folder is a column value.

**Try This:**  
Can you think of an app or website you use that probably uses a database? What kind of data do you think it stores?  
Write down your answer before moving on.

## 2. Types of Databases and Their Use Cases

Before we focus on relational databases, let’s briefly look at the main types of databases and what they’re best for:

### A. Relational Databases (SQL)

- **How they work:** Store data in tables with predefined columns and data types. Relationships are defined using keys.
- **Examples:** MySQL, PostgreSQL, SQLite, SQL Server, Oracle.
- **Common use cases:**
  - Business applications (inventory, HR, finance)
  - E-commerce (customers, orders, products)
  - Social media (users, posts, comments)
- **Why use them?**
  - Strong data consistency and integrity
  - Complex queries and reporting

### B. Document Databases

- **How they work:** Store data as documents (usually JSON or BSON), which can have flexible structures.
- **Examples:** MongoDB, CouchDB, Firebase Firestore.
- **Common use cases:**
  - Content management systems (CMS)
  - User/customer profiles with varying fields
  - Event logging
- **Why use them?**
  - Flexible schema (easy to change structure)
  - Good for hierarchical or nested data

### C. Key-Value Stores

- **How they work:** Store data as simple key-value pairs (like a dictionary or map).
- **Examples:** Redis, DynamoDB (in key-value mode), Memcached.
- **Common use cases:**
  - Caching
  - Session storage (e.g., customer login sessions)
  - Real-time leaderboards
- **Why use them?**
  - Extremely fast for simple lookups
  - Simple data access patterns

### D. Graph Databases

- **How they work:** Store data as nodes and edges, representing entities and their relationships.
- **Examples:** Neo4j, Amazon Neptune, ArangoDB.
- **Common use cases:**
  - Social networks (customers and their friends/connections)
  - Recommendation engines
  - Fraud detection
- **Why use them?**
  - Efficient for complex relationships and traversals

### E. Vector Databases

- **How they work:** Store high-dimensional vectors, often used for similarity search (e.g., AI embeddings).
- **Examples:** Pinecone, Weaviate, Milvus.
- **Common use cases:**
  - AI-powered search (semantic search for customer support)
  - Image, audio, or text similarity
  - Recommendation systems
- **Why use them?**
  - Fast similarity search for machine learning applications

**Summary Table:**

| Type       | Structure       | Example DBs      | Key Use Cases                    |
| ---------- | --------------- | ---------------- | -------------------------------- |
| Relational | Tables/Rows     | MySQL, Postgres  | Business apps, e-commerce        |
| Document   | JSON Documents  | MongoDB, CouchDB | CMS, user/customer profiles      |
| Key-Value  | Key-Value Pairs | Redis, DynamoDB  | Caching, sessions                |
| Graph      | Nodes/Edges     | Neo4j, Neptune   | Social networks, recommendations |
| Vector     | Vectors         | Pinecone, Milvus | AI search, similarity            |

## 3. Our Focus: Relational Databases

In this course, we’ll focus on **relational databases** because they are the foundation for many business, web, and enterprise applications.

**Why Relational Databases?**

- Enforce data consistency and integrity
- Model complex relationships between different types of data (e.g., customers and their orders)
- Support complex queries and reporting

**Real-World Example:**  
Online stores use relational databases to track customers, their orders, and products, ensuring that every order is linked to a valid customer and product.

## 4. Basic Relational Database Terminology

| Term         | Definition                                        | Example                       |
| ------------ | ------------------------------------------------- | ----------------------------- |
| Table        | A collection of related data (like a spreadsheet) | `customers` table             |
| Row (Record) | A single entry in a table                         | One customer's info           |
| Column       | A field in the table (attribute)                  | `name`, `email`, `created_at` |
| Primary Key  | A unique identifier for each row                  | `id` column                   |

## 5. Hands-On: Your First Table

Let’s design a simple `customers` table.

| id  | name        | email           | created_at          |
| --- | ----------- | --------------- | ------------------- |
| 1   | Alice Smith | alice@email.com | 2023-01-15 10:00:00 |
| 2   | Bob Johnson | bob@email.com   | 2023-02-20 14:30:00 |

**Try This:**  
If you were building a customer management app, what other columns might you add? (e.g., phone number, address, loyalty points)  
Write down your ideas.

## 6. Hands-On: Your First SQL Query

### Step 1: Open MySQL Shell

If using Docker:

```
docker exec -it mysql-db mysql -uroot -psecret
```

### Step 2: Create a Database and Table

```sql
CREATE DATABASE IF NOT EXISTS lesson1;
USE lesson1;

CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100),
  created_at DATETIME
);
```

### Step 3: Insert Data

```sql
INSERT INTO customers (name, email, created_at) VALUES
  ('Alice Smith', 'alice@email.com', '2023-01-15 10:00:00'),
  ('Bob Johnson', 'bob@email.com', '2023-02-20 14:30:00');
```

### Step 4: Query the Table

```sql
SELECT * FROM customers;
```

**What you should see:**

| id  | name        | email           | created_at          |
| --- | ----------- | --------------- | ------------------- |
| 1   | Alice Smith | alice@email.com | 2023-01-15 10:00:00 |
| 2   | Bob Johnson | bob@email.com   | 2023-02-20 14:30:00 |

## 7. Recap

- A database is an organized collection of data.
- There are several types of databases; relational databases are the most common for business and web apps.
- In a relational database, data is stored in tables, which are made up of rows and columns.
- Each table should have a primary key to uniquely identify each row.
- You can create tables and insert/query data using SQL.

## 8. Practice

- Think of an app you use every day. Write down what tables you think its relational database might have, and what columns would be in each table.
- (Optional) Try creating your own `customers` table and inserting data using the MySQL shell.
- (Optional) Add a new column to your table (e.g., `phone_number`) and insert a new customer with a phone number.

## 9. Next Steps

You’ve completed Lesson 1!  
To reinforce what you’ve learned, complete the homework assignment for this lesson.

**➡️ [Go to Homework 1: Introduction to Databases](../homework/hw1.md)**

- The homework will ask you to reflect on real-world database use, and practice creating and querying your first table.
- Submit your work as described in the assignment instructions.
