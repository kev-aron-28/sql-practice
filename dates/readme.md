# Dates in postgres

## Date and time types

| Type                                       | Description                      | Example                  |
| ------------------------------------------ | -------------------------------- | ------------------------ |
| `DATE`                                     | Only date                        | `2025-12-15`             |
| `TIME`                                     | Time of day (no timezone)        | `14:30:00`               |
| `TIME WITH TIME ZONE`                      | Time with offset                 | `14:30:00-06`            |
| `TIMESTAMP`                                | Date + time (no timezone)        | `2025-12-15 14:30:00`    |
| `TIMESTAMP WITH TIME ZONE` (`timestamptz`) | Date + time + timezone awareness | `2025-12-15 20:30:00+00` |
| `INTERVAL`                                 | Duration / difference            | `3 days 2 hours`         |

# Current date and time functions
| Function            | Returns                         |
| ------------------- | ------------------------------- |
| `NOW()`             | Current timestamp (timestamptz) |
| `CURRENT_TIMESTAMP` | Same as `NOW()`                 |
| `CURRENT_DATE`      | Only date                       |
| `CURRENT_TIME`      | Only time                       |
| `LOCALTIMESTAMP`    | Timestamp without timezone      |


# Casting and conversion
```
SELECT DATE '2025-12-15';
SELECT TIMESTAMP '2025-12-15 10:00:00';
SELECT '2025-12-15'::DATE;
```

# Convert between types
```
SELECT NOW()::DATE;          -- strip time
SELECT CURRENT_DATE::TIMESTAMP;
```
# Arithmetics
```
-- Add or substract
SELECT CURRENT_DATE + 7;   -- 7 days later
SELECT CURRENT_DATE - 1;   -- yesterday

-- Using intervfal
SELECT NOW() + INTERVAL '3 days';
SELECT NOW() - INTERVAL '2 hours';
INTERVAL '1 year'
INTERVAL '2 months'
INTERVAL '15 minutes'
INTERVAL '1 day 3 hours'

-- Date difference
SELECT DATE '2025-12-31' - DATE '2025-12-01';
-- Result: 30

-- Extract
SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(HOUR FROM NOW());
```


# Formating dates
```
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD');
SELECT TO_CHAR(NOW(), 'DD/MM/YYYY HH24:MI');
```

| Pattern | Meaning    |
| ------- | ---------- |
| `YYYY`  | Year       |
| `MM`    | Month      |
| `DD`    | Day        |
| `HH24`  | Hour (24h) |
| `MI`    | Minutes    |
| `SS`    | Seconds    |

# Parsing strings to dates
```
SELECT TO_DATE('15-12-2025', 'DD-MM-YYYY');
SELECT TO_TIMESTAMP('15-12-2025 10:30', 'DD-MM-YYYY HH24:MI');
```

# What does date_trunc mean?
DATE_TRUNC = “cut everything smaller than a given unit”
It resets the smaller parts of a date/time to zero

When you truncate at a level, everything below it becomes zero.

```
DATE_TRUNC(unit, timestamp)
```

# Example
SELECT DATE_TRUNC('year', TIMESTAMP '2025-12-15 18:47:23');
2025-01-01 00:00:00

SELECT DATE_TRUNC('month', TIMESTAMP '2025-12-15 18:47:23');
2025-12-01 00:00:00

SELECT DATE_TRUNC('day', TIMESTAMP '2025-12-15 18:47:23');
2025-12-15 00:00:00

SELECT DATE_TRUNC('hour', TIMESTAMP '2025-12-15 18:47:23');
2025-12-15 18:00:00

SELECT DATE_TRUNC('minute', TIMESTAMP '2025-12-15 18:47:23');
2025-12-15 18:47:00

