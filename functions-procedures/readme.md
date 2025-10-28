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

# Functions parameters
PostgreSQL functions support several parameter types:

| Type       | Description                           |
| ---------- | ------------------------------------- |
| `IN`       | Default. Input value.                 |
| `OUT`      | Returned as a result column.          |
| `INOUT`    | Used both as input and output.        |
| `VARIADIC` | Allows variable number of arguments.  |
| `DEFAULT`  | Default value if argument not passed. |


# Return types
| Type   | Description      | Example                               |
| ------ | ---------------- | ------------------------------------- |
| Scalar | Single value     | `RETURNS INT`                         |
| Record | Custom structure | `RETURNS RECORD`                      |
| Table  | Query result     | `RETURNS TABLE(col1 TYPE, col2 TYPE)` |
| Set    | Multiple rows    | `RETURNS SETOF TYPE`                  |
| Void   | No return        | `RETURNS VOID`                        |


# All types
| Tipo                                             | Descripción                                | Ejemplo                           |
| ------------------------------------------------ | ------------------------------------------ | --------------------------------- |
| `integer`, `int`, `smallint`, `bigint`           | Números enteros                            | `salary integer := 5000;`         |
| `numeric`, `decimal`, `real`, `double precision` | Números con decimales                      | `price numeric(10,2) := 19.99;`   |
| `serial`, `bigserial`                            | Enteros autoincrementales (solo en tablas) | —                                 |
| `boolean`                                        | Verdadero o falso                          | `is_active boolean := true;`      |
| `char(n)`, `varchar(n)`, `text`                  | Cadenas de texto                           | `name text := 'Ana';`             |
| `date`, `time`, `timestamp`, `timestamptz`       | Fechas y horas                             | `created_at timestamp := now();`  |
| `interval`                                       | Periodo de tiempo                          | `duration interval := '1 month';` |
| `uuid`                                           | Identificador único universal              | `id uuid := gen_random_uuid();`   |
| `bytea`                                          | Datos binarios (archivos, imágenes)        | —                                 |
