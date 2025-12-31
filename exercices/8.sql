CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    department_id INT NOT NULL,
    score INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
);

CREATE TABLE task_status (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    assigned_to INT,
    status_id INT NOT NULL,
    priority INT CHECK (priority BETWEEN 1 AND 5),
    due_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    FOREIGN KEY (assigned_to) REFERENCES users(id),
    FOREIGN KEY (status_id) REFERENCES task_status(id)
);

CREATE TABLE task_history (
    id SERIAL PRIMARY KEY,
    task_id INT NOT NULL,
    old_status INT,
    new_status INT,
    changed_at TIMESTAMPTZ DEFAULT NOW(),

    FOREIGN KEY (task_id) REFERENCES tasks(id)
);

INSERT INTO departments (name) VALUES
('Engineering'),
('Sales'),
('Support'),
('HR');

INSERT INTO users (full_name, email, department_id, score) VALUES
('Kevin Tapia', 'kevin@company.com', 1, 25),
('Ana Ruiz', 'ana@company.com', 1, 40),
('Luis Perez', 'luis@company.com', 2, 15),
('Maria Lopez', 'maria@company.com', 3, 30),
('Jorge Diaz', 'jorge@company.com', 4, 0);

INSERT INTO task_status (name) VALUES
('pending'),
('in_progress'),
('completed'),
('cancelled');

INSERT INTO tasks
(title, description, assigned_to, status_id, priority, due_at, completed_at, created_at)
VALUES
('Build API', 'REST API for mobile app', 1, 3, 5,
 NOW() - INTERVAL '5 days',
 NOW() - INTERVAL '4 days',
 NOW() - INTERVAL '10 days'),

('Fix login bug', 'Users cannot login', 2, 3, 4,
 NOW() - INTERVAL '3 days',
 NOW() - INTERVAL '1 days',
 NOW() - INTERVAL '6 days'),

('Prepare sales report', 'Monthly numbers', 3, 2, 3,
 NOW() - INTERVAL '1 day',
 NULL,
 NOW() - INTERVAL '7 days'),

('Customer follow-up', 'Call pending clients', 4, 1, 2,
 NOW() - INTERVAL '2 days',
 NULL,
 NOW() - INTERVAL '5 days'),

('Update policies', 'HR internal policies', 5, 1, 1,
 NOW() + INTERVAL '5 days',
 NULL,
 NOW() - INTERVAL '1 days'),

('Refactor legacy code', 'Cleanup old modules', 1, 2, 5,
 NOW() + INTERVAL '10 days',
 NULL,
 NOW() - INTERVAL '3 days'),

('Onboarding docs', 'Docs for new hires', NULL, 1, 2,
 NOW() + INTERVAL '7 days',
 NULL,
 NOW() - INTERVAL '2 days');

 INSERT INTO task_history (task_id, old_status, new_status, changed_at)
VALUES
(1, 1, 2, NOW() - INTERVAL '8 days'),
(1, 2, 3, NOW() - INTERVAL '4 days'),
(2, 1, 3, NOW() - INTERVAL '1 day'),
(3, 1, 2, NOW() - INTERVAL '5 days'),
(6, 1, 2, NOW() - INTERVAL '2 days');

-- Function: task_is_overdue(task_id)
create or replace function task_is_overdue(task_id int)
returns BOOLEAN as $$
DECLARE
	v_due_at TIMESTAMPTZ;
	v_completed_at TIMESTAMPTZ;
BEGIN
	select due_at, completed_at into v_due_at, v_completed_at from tasks
	where id = task_id;
	
	if not found THEN
		raise EXCEPTION 'Task with id % not found', task_id;
	end if;
	
	return v_due_at < now() and v_completed_at is null;
END
$$ LANGUAGE plpgsql;

-- Function: task_delay(task_id)
create or replace function task_delay(task_id int)
returns interval as $$
DECLARE
	v_due_at timestamptz;
	v_completed_at timestamptz;
BEGIN
	select due_at, completed_at 
	into v_due_at, v_completed_at 
	from tasks
	where id = task_id;
	
	if not found THEN
		raise EXCEPTION 'Tasks not found';
	end if;
	
	if v_completed_at is null THEN
		return null;
	end if;
	
		
	if v_completed_at <= v_due_at THEN
		return null;
	end IF;
	
   return v_completed_at - v_due_at;
END
$$ language plpgsql;


--Function: user_completion_rate(user_id)
create or replace function user_completion_rate(user_id int)
returns numeric as $$
declare
	v_completed_tasks int := 0;
	v_total_assigned_tasks int := 0;
BEGIN
	select
		count(t.completed_at) as t_completed,
		count(*) as total
		into v_completed_tasks, v_total_assigned_tasks
	from tasks t
	where t.assigned_to = user_id;
	
	if v_total_assigned_tasks = 0 THEN
		return 0.0;
	end if;
	
	return v_completed_tasks::numeric / v_total_assigned_tasks::numeric;
END
$$ language plpgsql;