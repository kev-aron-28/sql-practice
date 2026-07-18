# Migrations
A  migration is simply a vresion-controlled change to a database
Every change becomes permanent history

# The migration table
Almost every migration tool creates something like schema_migrations

# Common migration operations

1. add column

``` sql
ALTER TABLE users
ADD COLUMN email TEXT;
```

2. rename column

``` sql
ALTER TABLE users
RENAME COLUMN username
TO login;
```

3. Remove column

``` sql
ALTER TABLE users
DROP COLUMN email;
```

4. change datatype
``` sql
ALTER TABLE products
ALTER COLUMN price
TYPE NUMERIC(12,2);
```

5. add constraint

``` sql
ALTER TABLE users
ADD CONSTRAINT unique_email
UNIQUE(email);
```

6. Remove constraint

``` sql
ALTER TABLE users
DROP CONSTRAINT unique_email;
```

# The safe three step pattern

Step 1.

``` sql
ALTER TABLE users
ADD COLUMN email TEXT;
```

Step 2. 

``` sql
UPDATE users
SET email = username || '@company.com';
```

Step 3. 

``` sql
ALTER TABLE users
ALTER COLUMN email
SET NOT NULL;
```

# Large table migrations

Suppose 500 million rows

So updating all at once is dangerous

because it may:
- lock many rows
- generate massive WAL
- bloat the table
- take hours

Instead you should do it in batch operations limiting 

# Zero downdime migrations

