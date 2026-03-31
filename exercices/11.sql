CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    country TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    status TEXT CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled')),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT NOT NULL,
    price_at_purchase NUMERIC(10,2) NOT NULL
);

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    amount NUMERIC(10,2),
    method TEXT,
    paid_at TIMESTAMP
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE friendships (
    user_id INT,
    friend_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, friend_id)
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    user_id INT,
    event_type TEXT,
    event_time TIMESTAMP
);

INSERT INTO users (name, email, country, created_at) VALUES
('Alice', 'alice@mail.com', 'US', '2023-01-01'),
('Bob', 'bob@mail.com', 'MX', '2023-01-02'),
('Charlie', 'charlie@mail.com', 'MX', '2023-01-05'),
('Diana', 'diana@mail.com', 'US', '2023-02-01'),
('Eve', 'eve@mail.com', 'CA', '2023-02-10');

INSERT INTO products (name, category, price) VALUES
('Laptop', 'electronics', 1000),
('Phone', 'electronics', 700),
('Keyboard', 'electronics', 100),
('Chair', 'furniture', 200),
('Desk', 'furniture', 400);

INSERT INTO orders (user_id, status, created_at) VALUES
(1, 'paid', '2023-03-01'),
(2, 'paid', '2023-03-02'),
(3, 'cancelled', '2023-03-03'),
(1, 'shipped', '2023-03-05'),
(4, 'pending', '2023-03-06');

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 1000),
(1, 3, 2, 100),
(2, 2, 1, 700),
(2, 3, 1, 100),
(3, 4, 1, 200),
(4, 5, 1, 400);

INSERT INTO payments (order_id, amount, method, paid_at) VALUES
(1, 1200, 'card', '2023-03-01'),
(2, 800, 'paypal', '2023-03-02'),
(4, 400, 'card', '2023-03-05');

INSERT INTO reviews (user_id, product_id, rating) VALUES
(1, 1, 5),
(2, 1, 4),
(3, 2, 3),
(4, 3, 5),
(5, 1, 2);

INSERT INTO friendships VALUES
(1,2), (2,1),
(1,3), (3,1),
(2,3), (3,2),
(4,1);

INSERT INTO events (user_id, event_type, event_time) VALUES
(1, 'login', '2023-03-01'),
(1, 'purchase', '2023-03-01'),
(2, 'login', '2023-03-02'),
(3, 'login', '2023-03-03'),
(3, 'logout', '2023-03-03'),
(1, 'login', '2023-03-04');

-- A. Basic

-- 1. Find all users from Mexico
select name, country from users where country = 'MX';

-- 2. Count total users per country
select country, count(*) as total_users from users group by country;

-- 3. Find total revenue (only paid/shipped orders)
select sum(p.amount) from orders o join payments p on p.order_id = o.id
where o.status = 'shipped' or o.status = 'paid';

-- 4. Get average product price per category
select category, round(avg(price),2) from products group by category;

-- 5. Find users who never placed an order

select u."name" from users u left join orders o on o.user_id = u.id
where o.id is null;

-- 6. Find top 3 most expensive products

with rnk as (
select category, name, price, DENSE_RANK() over (order by price desc) as rnk from products
)

select * from rnk where rnk <= 3; 

-- 7. Count how many orders each user made
select 
	u."name",
	count(*)
from users u left join orders o on o.user_id = u.id
group by u.name;

-- B. Joins

-- 1. Get all orders with username
select u.name, o.id as order_id from users u join orders o
on o.user_id = u.id;

-- 2. Get all order items with product name
select o.id as order_id, p."name" from orders o join order_items oi on oi.order_id = o.id join products p on oi.product_

-- 3. FInd all total spent per user
select o.user_id, sum(p.amount) as total from orders o join payments p on p.order_id = o.id
group by o.user_id
order by total desc;

-- 4. Find all users who bought a laptop
select u."name", p."name" from orders o
join order_items oi on oi.order_id = o.id
join products p on oi.product_id = p.id
join users u on o.user_id = u.id
where p."name" = 'Laptop'
;


-- 5. Find products that were never purchased
select p."name" from products p 
left join order_items oi on oi.order_id = p.id
where oi.id is null

-- 6. Get orders with missing payments

select * from orders o 
left join payments p on p.order_id = o.id
where p.id is null;

-- 7. Find users who reviewed products they never bought

select r.user_id from reviews r
where not exists (
	select 1 from orders o 
	join order_items oi on oi.order_id = o.id
	where oi.product_id = r.product_id and
	o.user_id = r.user_id
)

-- C. Grouping + Having

-- 1. Users who spent more that 1000

select * from users u 
join orders o on o.user_id = u.id
join payments p on p.order_id = o.id
where p.amount > 1000;

-- 2. Products with avg rating > 4
select r.product_id, round(avg(r.rating),2) as rating from reviews r group by r.product_id


-- 3. Categories with total revenue > 1500

select p.category, sum(oi.price_at_purchase * oi.quantity) as total_revenue from products p 
join order_items oi on oi.product_id = p.id
group by p.category
having sum(oi.price_at_purchase * oi.quantity) > 1500

-- 4. Users with more than 2 orders

select u."name", count(*) from users u 
join orders o on o.user_id = u.id
group by u."name"
having count(*) > 1;

-- 5. Products bought more than 3 times total
select p."name", count(*) from products p join order_items oi on oi.product_id = p.id
group by p."name";

