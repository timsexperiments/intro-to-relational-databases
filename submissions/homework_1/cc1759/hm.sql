-- create and use database
CREATE DATABASE IF NOT EXISTS lesson1;
USE lesson1;

-- create table of books
CREATE TABLE Emilys_fav_books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    author VARCHAR(100),
    year_published INT
);

-- insert rows/books into table
INSERT INTO Emilys_fav_books (title, author, year_published) 
    VALUES ('Cursed Princess Club', 'JambCat', 2019);
INSERT INTO Emilys_fav_books (title, author, year_published) 
    VALUES ('Grace (but said in a French accent)', 'Mary Casanova', 2015);

-- display all rows/books in the table
SELECT * FROM Emilys_fav_books;