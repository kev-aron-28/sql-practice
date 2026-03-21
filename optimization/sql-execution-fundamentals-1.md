# Execution fundamentals

## Declarative vs Imperative thinking
In SQL you dont control: 
-  Iteration
- Indexing
- Join order
- access path
the query plan is in charge of that

# Query processing order
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. LIMIT

1. Get rows (FROM)
2. Apply joins
3. Filter rows (WHERE)
4. Group rows
5. Filter groups (HAVING)
6. Compute SELECT expressions
7. Sort results

# 