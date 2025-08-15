In PostgreSQL, a subquery (also called an inner query or nested query) is a SELECT statement that is embedded inside another SQL query. Subqueries let you use the result of one query as input for another.


SELECT column1, column2
FROM table1
WHERE column3 = (
    SELECT column3
    FROM table2
    WHERE condition
);

Types of Subqueries

a) Single-row subquery

Returns one value.

Can be used with =, <, >, etc.

SELECT name
FROM employees
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE name = 'Sales'
);


b) Multi-row subquery
Returns multiple values.
Use IN or ANY/ALL.

SELECT name
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Mexico'
);

c) Correlated subquery

References columns from the outer query.
Runs once for each row of the outer query.

SELECT e.name
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);


Subqueries can be used in WHERE, FROM, SELECT, and even HAVING clauses.


# In select

anyu subquery that results in a single value

select name, ... (query)
from products
where price > 334

# In from 

Any subquery, so long as the outer selects, wheres/etc are compatible

