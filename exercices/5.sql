CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  title TEXT NOT NULL,
  status TEXT CHECK (status IN ('pending', 'in_progress', 'done')),
  due_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

INSERT INTO users (name, created_at) VALUES
('Kevin', NOW() - INTERVAL '40 days'),
('Ana',   NOW() - INTERVAL '15 days');

INSERT INTO tasks (user_id, title, status, due_at, created_at, completed_at) VALUES
(1, 'Finish report', 'done',
 NOW() - INTERVAL '10 days',
 NOW() - INTERVAL '20 days',
 NOW() - INTERVAL '12 days'),

(1, 'Prepare slides', 'in_progress',
 NOW() + INTERVAL '2 days',
 NOW() - INTERVAL '5 days',
 NULL),

(1, 'Fix bugs', 'pending',
 NOW() + INTERVAL '1 day',
 NOW() - INTERVAL '1 day',
 NULL),

(2, 'Design UI', 'done',
 NOW() - INTERVAL '3 days',
 NOW() - INTERVAL '10 days',
 NOW() - INTERVAL '4 days'),

(2, 'Client meeting', 'pending',
 DATE_TRUNC('day', NOW()) + INTERVAL '1 day 9 hours',
 NOW() - INTERVAL '2 days',
 NULL);


-- Get all tasks due today
SELECT *
FROM tasks
WHERE due_at >= DATE_TRUNC('day', NOW())
  AND due_at <  DATE_TRUNC('day', NOW()) + INTERVAL '1 day';

-- Get all tasks that are overdue
SELECT *
FROM tasks
WHERE due_at < NOW()
  AND status != 'done';

-- Show task title + days remaining until due date
SELECT
  title,
  (due_at::DATE - CURRENT_DATE) AS days_remaining
FROM tasks;


-- Count how many tasks were created per day.
SELECT
  DATE_TRUNC('day', created_at) AS day,
  COUNT(*) AS total
FROM tasks
GROUP BY day
ORDER BY day;

-- Count tasks per month
select count(*), date_trunc('month', created_at) from tasks
group by date_trunc('month', created_at)

-- Show tasks grouped by week
select count(*), date_trunc('week', created_at) from tasks
group by date_trunc('week', created_at)

-- Find tasks completed on the same day there were created
SELECT *
FROM tasks
WHERE completed_at IS NOT NULL
  AND DATE_TRUNC('day', completed_at) = DATE_TRUNC('day', created_at);

-- Calculate how long each completed task took to finish.
select title, completed_at - created_at  from tasks
where status = 'done'

-- Get the average completion time of tasks
select avg(completed_at - created_at)  from tasks
where status = 'done'

--  Get all tasks created today, safely (timezone-safe).
SELECT *
FROM tasks
WHERE created_at >= DATE_TRUNC('day', NOW())
  AND created_at <  DATE_TRUNC('day', NOW()) + INTERVAL '1 day';


-- Get tasks due tomorrow between 9am and 12pm.
SELECT *
FROM tasks
WHERE due_at >= DATE_TRUNC('day', NOW()) + INTERVAL '1 day 9 hours'
  AND due_at <  DATE_TRUNC('day', NOW()) + INTERVAL '1 day 12 hours';
-- For each user, show:
-- total tasks
-- completed tasks
-- average completion time
select u.id, count(t.status = 'done') from users u
join tasks t on u.id = t.user_id
group by u.id

-- detect tasks that where completed after their due date

-- show tasks created in last 7 days