# Homework 4: Database Normalization

## Objectives

- Practice identifying and achieving higher normal forms (up to BCNF)
- Update your schema and ERD to be fully normalized
- Apply normalization concepts to real-world scenarios
- Demonstrate your understanding of 1NF, 2NF, 3NF, and BCNF through short answer and multiple choice

## Part 1: Update Your ERD

- Update your library ERD from Homework 3 so that all tables are in **BCNF**.
- Use Mermaid syntax and save your diagram as `hw4.mmd`.
- You can use the [Mermaid Playground](https://www.mermaidchart.com/play) to write and preview your diagram.

## Part 2: Update Your SQL Schema

- Alter your previous tables and create any new tables needed so that your schema matches your updated ERD and is in **BCNF**.
- Use `ALTER TABLE` and `CREATE TABLE` as needed.
- Save your SQL commands in `hw4.sql`.

## Part 3: Normal Form Questions

- Answer the following questions in a file named `hw4.txt`.
- For each question, write your answer on a separate line.  
  (For multiple choice, answer with A, B, C, or D. For short answer, write the normal form or a brief explanation.)
- The line number should match the question number.

### Questions

1. Which normal form is violated if a table has a column with comma-separated values?
2. If a table has a composite primary key and a non-key column depends only on part of that key, what normal form is violated?
3. If a table has no transitive dependencies but a non-candidate key determines another column, which normal form is violated?
4. What is the highest normal form for a table where every non-key attribute depends only on the whole primary key, but there is a transitive dependency?
5. Which normal form requires that every determinant is a candidate key?
6. If a table has repeating groups of columns (e.g., phone1, phone2, phone3), which normal form is violated?
7. A table with columns: `student_id`, `course_id`, `student_name`, `course_name`. `student_name` depends only on `student_id`. What normal form is violated?
8. If a table is in 2NF but not 3NF, what kind of dependency still exists?
9. Which of the following is a candidate key?  
   A) Any column that can uniquely identify a row  
   B) Any column that is a foreign key  
   C) Any column that is not null  
   D) Any column that is a determinant
10. In a table with columns `order_id`, `product_id`, `product_price`, if `product_price` depends only on `product_id`, what normal form is violated?
11. Which normal form is achieved by removing all partial dependencies?
12. If a table is in 3NF but not BCNF, what is true?  
    A) There is a transitive dependency  
    B) There is a partial dependency  
    C) There is a determinant that is not a candidate key  
    D) The table is not in 1NF
13. What is a determinant?
14. What is a functional dependency?
15. Which normal form is violated if a non-key attribute depends on another non-key attribute?
16. A table with columns `emp_id`, `dept_id`, `dept_name`, where `dept_name` depends on `dept_id`, and `dept_id` is not a candidate key. What normal form is violated?
17. Which of the following tables is in 1NF?  
    A) A table with a column containing lists  
    B) A table with repeating groups of columns  
    C) A table where every field contains only atomic values  
    D) A table with a composite key
18. If a table is in 1NF and 2NF, but not 3NF, what kind of dependency still exists?
19. What is the main goal of normalization?
20. Which normal form is most often sufficient for practical database design?  
    A) 1NF  
    B) 2NF  
    C) 3NF  
    D) BCNF

## Part 4: Submission

- Place all three files in:  
  `submissions/homework_4/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_4/
    your-github-username/
      hw4.mmd
      hw4.sql
      hw4.txt
```

## Tips

- Use your lesson notes and previous homework as references.
- For Mermaid syntax help, see the [Mermaid ER Diagram docs](https://mermaid.js.org/syntax/entityRelationshipDiagram.html).
- For ERD visualization, use the [Mermaid Playground](https://www.mermaidchart.com/play).
- For SQL, use `ALTER TABLE` to modify existing tables and `CREATE TABLE` for new ones.
- If you get stuck, review the lesson or ask for help!
