Null constraint

create table <> (
  field type not null
);


alter table <>
alter column <>
set not null;


alter table
drop constraint <name>;


alter table <>
add unique (<>, <>);


# Check validation

create table <> (
  <> <> check (<> >, <.. <>)
);


alter table products
add check(price > 0);


create table(

  ....,
  check(created_at < est_delivery)
);
