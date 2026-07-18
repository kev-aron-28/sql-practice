# How to backup

Where is the data stored?
When you create a database and a table you dont get: employees.csv or a .sql
Instead PostgreSQL creates binary files inside its data directory

``` bash
C:\Program Files\PostgreSQL\17\data\
/var/lib/postgresql/17/main/
```

and inside you will find something like

```
base/
global/
pg_wal/
pg_xact/
...
```

The actual table is stored as binary pages. You are never supposed to edit these files manually

So how do backups work?
There are two major kinds

## Logical backup
This produces SQL

```
pg_dump company > company.sql
```

and the file contains sql, it is literally a script capable of rebuilding the database

Advantages:
- human readable
- portable
- can restore on another version
- easy to modify

Disadvantages:
- slower
- large databases take time

### dump only one table

``` bash
pg_dump -t employees company
```

### dump only schema

``` bash
pg_dump --schema-only company
```

### dump only data

``` bash
pg_dump --data-only company
```

### Compressed backup

``` bash
pg_dump

-Fc

company

-f company.dump
```

and to restore it 

``` bash
pg_restore

-d company

company.dump
```

## Binary backup
Instead of exporting SQL, you copy the actual database files, postgres already provides pg_basebackup

``` sql
pg_basebackup \
-D backup_folder \
-Fp \
-X stream
```

this copies entire PostgreSQL cluster


# Common production backup strategy
A common production setup combines logical and physical backups:
- Nightly logical backup with pg_dump for portability and object-level restores
- Regular phisical backups with pg_basebackup for fast disaster recovery
- Continous WAL archiving so you can restore the database to a specific point in time (Point-in-Time recovery, or PITR)
- Off-site storage
- periodic restore tests to verify that backups are actually usable

# 