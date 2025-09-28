-- CREATING TABLES
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR2(50)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR2(50),
    salary NUMBER(10,2),
    dept_id INT,
    manager_id INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR2(50)
);

CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT,
    PRIMARY KEY(emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR2(50),
    city VARCHAR2(50)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR2(50)
);

CREATE TABLE Enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR2(50),
    city VARCHAR2(50)
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR2(50)
);

CREATE TABLE Teacher_Subject (
    teacher_id INT,
    subject_id INT,
    PRIMARY KEY(teacher_id, subject_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR2(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Student_Course_Teacher (
    student_id INT,
    course_id INT,
    teacher_id INT,
    PRIMARY KEY(student_id, course_id, teacher_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

INSERT INTO Departments VALUES (1, 'HR');
INSERT INTO Departments VALUES (2, 'IT');
INSERT INTO Departments VALUES (3, 'Finance');

INSERT INTO Employees VALUES (101, 'Ali', 60000, 2, NULL, TO_DATE('2021-05-10','YYYY-MM-DD'));
INSERT INTO Employees VALUES (102, 'Sara', 55000, 2, 101, TO_DATE('2022-03-15','YYYY-MM-DD'));
INSERT INTO Employees VALUES (103, 'Bilal', 40000, 1, 101, TO_DATE('2019-01-01','YYYY-MM-DD'));
INSERT INTO Employees VALUES (104, 'Hina', 75000, 3, NULL, TO_DATE('2020-07-01','YYYY-MM-DD'));

INSERT INTO Projects VALUES (1, 'Website');
INSERT INTO Projects VALUES (2, 'Payroll');

INSERT INTO Employee_Project VALUES (101, 1);
INSERT INTO Employee_Project VALUES (102, 1);
INSERT INTO Employee_Project VALUES (104, 2);

INSERT INTO Students VALUES (201, 'Ahmad', 'Lahore');
INSERT INTO Students VALUES (202, 'Ayesha', 'Karachi');
INSERT INTO Students VALUES (203, 'Usman', 'Lahore');

INSERT INTO Courses VALUES (301, 'DBMS');
INSERT INTO Courses VALUES (302, 'Networks');
INSERT INTO Courses VALUES (303, 'AI');

INSERT INTO Enrollments VALUES (201, 301);
INSERT INTO Enrollments VALUES (201, 303);
INSERT INTO Enrollments VALUES (202, 302);
INSERT INTO Enrollments VALUES (203, 301);

INSERT INTO Teachers VALUES (401, 'Sir Ali', 'Lahore');
INSERT INTO Teachers VALUES (402, 'Sir Bilal', 'Karachi');

INSERT INTO Subjects VALUES (501, 'DBMS');
INSERT INTO Subjects VALUES (502, 'Networks');
INSERT INTO Subjects VALUES (503, 'AI');

INSERT INTO Teacher_Subject VALUES (401, 501);
INSERT INTO Teacher_Subject VALUES (402, 502);

INSERT INTO Customers VALUES (601, 'Customer A');
INSERT INTO Customers VALUES (602, 'Customer B');

INSERT INTO Orders VALUES (701, 601, TO_DATE('2023-01-01','YYYY-MM-DD'));

INSERT INTO Student_Course_Teacher VALUES (201, 301, 401);
INSERT INTO Student_Course_Teacher VALUES (202, 302, 402);
INSERT INTO Student_Course_Teacher VALUES (203, 301, 401);



-- Q1. All possible pairs of employees and departments
SELECT * 
FROM Employees
CROSS JOIN Departments;



-- Q2. Show all departments and employees, even if no employees are assigned
SELECT d.dept_id, d.dept_name, e.emp_id, e.emp_name
FROM Departments d
FULL JOIN Employees e
ON d.dept_id = e.dept_id;



-- Q3. Employee names with their manager names
SELECT e.emp_name AS employee, m.emp_name AS manager
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id;



-- Q4. Employees with no project
SELECT e.emp_id, e.emp_name
FROM Employees e
LEFT JOIN Employee_Project ep ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;



-- Q5. Student names with their enrolled course names
SELECT s.student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;



-- Q6. All customers with their orders (even if none)
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;



-- Q7. All departments and employees, even if dept has no employees
SELECT d.dept_id, d.dept_name, e.emp_id, e.emp_name
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id;



-- Q8. All pairs of teachers and subjects
SELECT t.teacher_name, s.subject_name
FROM Teachers t
CROSS JOIN Subjects s;



-- Q9. All departments with total employees
SELECT d.dept_id, d.dept_name, COUNT(e.emp_id) AS total_employees
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;



-- Q10. Each student, their course, and their teacher
SELECT s.student_name, c.course_name, t.teacher_name
FROM Student_Course_Teacher sct
JOIN Students s ON sct.student_id = s.student_id
JOIN Courses c ON sct.course_id = c.course_id
JOIN Teachers t ON sct.teacher_id = t.teacher_id;



-- Q11. Students and teachers where student city = teacher city
SELECT s.student_name, t.teacher_name
FROM Students s
JOIN Teachers t ON s.city = t.city;



-- Q12. All employees and their manager names, include employees without managers
SELECT e.emp_name AS employee, m.emp_name AS manager
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id;



-- Q13. Employees who don’t belong to any department
SELECT e.emp_id, e.emp_name
FROM Employees e
LEFT JOIN Departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;



-- Q14. Average salary of employees in each department; avg > 50,000
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM Departments d
JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 50000;



-- Q15. Employees earning more than their department's average
SELECT e.emp_id, e.emp_name, e.salary, e.dept_id
FROM Employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);



-- Q16. Departments where no employee earns less than 30,000
SELECT d.dept_id, d.dept_name
FROM Departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.dept_id = d.dept_id AND e.salary < 30000
);



-- Q17. Students and their courses where city = 'Lahore'
SELECT s.student_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.city = 'Lahore';



-- Q18. Employees with their manager and department where hire_date between 2020-01-01 and 2023-01-01
SELECT e.emp_name AS employee, m.emp_name AS manager, d.dept_name
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id
LEFT JOIN Departments d ON e.dept_id = d.dept_id
WHERE e.hire_date BETWEEN TO_DATE('2020-01-01','YYYY-MM-DD') AND TO_DATE('2023-01-01','YYYY-MM-DD');



-- Q19. Students enrolled in courses taught by 'Sir Ali'
SELECT DISTINCT s.student_name
FROM Students s
JOIN Student_Course_Teacher sct ON s.student_id = sct.student_id
JOIN Teachers t ON sct.teacher_id = t.teacher_id
WHERE t.teacher_name = 'Sir Ali';



-- Q20. Employees whose manager is from the same department
SELECT e.emp_id, e.emp_name, e.dept_id
FROM Employees e
JOIN Employees m ON e.manager_id = m.emp_id
WHERE e.dept_id = m.dept_id;
