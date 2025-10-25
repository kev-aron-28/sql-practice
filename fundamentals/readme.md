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