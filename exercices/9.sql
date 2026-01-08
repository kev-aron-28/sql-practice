CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    department_id INT REFERENCES departments(id),
    name TEXT NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    hired_at DATE NOT NULL
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE project_assignments (
    employee_id INT REFERENCES employees(id),
    project_id INT REFERENCES projects(id),
    role TEXT NOT NULL,
    assigned_at DATE NOT NULL,
    PRIMARY KEY (employee_id, project_id)
);

CREATE TABLE time_logs (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    project_id INT REFERENCES projects(id),
    log_date DATE NOT NULL,
    hours_worked NUMERIC(4,2) CHECK (hours_worked > 0)
);

INSERT INTO departments (name) VALUES
('Engineering'), ('HR'), ('Sales');

INSERT INTO employees (department_id, name, salary, hired_at) VALUES
(1, 'Alice', 70000, '2020-01-15'),
(1, 'Bob', 90000, '2019-03-10'),
(1, 'Charlie', 85000, '2021-06-01'),
(2, 'Diana', 60000, '2018-09-20'),
(3, 'Eve', 75000, '2020-11-05');

INSERT INTO projects (name, start_date, end_date) VALUES
('ERP System', '2023-01-01', NULL),
('Website Redesign', '2022-05-01', '2023-02-01'),
('CRM Tool', '2023-03-01', NULL);

INSERT INTO project_assignments VALUES
(1, 1, 'Backend Dev', '2023-01-10'),
(2, 1, 'Tech Lead', '2023-01-05'),
(3, 3, 'Backend Dev', '2023-03-10'),
(1, 3, 'API Dev', '2023-03-15'),
(5, 2, 'Sales Liaison', '2022-05-10');

INSERT INTO time_logs (employee_id, project_id, log_date, hours_worked) VALUES
(1, 1, '2023-04-01', 6),
(1, 1, '2023-04-02', 7),
(2, 1, '2023-04-01', 8),
(3, 3, '2023-04-02', 5),
(1, 3, '2023-04-02', 4),
(5, 2, '2022-06-01', 3);


-- Employees working on more than one project
select name, count(*) as total from employees e left join project_assignments p on
e.id = p.employee_id
group by name
;

-- Total hours worked per employee per project
SELECT
    e.id AS employee_id,
    e.name AS employee,
    p.name AS project,
    COALESCE(SUM(t.hours_worked), 0) AS total_hours
FROM project_assignments pa
JOIN employees e
    ON e.id = pa.employee_id
JOIN projects p
    ON p.id = pa.project_id
LEFT JOIN time_logs t
    ON t.employee_id = e.id
   AND t.project_id = p.id
GROUP BY e.id, e.name, p.name
ORDER BY e.name, p.name;

-- Employees who never logged time
-- Employees who never logged time
select * from employees e left join time_logs ti
on e.id = ti.employee_id
where ti.id is NULL
;

-- Employees earning above department average salary

SELECT *
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

--   Projects with total logged hours greater than overall average hours per project