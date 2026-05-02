# RBAC
Is how you control who can do what in your database

Instead of assigning permissions directly to users everywhere, you define roles, assigne privileges to those roles, and then grant toles to users

In postgresql there is no strict distinction between user and role

``` sql
create role app_user;
create role admin;
```

If you want to role to be able to log in:

``` sql
create role kevin login password 'secure_password'
```

Role without LOGIN: like a group
Role with LOGIN: acts like user


## Granting roles
You assign roles to other roles:

``` sql
GRANT admin to kevin;
```

Now kevin inherits all permissions from admin

# Privileges
- SELECT
- INSERT
- UPDATE
- DELETE
- USAGE
- EXECUTE

## Grant privileges on a table

```
GRANT SELECT, INSERT on users to app_user;
```

## Revoke privileges 
``` sql
REVOKE INSERT ON users from app_user;
```

# Schema level permissions
Even if a role has table access, it cannot use without schema access

``` sql
GRANT USAGE ON SCHEMA public to app_user;
```

without this: access denied

# Default privileges

``` sql
ALTER DEFAULT PRIVILEGES
GRANT SELECT ON TABLES to app_user;
```

This applies to futere tables, not existing ones

# The real world order
1. Create roles (define responsibilities FIRST)
You dont start with users, you start with roles that represent responsabilities

```
CREATE ROLE app_read;
CREATE ROLE app_write;
CREATE ROLE app_admin;
```

2. Grant permissions to tolres
You define what each role can do

``` sql
-- allow access to schema
GRANT USAGE ON SCHEMA public TO app_read, app_write;

-- read-only
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;

-- read-write
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public TO app_write;
```