# Pivoting in postgres

Pivoting means transforming rows into columns — typically when you want to 
summarize or reorganize data for easier analysis.


Postgres doesn’t have a native PIVOT keyword like SQL Server or Oracle, but it gives you powerful 
and flexible ways to achieve the same thing — and even more control.


region	year	revenue

North	2023	1000
South	2023	1500
North	2024	1200
South	2024	1700

Goal pivoted table:
region	2023	2024

North	1000	1200
South	1500	1700



1. Basic pivot using CASE + GROUP BY (most common)

This is the standard way in PostgreSQL.

SELECT
    region,
    SUM(CASE WHEN year = 2023 THEN revenue END) AS "2023",
    SUM(CASE WHEN year = 2024 THEN revenue END) AS "2024"
FROM sales
GROUP BY region
ORDER BY region;

2. Pivot using FILTER (Postgres-only syntax)

SELECT
    region,
    SUM(revenue) FILTER (WHERE year = 2023) AS "2023",
    SUM(revenue) FILTER (WHERE year = 2024) AS "2024"
FROM sales
GROUP BY region;

3. Pivot dynamically (when columns are unknown)

SELECT string_agg(DISTINCT format(
    'SUM(revenue) FILTER (WHERE year = %s) AS "%s"', year, year
), ', ') AS columns_sql
FROM sales;


# Example

| employee | skill  | level        |
| -------- | ------ | ------------ |
| Alice    | SQL    | Expert       |
| Alice    | Python | Intermediate |
| Alice    | Java   | Beginner     |
| Bob      | SQL    | Intermediate |
| Bob      | Java   | Advanced     |
| Bob      | C++    | Beginner     |

You want it to look like this:

| employee | SQL          | Python       | Java     | C++      |
| -------- | ------------ | ------------ | -------- | -------- |
| Alice    | Expert       | Intermediate | Beginner | NULL     |
| Bob      | Intermediate | NULL         | Advanced | Beginner |


SELECT
    employee,
    MAX(CASE WHEN skill = 'SQL' THEN level END) AS "SQL",
    MAX(CASE WHEN skill = 'Python' THEN level END) AS "Python",
    MAX(CASE WHEN skill = 'Java' THEN level END) AS "Java",
    MAX(CASE WHEN skill = 'C++' THEN level END) AS "C++"
FROM employee_skills
GROUP BY employee
ORDER BY employee;















