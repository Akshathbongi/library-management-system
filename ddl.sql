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
