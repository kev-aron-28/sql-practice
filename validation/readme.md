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


1. NOT NULL

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL
);

2. PRIMARY KEY
 CREATE TABLE users (
  id INT,
  email TEXT,
  CONSTRAINT users_pk PRIMARY KEY (id)
);
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL
);

3. UNIQUE
 
CREATE TABLE users (
  username TEXT UNIQUE,
  email TEXT UNIQUE
);


CONSTRAINT unique_user UNIQUE (username, email)

4. FOREING KEY
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE
);


CONSTRAINT fk_user FOREIGN KEY (user_id)
  REFERENCES users(id)
  ON UPDATE CASCADE
  ON DELETE SET NULL;


5. CHECK
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  salary NUMERIC CHECK (salary > 0),
  age INT CHECK (age >= 18 AND age <= 65)
);

CHECK (length(name) > 2)

6. DEFAULT
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW()
);



7. EXCLUSION CONSTRAINT
CREATE TABLE reservations (
  room_id INT,
  during TSRANGE,
  EXCLUDE USING GIST (room_id WITH =, during WITH &&)
);

8. GENERATED COLUMS (computed cols)
also supported since POstgres12
CREATE TABLE items (
  price NUMERIC,
  quantity INT,
  total NUMERIC GENERATED ALWAYS AS (price * quantity) STORED
);



9. Domain level check constriant

CREATE DOMAIN positive_int AS INT CHECK (VALUE > 0);

CREATE TABLE orders (
  quantity positive_int
);



10. DEFERRED constraint

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id) DEFERRABLE INITIALLY DEFERRED
);













































