CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    order_date DATE,
    status VARCHAR(20)
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_name VARCHAR(100),
    quantity INT,
    price NUMERIC(10,2)
);

INSERT INTO customers (name, city) VALUES
('Kevin', 'CDMX'),
('Ana', 'Monterrey'),
('Luis', 'Guadalajara'),
('Maria', 'CDMX'),
('Pedro', 'Puebla');

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-01-10', 'completed'),
(1, '2026-01-20', 'completed'),
(1, '2026-02-02', 'cancelled'),

(2, '2026-01-15', 'completed'),
(2, '2026-03-01', 'completed'),

(3, '2026-02-10', 'completed'),

(4, '2026-01-01', 'completed'),
(4, '2026-01-05', 'completed'),
(4, '2026-03-20', 'completed');

INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1,'Laptop',1,25000),
(1,'Mouse',2,500),

(2,'Keyboard',1,1500),

(3,'Laptop',1,25000),

(4,'Monitor',2,4000),

(5,'Mouse',3,500),
(5,'Keyboard',1,1500),

(6,'Laptop',1,25000),
(6,'Monitor',1,4000),

(7,'Mouse',5,500),

(8,'Laptop',1,25000),
(8,'Keyboard',2,1500),

(9,'Monitor',2,4000),
(9,'Mouse',2,500);


-- Obtén todos los clientes junto con la cantidad de órdenes que han realizado.
-- Obtén todos los clientes junto con la cantidad de órdenes que han realizado.
select c.name, count(o.id) from customers c left join orders o on o.customer_id = c.id
group by c.id,c."name"
-- Calcula el total gastado por cada cliente.
select c.name, coalesce(sum(quantity * price),0) from customers c 
left join orders o on o.customer_id = c.id
left join order_items oi on oi.order_id = o.id
group by c.id, c."name"
-- Encuentra el cliente que más dinero ha gastado.
select c.name, coalesce(sum(quantity * price),0) as total from customers c 
left join orders o on o.customer_id = c.id
left join order_items oi on oi.order_id = o.id
group by c.id, c."name"
order by total desc
limit 1
-- Obtén los productos más vendidos por cantidad.
select oi.product_name, count(*) from order_items oi
group by oi.product_name
-- ¿Qué clientes nunca han realizado una orden?
select * from customers c left join orders o on o.customer_id = c.id
where o.id is null
-- Para cada orden calcula Total de productos, Total de dinero, Número de artículos diferentes
select o.id, count(*), sum(price * quantity) from orders o join order_items oi on oi.order_id = o.id
group by o.id

-- Obtén el promedio de compra por cliente.
select c.name, COALESCE(avg(quantity * price), 0) as avg_purchase from customers c
left join orders o on o.customer_id = c.id
left join order_items oi on oi.order_id = o.id
group by c.id, c.name

-- Encuentra la ciudad que más dinero ha generado.
select c.city, COALESCE(sum(quantity * price),0) as total from customers c
left join orders o on o.customer_id = c.id
left join order_items oi on oi.order_id = o.id
group by c.city
order by total desc
limit 1

-- Obtén el porcentaje de ventas que representa cada cliente respecto al total.
select c.city, COALESCE(sum(quantity * price),0),  COALESCE(sum(quantity * price),0) * 100 / (select sum(quantity * price) from order_items) as total from customers c
left join orders o on o.customer_id = c.id
left join order_items oi on oi.order_id = o.id
group by c.id, c.name
order by total desc

-- Obtén el porcentaje de ventas que representa cada cliente respecto al total.
with total_per_client as (
	select c.name, COALESCE(sum(quantity * price),0) as total from customers c
	left join orders o on o.customer_id = c.id
	left join order_items oi on oi.order_id = o.id
	group by c.id, c.name
	order by total desc
)

select name, total, DENSE_RANK() over (order by total desc) from total_per_client

-- Para cada cliente muestra: fecha de compra, monto, acumulado histórico

WITH order_totals AS (
    SELECT
        o.id,
        o.customer_id,
        o.order_date,
        SUM(oi.quantity * oi.price) AS total
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY
        o.id,
        o.customer_id,
        o.order_date
)
SELECT
    c.name,
    ot.order_date,
    ot.total,
    SUM(ot.total) OVER (
        PARTITION BY c.id
        ORDER BY ot.order_date
    ) AS running_total
FROM customers c
JOIN order_totals ot
    ON ot.customer_id = c.id
ORDER BY
    c.id,
    ot.order_date;

-- Obtén la diferencia entre una compra y la compra anterior de cada cliente.

WITH totals AS (
    SELECT
        c.id AS customer_id,
        c.name,
        o.id AS order_id,
        o.order_date,
        SUM(oi.quantity * oi.price) AS total
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.id
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY
        c.id,
        c.name,
        o.id,
        o.order_date
)
SELECT
    order_id,
    name,
    order_date,
    total,
    total - LAG(total) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS difference
FROM totals
ORDER BY
    customer_id,
    order_date;

-- Obtén el tiempo (en días) entre compras consecutivas de cada cliente.
WITH totals AS (
    SELECT
        c.id AS customer_id,
        c.name,
        o.id AS order_id,
        o.order_date,
        SUM(oi.quantity * oi.price) AS total
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.id
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY
        c.id,
        c.name,
        o.id,
        o.order_date
)
SELECT
    order_id,
    name,
    order_date,
    total,
    order_date - LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS difference
FROM totals
ORDER BY
    customer_id,
    order_date;

-- Encuentra la primera y la última compra de cada cliente usando Window Functions.

WITH totals AS (
    SELECT
        c.id AS customer_id,
        c.name,
        o.id AS order_id,
        o.order_date,
        SUM(oi.quantity * oi.price) AS total
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.id
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY
        c.id,
        c.name,
        o.id,
        o.order_date
)
SELECT
    order_id,
    name,
    order_date,
    total,
    FIRST_VALUE(order_date) over (partition by name order by order_date asc),
    last_value(order_date) over (partition by name order by order_date rows between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING)
FROM totals
ORDER BY
    customer_id,
    order_date;


-- Obtén el cliente cuyo ticket promedio sea mayor.

-- Encuentra los clientes que compraron en enero pero nunca volvieron a comprar.
SELECT
    c.id,
    c.name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND EXTRACT(MONTH FROM o.order_date) = 1
)
AND NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND o.order_date > DATE '2026-01-31'
);

-- Encuentra los clientes que compraron al menos un Laptop y también un Monitor, pero nunca un Keyboard.
select * from customers c
where exists (
	select 1 from orders o
	join order_items oi on oi.order_id = o.id and o.customer_id = c.id
	where oi.product_name = 'Laptop'
)
and exists(
	select 1 from orders o
	join order_items oi on oi.order_id = o.id and o.customer_id = c.id
	where oi.product_name = 'Monitor'
)
and not exists(
	select 1 from orders o
	join order_items oi on oi.order_id = o.id and o.customer_id = c.id
	where oi.product_name = 'Keyboard'
)