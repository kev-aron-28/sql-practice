select
	users.username,
	tags.created_at
from users
join(
	select user_id, created_at from caption_tags
	union all
	select user_id, created_at from photo_tags
) as tags on tags.user_id = users.id
where tags.created_at < '2010-01-07';


So this is kinda difficult to read
so thats where CTE

WITH tags as (
	select user_id, created_at from caption_tags
        union all
        select user_id, created_at from photo_tags
)

select username, tags.created_at
from users
join tags on tags.user_id = users.user_id
where ...

- Defined with a with before the main query
- Produces a table that we can refer to anywhere else
- There are two ways:
	- Simple form used to make a query easier to understand
	- Recursive form used to write queries that are otherwise impossible


# Important notes
Recursive CTE are very different from simple CTE's

Useful any tome you have a tree or graph-type data structure

must use a union keyword

This is super super advance

with recursive countdown(val) as (
	select 3 as val -- no recursive query. initial
	union
	select val - 1 from countdown where val > 1 -- recursive query
)
select * from countdown;

# Explanation

This builds two tables
Working table
Result table

Graph type or tres really usefuly


with recursive suggestions(leader_id, follower_id, d) as (
	
)




