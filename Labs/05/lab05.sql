-- Departments
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Employees
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

delete table employees

-- Projects
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50)
);

-- Employee_Project (Many-to-Many)
CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT,
    PRIMARY KEY(emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

-- Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

-- Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Enrollments (Student-Course Many-to-Many)
CREATE TABLE Enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Teachers
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(50)
);

-- Subjects
CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(50)
);

-- Teacher_Subject (Many-to-Many)
CREATE TABLE Teacher_Subject (
    teacher_id INT,
    subject_id INT,
    PRIMARY KEY(teacher_id, subject_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id),
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Student-Course-Teacher mapping
CREATE TABLE Student_Course_Teacher (
    student_id INT,
    course_id INT,
    teacher_id INT,
    PRIMARY KEY(student_id, course_id, teacher_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);




-- q1
select *
from employees
cross join departments;

-- q2
select d.dept_id, d.dept_name, e.emp_id, e.emp_name
from departments d
full join employees e
on d.dept_id = e.dept_id;

-- q3
select e.emp_name as employee, m.emp_name as manager
from employees e
left join employees m
on e.manager_id = m.emp_id;

-- q4
select e.emp_id, e.emp_name
from employees e
left join employee_project ep
on e.emp_id = ep.emp_id
where ep.project_id is null;

-- q5
select s.student_name, c.course_name
from students s
join enrollments e
on s.student_id = e.student_id
join courses c
on e.course_id = c.course_id;

-- q6
select c.customer_id, c.customer_name, o.order_id, o.order_date
from customers c
left join orders o
on c.customer_id = o.customer_id;

-- q7
select d.dept_id, d.dept_name, e.emp_id, e.emp_name
from departments d
left join employees e
on d.dept_id = e.dept_id;

-- q8
select t.teacher_name, s.subject_name
from teachers t
cross join subjects s;

-- q9
select d.dept_id, d.dept_name, count(e.emp_id) as total_employees
from departments d
left join employees e
on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name;

-- q10
select s.student_name, c.course_name, t.teacher_name
from student_course_teacher sct
join students s
on sct.student_id = s.student_id
join courses c
on sct.course_id = c.course_id
join teachers t
on sct.teacher_id = t.teacher_id;