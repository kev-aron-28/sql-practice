# Execution fundamentals

## Declarative vs Imperative thinking
In SQL you dont control: 
-  Iteration
- Indexing
- Join order
- access path
the query plan is in charge of that

# Query processing order
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. LIMIT

1. Get rows (FROM)
2. Apply joins
3. Filter rows (WHERE)
4. Group rows
5. Filter groups (HAVING)
6. Compute SELECT expressions
7. Sort results

# Explain

At a high level: EXPLAIN shows you the execution plan the PostgreSQL planner intends to use

It does not execute the query (by default)

- You ask PostgreSQL how would you run this?
- It responds with a plan tree

# What EXPLAIN ANALYZE is
EXPLAIN ANALYZE actually runs the query and shows what really happened


# Output


## COST
``` sql
(cost=0.15..8.17 rows=1 width=244)
```
- 0.15 → startup cost
- 8.17 → total cost
- rows=1 → estimated rows
- width=244 → estimated row size (bytes)

Cost is not time, its an internal unit used to compare plans

## ACTUAL

``` sql
(actual time=0.020..0.021 rows=1 loops=1)
```

- 0.020 → time to get first row
- 0.021 → time to get all rows
- rows=1 → actual rows returned
- loops=1 → how many times this node ran

# Estimated vs Actual

Case 1: Good estimation where both rows in estimated and actual match so there is a good plan
Case 2: Bad estimation where both rows in estimated and actual do not match so there is a bad plan

This matters because PostgreSQL chooses strategies based on estimates:

Fewer rows: index scan
Many rows: Seq scan

So if estimates are wrong: wrong strategy

# Reading the execution tree
Plans are trees (bottom-up execution)

```
Nested Loop
  -> Index Scan on users
  -> Index Scan on orders
```

How to read:
1. Start from the bottom
2. Each node feeds into the parent

# Common nodes
1. Seq scan
- Full table scan
- Reads everything
- Bad for large tables

2. Index Scan
- Uses index
- Good for selective queries

3. Bitmap index scan + Heap scan
- Used when multiple rows match
- Middle ground between index and seq scan

4. Nested loop
- For joins
- Good when one side is small

5. Hash join
- Builds hash table 
- Good for large joins

6. Merge join
- Requires sorted input
- Efficient for large sorted datasets


# Optimization workflow

1. Run

2. Compare
Look for:
- Estimated rows vs actual rows
- Big mismatches = problem

3. Identify bottleneck
Look for:
- Highest actual time
- highest loops
- expensive nodes

4. Ask why?
- Why seq scan? Missing index?
- WHy nested loop? Bad cardinality estimate?
- Why many loops? Bad join order?

5. Fix
- Add index
- Update statistics
- Rewrite query
- Reduce data early (Push filters down)


# Advanced insights

## Loops are dangerous
```
loops=10000
```

Means: That node ran 10,000 times, even small operations become expensive

## Width matters
- Large rows:
    - More memory
    - More I/O
    - Slower joins

## Timing vs cost mismatch
if cost is low but actual time is high then planner assumptions are wrong