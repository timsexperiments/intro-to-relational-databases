# Homework 11: Combining Results (Set Operations)

## Notes for the problems

For question (1), the goal will not be accomplished because authors are publishing under psudonyms. I know you dont look at the test results usually, but I added mom to the authors table too without a psudonym so you can see the desired result.

To simulate an INTERSECT UNION in (3), I used a (INNER) JOIN on the names to grab the rows where members and authors shared names. I'm sure this is how you want it, but method is really bad since many authors use psudonyms and because multiple diffrent people can have the name.

To simulate the EXCEPT/MINUS UNION in (4), I used a left join and a where clause saying only selct where the right table is null. This way it only grabs things from the left table when the right table has no data.

For problem (5), I started by using a (INNER) JOIN on books and checkouts so that it selected only books that had been checked out. Then I used a GROUP BY to have it list for each unique book and only display and I used a HAVING statement and a LEFT JOIN of the book_review table to have only the ones that havn't been reviewed show.