-- Exercise 1 — Customer Tier
-- Create a function:

-- get_customer_tier(points INT)

-- Rules:

-- 0-99 → Bronze
-- 100-199 → Silver
-- 200+ → Gold

create or replace function get_customer_tier(points int)
returns text as $$
BEGIN

	if points < 100 then
		return 'Bronze';
	else if points >= 100 and points < 200 then
		return 'Silver';
	else
		return 'Gold';
	end if;

END;
$$ LANGUAGE plpgsql

--Exercise 2 — Product Tax
create or replace function calculate_tax(price numeric)
returns numeric as $$
begin
	return ((price * 16.0) / 100) + price;
end;
$$ LANGUAGE plpgsql

-- Exercise 3 — Full Order Status
-- get_order_label(order_status TEXT)

create or replace function get_order_label(order_status text)
returns text as $$
BEGIN
	
	if order_status = 'pending' then
		return 'Waiting payment';
	elsif order_status = 'paid' then
		return 'Completed';
	else
		return 'Cancelled order';
	
	end if;

end;
$$ LANGUAGE plpgsql;


-- Exercise 4 — Total Orders by Customer

-- Create a function that returns how many orders a customer has.

-- count_customer_orders(customer_id BIGINT)

create or replace function count_customer_orders(customer_id_p bigint)
returns int as $$
DECLARE
	total_orders int;
BEGIN
	select count(*) into total_orders
	from orders
	where customer_id = customer_id_p;
	
	return total_orders;

END;
$$ LANGUAGE plpgsql;


-- Exercise 5 — Customer Total Spent

-- Create a function:
-- get_total_spent(customer_id BIGINT)

CREATE OR REPLACE FUNCTION get_total_spent(customer_id_p BIGINT)
RETURNS NUMERIC(10,2) AS $$
DECLARE
    total_spent NUMERIC(10,2) := 0;
BEGIN

    SELECT COALESCE(SUM(o.total), 0)
    INTO total_spent
    FROM orders o
    WHERE o.customer_id = customer_id_p
      AND o.status = 'paid';

    RETURN total_spent;

END;
$$ LANGUAGE plpgsql;



-- Exercise 6 — Product Stock Validation

-- Create a function:

-- has_enough_stock(product_id BIGINT, requested_quantity INT)

create or replace function has_enough_stock(product_id_p bigint, requested_quantity_p int)
returns boolean as $$
DECLARE
	current_stock int;
BEGIN
	select stock into current_stock
	from products
	where id = product_id_p;
	
	if not found then
		raise EXCEPTION 'Product not found';
	end if;
	
	
	return requested_quantity_p <= current_stock;
END;
$$ LANGUAGE plpgsql;


-- Exercise 7 — Products by Category

-- Create a function returning a table:




DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    country TEXT NOT NULL,
    loyalty_points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    status TEXT NOT NULL DEFAULT 'pending',
    total NUMERIC(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    product_id BIGINT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    amount NUMERIC(10,2) NOT NULL,
    payment_method TEXT NOT NULL,
    paid_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    action TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO customers (full_name, email, country, loyalty_points)
VALUES
('Kevin Tapia', 'kevin@example.com', 'Mexico', 120),
('Ana Lopez', 'ana@example.com', 'Mexico', 50),
('John Smith', 'john@example.com', 'USA', 300),
('Maria Garcia', 'maria@example.com', 'Spain', 0);

INSERT INTO products (name, category, price, stock)
VALUES
('Laptop', 'Electronics', 25000.00, 10),
('Mouse', 'Electronics', 500.00, 100),
('Keyboard', 'Electronics', 1200.00, 50),
('Desk', 'Furniture', 3500.00, 20),
('Chair', 'Furniture', 1800.00, 15);

INSERT INTO orders (customer_id, status, total)
VALUES
(1, 'paid', 26000),
(2, 'pending', 1700),
(3, 'paid', 3500),
(1, 'cancelled', 500);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 25000),
(1, 2, 2, 500),
(2, 3, 1, 1200),
(2, 2, 1, 500),
(3, 4, 1, 3500),
(4, 2, 1, 500);

INSERT INTO payments (order_id, amount, payment_method)
VALUES
(1, 26000, 'credit_card'),
(3, 3500, 'paypal');