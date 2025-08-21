SQL Command Categories

1. DDL (Data Definition Language)

Commands that define or change the structure of the database (tables, schemas, indexes).
They affect metadata, not just data.

Examples:

CREATE TABLE employees (...);   -- create new table
ALTER TABLE employees ADD email VARCHAR(255);  -- modify table
DROP TABLE employees;           -- delete table
TRUNCATE TABLE employees;       -- delete all rows, reset identity
RENAME TABLE old_name TO new_name; -- rename

2. DML (Data Manipulation Language)

Commands that deal with the data inside tables.

Examples:

INSERT INTO employees (name, salary) VALUES ('John', 5000); -- add row
UPDATE employees SET salary = 6000 WHERE name = 'John';    -- modify rows
DELETE FROM employees WHERE id = 3;                        -- delete rows
SELECT * FROM employees;                                   -- query rows


(Some people put SELECT in its own group called DQL – Data Query Language, but many consider it part of DML.)

3. DCL (Data Control Language)

Commands that control permissions and security.

Examples:

GRANT SELECT, INSERT ON employees TO user1;  -- give rights
REVOKE INSERT ON employees FROM user1;       -- take rights away

4. TCL (Transaction Control Language)

Commands that control transactions (groups of DML statements that succeed or fail together).

Examples:

BEGIN;          -- start transaction
UPDATE employees SET salary = salary + 1000;
COMMIT;         -- save changes
ROLLBACK;       -- undo changes
SAVEPOINT sp1;  -- set a rollback point
ROLLBACK TO sp1;-- rollback to that point

🔹 Quick Memory Aid

DDL → Structure (tables, schema).

DML → Data (insert, update, delete).

DCL → Control (permissions).

TCL → Transactions (commit, rollback).


1. Add a new column
ALTER TABLE table_name
ADD column_name datatype;


ALTER TABLE employees
ADD email VARCHAR(255);

2. Add multiple columns
ALTER TABLE table_name
ADD (col1 datatype, col2 datatype);

3. Drop (delete) a column
ALTER TABLE table_name
DROP COLUMN column_name;

4. Rename a column

MySQL / MariaDB

ALTER TABLE table_name
CHANGE old_column_name new_column_name datatype;


PostgreSQL / SQL Server (2016+)

ALTER TABLE table_name
RENAME COLUMN old_column_name TO new_column_name;

5. Modify column datatype or size

MySQL / MariaDB

ALTER TABLE table_name
MODIFY column_name new_datatype;


PostgreSQL

ALTER TABLE table_name
ALTER COLUMN column_name TYPE new_datatype;

6. Set a column to NOT NULL or drop NOT NULL
ALTER TABLE table_name
ALTER COLUMN column_name SET NOT NULL;

ALTER TABLE table_name
ALTER COLUMN column_name DROP NOT NULL;

7. Add / Drop Default value
ALTER TABLE table_name
ALTER COLUMN column_name SET DEFAULT 'value';

ALTER TABLE table_name
ALTER COLUMN column_name DROP DEFAULT;

8. Rename a table
ALTER TABLE old_table_name
RENAME TO new_table_name;

9. Add a constraint
ALTER TABLE table_name
ADD CONSTRAINT constraint_name CHECK (age >= 18);

10. Drop a constraint
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;

🔹 Updating Table Data (DML – UPDATE)
11. Update one column
UPDATE table_name
SET column_name = value
WHERE condition;

12. Update multiple columns
UPDATE table_name
SET col1 = value1,
    col2 = value2
WHERE condition;

13. Update all rows
UPDATE table_name
SET column_name = value;
