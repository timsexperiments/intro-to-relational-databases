## **Homework Assignment 3: _Relationships and Cardinality_**



___



## **Part 1: _Design Choices_**

## General 
I generally just recreated the system from the last homework, and added webprofiles table and book revew table. I also changed the feilds for the members profile. A few of the unique design choices or areas I learned how to do something new in this language are:

-  use a normal autoincrementing primary keyfor active checkouts table instead of using the other primary key I used for the other join tables so the members could recheckout the same book if they wanted

- using the CHAR_LENGTH check that the value isn't shorter (or longer technicly but thats less important because the VARCHAR check can also make sure its not longer).

- for the phone number of the members, I had to turn my numerical value into a string so I could make sure it was no longer (but most importantly) shorter than 10 digits.

- this ones from last tiem but i don't think I mentioned it, I had to figure out how to add days to the current date so I could auto generate the active checkouts due dates because I didn't want to manually calculate and write each due date.


## Divergances
A few places I divereged from the hw3 docs system are:

- I had the members have there phone number registered instead of their email, because I feel thats what libraries normally do, but idk.

- I didn't understand why some library members would have profile information like address (i feel like that would be every profile because usually they only allow people from certain districtd to join) and phone number while others wouldn't, so I changed it to be like the web profile of their app/website. This i feel makes more since plus then it also makes the review system make more since because I fell that would litterally only make since on an online envirment.

- I dont have the returned part of the checkout system for the same reason as last time. I think it would be better to have an active checkouts table, and then a table for old checkouts, so once they return the book, there checkout data is moved to the old checkout data, with the return date added (but i didnt model that table)



___



## **Part 2: _Modeling Optional/Mandatory Participation_**

I modeled optional/mandatory participation in relationships such as

- authors ||--o{ book_authors
- books ||--o{ book_authors
- books ||--o{ book reviews
- members ||--o| web_profile
- members ||--o{ active_checkouts
- members ||--o{ book_reviews
- web_profile ||--o| 

In all of these, from the parents side it is optional, but from the childs side it is mandatory.



___



## **Part 3: _violating Constraints_**

In the last section of sql file, I left all the ways I tested violating the constriants. the results are as follows:


When trying to insert an invalid phone number, if I inserted a too small phone number to the members table, I got back the error,

> Check constraint 'members_chk_1' is violated.

because the check constraint, which checks to make sure the legnth of the number entered is equal to ten, was violated. When I put a too long phone number however, I'll get back the error,

> Out of range value for column 'phone_numb' at row 1

This is because the phone number value is set to be a DECIMAL with only ten digits (all of which are before the decimal), so since the number is above ten digits, it throws an error. If the DECIMAL is replaced with just a FLOAT or BIGINT, later error thrown will actually also be about the check constraint being violated, so obviously the check for the DECIMAL digit goes first in exacution order (which makes since since you have to assign the variable before you check something about it lol), which was cool to see. I also like how the error format for costraints (or at least the check constraints) tell you exactly how to find the error with their format of 'table_errorType_indexOfThatTypeOfConstraint'


Checking for error with the card numbers when very simeraly, ending up with there errors:

> Check constraint 'members_chk_2' is violated.

> Data too long for column 'card_numb' at row 1

when I entered a card number too small and a card number too large respectivly. The only diffrence is that the too long VARCHAR returned a diffrent error meaning basicly the same thing as the too long DECIMAL one which is intresting. 


With respects to inserting invalig ratings, I got these errors:

> Out of range value for column 'rating' at row 1

> Check constraint 'book_reviews_chk_1' is violated

> Check constraint 'book_reviews_chk_1' is violated

The first one happened when insering a rating with more than 2 digits above the decimal. Since the review value is a DECIMAL with only two digit, one of w6hich is reserved for behind the decimal point, it throws an error when you have any number over 9. The second one was when entering a value that is above 5, but is still below two digits above the decimal. This caused an error because of the check constrint checking if the value entered is under 6. The third was when entering a negative rating, which caused an error because I added a check constraint that makes sure the value is not under 0. The fourth test I did was inserting a value with multiple zeros below the decimal. This test did not return an error, but instead silently truncated off any values below the threshold it could store.


The last tests I did was on entering invalid forign keys. I this by inserting invalid IDs for books and invalid IDs for members web profiles respectivly. The error I got for both of them was,

> a foreign key constraint fails

and then the path to the foreign key and what it refrences.
