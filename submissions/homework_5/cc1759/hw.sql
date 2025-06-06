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
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATE DEFAULT (DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY)),
    returned_date DATETIME,
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



-- -- ADD VALUES

-- add books
INSERT INTO books (title, isbn, year_published) VALUES
    ("How to be Depressed for Dummies!", "5555886810", "2007"), 
    ("This Book is Illigal in 42 states.", "1111111111", NULL),
    ("How to Shoot a Three", "9789841463663", "2016"),
    ("I Love Arsin", "9786378755865", "2022"),
    ("The Adventures of Bobrickabilly", "617039068788", "2012"),
    ("Torpido Dog", "9749828844", "2015"),
    ("Look at Me! I'm a Fish!", "4039164758394029", "2083"),
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
-- it looks like it sorts by smallest auther first and then smallest book when you select

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
    (@last_book_id + 1, @last_memb_id + 3, DEFAULT, DEFAULT, NULL), 
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



-- UPDATE DATA

-- update a members phone number
UPDATE members SET phone_numb = 8929407173 WHERE id = 2;

-- update a checkout to be returned
UPDATE checkouts SET returned_date = CURRENT_DATE WHERE id = 4;

-- update a review's rating
UPDATE book_reviews SET rating = 5 where book_id = 3 AND memb_web_prof_id = 2;



-- DELETE DATA

-- delete a member with no checkouts 
UPDATE members SET is_deleted = 1 WHERE id = 3;

-- delete books published before the 2000
UPDATE books SET is_deleted = 1 WHERE year_published < 2000;



-- TRANSACTIONS

START TRANSACTION;
-- mom checks out "Torpido Dog"
INSERT INTO checkouts (book_id, member_id) VALUES (6, 2);
-- mom reviews "Torpido Dog"
INSERT INTO book_reviews (book_id, memb_web_prof_id, rating) VALUES (6, 3, 4);
-- mom sets her favorit book to "Torpido Dog" 
UPDATE web_profiles SET fav_book = 6 WHERE id = 3;
ROLLBACK;


START TRANSACTION;
-- 
INSERT INTO checkouts (book_id, member_id) VALUES (3, 1);
-- 
UPDATE web_profiles SET email = "its_in_the_game@EAmail.com" WHERE id = 1;
COMMIT;




























-- ORIGINAL METHOD OF CLEARING/CREATING TABLES


-- Drop function if it already exists
-- DROP FUNCTION IF EXISTS check_for_table;

-- -- create query function to check for table
-- DELIMITER $$

-- CREATE FUNCTION IF NOT EXISTS check_for_table(db VARCHAR(100), tbl VARCHAR(100)) RETURNS bool DETERMINISTIC
-- BEGIN
--     -- set default db
--     IF db IS NULL THEN
--         SET db = "lesson5";
--     END IF;
--     -- query schema for the correct table and returns if it exists
--     RETURN EXISTS(
--         SELECT * FROM information_schema.tables
--         WHERE table_schema = db
--         AND table_name = tbl
--     );
-- END$$


-- -- imake procedures to create or wipe tables

-- -- books table
-- DROP PROCEDURE IF EXISTS clear_create_table_books;
-- CREATE PROCEDURE clear_create_table_books()
-- BEGIN
--     IF check_for_table(NULL, "books") THEN
--         DELETE FROM books;
--     ELSE
--         CREATE TABLE books (
--             id INT PRIMARY KEY AUTO_INCREMENT,
--             title VARCHAR(100) NOT NULL,
--             isbn VARCHAR(20) UNIQUE NOT NULL,
--             year_published YEAR,
--             is_deleted TINYINT(1) DEFAULT 0
--         );
--     END IF;
-- END$$

-- -- author table
-- DROP PROCEDURE IF EXISTS clear_create_table_authors;
-- CREATE PROCEDURE clear_create_table_authors()
-- BEGIN
--     IF check_for_table(NULL, "authors") THEN
--       DELETE FROM authors;
--     ELSE
--         CREATE TABLE authors (
--             id INT PRIMARY KEY AUTO_INCREMENT,
--             name VARCHAR(100) NOT NULL
--         );
--     END IF;
-- END$$

-- -- book's authors table
-- DROP PROCEDURE IF EXISTS clear_create_table_book_authors;
-- CREATE PROCEDURE clear_create_table_book_authors()
-- BEGIN
--     IF check_for_table(NULL, "book_authors") THEN
--         DELETE FROM book_authors;
--     ELSE
--         CREATE TABLE book_authors (
--             book_id INT NOT NULL,
--             author_id INT NOT NULL,
--             PRIMARY KEY (book_id, author_id),
--             CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES books(id),
--             CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors(id)
--         );
--     END IF;
-- END$$

-- -- library members table
-- DROP PROCEDURE IF EXISTS clear_create_table_members;
-- CREATE PROCEDURE clear_create_table_members()
-- BEGIN
--     IF check_for_table(NULL, "members") THEN
--         DELETE FROM members;
--     ELSE
--         CREATE TABLE members (
--             id INT PRIMARY KEY AUTO_INCREMENT,
--             full_name VARCHAR(100) NOT NULL,
--             phone_numb DECIMAL(10, 0) CHECK (CHAR_LENGTH(CAST(phone_numb AS CHAR)) = 10) UNIQUE NOT NULL,
--             card_numb VARCHAR(15) CHECK (CHAR_LENGTH(card_numb) = 15) UNIQUE NOT NULL,
--             is_deleted TINYINT(1) DEFAULT 0
--         );
--     END IF;
-- END$$

-- -- web profiles table
-- DROP PROCEDURE IF EXISTS clear_create_table_web_profiles;
-- CREATE PROCEDURE clear_create_table_web_profiles()
-- BEGIN
--     IF check_for_table(NULL, "web_profiles") THEN
--         DELETE FROM web_profiles;
--     ELSE
--         CREATE TABLE web_profiles (
--             id INT PRIMARY KEY AUTO_INCREMENT,
--             member_id INT UNIQUE NOT NULL,
--             email VARCHAR(100) UNIQUE NOT NULL,
--             fav_book INT,
--             is_deleted TINYINT(1) DEFAULT 0,
--             CONSTRAINT fk_wp_member FOREIGN KEY (member_id) REFERENCES members(id),
--             CONSTRAINT fk_wp_favBook FOREIGN KEY (fav_book) REFERENCES books(id)
--         );
--     END IF;
-- END$$

-- -- checkouts table
-- DROP PROCEDURE IF EXISTS clear_create_table_checkouts;
-- CREATE PROCEDURE clear_create_table_checkouts()
-- BEGIN
--     IF check_for_table(NULL, "checkouts") THEN
--         DELETE FROM checkouts;
--     ELSE
--         CREATE TABLE checkouts (
--             id INT PRIMARY KEY AUTO_INCREMENT,
--             book_id INT NOT NULL,
--             member_id INT NOT NULL,
--             checkout_date DATETIME DEFAULT CURRENT_TIMESTAMP,
--             due_date DATE DEFAULT (DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY)),
--             returned_date DATETIME,
--             CONSTRAINT fk_ac_book FOREIGN KEY (book_id) REFERENCES books(id),
--             CONSTRAINT fk_ac_member FOREIGN KEY (member_id) REFERENCES members(id)
--         );
--     END IF;
-- END$$

-- -- book reviews table
-- DROP PROCEDURE IF EXISTS clear_create_table_book_reviews;
-- CREATE PROCEDURE clear_create_table_book_reviews()
-- BEGIN
--     IF check_for_table(NULL, "book_reviews") THEN
--         DELETE FROM book_reviews;
--     ELSE
--         CREATE TABLE book_reviews (
--             book_id INT NOT NULL,
--             memb_web_prof_id INT NOT NULL,
--             review TEXT,
--             rating DECIMAL(2, 1) CHECK (rating >= 0 && rating < 6) NOT NULL,
--             review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
--             is_deleted TINYINT(1) DEFAULT 0,
--             PRIMARY KEY (memb_web_prof_id, book_id),
--             CONSTRAINT fk_br_book FOREIGN KEY (book_id) REFERENCES books(id),
--             CONSTRAINT fk_br_member FOREIGN KEY (memb_web_prof_id) REFERENCES web_profiles(id)
--         );
--     END IF;
-- END$$

-- DELIMITER ;


-- -- create or wipe tables depending on if the table already exists

-- SET FOREIGN_KEY_CHECKS = 0;

-- CALL clear_create_table_books();
-- CALL clear_create_table_authors();
-- CALL clear_create_table_book_authors();
-- CALL clear_create_table_members();
-- CALL clear_create_table_web_profiles();
-- CALL clear_create_table_checkouts();
-- CALL clear_create_table_book_reviews();

-- SET FOREIGN_KEY_CHECKS = 1;
