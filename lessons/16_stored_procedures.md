# Lesson 16: Stored Procedures

## What You’ll Learn

- Why and when to use stored procedures in MySQL
- Syntax for creating and invoking procedures with `CREATE PROCEDURE` and `CALL`
- Working with `IN`, `OUT`, and `INOUT` parameters
- Declaring variables and using control flow (`IF`, `LOOP`, `WHILE`)
- Managing procedures with `SHOW PROCEDURE STATUS` and `DROP`
- Pros and cons of moving logic into the database layer

## 1. Introduction

A **stored procedure** encapsulates SQL statements on the server so they can be reused by name. Procedures can enforce business
rules, bundle multiple statements into a single call, and improve performance by reducing round trips between an application and
the database.

## 2. Basic Syntax

MySQL requires changing the statement delimiter when defining a procedure so the body can contain semicolons.

```sql
DELIMITER $$
CREATE PROCEDURE get_customer_orders()
BEGIN
  SELECT c.id, c.name, o.total_amount
  FROM customers c
  JOIN orders o ON o.customer_id = c.id;
END$$
DELIMITER ;
```

Call the procedure with `CALL`:

```sql
CALL get_customer_orders();
```

## 3. Parameters

Procedures can accept parameters to make them reusable.

```sql
DELIMITER $$
CREATE PROCEDURE find_customer(IN p_email VARCHAR(255))
BEGIN
  SELECT id, name, email
  FROM customers
  WHERE email = p_email;
END$$
DELIMITER ;
```

- `IN` parameters pass data into the procedure.
- `OUT` parameters return values via user variables:

```sql
DELIMITER $$
CREATE PROCEDURE count_orders(IN p_customer_id INT, OUT p_total INT)
BEGIN
  SELECT COUNT(*) INTO p_total
  FROM orders
  WHERE customer_id = p_customer_id;
END$$
DELIMITER ;

SET @order_total = 0;
CALL count_orders(3, @order_total);
SELECT @order_total; -- displays the value assigned in the procedure
```

`INOUT` parameters behave as both input and output.

## 4. Variables and Control Flow

Inside a procedure you can declare variables and use control structures to build complex logic.

```sql
DELIMITER $$
CREATE PROCEDURE apply_discount(IN p_customer_id INT, IN p_amount DECIMAL(10,2))
BEGIN
  DECLARE current_total DECIMAL(10,2);

  SELECT SUM(total_amount) INTO current_total
  FROM orders
  WHERE customer_id = p_customer_id;

  IF current_total > 500 THEN
    INSERT INTO orders(customer_id, total_amount)
    VALUES (p_customer_id, p_amount * 0.9); -- apply 10% discount
  ELSE
    INSERT INTO orders(customer_id, total_amount)
    VALUES (p_customer_id, p_amount);
  END IF;
END$$
DELIMITER ;
```

Loops are available through `WHILE`, `REPEAT`, and `LOOP` constructs when iterating over sets of values.

## 5. Managing Procedures

- List procedures in the current database:

  ```sql
  SHOW PROCEDURE STATUS WHERE Db = DATABASE();
  ```

- View the definition of a procedure:

  ```sql
  SHOW CREATE PROCEDURE get_customer_orders;```

- Remove a procedure you no longer need:

  ```sql
  DROP PROCEDURE IF EXISTS get_customer_orders;
  ```

## 6. Pros and Cons

**Advantages**
- Reduce network overhead by executing multiple statements server-side
- Centralize business logic for consistent rules
- Can offer additional security by limiting direct table access

**Disadvantages**
- Harder to version control compared to application code
- Logic can become database-specific
- Overuse may lead to tightly coupled applications

## 7. Next Steps

You’ve learned how to create, parameterize, and manage stored procedures. To reinforce these concepts, complete the homework for this lesson.

**➡️ [Go to Homework 15: Stored Procedures](../homework/hw15.md)**

**Next Up:** We’ll explore **views and triggers** to create reusable queries and automate reactions to data changes.
