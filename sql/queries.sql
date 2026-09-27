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
