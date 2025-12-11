# DDL Data definition lenguage
used to define or modify db structure:
-create
alter
drop
truncate
rename
comment

# DML Data manipulation language
used to work with data inside tables
select
insert
update
delete

# DCL Data control language
grant
revoke

# TCL Transaction control language
commit
rollback
savepoint
set transaction



# Execices

create table users (
    id serial primary key,
    nombre varchar(100),
    edad int,
    correo varchar(100)  
);

# add column

alter table users
add column created_at date default current_date;

# Change table name
alter table users
rename to clients;

#Change column name
alter table users
rename column edad to email;

# Chage data type
alter table clientes
alter column edad type smallint;

# Drop column
alter table clientes
drop column created_at;

# Add check

alter table clientes
add constraint unique_email unique (email);

alter table clientes
add constraint check_edad check(edad >= 0);

# Eliminar restricciones 
alter table clientes
drop table unique_email;

# create index
create index idx_clients_email on clientes(email);

# Drop table
drop table clientes;

# Defining a primary key
A.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);


B.
CREATE TABLE users (
  id SERIAL,
  name TEXT NOT NULL,
  PRIMARY KEY (id)
);

or 

CREATE TABLE orders (
  user_id INT,
  product_id INT,
  PRIMARY KEY (user_id, product_id)
);

C. WIth constraint
CREATE TABLE users (
  id INT,
  name TEXT NOT NULL,

  CONSTRAINT pk_users PRIMARY KEY (id)
);

# Foreing key

A.

CREATE TABLE orders (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id INT REFERENCES users(id)
);

user_id INT REFERENCES users(id) ON DELETE CASCADE


B. 
CREATE TABLE orders (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id INT,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CONSTRAINT fk_orders_user
  FOREIGN KEY (user_id)
  REFERENCES users(id)

create table t (
    id serial primary key,
    user_id int,
    constraint fk_user_id foreign key (user_id) references user(id) on delete cascade on update cascade
)