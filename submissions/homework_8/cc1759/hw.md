# **Homework: _Indexing and Query Performance_**



## **Part 1: _Adding Indexes_**
## Common Indexes
Common Queries the library would run:
- book by book title (search bar on website)
- author by author name (search bar on website)
- book by isbn number (when scanning it in the system)
- members by card number (scanning/logging into your account when checking out or going online)
- authors by a book (brought up when your looking at book info or checking out (usually goes with the name of the book))
- books by checkouts (when checking if a book is instock (though a 'quantity' should be added to the books table and a 'instock' var should probally be in a join or invitory table instead))
  
Slightly less common ones:
- books by year published (filters on online searching)
- reviews by books (if you check the reviews online in library app)
- positive reviews by book (I'm pretty sure they use a way diffrent way of sentiment analizis, but i needed this one to do the full_text index)

Common thing to order by:
- date checked out
- book title (searching for book through an alphabetical list)
- book ratings (for general searches like "best rated")

Less common ones to order by:
- member name (I used this a lot in my selects, but I dont think it would be that usefull in the front end...)
- author name (because thats how most libraries have books sorted (though online the only example i can give is typing in only partial part of authors name (like only first name)))


## Indexing

Below I have put the requirements asked by hw8.md and what I did to complete them:

> - At least **one standard index** (B-tree) on a single column not already indexed by a `PRIMARY KEY` or `UNIQUE` constraint.

I indexed book.title and author.name, which both completed this constraint.

>  - At least **one composite index** on a table that could benefit from filtering/sorting on multiple columns together.

I made composite indexes for (book_id, checkout_date) and (member_id, checkout_date) on the checkouts table and (year published, book title) on books table. 

>  - At least **one functional index** (e.g., for case-insensitive search on a relevant column like `member.email` or `book.title`).

I did the case-insesitive search on member.email.

>  - At least **one `FULLTEXT` index** (if applicable to your schema and MySQL's default setup, e.g., on a `review_text` or `book_description` column).

I made a full-text index on book reviews for easy keyword searching.


_NOTE: I switched book.isbn to me a decimil will zerofill to have better lookups than varchar_

_NOTE: mayeb also add a renewed var to books, because in a real system you can renew a book once before having to return it_



## **Part 2: _Answering Questions_**

- 1. A **FULL TABLE SCAN** is the proccess of going over every row in a table to search for a specific row or value of a column (O(n)). Since it is O(n), the larger the tables (the more rows it has (which is the n)) the less efficient the search is.
  
- 2. A **Cache Hit** happens when the data being retrieved is found being stored in the cache at the time of retrieveal. This will speed up the retrieval procces because it doesn't have to do a less efficient search in the disk. If the data isn't currently beign stored in memory, then a **Cache Miss** occures, and a slower disk read must be preformed. After a cache miss, the retreived data will be temporarily stored in the memory for future searches.

- 3. **B-TREE Indexes** are simple and scalable method of indexing items for quick retrivals (O(log(n))). They are sufficient for most general lookups like most WHEREs, ORDER BYs, and more

- 4. **HASH Indexes** have an average lookup time of o(1), which is faster than B-TREE indexes, but they are basicly only usefull for direct equality lookups.

- 5. A **COMPOSITE Index** indexes rows based on the combonations of two or more colums. I have a composite index on the columns year_published and book title to optomize query searches for books from certain years

- 6. A item that is a primary key must be unique, therefore mysql applies a unique index to it.

- 7. When adding an index to your table, the main tradeoff you have to be concerned about is the _Read Write Trade Off_. With indexed tables, reading the table for certain columns become faster, butting writting to those same columns will take longer.

- 8. You would use _Functional Index_ for indexing case inseitive searches. You would create it with:

        ``` sql
        CREATE INDEX idx_email_lower ON web_profiles ((LOWER(email)));
        ```

- 9. B.)

- 10. **Sharding** is the practice of splitting up data accros multiple servers to increase your database's scalability and lookup times.

- 11. One common sharding practice is to place data in servers closer to its reigion of relevency (ie: place profiles of people in india near india, and profiles of people in canada near canada). One problem with this is that it may take longer (or not allow you depending on how its built) to access info from other reigions (which can also be used to your advantage for reigion locked content or stuff).

- 12. Quierying across multiple shards is more complex because it requires sending a request to each shard and wait for each to respond before it can finish, compared to a single shard quiery where you only have to wait for a ingle shard to respond.

- 13. B.) 

- 14. To search through long pieces of text, you usually use a _Full-Text Index_.

- 15. Since the values are already indexes (since they are part of the primary key and theirfore must be unique), the join statement should have an easier time joining them.

- 16. O(log(n))

- 17. False. Adding too many indexes will make writing to those tables slower and may cause the system to choose the not the most efficient quiery avalible by accident.

- 18. **Scaling Up** indicates growing the proccesing power and storage capibilities to your existing servers, while **Scaling Out** indicates splitting up your database between multiple (usually less powerful) servers (AKA sharding).


_NOTE: Im not sure why you wanted me to do this in a .txt file instead of a .md file, so I just did it in a .md file._
