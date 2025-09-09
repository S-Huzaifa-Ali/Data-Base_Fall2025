-- Syed Huzaifa Ali
-- 23K-0004
-- DB Lab 02

-- Q1. Find the total salary of all employees.

SELECT SUM(salary) AS total_salary
FROM employees;

-- Q2. Find the average salary of employees.

SELECT AVG(salary) AS average_salary
FROM employees;

-- Q3. Count the number of employees reporting to each manager.

SELECT manager_id, COUNT(*) AS num_employees
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- Q4. Select * employees who has lowest salary.

SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- Q5. Display the current system date in the format DD-MM-YYYY.

SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS today
FROM dual;

-- Q6. Display the current system date with full day, month, and year (e.g., MONDAY AUGUST 2025).

SELECT TO_CHAR(SYSDATE, 'DAY MONTH YYYY') AS full_date
FROM dual;

-- Q7. Find all employees hired on a Wednesday.

SELECT *
FROM employees
WHERE TO_CHAR(hire_date, 'DAY') = 'WEDNESDAY';

-- Q8. Calculate months between 01-JAN-2025 and 01-OCT-2024.

SELECT MONTHS_BETWEEN(DATE '2025-01-01', DATE '2024-10-01') AS months_diff
FROM dual;

-- Q9. Find how many months each employee has worked in the company (using hire_date).

SELECT first_name, last_name,
       MONTHS_BETWEEN(SYSDATE, hire_date) AS months_worked
FROM employees;

-- Q10.Extract the first 5 characters from each employee’s last name.

SELECT last_name, SUBSTR(last_name, 1, 5) AS first_5_chars
FROM employees;


-- Q11. Pad employee first names with * on the left side to make them 15 characters wide.

SELECT LPAD(first_name, 15, '*') AS padded_name
FROM employees;

-- Q12. Remove leading spaces from ' Oracle'.

SELECT LTRIM(' Oracle') AS trimmed_string
FROM dual;

-- Q13. Display each employee’s name with the first letter capitalized.

SELECT INITCAP(first_name) AS formatted_first_name,
       INITCAP(last_name) AS formatted_last_name
FROM employees;

-- Q14. Find the next Monday after 20-AUG-2022.

SELECT NEXT_DAY(DATE '2022-08-20', 'MONDAY') AS next_monday
FROM dual;

-- Q15. Convert &#39;25-DEC-2023&#39; (string) to a date and display it in MM-YYYY format.

SELECT TO_CHAR(TO_DATE('25-DEC-2023', 'DD-MON-YYYY'), 'MM-YYYY') AS month_year
FROM dual;

-- Q16. Display all distinct salaries in ascending order.

SELECT DISTINCT salary
FROM employees
ORDER BY salary ASC;

-- Q17. Display the salary of each employee rounded to the nearest hundred.

SELECT first_name, last_name,
       ROUND(salary, -2) AS rounded_salary
FROM employees;

-- Q18. Find the department that has the maximum number of employees.

SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id
ORDER BY num_employees DESC
FETCH FIRST 1 ROW ONLY;

-- Q19. Find the top 3 highest-paid departments by total salary expense.

SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY total_salary DESC
FETCH FIRST 3 ROWS ONLY;

-- Q20. Find the department that has the maximum number of employees.

SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id
ORDER BY num_employees DESC
FETCH FIRST 1 ROW ONLY;
