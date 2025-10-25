create database library;
use library;


create table author(
	author_id int primary key,
	name varchar(100) not null,
	country varchar(50) not null
);

create table book(
	id int primary key,
	title varchar(20) not null,
	year date default  current_date,
	author_id int,
	category varchar(50)
	constraint fk_author foreing key (author_id) references author(author_id),
);


create table member(
	id serial primary key,
	name varchar(100) not null,
	email varchar(100) not null unique, 
	created_at date default current_date
);

create table loan(
	id serial primary key,
	book_id int, 
	member_id int,
	date_loan date not null,
	daet_refound date, 
	status varchar(50) check (status in ('pending', 'returned', 'lost')) default 'pending'
);


