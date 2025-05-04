# Homework 3: Relationships and Cardinality

## Objectives

- Practice modeling relationships
- Use foreign keys and constraints to enforce data integrity
- Model optional vs. mandatory participation in relationships
- Create ERDs for your schema

## Scenario

You are designing a database for a library. The library wants to track books, authors, members, checkouts, and book reviews.  
Your goal is to design a schema that supports the following requirements:

## System Description

- The library has **books**. Each book has a title, an ISBN (which should be unique), and a published year.
- Each book can have one or more **authors**. Each author has a name.
- The library has **members**. Each member has a name and an email (which should be unique).
- Some members have additional profile information, such as address and phone number, but not all members provide this information.
- Members can **check out** books. For each checkout, you need to know which member checked out which book, the checkout date, the due date, and (if returned) the returned date.
- Members can also **review** books. Each review should include the member, the book, the review text, a rating (1-5), and the date the review was created.

## Tasks

1. **Create a Mermaid ERD**: Draw your schema as an ERD using Mermaid syntax. Show all tables and relationships. Use the [Mermaid Live Editor](https://mermaid.live/edit) to preview your diagram. Save your Mermaid code in a file named `hw.mmd`.
2. **Write SQL**: Create your tables and relationships in SQL, using appropriate data types and constraints. Save your SQL commands in a file named `hw.sql`.
3. **Test data integrity**: Try to insert data that violates your constraints (e.g., duplicate ISBN, checkout for a non-existent book) and note what happens.
4. **Explain your design**: In your writeup, describe your design choices, how you modeled optional/mandatory participation, and what happened when you tried to violate constraints. Save your explanation in a file named `hw.md`.

## Submission

- Place all three files in:  
  `submissions/homework_3/<your-github-username>/`
- Submit a pull request as described in the [submissions README](../submissions/README.md).

## Example Directory Structure

```
submissions/
  homework_3/
    your-github-username/
      hw.mmd
      hw.sql
      hw.md
```

## Tips

- Use `CREATE TABLE` and `ALTER TABLE` as needed.
- Use `INSERT INTO` to test your constraints.
- Use `DESCRIBE <table_name>;` to check your table structure.
- If you get stuck, review the lesson or ask for help!
- For Mermaid syntax help, see the [Mermaid ER Diagram docs](https://mermaid.js.org/syntax/entityRelationshipDiagram.html).

## Hints (if you need them)

- Think about which relationships are one-to-one, one-to-many, or many-to-many.
- Consider how you might represent books with multiple authors, and authors with multiple books.
- How would you model the fact that not all members have a profile?
- What fields should be required, and which can be optional?
- How can you ensure that a book’s ISBN and a member’s email are unique?
- How would you prevent a checkout or review from referencing a non-existent book or member?
- **Be sure to properly model mandatory and optional participation in your relationships.**
- Consider naming at least one of your foreign key constraints for clarity.
