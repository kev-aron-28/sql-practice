Grouping
> Reduces many rows down to fewer rows
> Done by using the GROUP BY keyword
> Visualizing the result is key to use

select * from comments
GROUP BY user_id;

- Find the set of all unique user_id's
- Take each row and assign it to a group based on its user_id


Aggregates
> Redues many values down to one
> Done by using aggregate functions


SUM
AVG
COUNT
MIN
MAX


Mixed

select user_id , count(user_id) as nums_comments_created
from comments
group by user_id;

GROUP BY Groups rows by a unique set of values
HAVING Filters the set of gropus
