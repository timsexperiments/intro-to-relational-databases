# Homework 1: Introduction to Databases

## **Objectives**

- Reflect on real-world uses of databases
- Practice basic SQL: creating a database, table, inserting, and selecting data
- Ensure your environment is set up and you can run SQL scripts

## **Instructions**

### **Part 1: Written Reflection**

1. List three apps or websites you use that probably use a database.
2. For each, describe what kind of data you think they store.
3. Briefly explain, in your own words, what a relational database is.

### **Part 2: SQL Practice**

1. **Create a new database** called `lesson1`.
2. **Create a table** called `books` with the following columns:
   - `id` (integer, primary key, auto-increment)
   - `title` (string, up to 150 characters)
   - `author` (string, up to 100 characters)
   - `published_year` (integer)
3. **Insert at least two books** into the table with realistic data.
4. **Query the table** to show all books using:
   ```sql
   SELECT * FROM books;
   ```

### **Part 3: Submission**

- Save your SQL commands in a file named `hw.sql`.
- Write your answers to the written reflection and a brief explanation of your SQL steps in a file named `hw.md`.
- Place both files in:  
  `submissions/homework_1/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## **Example Directory Structure**

```
submissions/
  homework_1/
    your-github-username/
      hw.sql
      hw.md
```

## **Tips**

- You can run your SQL file in MySQL using:
  ```
  docker exec -i mysql-db mysql -uroot -psecret < submissions/homework_1/<your-github-username>/hw.sql
  ```
- If you get stuck, review Lesson 1 or ask for help!
