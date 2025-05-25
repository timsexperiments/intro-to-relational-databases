 -- -- DEBUGING
DROP DATABASE lesson3;

-- CREATE AND ENTER DATABASE
CREATE DATABASE IF NOT EXISTS lesson3;
USE lesson3;



-- CREATE TABLES

-- create table of books
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    year_published YEAR
);

-- create table of authors
CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- create a join table for books and authors to credit each author of each book
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors(id)
);

-- create table of library members
CREATE TABLE members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone_numb DECIMAL(10, 0) CHECK (CHAR_LENGTH(CAST(phone_numb AS CHAR)) = 10) UNIQUE NOT NULL,
    card_numb VARCHAR(15) CHECK (CHAR_LENGTH(card_numb) = 15) UNIQUE NOT NULL
);

-- create a table of web profiles for library members
CREATE TABLE web_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fav_book INT,
    CONSTRAINT fk_wp_member FOREIGN KEY (member_id) REFERENCES members(id),
    CONSTRAINT fk_wp_favBook FOREIGN KEY (fav_book) REFERENCES books(id)
);

-- create a table for all books that are activly checked out
CREATE TABLE checkouts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATE DEFAULT (DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY)),
    returned_date DATETIME,
    CONSTRAINT fk_ac_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_ac_member FOREIGN KEY (member_id) REFERENCES members(id)
);

-- create a table for all submittedd book reviews
CREATE TABLE book_reviews (
    book_id INT NOT NULL,
    memb_web_prof_id INT NOT NULL,
    review TEXT,
    rating DECIMAL(2, 1) CHECK (rating >= 0 && rating < 6) NOT NULL,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (memb_web_prof_id, book_id),
    CONSTRAINT fk_br_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_br_member FOREIGN KEY (memb_web_prof_id) REFERENCES web_profiles(id)
);



-- ADD VALUES (mostly just taken from homework 2 lol)

-- add books
INSERT INTO books (title, isbn, year_published) VALUES
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
INSERT INTO members (full_name, phone_numb, card_numb) VALUES
    ("Jeffa A.", 3194806538, "2fj3e9KnU0pkJnH"),
    ("Marler Altemus", 6698311947, "Kl9803bJSeW1084"),
    ("Jeffin Altemus", 5101668872, "gPM9274bH9ja090"),
    ("Esteven the Weaven", 8865360830, "8Jnm3K22M3HfIe4");

-- add active checkouts
INSERT INTO active_checkouts (book_id,  member_id) VALUES
    (5, 1), (6, 2), (7, 3), (2, 4), (4, 1);

-- add web profiles
INSERT INTO web_profiles (member_id, email, fav_book) VALUES
    (1, "emily-in-desguise@estupido.com", 5),
    (4, "uncleweaven@gmail.com", NULL);

-- add review
INSERT INTO book_reviews (book_id, memb_web_prof_id, review, rating) VALUES
    (5, 1, "OMG, litterally the BEST book EVER!!! CHANGED my WHOLE LIFE!!!! 10/10, wouldn't recomend, I would DAMAND you to read it!!!!!", 5);



-- -- TEST DATA INTEGRATY

-- -- insert invalid phone number legnth
-- INSERT INTO members (full_name, phone_numb, card_numb) VALUES
--     ("test small phone number.", 1234567, "fjialodksicngmf");
-- INSERT INTO members (full_name, phone_numb, card_numb) VALUES
--     ("test large phone number.", 123456789012345, "gjiekdloaidkejg");
    
-- -- insert invalid card legnth
-- INSERT INTO members (full_name, phone_numb, card_numb) VALUES
--     ("test too small card.", 1010101010, "thistoosmall");
-- INSERT INTO members (full_name, phone_numb, card_numb) VALUES
--     ("test too small card.", 1010101010, "this is way too large to be 15 charictors");

-- -- insert invalid book rating
-- INSERT INTO book_reviews (book_id, memb_web_prof_id, review, rating) VALUES
--     (1, 1, "too many digits above decimal", 11);
-- INSERT INTO book_reviews (book_id, memb_web_prof_id, review, rating) VALUES
--     (1, 1, "too big rating", 6);
-- INSERT INTO book_reviews (book_id, memb_web_prof_id, review, rating) VALUES
--     (2, 1, "negative rating", -2.1);
-- INSERT INTO book_reviews (book_id, memb_web_prof_id, review, rating) VALUES
--     (3, 1, "too many decimals", .13); SELECT rating FROM book_reviews;

-- -- insert invalid book
-- INSERT INTO book_reviews (book_id, memb_web_prof_id, rating) VALUES
--     (100, 1, 4.0);

-- -- insert invalid web profile
-- INSERT INTO book_reviews (book_id, memb_web_prof_id, rating) VALUES
--     (1, 100, 3.0);
