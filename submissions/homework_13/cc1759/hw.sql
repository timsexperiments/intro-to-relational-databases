-- DEBUGING
DROP DATABASE IF EXISTS lesson13;

-- CREATE AND ENTER DATABASE
CREATE DATABASE IF NOT EXISTS lesson13;
USE lesson13;



-- CREATE EMPTY TABLES

-- create tables

CREATE TABLE IF NOT EXISTS books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    isbn DECIMAL(13, 0) ZEROFILL UNIQUE NOT NULL,
    year_published YEAR,
    market_price DECIMAL (6, 2),
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
INSERT INTO books (title, isbn, year_published, market_price) VALUES
    ("How to be Depressed for Dummies!", 9003478112573, "2007", 29.99), 
    ("This Book is Illigal in 42 states.", 1111111111111, NULL, NULL),
    ("How to Shoot a Three", 9789841463663, "2016", 19.45),
    ("I Love Arsin", 9786378755865, "2022", 10.13),
    ("The Adventures of Bobrickabilly", 617039068788, "2012", 40.78),
    ("Torpido Dog", 7019749828844, "2015", 12.39),
    ("Look at Me! I'm a Python!", 9164758394029, "2083", 56.87),
    ("How to Be a Dummy for Dummies", 8781924907302, "1997", 69.69);
SET @last_book_id = (SELECT LAST_INSERT_ID());

-- add authors
INSERT INTO authors (name) VALUES
    ("Timotello"), ("Omilo"), ("JimmyJames"), 
    ("Willywonk-the-Sillywonk"), ("Billy-Joe-MCGuffin"), ("Marler Altemus");
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
    ("Esteven the Weaven", 8865360830, "8Jnm3K22M3HfIe4"),
    ("Jimmy Bean", 9274837501, "X2RxhoJv9Um6Ow4"),
    ("Gae Gae Cat", 7191928563, "crHT6JiQE79G4Qy"),
    ("Sir Gigglesworth the 4th", 1111111111, "wCe7xFyNutMuju2");
SET @last_memb_id = (SELECT LAST_INSERT_ID());

-- add active checkouts
-- should  result in (4, 1), (7, 1), (5, 2), (2, 4), (3, 4), (4, 4)
INSERT INTO checkouts (book_id,  member_id, checkout_date, returned_date) VALUES
    (@last_book_id + 3, @last_memb_id + 0, '2012-04-13 6:02:57', '2012-04-26 16:23:44'), 
    (@last_book_id + 5, @last_memb_id + 0, DEFAULT, NULL),
    (@last_book_id + 4, @last_memb_id + 1, "2025-06-14", NULL), 
    (@last_book_id + 4, @last_memb_id + 0, "2025-06-25 15:52:05", NULL), 
    (@last_book_id + 1, @last_memb_id + 3, "2025-05-04 15:59:01", NULL), 
    (@last_book_id + 3, @last_memb_id + 3, DEFAULT, NULL), 
    (@last_book_id + 2, @last_memb_id + 1, '2015-11-11 13:10:08', '2015-11-19 13:30:41'),
    (@last_book_id + 2, @last_memb_id + 5, '2025-01-06 17:05:02', '2015-11-19 13:30:41'),
    (@last_book_id + 6, @last_memb_id + 6, '2025-01-09 08:04:20', NULL),
    (@last_book_id + 0, @last_memb_id + 3, '2017-10-18 13:23:44', '2017-10-29 13:47:13');

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
    (@last_book_id + 4, @last_prof_id + 1, "BOOOO, this stinks! What a bad book", 0.5),
    (@last_book_id + 3, @last_prof_id + 1, "Very Relatable", 4.8),
    (@last_book_id + 4, @last_prof_id + 2, "A great story teeming with adventure.", 3.9);



-- INDEXING

CREATE INDEX idx_book_titles ON books (title);
CREATE INDEX idx_title_yearPublished ON books (year_published, title);

CREATE INDEX idx_author_name ON authors (name);

CREATE INDEX idx_ba_book_id ON book_authors (book_id);
CREATE INDEX idx_ba_author_id ON book_authors (author_id);

CREATE INDEX idx_memberID_checkoutDate ON checkouts (book_id, checkout_date);
CREATE INDEX idx_bookID_checkoutDate ON checkouts (member_id, checkout_date);

CREATE INDEX idx_wp_member_id ON web_profiles (member_id);
CREATE INDEX idx_wp_fav_book ON web_profiles (fav_book);
CREATE INDEX idx_email_lower ON web_profiles ((LOWER(email)));

CREATE INDEX idx_br_book_id ON book_reviews (book_id);
CREATE INDEX idx_br_web_prof_id ON book_reviews (memb_web_prof_id);
CREATE FULLTEXT INDEX idx_reviews ON book_reviews (review);



-- ANSWERS

-- (1) recent checkouts
WITH recent_checkouts AS (
    SELECT m.id, m.full_name, b.title, c.checkout_date
    FROM checkouts c
    LEFT JOIN members m ON c.member_id = m.id
    LEFT JOIN books b ON c.book_id = b.id
    WHERE c.checkout_date > DATE_SUB(NOW(), INTERVAL 30 DAY)
)
SELECT rc.full_name AS member_name, rc.title AS book_title, rc.checkout_date AS checkout_date
FROM recent_checkouts rc;


-- (2) highly rated books
WITH avg_ratings AS (
    SELECT b.id, b.title, COUNT(br.rating) AS total_reviewers, AVG(br.rating) AS rating_avg
    FROM book_reviews br
    LEFT JOIN books b ON br.book_id = b.id
    GROUP BY b.id, b.title
)
SELECT avg_r.title AS highly_rated, avg_r.rating_avg
FROM avg_ratings avg_r
WHERE avg_r.rating_avg > 4.0;


-- (3) authors ranked by popularity
WITH book_checkout_counts AS (
    SELECT b.id, b.title, COUNT(c.checkout_date) AS checkout_amt
    FROM checkouts c
    LEFT JOIN books b ON c.book_id = b.id
    GROUP BY b.id
),
author_checkout_totals AS (
    SELECT a.id, a.name, SUM(bcc.checkout_amt) AS checkout_amt
    FROM book_authors ba
    LEFT JOIN authors a ON ba.author_id = a.id
    LEFT JOIN book_checkout_counts bcc ON ba.book_id = bcc.id
    GROUP BY a.id, a.name
)
SELECT act.name AS author_name, act.checkout_amt
FROM author_checkout_totals act
ORDER BY act.checkout_amt DESC;


-- (4) inactive members
WITH members_latest_checkout AS (
    SELECT m.id, m.full_name AS name, MAX(c.checkout_date) AS latest_checkout
    FROM members m
    LEFT JOIN checkouts c ON m.id = c.member_id
    GROUP BY m.id, m.full_name
)
SELECT mlc.name AS inactive_members, mlc.latest_checkout
FROM members_latest_checkout mlc
WHERE mlc.latest_checkout IS NULL OR mlc.latest_checkout < DATE_SUB(NOW(), INTERVAL 6 MONTH);


-- (5) overdue books
WITH checked_out_books AS (
    SELECT m.id, m.full_name, b.title, DATE_ADD(c.checkout_date, INTERVAL 2 WEEK) AS due_date
    FROM checkouts c
    LEFT JOIN members m ON c.member_id = m.id
    LEFT JOIN books b ON c.book_id = b.id
    WHERE c.returned_date IS NULL
),
overdue_books AS (
    SELECT cob.id, cob.full_name, cob.title, DATEDIFF(CURRENT_DATE, cob.due_date) AS days_overdue
    FROM checked_out_books cob
    WHERE cob.due_date < CURRENT_DATE
)
SELECT ob.full_name AS member_name, ob.title, ob.days_overdue
FROM overdue_books ob;


-- (6) checkouts per each day of Jan 2025
WITH RECURSIVE days_in_January_2025 AS (
    SELECT "2025-01-01" AS dates
    UNION ALL
    SELECT DATE_ADD(dates, INTERVAL 1 DAY)
    FROM days_in_January_2025
    WHERE dates < "2025-02-01"
)
SELECT m.full_name AS member, b.title, c.checkout_date
FROM checkouts c
JOIN days_in_January_2025 Jan2025 ON DATE(c.checkout_date) = Jan2025.dates
LEFT JOIN members m ON c.member_id = m.id
LEFT JOIN books b ON c.member_id = b.id
ORDER BY checkout_date ASC;


-- (7) members who have written at least one review

-- using subqueries
SELECT m.full_name AS name
    FROM members m
    WHERE EXISTS (
        SELECT 1
        FROM web_profiles wp
        JOIN book_reviews br ON wp.id = br.memb_web_prof_id
        WHERE m.id = wp.member_id
    );

-- using neither
SELECT m.full_name AS name, COUNT(br.review_date) AS total_reviews
    FROM members m
    JOIN web_profiles wp ON m.id = wp.member_id
    JOIN book_reviews br ON wp.id = br.memb_web_prof_id
    GROUP BY name;

-- using CTEs
WITH critics AS (
    SELECT m.full_name AS name, COUNT(br.review_date) AS total_reviews
        FROM members m
        JOIN web_profiles wp ON m.id = wp.member_id
        JOIN book_reviews br ON wp.id = br.memb_web_prof_id
        GROUP BY name
)
SELECT crit.name, crit.total_reviews
FROM critics crit;
