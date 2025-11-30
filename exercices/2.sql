create database company_db;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email VARCHAR(50) UNIQUE,
    salary NUMERIC(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE employees 
ADD COLUMN phone VARCHAR(20);

ALTER TABLE employees 
ALTER COLUMN first_name TYPE VARCHAR(100);

ALTER TABLE employees 
RENAME COLUMN salary TO monthly_salary;

ALTER TABLE employees 
DROP COLUMN last_name;

INSERT INTO employees (first_name, email, monthly_salary)
VALUES
('Ana', 'ana@mail.com', 15000.00),
('Luis', 'luis@mail.com', 18000.00),
('Mariana', 'mariana@mail.com', 22000.00),
('Jorge', 'jorge@mail.com', 20000.00);

select * from employees;
select first_name, monthly_salary from employees;
select * from employees where monthly_salary > 18000;
select * from employees order by salary asc;

select avg(monthly_salary) from employees;

select * from employees order by monthly_salary desc limit 1;

select count(*) from employees where monthly_salary > 15000 and monthly_salary < 20000;

select * from employees where first_name like '%M'


CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

ALTER TABLE employees
ADD COLUMN department_id INTEGER;

ALTER TABLE employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id)
REFERENCES departments(id);

insert into departments (name, location) values 
('Ventas', 'CDMX'),
('Soporte', 'Monterrey'),
('Sistemas', 'Guadalajara');

UPDATE employees
SET department_id = 1
WHERE first_name = 'Ana';

UPDATE employees
SET department_id = 3
WHERE first_name = 'Luis';

