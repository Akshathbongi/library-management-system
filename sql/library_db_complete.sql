-- =====================================================================
-- Library Management System : complete SQL script (MySQL 8.0 dialect)
-- =====================================================================
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- ---------------- DDL : table creation with constraints ----------------
CREATE TABLE Publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    website VARCHAR(200)
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    total_copies INT DEFAULT 1 CHECK (total_copies >= 0),
    genre VARCHAR(50),
    publication_year YEAR,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id)
);

CREATE TABLE Author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    nationality VARCHAR(50)
);

CREATE TABLE Book_Author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

CREATE TABLE Member (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    membership_type VARCHAR(30) DEFAULT 'Student',
    membership_date DATE,
    membership_expiry DATE
);

CREATE TABLE Loan (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

CREATE TABLE Fine (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT UNIQUE NOT NULL,
    member_id INT NOT NULL,
    fine_amount DECIMAL(8,2) CHECK (fine_amount >= 0),
    fine_date DATE,
    payment_status VARCHAR(20) DEFAULT 'Unpaid',
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id),
    FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

-- ---------------- DML : sample data insertion ----------------
INSERT INTO Publisher (publisher_name, country, website) VALUES
('McGraw-Hill Education', 'USA', 'https://www.mheducation.com'),
('Prentice Hall', 'USA', 'https://www.pearson.com'),
('HarperCollins', 'UK', 'https://www.harpercollins.com');

INSERT INTO Author (first_name, last_name, nationality) VALUES
('Abraham', 'Silberschatz', 'American'),
('Robert', 'Martin', 'American'),
('Paulo', 'Coelho', 'Brazilian');

INSERT INTO Book (title, isbn, total_copies, genre, publication_year, publisher_id) VALUES
('Database System Concepts', '978-0073523323', 5, 'Technology', 2019, 1),
('Clean Code', '978-0132350884', 3, 'Technology', 2008, 2),
('The Alchemist', '978-0062315007', 4, 'Fiction', 2014, 3);

INSERT INTO Book_Author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Member (first_name, last_name, email, phone, membership_type, membership_date, membership_expiry) VALUES
('Rahul', 'Sharma', 'rahul.sharma@example.com', '9876543210', 'Student', '2024-01-15', '2025-01-15'),
('Priya', 'Verma', 'priya.verma@example.com', '9876543211', 'Faculty', '2024-03-10', '2025-03-10');

INSERT INTO Loan (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2024-07-01', '2024-07-15', '2024-07-13', 'Returned'),
(2, 2, '2024-07-10', '2024-07-24', NULL, 'Active'),
(3, 1, '2024-07-20', '2024-08-03', '2024-08-10', 'Returned');

-- Loan 3 was returned 7 days late; fine at Rs.10 per day = Rs.70
INSERT INTO Fine (loan_id, member_id, fine_amount, fine_date, payment_status) VALUES
(3, 1, 70.00, '2024-08-10', 'Unpaid');

-- ================= DQL : basic retrieval (Q1-Q5) =================
-- Q1: List all books with their genre and publication year.
SELECT book_id, title, genre, publication_year FROM Book;

-- Q2: List all registered members.
SELECT member_id, first_name, last_name, email, membership_type FROM Member;

-- Q3: Show all currently active loans.
SELECT loan_id, book_id, member_id, loan_date, due_date
FROM Loan WHERE status = 'Active';

-- Q4: Show overdue loans (due date passed and not yet returned).
SELECT loan_id, book_id, member_id, due_date
FROM Loan WHERE return_date IS NULL AND due_date < CURDATE();

-- Q5: List books of genre 'Technology'.
SELECT title, isbn, total_copies FROM Book WHERE genre = 'Technology';

-- ================= Joins (Q6-Q11) =================
-- Q6: Inner join - books with their publisher names.
SELECT b.title, p.publisher_name, p.country
FROM Book b INNER JOIN Publisher p ON b.publisher_id = p.publisher_id;

-- Q7: Books with their authors (through the Book_Author junction).
SELECT b.title, CONCAT(a.first_name, ' ', a.last_name) AS author
FROM Book b
JOIN Book_Author ba ON b.book_id = ba.book_id
JOIN Author a ON ba.author_id = a.author_id;

-- Q8: Loan details with member name and book title.
SELECT l.loan_id,
       CONCAT(m.first_name, ' ', m.last_name) AS member,
       b.title, l.loan_date, l.due_date, l.status
FROM Loan l
JOIN Member m ON l.member_id = m.member_id
JOIN Book b ON l.book_id = b.book_id;

-- Q9: Left outer join - all members and any fines they have.
SELECT CONCAT(m.first_name, ' ', m.last_name) AS member,
       f.fine_id, f.fine_amount, f.payment_status
FROM Member m LEFT JOIN Fine f ON m.member_id = f.member_id;

-- Q10: Right outer join - all loans and any fine raised on each.
SELECT l.loan_id, l.status, f.fine_id, f.fine_amount
FROM Fine f RIGHT JOIN Loan l ON f.loan_id = l.loan_id;

-- Q11: Full outer join (MySQL: LEFT JOIN UNION RIGHT JOIN) - members and fines.
SELECT m.member_id, f.fine_id, f.fine_amount
FROM Member m LEFT JOIN Fine f ON m.member_id = f.member_id
UNION
SELECT m.member_id, f.fine_id, f.fine_amount
FROM Member m RIGHT JOIN Fine f ON m.member_id = f.member_id;

-- ================= Aggregates, GROUP BY, HAVING (Q12-Q16) =================
-- Q12: Total number of books in the catalogue.
SELECT COUNT(*) AS total_books FROM Book;

-- Q13: Total fine amount per member.
SELECT member_id, SUM(fine_amount) AS total_fine
FROM Fine GROUP BY member_id;

-- Q14: Genre-wise book count (only genres having more than one book).
SELECT genre, COUNT(*) AS book_count
FROM Book GROUP BY genre HAVING COUNT(*) > 1;

-- Q15: Average fine amount levied.
SELECT AVG(fine_amount) AS avg_fine FROM Fine;

-- Q16: Maximum fine amount and the member who must pay it.
SELECT member_id, MAX(fine_amount) AS max_fine
FROM Fine GROUP BY member_id ORDER BY max_fine DESC LIMIT 1;

-- ================= Nested and correlated subqueries (Q17-Q20) =================
-- Q17: Books that have never been loaned out (nested subquery).
SELECT title FROM Book
WHERE book_id NOT IN (SELECT book_id FROM Loan);

-- Q18: Members who have at least one unpaid fine (correlated subquery).
SELECT CONCAT(first_name, ' ', last_name) AS member
FROM Member m
WHERE EXISTS (SELECT 1 FROM Fine f
              WHERE f.member_id = m.member_id
              AND f.payment_status = 'Unpaid');

-- Q19: Books published after the average publication year (nested).
SELECT title, publication_year FROM Book
WHERE publication_year > (SELECT AVG(publication_year) FROM Book);

-- Q20: Loans for books with more than 3 total copies (nested).
SELECT loan_id, book_id, member_id, status FROM Loan
WHERE book_id IN (SELECT book_id FROM Book WHERE total_copies > 3);

-- ================= Views and set operations (Q21-Q25) =================
-- Q21: Books having more copies than the average (nested subquery).
SELECT title, total_copies FROM Book
WHERE total_copies > (SELECT AVG(total_copies) FROM Book);

-- Q22: Updatable view of active loans.
CREATE VIEW Active_Loans AS
SELECT loan_id, book_id, member_id, loan_date, due_date
FROM Loan WHERE status = 'Active';

-- Q23: Non-updatable view (aggregate) of member-wise fine totals.
CREATE VIEW Member_Fine_Summary AS
SELECT m.member_id, CONCAT(m.first_name, ' ', m.last_name) AS member,
       COUNT(f.fine_id) AS fine_count, SUM(f.fine_amount) AS total_fine
FROM Member m LEFT JOIN Fine f ON m.member_id = f.member_id
GROUP BY m.member_id;

-- Q24: UNION - distinct first names of authors and members.
SELECT first_name FROM Author
UNION
SELECT first_name FROM Member;

-- Q25: INTERSECT - first names common to authors and members.
SELECT first_name FROM Author
INTERSECT
SELECT first_name FROM Member;

-- Q26: EXCEPT - author first names that are not member first names.
SELECT first_name FROM Author
EXCEPT
SELECT first_name FROM Member;

-- ================= DCL (Q26-Q27) =================
-- Q27: Grant read access on the Book table to a librarian user.
GRANT SELECT ON library_db.Book TO 'librarian'@'localhost';

-- Q28: Revoke that access.
REVOKE SELECT ON library_db.Book FROM 'librarian'@'localhost';

-- ================= TCL (Q28-Q30) =================
-- Q29: Insert a member and commit the transaction.
START TRANSACTION;
INSERT INTO Member (first_name, last_name, email, membership_type)
VALUES ('Amit', 'Kumar', 'amit.kumar@example.com', 'Public');
COMMIT;

-- Q30: Begin a transaction, insert two members and set a savepoint.
START TRANSACTION;
INSERT INTO Member (first_name, last_name, email, membership_type)
VALUES ('Neha', 'Reddy', 'neha.reddy@example.com', 'Student');
SAVEPOINT sp1;
INSERT INTO Member (first_name, last_name, email, membership_type)
VALUES ('Vikram', 'Rao', 'vikram.rao@example.com', 'Student');

-- Q31: Roll back to the savepoint and commit (the second insert is undone).
ROLLBACK TO sp1;
COMMIT;
