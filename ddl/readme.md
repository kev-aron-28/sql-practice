# DDL
DDL is the part of the SQL used to define and modify the structure of your database


1. ALTER TABLE

Add column:

``` sql
alter table users
add column age int;
```

Modify a column:

``` sql
alter table usrs
alter column age type bigint
```

Rename a column:

``` sql
alter table
rename column age to user_age
```

Drop column:

``` sql
alter table users
drop column user_age;
```

2. CONSTRAINTS

add a constraint:

``` sql
alter table users
add constraint user_email_unit unique (email);
```

drop constraint:

``` sql
alter table users
drop constraint user_email_unique;
```

3. Updating primary key
You cannot directly modify a primary key

First drop it
``` sql
alter table useres
drop constraint users_pkey;
```

Create a new one:
``` sql
alter table users
add primary key (email);
```

4. Updating a FOREING KEY
Same idea: drop and create

``` sql
alter table orders
drop constraint orders_user_id_fkey;

alter table orders
add constraint orders_user_id_fkey
foreign key (user_id)
references users(id)
on delete cascade;
```

5. NOT NULL constraints

add not null

``` sql
alter table users
alter column email set not null;
```

remove not null

``` sql
alter table users
alter column email drop not null;
```

6. DEFAULT values
Add default

``` sql
alter table users
alter column created_at set default now();
```

Remove default
``` sql
alter table users
alter column created_at drop default;
```

7. Rename things
Rename table

``` sql
alter table useres
rename to customers;
```


