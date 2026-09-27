# Library Management System — DBMS Capstone Project

A relational database for managing books, authors, publishers, members, book loans and fines in a library.
Built with **MySQL 8.0** as the DBMS Capstone Project (course 2501IT05), Department of Artificial Intelligence
and Machine Learning, Aditya University, academic year 2026–2027.

## Database overview

- **6 entities** modelled as **7 tables**: `Publisher`, `Book`, `Author`, `Book_Author` (junction for the
  M:N Book–Author relationship), `Member`, `Loan`, `Fine`
- Normalised to **3NF**
- Integrity enforced with primary keys, foreign keys, `UNIQUE`, `NOT NULL`, `CHECK` and `DEFAULT` constraints
- **31 SQL queries** covering DQL, joins, aggregate functions, subqueries, views, set operations, DCL and TCL

## Repository structure

```
library-management-system/
├── README.md                      — this file
├── sql/
│   └── library_db_complete.sql    — complete script: database + DDL + sample data + all 31 queries
├── diagrams/
│   ├── er_diagram.png             — ER diagram (draw.io)
│   └── relational_schema.png      — relational schema diagram
└── docs/
    └── DBMS_Capstone_Library_Management_System_Documentation.docx  — full project report
```

## Quick start

```bash
# 1. Start MySQL 8.0 and open MySQL Workbench (or the mysql client)
# 2. Run the complete script:
mysql -u root -p < sql/library_db_complete.sql
```

The script creates the `library_db` database, all seven tables with constraints, inserts sample data
(3 publishers, 3 authors, 3 books, 2 members, 3 loans, 1 fine) and then runs queries Q1–Q31.

## Screenshots

Execution screenshots (Fig. 4.1–4.3, 7.1–7.4 in the report) go in `screenshots/`:

| Figure | What to capture |
|--------|-----------------|
| Fig. 7.1 | Successful creation of the database and tables |
| Fig. 7.2 | Sample data in the Book and Loan tables |
| Fig. 7.3 | Join query output — loan details with member and book (Q8) |
| Fig. 7.4 | Fine report — member-wise fine totals (Q13) and overdue loans (Q4) |

## Team

| S.No | Name | Roll No. | Responsibility |
|------|------|----------|----------------|
| 1 | B. Sai Akshath | 25B11AI151 | Team lead — database design, ER diagram, relational schema (Ch. 3) |
| 2 | B. Likhitha | 25B11AI097 | DDL implementation, constraints, normalization (Ch. 4) |
| 3 | R. Supriya | 25B11AIA30 | Sample data, DML/DQL, 31 SQL queries (Ch. 5) |
| 4 | K. Jahnavi | 25B11AI471 | Testing, validation, documentation and report compilation (Ch. 8–10) |

**Guide:** Mr. T. Srinivasulu, Assistant Professor, Department of AI & ML.
