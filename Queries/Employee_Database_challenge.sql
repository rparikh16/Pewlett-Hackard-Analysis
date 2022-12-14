-- Deliverable 1: 
-- The Number of Retiring Employees by Title.
SELECT 
	e.emp_no,
	e.first_name, 
	e.last_name, 
	t.title, 
	t.from_date, 
	t.to_date	
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
	
-- The Number of Retiring Employees by Title (No Duplicates).
SELECT DISTINCT ON (rt.emp_no) 
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

-- The number of employees by their most recent job title who are about to retire.
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;

-- Deliverable 2: 
-- The mentorship-eligibility table.
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no, de.to_date DESC;

-- Deliverable 3:
-- The number of employees by their most recent job title who eligible for the mentorship program.
SELECT COUNT(mt.title), mt.title
INTO mentorship_titles
FROM mentorship_eligibilty as mt
GROUP BY mt.title
ORDER BY count DESC;

-- Number of employees each mentor will have to train
SELECT ROUND((retiring_titles.count / mentorship_titles.count), 2) AS result, retiring_titles.title
INTO mentorship_count
FROM retiring_titles INNER JOIN mentorship_titles
ON retiring_titles.title = mentorship_titles.title
ORDER BY retiring_titles.title 