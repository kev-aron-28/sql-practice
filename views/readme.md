Query to get the most tagged users

select username, count(*) from
users
join(
	select user_id from photo_tags
	union all
	select user_id from caption_tags

) as tags on tags.user_id = users.id
group by username
order by count(*) desc;

We've always need to do that union, maybe having separate tables
might be a bad design

Theres two way to solve this issue:
	- Merge the two tables, delete original ones
	- Create a view

Views:
Fake table that has rows from other tables
These can be exact rows as they exists on another table or a computed value
Can reference the view in any place where we'd normally reference a table
Views doesnt actually create a new table or move any data around
Doesnt have to be used for a union can compute any values

create view tags as (
	-- query inside	
);

# When to use a view?

create view recent_posts as (
	select * from posts
	order by created_at desc
	limit 10

);

TO update a view
create or replace view recent_posts as (
	-- query
);



# Materialized views
View: Query that gets executed every time you refer to it

Materialized view: Query that gets executed only at a very specific
times but the results are saved and can be referenced without rerunning
the query

