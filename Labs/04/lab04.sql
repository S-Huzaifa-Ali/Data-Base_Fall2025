
-- CREATING ALL THE TABLES
CREATE TABLE departments (
    dept_id    NUMBER PRIMARY KEY,
    dept_name  VARCHAR2(50) UNIQUE
);

CREATE TABLE faculty (
    faculty_id   NUMBER PRIMARY KEY,
    name         VARCHAR2(50),
    dept_id      NUMBER REFERENCES departments(dept_id),
    salary       NUMBER,
    joining_date DATE
);

CREATE TABLE courses (
    course_id   NUMBER PRIMARY KEY,
    course_name VARCHAR2(50),
    dept_id     NUMBER REFERENCES departments(dept_id),
    faculty_id  NUMBER REFERENCES faculty(faculty_id)
);

CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    name       VARCHAR2(50),
    dept_id    NUMBER REFERENCES departments(dept_id),
    gpa        NUMBER(3,2),
    fee        NUMBER
);

CREATE TABLE enrollments (
    student_id NUMBER REFERENCES students(student_id),
    course_id  NUMBER REFERENCES courses(course_id)
);

INSERT INTO departments VALUES (1, 'CS');
INSERT INTO departments VALUES (2, 'Math');
INSERT INTO departments VALUES (3, 'Physics');

INSERT INTO faculty VALUES (101, 'Dr. Khan', 1, 120000, TO_DATE('2010-01-01','YYYY-MM-DD'));
INSERT INTO faculty VALUES (102, 'Dr. Ali', 2, 95000, TO_DATE('2015-03-15','YYYY-MM-DD'));
INSERT INTO faculty VALUES (103, 'Dr. Sara', 3, 150000, TO_DATE('2005-06-10','YYYY-MM-DD'));

INSERT INTO courses VALUES (201, 'DB Systems', 1, 101);
INSERT INTO courses VALUES (202, 'Calculus', 2, 102);
INSERT INTO courses VALUES (203, 'Quantum', 3, 103);
INSERT INTO courses VALUES (204, 'AI', 1, 101);

INSERT INTO students VALUES (301, 'Ali', 1, 3.8, 500000);
INSERT INTO students VALUES (302, 'Sara', 1, 3.2, 300000);
INSERT INTO students VALUES (303, 'Bilal', 2, 2.9, 200000);
INSERT INTO students VALUES (304, 'Hina', 3, 3.6, 450000);
INSERT INTO students VALUES (305, 'Usman', 1, 3.9, 600000);

INSERT INTO enrollments VALUES (301, 201);
INSERT INTO enrollments VALUES (301, 204);
INSERT INTO enrollments VALUES (302, 201);
INSERT INTO enrollments VALUES (303, 202);
INSERT INTO enrollments VALUES (304, 203);
INSERT INTO enrollments VALUES (305, 201);
INSERT INTO enrollments VALUES (305, 204);



-- Q1. List each department and the number of students in it.
SELECT d.dept_name, COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;



-- Q2. Find departments where the average GPA of students is greater than 3.0.
SELECT d.dept_name, AVG(s.gpa) AS avg_gpa
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING AVG(s.gpa) > 3.0;



-- Q3. Display the average fee paid by students grouped by course.
SELECT c.course_name, AVG(s.fee) AS avg_fee
FROM courses c
JOIN students s ON c.dept_id = s.dept_id
GROUP BY c.course_name;



-- Q4. Count how many faculty members are assigned to each department.
SELECT d.dept_name, COUNT(f.faculty_id) AS faculty_count
FROM departments d
LEFT JOIN faculty f ON d.dept_id = f.dept_id
GROUP BY d.dept_name;



-- Q5. Find faculty members whose salary is higher than the average salary.
SELECT *
FROM faculty
WHERE salary > (SELECT AVG(salary) FROM faculty);



-- Q6. Show students whose GPA is higher than at least one student in the CS department.
SELECT *
FROM students
WHERE gpa > (
    SELECT MIN(gpa)
    FROM students
    WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'CS')
);



-- Q7. Display the top 3 students with the highest GPA.
SELECT * FROM (
    SELECT student_id, name, gpa
    FROM students
    ORDER BY gpa DESC
)
WHERE ROWNUM <= 3;



-- Q8. Find students enrolled in all the courses that student Ali is enrolled in.
SELECT s.student_id, s.name
FROM students s
WHERE NOT EXISTS (
    SELECT c.course_id
    FROM enrollments c
    WHERE c.student_id = (SELECT student_id FROM students WHERE name = 'Ali')
    MINUS
    SELECT e.course_id
    FROM enrollments e
    WHERE e.student_id = s.student_id
);



-- Q9. Show the total fees collected per department.
SELECT d.dept_name, SUM(s.fee) AS total_fees
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;



-- Q10. Display courses taken by students who have GPA above 3.5.
SELECT DISTINCT c.course_name
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
WHERE s.gpa > 3.5;



-- Q11. Show departments where total fees collected exceed 1 million.
SELECT d.dept_name, SUM(s.fee) AS total_fees
FROM departments d
JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING SUM(s.fee) > 1000000;



-- Q12. Display faculty departments where more than 5 faculty members earn above 100,000.
SELECT d.dept_name, COUNT(f.faculty_id) AS high_salary_count
FROM departments d
JOIN faculty f ON d.dept_id = f.dept_id
WHERE f.salary > 100000
GROUP BY d.dept_name
HAVING COUNT(f.faculty_id) > 5;



-- Q13. Delete all students whose GPA is below the overall average GPA.
DELETE FROM students
WHERE gpa < (SELECT AVG(gpa) FROM students);

Q14. Delete courses that have no students enrolled.
DELETE FROM courses c
WHERE NOT EXISTS (
    SELECT 1 FROM enrollments e
    WHERE e.course_id = c.course_id
);



-- Q15. Copy students who paid more than the average fee into HighFee_Students.
CREATE TABLE HighFee_Students AS
SELECT *
FROM students
WHERE fee > (SELECT AVG(fee) FROM students);



-- Q16. Insert faculty into Retired_Faculty if their joining date is earlier than the minimum joining date.
INSERT INTO Retired_Faculty
SELECT *
FROM faculty
WHERE joining_date = (SELECT MIN(joining_date) FROM faculty);



-- Q17. Find the department having the maximum total fee collected.
SELECT dept_name, total_fees FROM (
    SELECT d.dept_name, SUM(s.fee) AS total_fees
    FROM departments d
    JOIN students s ON d.dept_id = s.dept_id
    GROUP BY d.dept_name
    ORDER BY total_fees DESC
)
WHERE ROWNUM = 1;



-- Q18. Top 3 courses with highest enrollments using ROWNUM.
SELECT * FROM (
    SELECT c.course_id, c.course_name, COUNT(e.student_id) AS total_enrolled
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name
    ORDER BY total_enrolled DESC
)
WHERE ROWNUM <= 3;



-- Q19. Students enrolled in more than 3 courses and GPA greater than overall average.
SELECT s.student_id, s.name, s.gpa, COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name, s.gpa
HAVING COUNT(e.course_id) > 3
   AND s.gpa > (SELECT AVG(gpa) FROM students);



-- Q20. Find faculty who do not teach any course and insert them into Unassigned_Faculty.
INSERT INTO Unassigned_Faculty
SELECT f.*
FROM faculty f
WHERE NOT EXISTS (
    SELECT 1
    FROM courses c
    WHERE c.faculty_id = f.faculty_id
);
