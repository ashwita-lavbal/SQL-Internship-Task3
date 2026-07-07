1. INNER JOIN: Employee-Department Mapping

SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS name, d.dept_name FROM employees e INNER JOIN dept_emp de ON 
e.emp_no = de.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE de.to_date > CURDATE() LIMIT 5;

2. LEFT JOIN: Employees with Manager Info

SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS employee, CONCAT(m.first_name, ' ', m.last_name) AS manager
FROM employees e LEFT JOIN dept_manager dm ON dm.dept_no = (SELECT dept_no FROM dept_emp WHERE emp_no = e.emp_no AND 
to_date > CURDATE()) LEFT JOIN employees m ON dm.emp_no = m.emp_no WHERE dm.to_date > CURDATE() LIMIT 5;

3. UNION: Combine Active/Former Employees

SELECT emp_no, 'Active' AS status, dept_name FROM dept_emp de JOIN departments d ON de.dept_no = d.dept_no 
WHERE de.to_date > CURDATE() AND d.dept_name = 'Sales' 
UNION ALL
SELECT emp_no, 'Former' AS status, dept_name FROM dept_emp de JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date <= CURDATE() AND d.dept_name = 'Sales' LIMIT 5;

4. Correlated Subquery: Current Salary

SELECT e.emp_no, e.first_name, (SELECT salary FROM salaries s WHERE s.emp_no = e.emp_no AND s.to_date > CURDATE()) AS 
current_salary FROM employees e WHERE e.emp_no BETWEEN 10001 AND 10010;

5. Duplicate Handling: Unique Job Titles

SELECT DISTINCT title AS unique_titles FROM titles t WHERE t.to_date > CURDATE();

6. Department Gender Ratios

SELECT d.dept_name, ROUND(100 * SUM(IF(e.gender = 'F', 1, 0)) / COUNT(*), 1) AS female_pct, 
ROUND(100 * SUM(IF(e.gender = 'M', 1, 0)) / COUNT(*), 1) AS male_pct FROM departments d JOIN dept_emp de 
ON d.dept_no = de.dept_no JOIN employees e ON de.emp_no = e.emp_no WHERE de.to_date > CURDATE() GROUP BY d.dept_name
HAVING COUNT(*) > 1000;

7. Join Performance Optimization

CREATE INDEX idx_emp ON salaries (emp_no, salary, to_date);

EXPLAIN ANALYZE
SELECT e.emp_no, MAX(s.salary) AS max_salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no GROUP BY e.emp_no
LIMIT 10;