Union
the UNION keyword is used to combine the result sets of two or more SELECT queries into a single result set. It automatically removes duplicate rows (similar to a "distinct" operation).

UNION → removes duplicates.
UNION ALL → keeps duplicates, faster because no distinct check is performed.


the INTERSECT keyword is used to return only the rows that appear in the result sets of both SELECT queries. Think of it as the opposite of UNION in terms of inclusion: UNION combines all unique rows, INTERSECT keeps only the common ones.
Rules:

Both SELECT statements must have the same number of columns.

Corresponding columns must have compatible data types.

By default, duplicates are removed.

INTERSECT → removes duplicates.
INTERSECT ALL → keeps duplicates that appear in both queries.


the EXCEPT keyword is used to return rows from the first SELECT query that do not appear in the second SELECT query. It's essentially a "difference" operation.
Both SELECT statements must have the same number of columns.

Corresponding columns must have compatible data types.

By default, duplicates are removed.
EXCEPT → removes duplicates.

EXCEPT ALL → keeps duplicates, subtracting the occurrences of the second query from the first.
