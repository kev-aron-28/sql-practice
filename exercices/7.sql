CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    owner_id INT NOT NULL REFERENCES users(id),
    status TEXT CHECK (status IN ('active', 'archived')) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    project_id INT NOT NULL REFERENCES projects(id),
    assignee_id INT REFERENCES users(id),
    title TEXT NOT NULL,
    status TEXT CHECK (status IN ('pending', 'in_progress', 'done', 'canceled')) NOT NULL,
    priority INT CHECK (priority BETWEEN 1 AND 5),
    due_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    completed_at TIMESTAMPTZ
);

CREATE TABLE task_status_history (
    id SERIAL PRIMARY KEY,
    task_id INT NOT NULL REFERENCES tasks(id),
    old_status TEXT,
    new_status TEXT NOT NULL,
    changed_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE time_logs (
    id SERIAL PRIMARY KEY,
    task_id INT NOT NULL REFERENCES tasks(id),
    user_id INT NOT NULL REFERENCES users(id),
    minutes_spent INT CHECK (minutes_spent > 0),
    logged_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO users (name, email, created_at) VALUES
('Alice', 'alice@corp.com', now() - interval '40 days'),
('Bob',   'bob@corp.com',   now() - interval '35 days'),
('Carol', 'carol@corp.com', now() - interval '30 days');

INSERT INTO projects (name, owner_id, status, created_at) VALUES
('Internal ERP', 1, 'active',   now() - interval '30 days'),
('Website Redesign', 2, 'active', now() - interval '25 days'),
('Legacy Migration', 3, 'archived', now() - interval '60 days');

INSERT INTO tasks
(project_id, assignee_id, title, status, priority, due_at, created_at, completed_at)
VALUES
-- Project 1
(1, 1, 'Design database schema', 'done', 5,
 now() - interval '20 days',
 now() - interval '25 days',
 now() - interval '18 days'), -- completed late

(1, 2, 'Implement auth module', 'in_progress', 4,
 now() - interval '5 days',
 now() - interval '15 days',
 NULL), -- overdue

(1, 3, 'Write API documentation', 'pending', 3,
 now() + interval '5 days',
 now() - interval '10 days',
 NULL),

-- Project 2
(2, 2, 'Create landing page', 'done', 2,
 now() - interval '10 days',
 now() - interval '12 days',
 now() - interval '9 days'),

(2, 1, 'Setup CI pipeline', 'canceled', 3,
 now() - interval '3 days',
 now() - interval '8 days',
 NULL),

-- Project 3 (archived)
(3, 3, 'Migrate old database', 'done', 5,
 now() - interval '40 days',
 now() - interval '50 days',
 now() - interval '45 days'),

-- Inconsistent task (for integrity query)
(2, 3, 'Broken task example', 'done', 1,
 now() + interval '10 days',
 now() - interval '2 days',
 NULL);

INSERT INTO task_status_history (task_id, old_status, new_status, changed_at) VALUES
-- Task 1
(1, 'pending', 'in_progress', now() - interval '24 days'),
(1, 'in_progress', 'done', now() - interval '18 days'),

-- Task 2 (many changes + regression)
(2, 'pending', 'in_progress', now() - interval '14 days'),
(2, 'in_progress', 'pending', now() - interval '12 days'),
(2, 'pending', 'in_progress', now() - interval '10 days'),
(2, 'in_progress', 'in_progress', now() - interval '7 days'),

-- Task 3
(3, 'pending', 'pending', now() - interval '9 days'),

-- Task 4
(4, 'pending', 'in_progress', now() - interval '11 days'),
(4, 'in_progress', 'done', now() - interval '9 days'),

-- Task 6
(6, 'pending', 'in_progress', now() - interval '48 days'),
(6, 'in_progress', 'done', now() - interval '45 days');


INSERT INTO time_logs (task_id, user_id, minutes_spent, logged_at) VALUES
-- Task 1
(1, 1, 120, now() - interval '23 days'),
(1, 1, 90,  now() - interval '21 days'),

-- Task 2 (overdue, not done)
(2, 2, 60,  now() - interval '13 days'),
(2, 2, 180, now() - interval '8 days'),

-- Task 3 (not completed)
(3, 3, 45,  now() - interval '7 days'),

-- Task 4
(4, 2, 200, now() - interval '10 days'),
(4, 2, 50,  now() - interval '9 days'),

-- Task 6
(6, 3, 300, now() - interval '46 days'),

-- Logged but never completed by user
(2, 1, 30,  now() - interval '6 days');


1. list all active projects with their owner name

select u.name, p.name from projects p join users u on p.owner_id = u.id;

2. list all tasks with project name assignee name priority statuts

select p.name, u.name, t.priority, t.status from tasks t 
join users u on t.assignee_id = u.id
join projects p on t.project_id = p.id
;

3. Find all over due stask that are not done
select * from tasks where due_at < now() and status != 'done';

4. show tasks that were completed after their due date
select * from tasks where status = 'done' and completed_at > due_at;

5. list users who never completed a task
with users_who_completed as (
	select u.id from tasks t join users u on t.assignee_id = u.id
	where t.status = 'done'
)

select * from users where id not in (select id from users_who_completed)

-- 6. for each user show: total tasks assigned, total tasks completed
select u.name, count(*) as total_tasks, count(t.completed_at) as completed_tasks from tasks t left join users u on t.assignee_id = u.id
group by u.name
;


7. For each project calculate: averege task priority, number of canceled tasks
select p.name, avg(t.priority), count(t.status = 'canceled') from projects p left join tasks t on t.project_id = p.id
group by p."name"

8. find the top 2 users by total minutes logged
select t.user_id, sum(t.minutes_spent) as total_minutes from time_logs t 
group by t.user_id
order by total_minutes DESC
limit 2