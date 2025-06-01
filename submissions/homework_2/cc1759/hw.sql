-- DEBUGING
DROP DATABASE lesson2;

-- create and enter database
CREATE DATABASE IF NOT EXISTS lesson2;
use lesson2;



-- CREATE TABLES

-- create table of books
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    published_year YEAR
);

-- create author table
CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- create a join table for books and authors to credit each author of each book
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_credited_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_credited_author FOREIGN KEY (author_id) REFERENCES authors(id)
);

-- create table of library members
CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- create a table for all active checkouts  
CREATE TABLE active_checkouts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT UNIQUE NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATE DEFAULT (DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY)),
    CONSTRAINT fk_checkedout_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_borrowing_member FOREIGN KEY (member_id) REFERENCES members(id) 
);



-- ALTERING VALUES

-- add created_at date to members
ALTER TABLE members ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

-- rename 'name' column to 'member' in members table
ALTER TABLE members RENAME COLUMN member TO full_name;



-- ADD VALUES

-- add books
INSERT INTO books (title, isbn, published_year) VALUES
    ("How to be Depressed for Dummies!", "5555886810", "2007"), 
    ("This Book is Illigal in 42 states.", "1111111111", NULL),
    ("How to Shoot a Three", "9789841463663", "2016"),
    ("I Love Arsin", "9786378755865", "2022"),
    ("The Adventures of Bobrickabilly", "617039068788", "2012"),
    ("Torpido Dog", "9749828844", "2015"),
    ("Look at Me! I'm a Fish!", "4039164758394029", "2083"),
    ("How to Be a Dummy for Dummies", "87819249073", "2001");

-- add authors
INSERT INTO authors (name) VALUES
    ("Timotello"), ("Omilo"), ("JimmyJames"), 
    ("Willywonk-the-Sillywonk"), ("Billy-Joe-MCGuffin");

-- add book_authors
INSERT INTO book_authors (book_id, author_id) VALUES
    (1, 2), (3, 1), (4, 2), (4, 3), (5, 2), (5, 1), (6, 4), (7, 3), (8, 5);

-- add members
INSERT INTO members (full_name, email) VALUES
    ("Jeffa", "emily-in-desguise@estupido.com"),
    ("Marler", "matlemus@altemus.com"),
    ("Jeffin", "father-jefferham@gmail.comolicouse"),
    ("Esteven", "uncleweaven@gmail.com");

-- add active checkouts
INSERT INTO active_checkouts (book_id,  member_id) VALUES
    (5, 1), (6, 2), (7, 3), (2, 4), (4, 1);



-- TEST CONSTRAINTS (SHOULD ERROR)

-- -- checkout of nonexistant book
-- INSERT INTO active_checkouts (book_id, member_id) VALUES
--     (100, 3)

-- -- checkout for nonexistant member
-- INSERT INTO active_checkouts (book_id, member_id) VALUES
--     (8, 100)

-- -- two books with same isbn
-- INSERT INTO books (title, isbn, published_year) VALUES 
--     ("Gae Gae Cat's favorite word!", "9786378755865", YEAR(CURRENT_DATE))
