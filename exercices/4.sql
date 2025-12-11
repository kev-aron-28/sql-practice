-- Empleados
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10,2),
    manager_id INT REFERENCES employees(id)
);

-- Clientes
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

-- Productos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50)
);

-- Pedidos
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    employee_id INT REFERENCES employees(id),
    order_date DATE
);

-- Detalles de pedidos
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT
);


-- Empleados
INSERT INTO employees (name, position, hire_date, salary, manager_id) VALUES
('Ana López', 'Gerente', '2020-01-01', 50000, NULL),
('Juan Pérez', 'Vendedor', '2021-06-15', 25000, 1),
('Carlos Ruiz', 'Vendedor', '2022-03-20', 24000, 1),
('María Sánchez', 'Asistente', '2023-01-10', 18000, 2);

-- Clientes
INSERT INTO customers (name, email, city) VALUES
('Luis García', 'luis@example.com', 'CDMX'),
('Sofía Martínez', 'sofia@example.com', 'Guadalajara'),
('Miguel Torres', 'miguel@example.com', 'Monterrey');

-- Productos
INSERT INTO products (name, price, category) VALUES
('Laptop', 15000, 'Electrónica'),
('Mouse', 500, 'Electrónica'),
('Escritorio', 2500, 'Muebles'),
('Silla', 1800, 'Muebles');

-- Pedidos
INSERT INTO orders (customer_id, employee_id, order_date) VALUES
(1, 2, '2024-03-01'),
(2, 3, '2024-03-02'),
(1, 2, '2024-03-05'),
(3, 2, '2024-03-10');

-- Detalles de pedidos
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 2),
(3, 2, 1),
(4, 1, 1),
(4, 3, 1);


-- Get all emlpoyees
select * from employees;

-- List all clients from Guadalagara
select * from customers where city = 'Guadalajara';

-- All products with price > 2000
select * from products where price > 2000; 

-- List all orders with clients name and employees name
select c.name, e.name, r.order_date from orders r 
join employees e on r.employee_id = e.id
join customers c on r.customer_id = c.id;

-- List products sold in each order (with quantity and total by product)
select p.name, p.price, o.quantity from order_items o
join products p on o.product_id = p.id;

-- Show all orders with its genera total
select o.order_id, sum(o.quantity * p.price) as total from order_items o
join products p on o.product_id = p.id
group by o.order_id
;

-- Count how many orders have managed each employee
select e."name", count(*) from orders o
join employees e on o.employee_id = e.id
group by e."name";

-- How much each client has spent
select o.customer_id, sum(p.price * oi.quantity)
from order_items oi
join products p on oi.product_id = p.id
join orders o on oi.order_id = o.id
group by o.customer_id;

-- How much has been spent by product category
select p.category, sum(oi.quantity * p.price) from order_items oi
join products p on oi.product_id = p.id
group by p.category;

-- Most sold produt by units
SELECT 
    p.id, 
    p.name,
    SUM(oi.quantity) AS total_cantidad
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_cantidad DESC
LIMIT 1;

-- Employees with no subordinates
select * from employees
where employees.id not in(select e.manager_id from employees e where e.manager_id is not NULL);