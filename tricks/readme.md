# Group by consecutives

``` sql
WITH filtered AS (
    SELECT *,
           id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
),
groups AS (
    SELECT grp
    FROM filtered
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
```

or with dates

``` sql
WITH temp AS (
    SELECT *,
           visit_date - (ROW_NUMBER() OVER (ORDER BY visit_date)) * INTERVAL '1 day' AS grp
    FROM Stadium
),
groups AS (
    SELECT grp
    FROM temp
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
```