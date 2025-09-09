-- Syed Huzaifa Ali
-- 23K-0004
-- DB Lab 01


-- Q1. Write a SQL query to retrieve employees who are not in department 100.

SELECT *
FROM employees
WHERE department_id <> 100;

-- Q2. Write a SQL query to retrieve whose salary is either 10000 , 12000 or 15000.

SELECT *
FROM employees
WHERE salary IN (10000, 12000, 15000);

-- Q3. Write a SQL query to display the first name and salary of employees whose salary is less than OR equal to 25000.

SELECT first_name, salary
FROM employees
WHERE salary <= 25000;

-- Q4. Write a SQL query to retrieve employees who are not in department 60.

SELECT *
FROM employees
WHERE department_id <> 60;

-- Q5. Write a SQL query retrieve employees who are in between department 60 to 80.

SELECT *
FROM employees
WHERE department_id BETWEEN 60 AND 80;

-- Q6. Display all details of departments.

SELECT *
FROM departments;

-- Q7. Retrieve employees whose first name is 'Steven'.

SELECT *
FROM employees
WHERE first_name = 'Steven';

-- Q8. Display employees who earn between 15000 and 25000 and work in department 80.

SELECT *
FROM employees
WHERE salary BETWEEN 15000 AND 25000
  AND department_id = 80;

-- Q9. Display employees who earn less than the salary of any employee in department 100.

SELECT *
FROM employees
WHERE salary < ANY (SELECT salary
                    FROM employees
                    WHERE department_id = 100);
                    
-- Q10. Display employees whose department ID is unique in the employees table.

SELECT *
FROM employees e
WHERE department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) = 1
);


-- Q11. Retrieve employees hired between 01-JAN-05 and 31-DEC-06.

SELECT *
FROM employees
WHERE hire_date BETWEEN DATE '2005-01-01' AND DATE '2006-12-31';

-- Q12. Retrieve employees who do not have a manager.

SELECT *
FROM employees
WHERE manager_id IS NULL;

-- Q13. Retrieve employees whose salary is less than all employees earning more than 8000.

SELECT *
FROM employees
WHERE salary < ALL (SELECT salary
                    FROM employees
                    WHERE salary > 8000);

-- Q14. Retrieve employees whose salary is greater than any salary in department 90.

SELECT *
FROM employees
WHERE salary > ANY (SELECT salary
                    FROM employees
                    WHERE department_id = 90);

-- Q15. Retrieve departments that have at least one employee.

SELECT *
FROM departments d
WHERE EXISTS (SELECT 1
              FROM employees e
              WHERE e.department_id = d.department_id);

-- Q16. Retrieve departments that do not have any employee.

SELECT *
FROM departments d
WHERE NOT EXISTS (SELECT 1
                  FROM employees e
                  WHERE e.department_id = d.department_id);

-- Q17. Retrieve employees whose salary is not between 5000 and 15000.

SELECT *
FROM employees
WHERE salary NOT BETWEEN 5000 AND 15000;

-- Q18. Retrieve employees who are in departments 10, 20, or 30, but not 40.

SELECT *
FROM employees
WHERE department_id IN (10, 20, 30)
  AND department_id <> 40;

-- Q19. Display employees whose salary is less than the minimum salary of department 50.

SELECT *
FROM employees
WHERE salary < (SELECT MIN(salary)
                FROM employees
                WHERE department_id = 50);

-- Q20. Display employees whose salary is greater than the maximum salary of department 90.

SELECT *
FROM employees
WHERE salary > (SELECT MAX(salary)
                FROM employees
                WHERE department_id = 90);
