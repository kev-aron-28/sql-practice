Table: Collection of records

CREATE TABLE <name> (
  property type
);


insert into cities(name, population, area) values ('Test', 3999, 2933);

select * from cities;

\d check definition of table

\l list tables on postres table

# Calculated columns

select name, price * units_sold as revenue from phones;

# Strings operations

|| Concat

CONCAT()
LOWER()
LENGTH()
UPPER()

# Filtering with WHERE

select name, area from table where area > 4000;
select name, area from table where area between 2000 and 4000;
select name from table where name in (LIST) and area between 2000 and 4000;


=
>
<
>=
IN
<=
<>
!=
BETWEEN
NOT IN

# Execercise

select name, price from phones where units_sold > 5000;

select name, manufacturer from phones where manufacturer in ('Apple', 'Samsung');


# Updating rows

update <table> set <Property> = <Value> where <Property>=<Value>

delete from <table> where <property>=<value>
