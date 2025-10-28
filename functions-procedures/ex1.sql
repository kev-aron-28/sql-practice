CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT,
    department TEXT,
    salary NUMERIC(10,2),
    hire_date DATE
);

INSERT INTO employees (name, department, salary, hire_date) VALUES
('Ana', 'HR', 3000, '2020-01-15'),
('Luis', 'HR', 5000, '2019-03-22'),
('María', 'HR', 4500, '2021-07-30'),
('Sofía', 'IT', 8000, '2018-06-01'),
('Pedro', 'IT', 6500, '2020-02-25'),
('Carlos', 'Sales', 5500, '2021-03-10');

CREATE TABLE salary_log (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    bonus_applied NUMERIC(10,2),
    old_salary NUMERIC(10,2),
    new_salary NUMERIC(10,2),
    updated_at TIMESTAMP DEFAULT now()
);

-- Ejercicio 1

CREATE OR REPLACE FUNCTION public.get_bonus(employee_id integer)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
	emp_salary numeric;
	emp_hire_date date;
	years int;
	bonus numeric := 0;
BEGIN
	select salary, hire_date
	into    emp_salary, emp_hire_date
	from employees
	where id = employee_id;
	
	years := EXTRACT(year from age(current_date, emp_hire_date));
	
	if years < 1 THEN
		bonus := 0;
	elsif years between 1 and 3 then
		bonus := emp_salary * 0.05;
	elsif years between 4 and 6 THEN
		bonus := emp_salary * 0.10;
	else
		bonus := emp_salary * 0.15;
	end if;
	
	return bonus;
end;
$function$
