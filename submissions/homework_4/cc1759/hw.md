When there are multiple values in a single column (for instance, values seperated by commas) _1NF is violated_.
If a non key atribute's functionality depends on only part of the primary key, then _2NF is violated_.
If any nonkey atribute depends on any object besides the primary key, _3NF is violated_
_2NF is the highest normal form that allows for transitive dependencies_.
BCNF requires that any data which determins (besides trivial functional dependecies) any other data in a table (including other keys) must be a candidate key.
If there are multiple columns representing the same type (not litteral type) of data, _1NF is violated_.
Assuming the primary key is `student_id` and `course_id`, then _2NF is violated_. I can't think of any other good candidate keys for this table so thats what i'm assuming it is.
If a table is 2NF but isn't yet 3NF, _a transitional dependency must still exist_.
A.) (though technically it is any column or groups of columns)
Since `product_price` doesn't depend on `order_id`, which is the most likly primary key, and since `product_price` only depends on `product_id` and not the primary key, _2NF is violated_.
_2NF is the normal form that is achived by removing all partial dependencies_ (from a 1NF table).
C.)
A **Determinate** is a any column who's value determins the value of another column.
A **Functional Dependency** is when a value of one column is determined by the value of another column.
If a non-key attribute depends on any other value besides the (whole) primary key, then _3NF is violated_.
If `debt_name` depends on the primary key through a transitional dependancy with `debt_id`, _then 3NF is volated_, otherwise _it violates 2NF_. 
_Table C.) for sure follows 1NF_, while for table D.) more info is needed. All others tables explicitly violate 1NF.
Bro, this is litterally the same question as #8 lol. 2NF is inherintly in 1NF, so that information is unesascary, and if you exclude that info then the question is word for word question 8 but with an extra comma. IG i'll put the same answer of,  _a transitional dependency must still exist_.
The main goal of normalization is to create tables that are well orginized, reduce redundancy, and aren't prone to breaking when updated.
D.) is a most stable normal form out of those choices, and is usually sufficient for most tables.


## Lesson Notes

- I think my tables where already in BCNF lol.

- The examples for 3NF in the lesson were not the best because they both also violated 2NF. The 3NF example didn't show a good example of transitional dependencies since the `product_id` was already part of the key. Though it may have still been a transitional dependency, it had already broken 2NF by directly depending on only a part of the key, so a better example could've been used to show transitional dependency. When going over a table for NF violations, I start from lowest NF to highest, so i run into the problem with 2NF first
