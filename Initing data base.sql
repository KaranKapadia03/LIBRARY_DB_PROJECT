-- CREATING BARANCH TABLE 
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
	branch_id varchar(10) PRIMARY KEY,
	manager_id varchar(10),
	branch_address varchar(55),
	contact_no varchar(10)
);
ALTER TABLE branch
ALTER COLUMN contact_no TYPE varchar(33);-- SOME ENTRIES ARE +91 AND MOBILE NO , SO THE LIMIT WILL EXCEED 

-- CREATING EMPLOYEES TABLE
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
	emp_id varchar(10) PRIMARY KEY,
	emp_name varchar(25),
	position varchar(15),
	salary float,
	branch_id varchar(25)
);
--CREATING BOOKS TABLE
DROP TABLE IF EXISTS books;
CREATE TABLE books(
	isbn varchar (20) PRIMARY KEY,
	book_title varchar(75),
	category varchar(10),
	rental_price float,
	status varchar(15),
	author varchar(35),
	publisher varchar(55)
);
ALTER TABLE books
ALTER COLUMN category type varchar(33);--BECAUSE THERE IS AN ENTRY "LITERALLY BOOKS" JE LIMIT BAHAR JASE 
--CREATING MEMEBERS TABLE
DROP TABLE IF EXISTS members;
CREATE TABLE members(
	member_id varchar(10) PRIMARY KEY,
	member_name varchar(25),
	member_address varchar(75),	
	reg_date DATE
);
--CREATING issued status TABLE
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
	issued_id varchar(10) PRIMARY KEY,
	issued_member_id varchar(10),
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(25),
	issued_emp_id VARCHAR(10)

);

--CREATING RETURNED STATUS TABLE
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
	return_id varchar(10) PRIMARY KEY,
	issued_id varchar(10),
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20)
);



--Adding Foreign KEYS
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN Key (issued_member_id) REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN Key (issued_book_isbn) REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN Key (issued_emp_id) REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN Key (branch_id) REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN Key (issued_id) REFERENCES issued_status(issued_id);



