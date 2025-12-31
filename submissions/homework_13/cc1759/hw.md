# **Question #7 On Homework 13**

## **Using the Subquery**
The subquery feels unanecassary, as you can do it in a much simpiler way with simple joins. The guidelines for subqueries in lesson 12 states, "In most cases where a query can be written with either a `JOIN` or a subquery, the `JOIN` will perform better."

## **Using neither**
This method used simple JOIN logic. Lesson 2 stated, "If you can express the logic clearly and efficiently with a `JOIN`, that is usually the best path" which I believe is the case here.

## **Using the CTE**
I could not find any considerable functional way to improve the task using the CTE, so I simply put the code from th previous example into the CTE. The CTE does actually contribute slightly to readablility, since you can simply ignore what is in the CTE if you do not want the specifics, but this does not seem efficient resource wise. The guidelines of lesson 13 said to "avoid using a CTE when a simple join would suffice."