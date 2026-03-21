the main ways to handle conditionals are using:
- CASE expressions – works like if-else if-else.
- COALESCE / NULLIF – simple conditional checks with nulls.
- PL/pgSQL IF ... THEN ... ELSE – used in functions or DO blocks.

Basic CASE in PostgreSQL

SELECT 
    value,
    CASE
        WHEN value > 10 THEN 'Big'
        WHEN value > 5 THEN 'Medium'
        ELSE 'Small'
    END AS size_category
FROM my_table;


2. Conditional Aggregation (SUM + CASE)

SELECT
    SUM(CASE WHEN role = 'admin' THEN 1 ELSE 0 END) AS admins,
    SUM(CASE WHEN role = 'user' THEN 1 ELSE 0 END) AS users
FROM users;

3. Using COUNT with CASE

SELECT
    COUNT(CASE WHEN status = 'done' THEN 1 END) AS done_tasks
FROM tasks;

4. PostgreSQL Shortcut (FILTER)
SELECT
    COUNT(*) FILTER (WHERE role = 'admin') AS admins,
    COUNT(*) FILTER (WHERE role = 'user') AS users
FROM users;