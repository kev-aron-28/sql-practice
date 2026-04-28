create database logistics_systems;

use logistics_systems;

create table users (
    id serial primary key,
    name varchar(100) not null,
    email varchar(50) not null unique,
    created_at timestamp default current_timestamp
)

create table tasks(
    id serial primary key,
    title varchar(50) not null,
    description text,
    status varchar(20) default 'pending' check (status in ('pending','in_progress','completed')),
    due_date date check (due_date >= current_date),
    created_at timestamp default current_timestamp,

)

create table vehicles (
    id serial primary key,
    plate_number varchar(10) unique,
    model text,
    year int check (year >= 2000),
    status varchar(100) default 'active' check (status in ('active','maintenance','retired'))
)

create table task_assignments (
    id serial primary key,
    user_id int references users(id) on delete cascade on update cascade,
    task_id int,
    assigned_at date,

    constraint u_user_task unique (user_id, task_id),
    constraint fk_task_id foreing key (task_id) references tasks(id) on delete cascade on update cascade  
)

create table vehicle_assignments (
    id serial primary key,
    user_id int references users(id) on delete cascade on update cascade,
    vehicle_id references vehicles(id) on delete cascade on update cascade,
    assigned_at date default current_date
)

create table incidents (
    id serial primary key,
    user_id int,
    description text,
    severity int check (severity >= 1 and severity <= 5),
    created_at timestamp default current_timestamp,
    constraint fk_user foreing key (user_id) references users(id) on delete cascade on update cascade
)

create table user_scores(
    user_id int,
    month varchar(15),
    year int,
    score int,

    constraint pk_user_scores foreing key (user_id, month, year)
)

create index idx_user_email on users(email);
create index idx_tasks_status on tasks(status);
create index idx_tasks_composite on task_assignments(user_id, assigned_at);

alter table tasks
rename column title to task_title;

alter table tasks
alter column status type varchar(20);

alter table tasks
add column priority varchar(50) default 'medium';

alter table users
add column role varchar(50) default 'employee';

alter table users
add constraint check_role check (role in ('admin', 'employee'));

alter table vehicles
drop column year;
