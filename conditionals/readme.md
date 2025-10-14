the main ways to handle conditionals are using:
- CASE expressions – works like if-else if-else.
- COALESCE / NULLIF – simple conditional checks with nulls.
- PL/pgSQL IF ... THEN ... ELSE – used in functions or DO blocks.

1. Case

SELECT 
    value,
    CASE
        WHEN value > 10 THEN 'Big'
        WHEN value > 5 THEN 'Medium'
        ELSE 'Small'
    END AS size_category
FROM my_table;

