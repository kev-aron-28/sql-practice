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


# No partition, by no order by
SELECT
  employee,
  amount,
  SUM(amount) OVER () AS total_all
FROM sales;
**For each row, sum all amounts from the whole table**

Every row shows the same number, because the window = entire table

# Partition By

SELECT
  employee,
  amount,
  SUM(amount) OVER (PARTITION BY employee) AS total_per_employee
FROM sales;

Break the data into small windows one per employee then sum inside each window

| employee | amount | total_per_employee |
| -------- | ------ | ------------------ |
| Alice    | 200    | 850                |
| Alice    | 400    | 850                |
| Alice    | 250    | 850                |
| Bob      | 150    | 430                |
| Bob      | 100    | 430                |
| Bob      | 180    | 430                |
| Charlie  | 300    | 900                |
| Charlie  | 200    | 900                |
| Charlie  | 400    | 900                |

PARTITION BY employee works like GROUP BY, but keeps all rows visible

# Add order by

SELECT
  employee,
  sale_date,
  amount,
  SUM(amount) OVER (PARTITION BY employee ORDER BY sale_date) AS running_total
FROM sales;

**For each employee, go through their rows in date order, and add up everything so far**











































