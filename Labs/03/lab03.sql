-- Q1. Create employees table (referencing departments)
CREATE TABLE employees (
    emp_id     NUMBER PRIMARY KEY,
    emp_name   VARCHAR2(50),
    salary     NUMBER CHECK (salary > 20000),
    dept_id    NUMBER
);



-- Q4. Create departments table and insert 3 records
CREATE TABLE departments (
    dept_id   NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50) UNIQUE
);

INSERT INTO departments VALUES (10, 'HR');
INSERT INTO departments VALUES (20, 'IT');
INSERT INTO departments VALUES (30, 'Finance');



-- Q5. Add foreign key from employees.dept_id
ALTER TABLE employees
ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
REFERENCES departments(dept_id);



-- Q2. Rename emp_name to full_name
ALTER TABLE employees RENAME COLUMN emp_name TO full_name;



-- Q3. Drop check constraint on salary and insert employee with salary = 5000
ALTER TABLE employees DROP CONSTRAINT SYS_C00001;

INSERT INTO employees (emp_id, full_name, salary, dept_id)
VALUES (1, 'Ali Raza', 5000, 10);



-- Q6. Add bonus column with default 1000
ALTER TABLE employees
ADD bonus NUMBER(6,2) DEFAULT 1000;



-- Q7. Add city (default Karachi) and age (>18)
ALTER TABLE employees
ADD city VARCHAR2(50) DEFAULT 'Karachi';

ALTER TABLE employees
ADD age NUMBER CHECK (age > 18);



-- Q8. Delete records with id 1 and 3
DELETE FROM employees WHERE emp_id IN (1, 3);



-- Q9. Change length of full_name and city to 20
ALTER TABLE employees
MODIFY (full_name VARCHAR2(20), city VARCHAR2(20));



-- Q10. Add email column with UNIQUE constraint
ALTER TABLE employees
ADD email VARCHAR2(100) UNIQUE;



-- Q11. Unique constraint on bonus + test
ALTER TABLE employees
ADD CONSTRAINT unique_bonus UNIQUE (bonus);

INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus, age)
VALUES (2, 'Ahmed Khan', 30000, 10, 2000, 25);

INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus, age)
VALUES (3, 'Sara Ali', 35000, 20, 2000, 27);



-- Q12. Add dob column with 18+ constraint
ALTER TABLE employees
ADD dob DATE CHECK (dob <= ADD_MONTHS(SYSDATE, -12*18));



-- Q13. Insert invalid dob (<18 years old)
INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus, age, dob)
VALUES (4, 'Young Employee', 30000, 10, 3000, 19, TO_DATE('2020-01-01', 'YYYY-MM-DD'));



-- Q14. Drop foreign key, insert invalid dept, re-add
ALTER TABLE employees DROP CONSTRAINT fk_emp_dept;

INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus, age)
VALUES (5, 'Invalid Dept', 40000, 999, 4000, 25);

ALTER TABLE employees
ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
REFERENCES departments(dept_id);



-- Q15. Drop age and city columns
ALTER TABLE employees DROP COLUMN age;
ALTER TABLE employees DROP COLUMN city;



-- Q16. Display departments and their employees
SELECT d.dept_id, d.dept_name, e.emp_id, e.full_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id;



-- Q17. Rename salary to monthly_salary
ALTER TABLE employees RENAME COLUMN salary TO monthly_salary;



-- Q18. Departments with no employees
SELECT d.dept_id, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;



-- Q19. Truncate students table
TRUNCATE TABLE students;



-- Q20. Department with maximum number of employees
SELECT d.dept_id, d.dept_name, COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_employees DESC
FETCH FIRST 1 ROWS ONLY;
