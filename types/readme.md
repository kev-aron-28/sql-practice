# All types in postgres for data

## Numeric types

| Type                              | Description             |
| --------------------------------- | ----------------------- |
| `smallint`                        | 2-byte integer          |
| `integer` / `int`                 | 4-byte integer          |
| `bigint`                          | 8-byte integer          |
| `decimal(p, s)` / `numeric(p, s)` | Exact precision decimal |
| `real`                            | 4-byte floating point   |
| `double precision`                | 8-byte floating point   |
| `serial`                          | Auto-increment 4-byte   |
| `bigserial`                       | Auto-increment 8-byte   |


## Monetary types
| Type    | Description                    |
| ------- | ------------------------------ |
| `money` | Currency amount (locale-aware) |


## Character types
| Type         | Description     |
| ------------ | --------------- |
| `char(n)`    | Fixed length    |
| `varchar(n)` | Variable length |
| `text`       | Unlimited text  |


## Binary types
| Type    | Description                |
| ------- | -------------------------- |
| `bytea` | Binary data (“byte array”) |

## Date/time types
| Type          | Description               |
| ------------- | ------------------------- |
| `timestamp`   | Date + time (no timezone) |
| `timestamptz` | Date + time with timezone |
| `date`        | Calendar date             |
| `time`        | Time of day               |
| `timetz`      | Time of day with timezone |
| `interval`    | Time span                 |

## Boolean type
| Type      | Description      |
| --------- | ---------------- |
| `boolean` | `TRUE` / `FALSE` |

## Enumerated types
| Type   | Description                         |
| ------ | ----------------------------------- |
| `enum` | User-defined list of allowed values |
CREATE TYPE mood AS ENUM ('happy', 'sad', 'ok');


## Geometric types
| Type      | Description         |
| --------- | ------------------- |
| `point`   | (x, y)              |
| `line`    | Infinite line       |
| `lseg`    | Line segment        |
| `box`     | Rectangular box     |
| `path`    | Closed or open path |
| `polygon` | Polygon             |
| `circle`  | Circle              |


## Network types
| Type                   | Description |
| ---------------------- | ----------- |
| `cidr`                 | IP network  |
| `inet`                 | IP address  |
| `macaddr` / `macaddr8` | MAC address |

## Bit string types
| Type                        | Description                |
| --------------------------- | -------------------------- |
| `bit(n)`                    | Fixed-length bit string    |
| `bit varying(n)` / `varbit` | Variable-length bit string |


## Text Search Types

| Type       | Description               |
| ---------- | ------------------------- |
| `tsvector` | Full-text search document |
| `tsquery`  | Full-text search query    |

## UUID type

| Type   | Description                   |
| ------ | ----------------------------- |
| `uuid` | Universally unique identifier |


## XML JSON types

| Type    | Description                    |
| ------- | ------------------------------ |
| `json`  | Raw JSON                       |
| `jsonb` | Binary JSON (faster & indexed) |
| `xml`   | XML data                       |


## Arrays
EVery type can be an array

## Composite types
User-defined structs:
``` sql
CREATE TYPE full_name AS (
  first text,
  last text
);
```

# Range types
| Type        | Description          |
| ----------- | -------------------- |
| `int4range` | range of INTEGER     |
| `int8range` | range of BIGINT      |
| `numrange`  | range of NUMERIC     |
| `tsrange`   | range of TIMESTAMP   |
| `tstzrange` | range of TIMESTAMPTZ |
| `daterange` | range of DATE        |

# JSONPath type
| Type       | Description               |
| ---------- | ------------------------- |
| `jsonpath` | SQL/JSON path expressions |


## Miscellaneous Types
| Type                        | Description                 |
| --------------------------- | --------------------------- |
| `cid`                       | Command identifier          |
| `regclass`, `regtype`, etc. | Internal catalog references |
| `pg_lsn`                    | WAL log sequence number     |
