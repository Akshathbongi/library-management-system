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
