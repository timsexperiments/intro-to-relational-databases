 -- -- DEBUGING
DROP DATABASE lesson5;

-- CREATE AND ENTER DATABASE
CREATE DATABASE IF NOT EXISTS lesson5;
USE lesson5;



-- CREATE EMPTY TABLES

-- create tables

CREATE TABLE IF NOT EXISTS books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    year_published YEAR,
    is_deleted TINYINT(1) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE IF NOT EXISTS members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone_numb DECIMAL(10, 0) CHECK (CHAR_LENGTH(CAST(phone_numb AS CHAR)) = 10) UNIQUE NOT NULL,
    card_numb VARCHAR(15) CHECK (CHAR_LENGTH(card_numb) = 15) UNIQUE NOT NULL,
    is_deleted TINYINT(1) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS web_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fav_book INT,
    is_deleted TINYINT(1) DEFAULT 0,
    CONSTRAINT fk_wp_member FOREIGN KEY (member_id) REFERENCES members(id),
    CONSTRAINT fk_wp_favBook FOREIGN KEY (fav_book) REFERENCES books(id)
);

CREATE TABLE IF NOT EXISTS checkouts (
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATE DEFAULT (DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY)),
    returned_date DATETIME,
    PRIMARY KEY (book_id, member_id, checkout_date),
    CONSTRAINT fk_ac_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_ac_member FOREIGN KEY (member_id) REFERENCES members(id)
);

CREATE TABLE IF NOT EXISTS book_reviews (
    book_id INT NOT NULL,
    memb_web_prof_id INT NOT NULL,
    review TEXT,
    rating DECIMAL(2, 1) CHECK (rating >= 0 && rating < 6) NOT NULL,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_deleted TINYINT(1) DEFAULT 0,
    PRIMARY KEY (memb_web_prof_id, book_id),
    CONSTRAINT fk_br_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_br_member FOREIGN KEY (memb_web_prof_id) REFERENCES web_profiles(id)
);


-- delete tables with dependencies
DELETE FROM book_authors;
DELETE FROM book_reviews;
DELETE FROM checkouts;
DELETE FROM web_profiles;

-- empty the rest of the rest of the tables
DELETE FROM books;
DELETE FROM authors;
DELETE FROM members;



-- POPULATE TABLES

-- add books
INSERT INTO books (title, isbn, year_published) VALUES
    ("How to be Depressed for Dummies!", "5555886810", "2007"), 
    ("This Book is Illigal in 42 states.", "1111111111", NULL),
    ("How to Shoot a Three", "9789841463663", "2016"),
    ("I Love Arsin", "9786378755865", "2022"),
    ("The Adventures of Bobrickabilly", "617039068788", "2012"),
    ("Torpido Dog", "9749828844", "2015"),
    ("Look at Me! I'm a Python!", "4039164758394029", "2083"),
    ("How to Be a Dummy for Dummies", "87819249073", "1997");
SET @last_book_id = (SELECT LAST_INSERT_ID());

-- add authors
INSERT INTO authors (name) VALUES
    ("Timotello"), ("Omilo"), ("JimmyJames"), 
    ("Willywonk-the-Sillywonk"), ("Billy-Joe-MCGuffin");
SET @last_auth_id = (SELECT LAST_INSERT_ID());

-- add book_authors
-- should result in (3, 1), (5, 1), (1, 2), (4, 2), (5, 2), (4, 3), (7, 3), (6, 4), (8, 5);
INSERT INTO book_authors (book_id, author_id) VALUES
    (@last_book_id + 0, @last_auth_id + 1), 
    (@last_book_id + 2, @last_auth_id + 0), 
    (@last_book_id + 3, @last_auth_id + 1), 
    (@last_book_id + 3, @last_auth_id + 2), 
    (@last_book_id + 4, @last_auth_id + 1), 
    (@last_book_id + 4, @last_auth_id + 0),
    (@last_book_id + 5, @last_auth_id + 3),
    (@last_book_id + 6, @last_auth_id + 2),
    (@last_book_id + 7, @last_auth_id + 4);
-- it looks like it sorts by smallest author first and then smallest book when you select

-- add members
INSERT INTO members (full_name, phone_numb, card_numb) VALUES
    ("Jeffa A.", 3194806538, "2fj3e9KnU0pkJnH"),
    ("Marler Altemus", 6698311947, "Kl9803bJSeW1084"),
    ("Jeffin Altemus", 5101668872, "gPM9274bH9ja090"),
    ("Esteven the Weaven", 8865360830, "8Jnm3K22M3HfIe4");
SET @last_memb_id = (SELECT LAST_INSERT_ID());

-- add active checkouts
-- should  result in (4, 1), (7, 1), (5, 2), (2, 4), (3, 4), (4, 4)
INSERT INTO checkouts (book_id,  member_id, checkout_date, due_date, returned_date) VALUES
    (@last_book_id + 3, @last_memb_id + 0, '2012-04-13 6:02:57', '2012-4-27', '2012-04-26 16:23:44'), 
    (@last_book_id + 5, @last_memb_id + 0, DEFAULT, DEFAULT, NULL),
    (@last_book_id + 4, @last_memb_id + 1, DEFAULT, DEFAULT, NULL), 
    (@last_book_id + 4, @last_memb_id + 0, DEFAULT, DEFAULT, NULL), 
    (@last_book_id + 1, @last_memb_id + 3, DEFAULT, DEFAULT, NULL), 
    (@last_book_id + 3, @last_memb_id + 3, DEFAULT, DEFAULT, NULL), 
    (@last_book_id + 2, @last_memb_id + 3, '2015-11-11 13:10:08', '2015-11-25', '2015-11-19 13:30:41'),
    (@last_book_id + 0, @last_memb_id + 3, '2017-10-18 13:23:44', '2017-11-1', '2017-10-29 13:47:13');

-- add web profiles
-- should be (1, 6), 4, and 2
INSERT INTO web_profiles (member_id, email, fav_book) VALUES
    (@last_memb_id + 0, "emily-in-desguise@estupido.com", @last_book_id + 5),
    (@last_memb_id + 3, "uncleweaven@gmail.com", NULL),
    (@last_memb_id + 1, "mom@gmail.com", NULL);
SET @last_prof_id = (SELECT LAST_INSERT_ID());

-- add review
-- should be (5, 1), (5, 2), (3, 2)
INSERT INTO book_reviews (book_id, memb_web_prof_id, review, rating) VALUES
    (@last_book_id + 4, @last_prof_id + 0, "OMG, litterally the BEST book EVER!!! CHANGED my WHOLE LIFE!!!! 10/10, wouldn't recomend, I would DAMAND you to read it!!!!!", 5),
    (@last_book_id + 4, @last_prof_id + 1, "Teeming with Adventure", 3.7),
    (@last_book_id + 3, @last_prof_id + 1, "Very Relatable", 4.8);



-- ANSWERS

-- NOTE: The aliasing of the tables wasnt working so I didn't do them.

-- lists all members and the books they've checked out
SELECT members.full_name AS member, books.title, checkouts.checkout_date
    FROM members
    LEFT JOIN checkouts ON members.id = checkouts.member_id
    LEFT JOIN books ON books.id = checkouts.book_id
    ORDER BY checkouts.checkout_date ASC;

-- list all books and their authors
SELECT books.title, authors.name AS author
    FROM books
    LEFT JOIN book_authors ON books.id = book_authors.book_id
    LEFT JOIN authors ON authors.id = book_authors.author_id
    ORDER BY books.title ASC;

-- lists all books and any member who checked them out
SELECT books.title, members.full_name AS checked_out_by
    FROM books
    LEFT JOIN checkouts ON books.id = checkouts.book_id
    LEFT JOIN members ON members.id = checkouts.member_id
    ORDER BY books.title ASC;

-- list all authors and the books they wrote
SELECT authors.name AS author, books.title
    FROM authors
    LEFT JOIN book_authors ON authors.id = book_authors.author_id
    LEFT JOIN books ON books.id = book_authors.book_id
    ORDER BY authors.name ASC;

-- list all checkouts and the related names of members, title of books, and any reviews from that member on that book
-- I don't have reviews linked to checkouts because you could've read the book comewhere else and simply commented on the library website, so I simply checked if a review existed on that book from that member
SELECT members.full_name AS member, books.title, CONCAT(book_reviews.rating, " stars") AS rating, book_reviews.review
    FROM checkouts
    LEFT JOIN members ON checkouts.member_id = members.id
    LEFT JOIN books ON checkouts.book_id = books.id
    LEFT JOIN web_profiles ON web_profiles.member_id = members.id
    LEFT JOIN book_reviews ON book_reviews.book_id = books.id 
    AND book_reviews.memb_web_prof_id = web_profiles.id
    ORDER BY members.full_name; 

-- list every member and the reviews they have written
SELECT members.full_name AS member, books.title, book_reviews.rating, book_reviews.review
    FROM members
    LEFT JOIN web_profiles ON members.id = web_profiles.member_id
    LEFT JOIN book_reviews ON book_reviews.memb_web_prof_id = web_profiles.id
    LEFT JOIN books ON book_reviews.book_id = books.id
    ORDER BY members.full_name ASC;

-- show every possible combonation of members and books
SELECT members.full_name AS members, books.title
    FROM members
    CROSS JOIN books
    ORDER BY members.full_name;

-- liSt all members and all checkouts without exclusion of null values
-- can't have a checkout without a member ID because it is part of the primary key
-- INSERT INTO checkouts(member_id, book_id) VALUES (NULL, @last_book_id + 2);
SELECT checkouts.checkout_date, members.full_name
    FROM checkouts
    LEFT JOIN members ON members.id = checkouts.member_id
    UNION
SELECT checkouts.checkout_date, members.full_name
    FROM checkouts
    RIGHT JOIN members ON members.id = checkouts.member_id
    ORDER BY checkout_date DESC;
