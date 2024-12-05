-- Create Departments table.
CREATE TABLE departments (
    dept_no VARCHAR(5) PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);


-- Create Titles table.
CREATE TABLE titles (
    title_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(100) NOT NULL UNIQUE
);


-- Create Employees table.
CREATE TABLE employees (
    emp_no INTEGER PRIMARY KEY,
    emp_title_id VARCHAR(5) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    sex CHAR(1) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) 
		REFERENCES Titles(title_id)
);


-- Create Salaries table.
CREATE TABLE salaries (
    emp_no INTEGER NOT NULL,
    salary INTEGER NOT NULL CHECK (salary > 0),
    PRIMARY KEY (emp_no),
    FOREIGN KEY (emp_no) 
		REFERENCES Employees(emp_no)
);


-- Create Department Employees table.
CREATE TABLE dept_emp (
    emp_no INTEGER NOT NULL,
    dept_no VARCHAR(5) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) 
		REFERENCES Employees(emp_no),
    FOREIGN KEY (dept_no) 
		REFERENCES Departments(dept_no)
);

-- Create Department Managers table
CREATE TABLE Dept_Manager (
    dept_no VARCHAR(5) NOT NULL,
    emp_no INTEGER NOT NULL,
    PRIMARY KEY (dept_no, emp_no),
    FOREIGN KEY (dept_no) 
		REFERENCES Departments(dept_no),
    FOREIGN KEY (emp_no) 
		REFERENCES Employees(emp_no)
);


-- FOR CONVENIENCE VIEWING CSV DATA:

SELECT * FROM departments
-- Denote as "d".

SELECT * FROM dept_emp
-- Denote as "de".

SELECT * FROM dept_manager
-- Denote as "dm".

SELECT * FROM employees
-- Denote as "e".

SELECT * FROM salaries
-- Denote as "s".

SELECT * FROM titles
-- Denote as "t".


-- DATA ANALYSIS:

-- 1) List the employee number, last name, first name, sex, and salary of each employee.
-- Denote Employees table as "e".
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
;


-- 2) List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date::TEXT LIKE '1986%'
;


-- 3) List the manager of each department along with their department number, department name, employee number, last name, and first name.
-- Denote Dept_Manager table as dm; Departments as d; Employees as "e".
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM dept_manager dm
JOIN departments d ON dm.dept_no = d.dept_no
JOIN employees e ON dm.emp_no = e.emp_no
;


-- 4) List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
-- Denote Det_Emp table as "de"; Employees as "e"; Departments as "d".
SELECT de.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp de
JOIN employees e ON de.emp_no = e.emp_no
JOIN departments d ON de.dept_no = d.dept_no
;


-- 5) List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
-- Hint: Use LIKE %
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' 
AND last_name LIKE 'B%'
;


-- 6) List each employee in the Sales department, including their employee number, last name, and first name.
-- Denote Det_Emp table as "de"; Employees as "e"; Departments as "d".
-- Hint: Capitalization matters for data.
SELECT e.emp_no, e.last_name, e.first_name
FROM dept_emp de
JOIN employees e ON de.emp_no = e.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
;


-- 7) List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
-- Denote Det_Emp table as "de"; Employees as "e"; Departments as "d".
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM Dept_Emp de
JOIN Employees e ON de.emp_no = e.emp_no
JOIN Departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development')
;


-- 8) List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC
;
