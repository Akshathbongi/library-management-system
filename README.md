# Library Management System

DBMS Capstone Project (course 2501IT05) — a relational database for managing books, authors, publishers,
members, book loans and fines in a library.

## Team Members

1. B. Sai Akshath — 25B11AI151 — Akshathbongi
2. B. Likhitha — 25B11AI097 — likhitha-0418
3. R. Supriya — 25B11AIA30 — rekamandasupriya
4. K. Jahnavi — 25B11AI471 — jahnavi0999

**Guide:** Mr. T. Srinivasulu, Assistant Professor, Department of AI & ML, Aditya University (2026–2027).

## Project Description

A Library Management System built on MySQL 8.0. Six entities are modelled as seven tables —
`Publisher`, `Book`, `Author`, `Book_Author` (junction for the M:N Book–Author relationship),
`Member`, `Loan`, `Fine` — normalised to 3NF with primary keys, foreign keys, `UNIQUE`, `NOT NULL`,
`CHECK` and `DEFAULT` constraints. The project includes 31 SQL queries covering DQL, joins, aggregate
functions, subqueries, views, set operations, DCL and TCL.

## Technologies Used

- DBMS
- SQL
- MySQL 8.0 (MySQL Workbench)

## Main Modules

- Book Management
- Author Management
- Publisher Management
- Member Management
- Loan Management
- Fine Management

## Team Responsibilities

| Student Name | GitHub Username | Responsibility | Main Files | Status |
|---|---|---|---|---|
| B. Sai Akshath | Akshathbongi | ER Diagram & Relational Schema | diagrams/er-diagram.png | Completed |
| B. Likhitha | likhitha-0418 | DDL, Tables, Keys & Constraints | sql/ddl.sql | Pending |
| R. Supriya | rekamandasupriya | DML, CRUD, JOIN & Aggregate Queries | sql/dml.sql, sql/queries.sql | Pending |
| K. Jahnavi | jahnavi0999 | Documentation & Screenshots | docs/, screenshots/ | Pending |

> Every member commits their own work using their own GitHub account. Do not upload another
> member's work from your account — the faculty verifies individual participation from the
> commit history and the Contributors page.

## Repository

https://github.com/Akshathbongi/library-management-system

## How each member uploads their work (GitHub website method)

1. Log in using **your own** GitHub account and open the repository.
2. Open the folder your file belongs in (e.g. `sql`).
3. Click **Add file → Upload files** and select only the files you created.
4. Write a meaningful commit message (e.g. `Add DDL tables and constraints`) and click **Commit changes**.
5. Check the commit history and confirm your GitHub account is shown as the contributor.
