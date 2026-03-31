# Query tunning 

## The query processing pipeline
1. Parser -> builds the query tree 
2. Rewrite -> Decompose views into underlying table references
3. Planner -> Choose which strategy to execute the query given
4. Execute -> Run the strategy

## explain vs explain analyze

Explain -> BUild a query plan and display info about it 
Explain analyze -> Build a query plan, run it, and info about it


# The framework
When a query is slow:
1. Understand the query

2. Inspect the execution plan
    - Sequential scans
    - Nested loops on large datasets
    - Hash joins vs merge joins
    - Row estimates vs actual rows

3. Identify the bottleneck
    - Is it scanning too much data?
    - is it joining inefficiently?
    - Is it sorting or grouping too much?

# Core optimization patterns

1. Indexing
Stop scanning everything
The question is "Why is the database reading so many rows just to find a few?"
A table without an index is like reading a whole book to find just a sentence
an when you add an index:
- Jumping directly to the page

They trade write cost for read speed

- Composite indexes
``` sql
WHERE user_id = 10 AND status = 'paid'

CREATE INDEX idx_orders_user_status ON orders(user_id, status);
```
- Covering index (avoid table access)

``` sql
SELECT user_id, status FROM orders WHERE user_id = 10;

CREATE INDEX idx_cover ON orders(user_id, status);
```

- Partial index

```
WHERE status = 'active'

CREATE INDEX idx_active_users ON users(id)
WHERE status = 'active';
```

2. Reduce data early (Filter pushdown)
Reduce rows before join

Bad:

``` sql
SELECT * FROM orders
JOIN users ON ...
WHERE users.country = 'MX';
```
Better:

``` sql
SELECT * FROM orders
JOIN (
  SELECT id FROM users WHERE country = 'MX'
) u ON ...
```

3. Avoid SELECT *
Bad:
``` sql
SELECT * FROM large_table;
```
Better:
``` sql
SELECT id, name FROM large_table;
```

This reduces:
- I/O
- Memory
- Network

# Cardinality estimation
Cardinality = How many rows PostgreSQL thinks each step will return

Everything depends on:
- index vs seq scan
- join type
- join order

# Join order optimization

In what order should we join?

Possible join orders:

```
(A JOIN B) JOIN C
(A JOIN C) JOIN B
(B JOIN C) JOIN A
```

## Example

Case 1

```
A → 1M rows
B → 1K rows
C → 10 rows
```

Best strategy:

```
(B JOIN C) → small result
→ then join with A
```

Case 2 

With a bad strategy

```
(A JOIN B) first → huge result
→ then join C
```

Explodes in size so this is slow

# How PostgreSQL chooses join order

1. Estimate size of each table

2. Estimate join selectivity

# Join Algorithms

1. Nested loop

```
for each row in A:
  scan B
```

Good when:
- A is small
- B is indexed

2. Hash join
Build a hash table on smaller table probe with larger table

Good when:
- Large datasets
- no index

3. Merge join

Sort both tables then merge

Good when:
- Already sorted
- Large joins

