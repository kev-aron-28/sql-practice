When querying usually in a table, it has to load all data from
the heap file and the apply the filtering, so that is slow.

We try to minimize the data move from harddrive to ram memory.

Full table scan: PG has to load many rows from the heap file to memory
Poor performance.


# Whats an index?

Data structure that efficiently tell us what block/index a record is 
stored at.

# How an index works?
Extract only the property we want to do fast lookups by and the block/index
for each
Organize into a tree data structure. Evenly distribute values in the leaf
nodes, in order left to right

# HOw to create an index

create index username_index on users (username);

drop index username_index;

explain anaylize select *
from users
where usersname = '';


# Downside of indexes

You use some additional space to store the tree data strucuture
for indexes

Slows down insert/update/delete, the index has to be updated

# Index types
- B-tree index
- hash
- GiST
- SP-GiSt
- GIN
- BRIN

Postgres automatically creates an index for the primary key column
and for unique constraint column

select relname, relkind from pg_class
where kind = 'i';