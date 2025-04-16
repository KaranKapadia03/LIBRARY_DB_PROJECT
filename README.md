# Library Management System - SQL Project

This project is an SQL-based **Library Management System** that includes various operations such as CRUD operations, reporting queries, and complex analytical tasks. It showcases my skills in **SQL**, including joins, aggregates, ranking, and window functions.

---

## Features

- Create and manage books, members, and employees
- Track issued and returned books
- Generate performance reports for branches
- Identify overdue books and active members
- Calculate rental income based on book categories

---
## PROJECT SCHEMA

![Final Project Schema](https://github.com/KaranKapadia03/LIBRARY_DB_PROJECT/blob/main/Final%20Schema.png)



## SQL Queries Included

### TASK 1: Create a New Book Record
```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

###  TASK 2: Update an Existing Member's Address
```sql
UPDATE members
SET member_address='125 main st'
WHERE member_id='C101';
```
###  TASK 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
```sql
DELETE FROM issued_status
WHERE issued_id='IS121';
```
###  TASK 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'
```sql

SELECT issued_book_name FROM  issued_status
WHERE issued_emp_id='E101';

```
###  TASK 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
```sql

SELECT issued_member_id,COUNT(*)  FROM  issued_status
GROUP BY issued_member_id
HAVING COUNT(*) >1 
ORDER BY COUNT(*);

```
###  TASK 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
```sql
CREATE TABLE book_issued_cnt AS 
SELECT books.book_title,books.isbn ,COUNT(i.issued_book_name) FROM  issued_status AS i
Full OUTER  JOIN  books
ON i.issued_book_isbn = books.isbn
GROUP BY i.issued_book_name,books.isbn;
```
### Task 7: Retrieve All Books in a Specific Category:
```sql
SELECT * FROM books
WHERE category='Classic'
```

### Task 8: Find Total Rental Income by Category:
```sql
SELECT books.category,SUM(books.rental_price),COUNT(*) FROM issued_status AS i
LEFT JOIN  books
ON books.isbn=i.issued_book_isbn
GROUP BY books.category
```
### Task 9: RANK THE JOINING BASED ON THE YEAR AND CALSSIFY IT :
```sql
SELECT *,RANK() OVER(PARTITION BY EXTRACT (YEAR FROM REG_DATE) ORDER BY reg_date) FROM members;
```
### Task 10: List Employees with Their Branch Manager's Name and their branch details:
```sql
SELECT e1.emp_id,e1.emp_name,e1.position,e1.salary,b.*,e2.emp_name AS manager
FROM employees AS e1
JOIN 
branch AS b
ON e1.branch_id = b.branch_id    
JOIN
employees AS e2
ON e2.emp_id = b.manager_id
```
### Task 11: Create a Table of Books with Rental Price Above a Certain Threshold:
```sql

CREATE TABLE  expensive_books AS 
SELECT  * FROM books
WHERE rental_price > 6.5;
```
### Task 12: Retrieve the List of Books Not Yet Returned
```sql
SELECT issued_book_name,issued_date FROM issued_status AS i
FULL OUTER JOIN return_status AS r
ON i.issued_id =r.issued_id
WHERE return_date IS NULL
```
### Task 13: Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
```sql
SELECT ist.issued_book_name,ist.issued_date,m.member_id,m.member_name,(CURRENT_DATE-issued_date) AS overdue_days FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id=rs.issued_id
LEFT JOIN members AS m
ON m.member_id=ist.issued_member_id
WHERE rs.return_date IS NULL AND (CURRENT_DATE-issued_date)>30
```
### Task 14: Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
```sql
SELECT ist.issued_book_isbn,ist.issued_id,ist.issued_member_id,ist.issued_date,rs.return_date,b.* FROM issued_status AS ist
FULL OUTER JOIN return_status AS rs
ON ist.issued_id=rs.issued_id
LEFT JOIN books AS b
ON ist.issued_book_isbn=b.isbn
```

### Task 15: Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
```sql
CREATE TABLE branch_reports
AS
SELECT emp.branch_id,COUNT(ist.issued_id) AS issued_books ,COUNT(rs.return_date) AS return_date,SUM(b.rental_price) FROM  issued_status  AS ist
FULL OUTER JOIN return_status AS rs
ON rs.issued_id=ist.issued_id
FULL OUTER JOIN  employees AS emp
ON ist.issued_emp_id = emp.emp_id
FULL OUTER JOIN books AS b
ON b.isbn=ist.issued_book_isbn
GROUP BY emp.branch_id
HAVING emp.branch_id IS NOT NULL
ORDER BY emp.branch_id

```
### Task 16: Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 13 months.
```sql

CREATE TABLE active_members AS 
SELECT*,(CURRENT_DATE -ist.issued_date)  AS last_withdraw FROM members AS m
FULL OUTER JOIN issued_status AS ist
ON m.member_id=ist.issued_member_id
WHERE (ist.issued_date) >= (CURRENT_DATE - INTERVAL '13 months')

```
### Task 17: Find Employees with the Most Book Issues Processed
```sql
SELECT e.emp_name,ist.issued_emp_id,COUNT(ist.issued_emp_id) AS total_issues,DENSE_RANK() OVER(ORDER BY COUNT(ist.issued_emp_id) DESC ) FROM  issued_status AS ist
LEFT JOIN  employees AS e 
ON ist.issued_emp_id=e.emp_id
GROUP BY ist.issued_emp_id,e.emp_name
```





