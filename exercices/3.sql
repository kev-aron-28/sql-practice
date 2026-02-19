INSERT INTO employees (first_name, email, monthly_salary)
VALUES
('Ana', 'ana@mail.com', 15000.00),
('Luis', 'luis@mail.com', 18000.00),
('Mariana', 'mariana@mail.com', 22000.00),
('Jorge', 'jorge@mail.com', 20000.00);

-- 1
select * from salary 
where monthly_salary = ();
-- 2
select * from employees 
where monthly_salary > (select
    avg(monthly_salary)
    from employees
);
-- 3
select department

create table employees_log (
    id serial primary key,
    employee_id integer,
    action varchar(50),
    log_date timestamp default now()
);

create or replace function add_logs()
returns trigger as $$
BEGIN
    insert into employees_log (employee_id, action) VALUES
    (new.id, 'INSERT');
    return new;
end;
$$
LANGUAGE plpgsql;

create trigger on_insert_employee
after insert on employees
for each row
execute function add_logs();

create or replace funcition on_update_after_employees()
returns trigger as $$
declare
    current_monthly_salary_val numeric;
BEGIN
    insert into employees_log (employee_id, action) VALUES
    (new.id,'UPDATE');
    return new;
end;
$$
LANGUAGE plpgsql;

create trigger on_update_trigger
after update on employees
for each row
execute function on_update_after_employees();

CREATE OR REPLACE FUNCTION prevent_salary_decrease()
RETURNS TRIGGER AS $$
BEGIN
    -- Si el nuevo salario es menor al anterior, lanzar error
    IF NEW.monthly_salary < OLD.monthly_salary THEN
        RAISE EXCEPTION 'No puedes disminuir el salario.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_update_salary
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_salary_decrease();


create or replace function get_employees_by_department(p_department_id integer)
returns table(first_name varchar(50), email varchar(50), monthly_salary NUMERIC)
as $$
BEGIN
    return query
    select first_name, email, monthly_salary from 
    employees e join departments d on d.id = e.department_id
    where d.id = p_department_id;  
end;
$$ LANGUAGE plpgsql;


create view employees_info as (
    select
        e.first_name.
        e.email,
        e.monthly_salary,
        d.name as department_name 
    from employees e
    inner join departments d on e.department_id = d.id;
);


create index deparment_index on employees(department_id);