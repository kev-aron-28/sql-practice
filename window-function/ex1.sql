
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    created_at DATE
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    order_date DATE,
    status VARCHAR(30), -- delivered, cancelled, pending
    total NUMERIC(10,2)
);


CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    unit_price NUMERIC(10,2)
);

INSERT INTO customers (name, email, country, created_at) VALUES
('Kevin Tapia', 'kevin@mail.com', 'Mexico', '2023-01-10'),
('Ana Lopez', 'ana@mail.com', 'Mexico', '2023-02-15'),
('John Smith', 'john@mail.com', 'USA', '2023-03-01'),
('Maria Garcia', 'maria@mail.com', 'Spain', '2023-04-12');

INSERT INTO orders (customer_id, order_date, status, total) VALUES
(1, '2024-01-10', 'delivered', 1200),
(1, '2024-02-05', 'delivered', 800),
(1, '2024-03-01', 'cancelled', 500),
(2, '2024-01-15', 'delivered', 300),
(2, '2024-02-20', 'delivered', 450),
(3, '2024-01-25', 'delivered', 2000),
(3, '2024-03-05', 'delivered', 1800),
(4, '2024-02-10', 'pending', 700);

INSERT INTO order_items (order_id, product_name, category, quantity, unit_price) VALUES
-- Pedido 1
(1, 'Laptop', 'Electronics', 1, 1200),

-- Pedido 2
(2, 'Keyboard', 'Electronics', 2, 200),
(2, 'Mouse', 'Electronics', 1, 400),

-- Pedido 3
(3, 'Monitor', 'Electronics', 1, 500),

-- Pedido 4
(4, 'Book SQL', 'Books', 3, 100),

-- Pedido 5
(5, 'Headphones', 'Electronics', 1, 450),

-- Pedido 6
(6, 'iPhone', 'Electronics', 1, 2000),

-- Pedido 7
(7, 'Tablet', 'Electronics', 2, 900),

-- Pedido 8
(8, 'Desk Chair', 'Furniture', 1, 700);


-- ==================== EJERCICIOS =================================

-- Ranking de productos más vendidos por categoría
with product_sales as (
	select
		category,
		product_name,
		
		SUM(quantity) as total_pieces
	from order_items
	group by category, product_name
)

select 
	category,
	product_name,
	total_pieces,
	DENSE_RANK() over (PARTITION by category order by total_pieces)
from product_sales;

-- Participación de cada producto dentro de su categoría
-- Qué porcentaje representa cada producto dentro del total vendido en su categoría.

with product_sales as (
	select
		category,
		product_name,
		sum(sum(quantity * unit_price)) over (PARTITION by category) as total_per_category,
		SUM(quantity * unit_price) as total_sold
	from order_items
	group by category, product_name
)

select 
	category,
	product_name,
	total_sold,
	total_per_category,
	ROUND(100 * (total_sold / total_per_category), 2),
	DENSE_RANK() over (PARTITION by category order by total_sold)
from product_sales;

-- Producto más caro dentro de cada pedido
with orders_by_rank as (
select 
	order_id,
	product_name,
	unit_price,
	DENSE_RANK() over (PARTITION by order_id order by unit_price desc) as rnk
from order_items
)

select order_id, product_name, unit_price from orders_by_rank
where rnk = 1;

-- Ticket promedio por categoría (pero manteniendo cada fila)
select 
	order_id,
	category,
	avg(quantity * unit_price) over(partition by category)
from order_items;

-- Acumulado de ventas por categoria en el tiempo

select 
	oi.category, 
	order_date, 
	sum(quantity * unit_price) as total_per_day,
	sum(sum(quantity * unit_price)) over (partition by category order by o.order_date)
	from order_items oi join orders o on oi.order_id = o.id
where status = 'delivered'
group by o.order_date,oi.category
order by o.order_date asc;

-- Comparar cada producto contra el producto mas caro de su categoria
select	
	category,
	product_name,
	unit_price,
	first_value(unit_price) over (partition by category order by unit_price desc)
from order_items;

-- Top 2 productos por pais

select * from 
(
	select 
	c.country, 
	oi.product_name, 
	sum(oi.unit_price * oi.quantity) as total_per_product,
	rank() over (partition by country order by sum(oi.unit_price * oi.quantity) desc) as ranking
	from customers c 
	join orders o on o.customer_id = c.id
	join order_items oi on oi.order_id = o.id
	group by c.country, oi.product_name
	order by sum(oi.unit_price * oi.quantity) desc
) t
where ranking <= 2
order by country, ranking;