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

-- D. Subqueries

-- 1. Find users who spent above average
with total_spent_by_user as (
select o.user_id, sum(quantity * price_at_purchase) as total from orders o 
join order_items oi on oi.order_id = o.id
group by o.user_id
)

select user_id from total_spent_by_user where
total > (select avg(total) from total_spent_by_user);

-- 2. Get products priced above category average
WITH price_per_category AS (
    SELECT p.category, AVG(p.price) AS avg_price
    FROM products p
    GROUP BY p.category
)

SELECT *
FROM products p
WHERE p.price > (
    SELECT avg_price
    FROM price_per_category pc
    WHERE pc.category = p.category
);

-- 3. Find orders with total value greater than any single product price
with total_per_order as (
	select o.id, sum(oi.price_at_purchase * oi.quantity) as total from orders o
	join order_items oi on oi.order_id = o.id
	group by o.id
)

select id, total from total_per_order where total > any (select price from products) 

-- 4. Get users who made the most expensive order.

select o.id, sum(oi.price_at_purchase * oi.quantity) from orders o
join order_items oi on oi.order_id = o.id
group by o.id


-- 5. Find products that have the highest rating in their category.

select p.category, p."name", round(avg(r.rating),2) as avg_rating from products p left join reviews r
on r.product_id = p.id
group by p.category, p."name"
order by avg_rating desc




-- E. window functions

-- 1. Rank users by total spending.

WITH user_totals AS (
    SELECT u.id,
           COALESCE(SUM(oi.price_at_purchase * oi.quantity), 0) AS total_spent
    FROM users u
    LEFT JOIN orders o 
        ON o.user_id = u.id 
        AND o.status != 'cancelled'
    LEFT JOIN order_items oi 
        ON oi.order_id = o.id
    GROUP BY u.id
)

SELECT *,
       DENSE_RANK() OVER (ORDER BY total_spent DESC) AS rank
FROM user_totals
ORDER BY total_spent DESC;


-- 2. Dense rank products by price within category.
-- 3. Running total of revenue by date.
-- 4. For each order, show cumulative spending per user.
-- 5. Find the second most expensive product per category.
-- 6. Find top 2 users per country by spending.


-- F. CTEs

-- 1. Compute total revenue per user, then filter top 3.
-- 2. Build a query that calculates daily revenue.
-- 3. Find retention: users who logged in on consecutive days.
-- 4. Find first purchase date per user, then calculate days to second purchase.
-- 5. Build cohort analysis (group users by signup month and track orders).


-- G. Case + Conditional Aggregation

-- 1. Count orders by status per user.
-- 2. Calculate revenue split by payment method.
-- 3. Count how many 5-star reviews per product.
-- 4. Create a pivot:=columns: status (paid, pending, etc.) values: count of orders

-- H Analytics
-- 1. Find conversion rate: users who logged in vs users who purchased
-- 2. Funnel: login → purchase
-- 3. Find churned users: no activity in last X days
-- 4. Average time between first login and first purchase
-- 5. Lifetime value (LTV) per user


-- I. Graph / Social queries

-- 1. Find users with the most friends.
-- 2. Suggest friends (friends of friends not already friends).
-- 3. Find mutual friends between two users.
-- 4. Find users with at least 3 mutual connections.


-- J. Event-Based Queries (Time-Series)

-- 1. Daily active users (DAU).
-- 2. Count events per user per day.
-- 3. Find users who logged in but didn’t purchase.
-- 4. Sessionization: group events into sessions (30 min gap)
-- 5. Find peak activity hour.

-- K. Performacne / optimization thinking
-- 1. Add indexes to optimize: Order lookup by user, product filtering by category
-- 2. Rewrite a query to avoid subqueries
-- 3. Compare IN vs EXISTS
-- 4. Identify N + 1 query patterns
-- 5. 