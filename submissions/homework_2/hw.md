# **Homework Assignment 2: Database Fundamentals**


___



## **Part 1: _Design Choices_**

### General
I started the file with trying to create a db and then enter it. Then went on to create the table structures, then lastly add data to the tables. 

### Diffrences
Generally I simply created tables with the values suggested in the hw2 doc, but there were a few places I took liberties, like:

- ISBNs only go up to 13, but they've expanded the amount of digits in the number before, so I left some room for growth by putting it to 20 instead.

- I put type 'YEAR' for published_date in books table instead of the sujested INT.

-  I left publishind_year as 'NOT NULL' incase there is a book of unkown publishing date.

- I set due date to automagicly be 2 weeks after the current date if the field is empty instead of making it a required field.

- I named the checkout table 'active_checkouts' for quicker look ups and more relevent data. Still leaves the ability to add a 'old_checkouts table' to transfer the old data to when users checkout if that was wanted.

- didn't add column of returned date because of the previouse statment. Added created_at number column to members table instead.


___


### **Part 2: _Named Constraints_**

The only named constraints I put were forign keys. I did not think any other constraint was nessacary to be named.


___


### **Part 3: _Debug and Error Checks_**
Any of the code commented out is for debugging, or the error assignments

The first 2 lines in the file are for debugging the script. Its there to delete the database and its tables so that when i have to launch the script over and over, I don't get an error saying that I'm creating duplicate tables.

The last lines of code that are commented out are for the errer assignments given in the hw2. Its starts of with inserting a nonexistant book into the active_checkouts tables, which returns the error, 'a foreign key constraint fails', and then told you how to locate the restraint by giving the database, the table, and the name of the constriegnt. It also told what column was the foreign key and what it was trying to refrence. Then it inserts a nonexistant member into the active checkouts table and returns the same error. Lastly, it inserts a book with a non unique isbn #, which returned a 'Duplicate entry' error with the value, and the column its in.
