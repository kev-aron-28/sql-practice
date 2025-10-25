# What is PL / pgSQL

It lets you:
- write logic
- Group several SQL statements together
- Return values or result sets
- improve performance
- reuse code in multiple queires


# Enable PL/pgSQL
In modern versions its enabled by default,
if not, you can enable it manually:

create extension plpgsql;


# Basic sintax

create or replace function function_name(params)
returns return_type as $$
declare
 -- variables
begin

    return somethin;
end;
$$ language plpsql;

# Basic example
-- create or replace function add_two(a int, b int)
-- returns int as $$
-- begin
-- 	return a + b;
-- end;
-- $$ language plpgsql

# Variables
-- create or replace function area_circle(radius numeric)
-- returns numeric as $$
-- DECLARE
-- 	pi constant numeric := 3.1416;
-- 	result numeric;
	
-- BEGIN
-- 	result := pi * radius * radius;
-- 	return result;
-- end;
-- $$ language plpgsql;
select area_circle(10);

# if / else
-- CREATE OR REPLACE FUNCTION is_adult(age INT)
-- RETURNS TEXT AS $$
-- BEGIN
--     IF age >= 18 THEN
--         RETURN 'Adult';
--     ELSE
--         RETURN 'Minor';
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;


select is_adult(12);


# Loop
CREATE OR REPLACE FUNCTION count_to(n INT)
RETURNS VOID AS $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= n LOOP
        RAISE NOTICE 'Number: %', i;
        i := i + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT count_to(5);

# For in select
CREATE OR REPLACE FUNCTION list_employees()
RETURNS VOID AS $$
DECLARE
    emp RECORD;
BEGIN
    FOR emp IN SELECT name, salary FROM employees LOOP
        RAISE NOTICE 'Employee: %, Salary: %', emp.name, emp.salary;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

select list_employees();

# Returning rows or tables

CREATE OR REPLACE FUNCTION get_high_salaries(min_salary INT)
RETURNS TABLE(name TEXT, salary INT) AS $$
BEGIN
    RETURN QUERY
    SELECT name, salary FROM employees WHERE salary >= min_salary;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_high_salaries(6000);


# Procedures
CREATE OR REPLACE PROCEDURE subir_salarios(porcentaje NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE empleado
  SET salario = salario + salario * (porcentaje / 100);
  COMMIT;
END;
$$;
CALL subir_salarios(10);