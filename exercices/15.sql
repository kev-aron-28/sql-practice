CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    department_id INT REFERENCES departments(id),
    hire_date DATE NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    sale_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL
);

INSERT INTO departments (name) VALUES
('Engineering'),
('Sales'),
('Marketing'),
('HR');

INSERT INTO employees
(full_name, department_id, hire_date, salary)
VALUES
('Alice', 1, '2020-01-10', 80000),
('Bob', 1, '2021-03-15', 85000),
('Charlie', 1, '2019-08-20', 95000),

('David', 2, '2020-06-01', 60000),
('Emma', 2, '2021-07-12', 62000),
('Frank', 2, '2018-11-30', 70000),

('Grace', 3, '2022-02-14', 55000),
('Helen', 3, '2019-04-25', 72000),

('Ian', 4, '2021-09-01', 50000),
('Julia', 4, '2017-12-11', 68000);

INSERT INTO sales
(employee_id, sale_date, amount)
VALUES

(4,'2024-01-01',1000),
(4,'2024-01-05',1500),
(4,'2024-01-08',2000),
(4,'2024-01-10',1200),

(5,'2024-01-02',3000),
(5,'2024-01-06',1800),
(5,'2024-01-11',2500),

(6,'2024-01-01',4000),
(6,'2024-01-03',2200),
(6,'2024-01-08',3500),
(6,'2024-01-12',1800),

(4,'2024-02-01',2200),
(4,'2024-02-05',1800),

(5,'2024-02-03',3200),
(5,'2024-02-06',2600),

(6,'2024-02-01',4200),
(6,'2024-02-07',2800);



-- Obtén todos los empleados junto con un número consecutivo basado en salario descendente.
select 
	row_number() over (order by salary desc) as rnk,
	full_name,
	salary
from employees;

--- Obtén el ranking salarial global utilizando RANK().
select 
	full_name,
	salary,
	rank() over (order by salary desc)
from employees

-- Obtén el ranking salarial global utilizando DENSE_RANK().
select 
	full_name,
	salary,
	DENSE_RANK() over (order by salary desc)
from employees

-- Obtén el ranking salarial dentro de cada departamento.
select 
	e.full_name,
	e.salary,
	d."name",
	DENSE_RANK() over(PARTITION BY d.id order by e.salary desc)
from employees e join departments d on e.department_id = d.id

-- Muestra únicamente el empleado mejor pagado de cada departamento.

with ranking as (
select 
	e.full_name,
	e.salary,
	d."name",
	DENSE_RANK() over(PARTITION BY d.id order by e.salary desc) as rnk
from employees e join departments d on e.department_id = d.id
)

select * from ranking where rnk = 1

-- Para cada empleado muestra:nombre, salariom, salario, promedio, global
select 
	full_name,
	salary,
	avg(salary) over ()
from employees

-- Para cada empleado muestra: salario, salario máximo global
select
	full_name,
	salary,
	max(salary) over()
from employees

-- Para cada empleado muestra: salario salario promedio de su departamento
select 
	e.full_name,
	d."name",
	e.salary,
	avg(salary) over(PARTITION by d.id)
from employees e join departments d on e.department_id = d.id

-- Para cada empleado muestra cuánto se desvía su salario del promedio de su departamento.
SELECT
    full_name,
    salary,
    AVG(salary) OVER (
        PARTITION BY department_id
    ) AS department_avg,
    salary - AVG(salary) OVER (
        PARTITION BY department_id
    ) AS deviation
FROM employees;

-- Para cada empleado muestra qué porcentaje representa su salario respecto al total de salarios de la empresa.
select 
	full_name,
	salary,
	sum(salary) over () as total,
	salary * 100 / sum(salary) over () as per
from employees

-- Muestra las ventas ordenadas por fecha junto con el acumulado global.
select 
	sale_date,
	amount,
	sum(amount) over()
from sales
order by sale_date

-- Muestra las ventas acumuladas por vendedor.
select 
	sale_date,
	amount,
	employee_id,
	sum(amount) over(partition by employee_id order by employee_id)
from sales


-- Encuentra la primera fecha donde Frank superó $10,000 acumulados.
with runnig_total as (
SELECT
	sale_date,
	amount,
	sum(amount) over (order by sale_date) as acc
FROM sales
where employee_id = 6
)

select * from runnig_total
where acc > 10000
order by sale_date
limit 1

-- Para cada venta muestra la venta inmediatamente anterior.
select 
	sale_date,
	amount,
	lag(amount) over(order by sale_date) as prev_sale 
from sales 

-- Calcula la diferencia entre cada venta y la anterior.
select 
	sale_date,
	amount,
	lag(amount) over (order by sale_date asc)
from sales

-- Muestra la siguiente venta de cada vendedor.
select 
	employee_id,
	sale_date,
	amount,
	lead(amount) over(partition by employee_id order by sale_date) as prev_sale
from sales 

-- Para cada venta muestra la primera venta realizada por ese empleado.
select 
	employee_id,
	sale_date,
	amount,
	FIRST_VALUE(amount) over (partition by employee_id order by sale_date) as first_date
from sales

-- Obtén para cada vendedor su venta más alta utilizando ventanas.

SELECT
    employee_id,
    sale_date,
    amount,
    MAX(amount) OVER (
        PARTITION BY employee_id
    ) AS highest_sale
FROM sales;

--Calcula una media móvil de 3 ventas.
select 
	employee_id,
	sale_date,
	amount,
	avg(amount) over(rows BETWEEN 2 preceding and current row)
from sales


--- Calcula una suma móvil de 3 ventas.

select 
	sale_date,
	amount,
	sum(amount) over (order by sale_date rows between 2 preceding and current row)
from sales

-- Calcula una media móvil de 5 ventas por vendedor.

select 
	employee_id,
	amount,
	sale_date,
	avg(amount) over (partition by employee_id order by sale_date rows BETWEEN 4 preceding and current row)
from sales

-- Obtén el segundo empleado mejor pagado por departamento.
select * from (
	select
		full_name,
		department_id,
		salary,
		dense_rank() over (partition by department_id order by salary desc) as rnk
	from employees )
 where rnk = 2

-- Obtén las 3 ventas más grandes por vendedor.

select * from 
(
	select
		employee_id,
		amount,
		DENSE_RANK() over (partition by employee_id order by amount desc) as rnk
	from sales
) where rnk <= 3

--  Para cada vendedor encuentra su racha más larga de ventas crecientes consecutivas.

-- Encuentra los días en los que una venta fue mayor que las dos ventas anteriores juntas.

SELECT *
FROM (
    SELECT
        sale_date,
        amount,
        SUM(amount) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING
        ) AS previous_two_sales
    FROM sales
) t
WHERE amount > previous_two_sales;

-- Para cada vendedor calcula:

-- total vendido
-- ranking por total vendido
-- porcentaje del total global
-- diferencia contra el vendedor inmediatamente superior

WITH employee_totals AS (
    SELECT
        employee_id,
        SUM(amount) AS total_sales
    FROM sales
    GROUP BY employee_id
)
SELECT
    employee_id,
    total_sales,

    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank,

    ROUND(
        total_sales * 100.0
        / SUM(total_sales) OVER (),
        2
    ) AS percentage_of_total,

    LAG(total_sales) OVER (
        ORDER BY total_sales DESC
    ) - total_sales AS difference_to_higher
FROM employee_totals
ORDER BY sales_rank;

-- 