# Window functions

## What are window functions?
A window function performs a calculation across a set of rows related to the current row,
without collapsing them into a single row like normal GROUP BY aggregates.

You keep all rows, but get aggregated or ranked data per row.

Calculate something “like a group,” but keep every row.

function_name(expression) 
OVER (
    PARTITION BY col1, col2
    ORDER BY col3
    [ROWS or RANGE frame_clause]
)

You can use normal aggregate functions like SUM(), AVG(), COUNT(), etc. — but as window functions:

SELECT 
    department,
    employee_name,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS avg_salary_per_dept,
    SUM(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS cumulative_salary
FROM employees;

## ranking functions

RANK()

Gives a rank, skipping numbers for ties:
SELECT 
    department, employee_name, salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_dept
FROM employees;

DENSE_RANK()

Like RANK(), but doesn’t skip numbers:
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC)

ROW_NUMBER()

Unique number per row, even if values tie:
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)

## Value Navigation Functions

LAG() — previous row’s value

SELECT 
    employee_name,
    salary,
    LAG(salary) OVER (ORDER BY salary) AS previous_salary
FROM employees;

LEAD() — next row’s value

LEAD(salary) OVER (ORDER BY salary) AS next_salary

FIRST_VALUE() / LAST_VALUE()
Get first/last value in the window:

FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC)
LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC)

# Frame clouses
A frame defines which rows are considered in the calculation for each current row.

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

SELECT
    order_id,
    order_date,
    SUM(amount) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM orders;

# Diff with group by

| Without window            | With window                |
| ------------------------- | -------------------------- |
| Groups and collapses rows | Keeps all rows             |
| Used with `GROUP BY`      | Uses `OVER (...)`          |
| One result per group      | One result per row         |
| Simpler but less flexible | More powerful and flexible |


# Inside over
you can put 3 big components
1. PARTITION BY
2. ORDER BY
3. FRAME CLAUSE (ROWS / RANGE / GROUPS)

1. PARTITION BY
This breaks the dataset into independent groups.
It works like a GROUP BY, but it does not collapse rows.

Example

``` sql
SUM(salary) OVER (
    PARTITION BY department
)
```

Meaning:
Do a SUM for each department
Every row keeps its detail
SUM repeats for all rows in that department

If you omit PARTITION BY, the partition is the whole table

2. ORDER BY

Defines the row order inside the window.
Without ORDER BY, the window functions do NOT know the row sequence.

ORDER BY inside OVER() does not sort the whole query 
it only affects the window calculation.
To sort the final result, you need a separate ORDER BY outside OVER.

3. FRAME CLAUSE (ROWS / RANGE / GROUPS)
It controls which rows the function can use.

the sintax is:

ROWS | RANGE | GROUPS
BETWEEN <start> AND <end>

## Frame types
A. Rows
Frames based on physical positions

AVG(value) OVER (
    ORDER BY date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)

Take the current row + 2 rows before it

Full partition
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING


B. Range
Value-based frames (not row-based)

SUM(amount) OVER (
    ORDER BY created_at
    RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
)


C. Groups
Groups peer rows with same ORDER BY value

SUM(sales) OVER (
    ORDER BY date
    GROUPS BETWEEN 1 PRECEDING AND 1 FOLLOWING
)


# Aggregate functions 

Built-in aggregates
AVG()
COUNT()
MAX()
MIN()
SUM()

Statistical aggregates
CORR()
COVAR_POP()
COVAR_SAMP()
REGR_AVGX()
REGR_AVGY()
REGR_COUNT()
REGR_INTERCEPT()select 
	RANK(id) over (PARTITION by category order by price)
from products;
REGR_R2()
REGR_SLOPE()
REGR_SXX()
REGR_SXY()
REGR_SYY()
STDDEV()
STDDEV_POP()
STDDEV_SAMP()
VARIANCE()
VAR_POP()
VAR_SAMP()

Ranking Window Functions

These produce row rankings.
ROW_NUMBER()
RANK()
DENSE_RANK()
PERCENT_RANK()
CUME_DIST()
NTILE(n)

Value Window Functions
Look at values from other rows.
LAG(value [, offset [, default]])
LEAD(value [, offset [, default]])
FIRST_VALUE(value)
LAST_VALUE(value)
NTH_VALUE(value, n)















































