CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    country TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE employees (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    department TEXT NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    manager_id BIGINT REFERENCES employees(id),
    hired_at DATE NOT NULL
);

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category_id BIGINT REFERENCES categories(id),
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customers(id),
    employee_id BIGINT REFERENCES employees(id),
    status TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    product_id BIGINT REFERENCES products(id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE projects (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    budget NUMERIC(12,2),
    start_date DATE,
    end_date DATE
);

CREATE TABLE project_members (
    project_id BIGINT REFERENCES projects(id),
    employee_id BIGINT REFERENCES employees(id),
    role TEXT NOT NULL,
    PRIMARY KEY(project_id, employee_id)
);

CREATE TABLE tasks (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT REFERENCES projects(id),
    assigned_to BIGINT REFERENCES employees(id),
    title TEXT NOT NULL,
    status TEXT NOT NULL,
    priority TEXT NOT NULL,
    due_date DATE,
    completed_at TIMESTAMP
);

CREATE TABLE task_comments (
    id BIGSERIAL PRIMARY KEY,
    task_id BIGINT REFERENCES tasks(id),
    employee_id BIGINT REFERENCES employees(id),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO customers(name, country, created_at) VALUES
('Alice', 'USA', '2025-01-10'),
('Bob', 'Canada', '2025-01-12'),
('Carlos', 'Mexico', '2025-01-15'),
('Diana', 'USA', '2025-02-01'),
('Eva', 'Germany', '2025-02-03');

INSERT INTO employees(name, department, salary, manager_id, hired_at) VALUES
('John', 'Engineering', 90000, NULL, '2022-01-10'),
('Sarah', 'Engineering', 75000, 1, '2023-03-15'),
('Mike', 'Engineering', 72000, 1, '2023-05-20'),
('Emma', 'Sales', 68000, NULL, '2021-07-11'),
('David', 'Sales', 60000, 4, '2024-01-05'),
('Sophia', 'Support', 55000, NULL, '2022-08-18');

INSERT INTO categories(name) VALUES
('Laptops'),
('Phones'),
('Accessories');


INSERT INTO products(name, category_id, price, stock) VALUES
('MacBook Pro', 1, 2500, 10),
('ThinkPad X1', 1, 1800, 15),
('iPhone 15', 2, 1200, 25),
('Galaxy S24', 2, 1100, 20),
('USB-C Dock', 3, 250, 50),
('Mechanical Keyboard', 3, 180, 40);


INSERT INTO products(name, category_id, price, stock) VALUES
('MacBook Pro', 1, 2500, 10),
('ThinkPad X1', 1, 1800, 15),
('iPhone 15', 2, 1200, 25),
('Galaxy S24', 2, 1100, 20),
('USB-C Dock', 3, 250, 50),
('Mechanical Keyboard', 3, 180, 40);


INSERT INTO orders(customer_id, employee_id, status, created_at) VALUES
(1, 4, 'paid', '2025-03-01'),
(2, 4, 'paid', '2025-03-02'),
(3, 5, 'pending', '2025-03-05'),
(1, 5, 'paid', '2025-03-10'),
(4, 4, 'cancelled', '2025-03-12'),
(5, 5, 'paid', '2025-03-15');



INSERT INTO order_items(order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 2500),
(1, 5, 2, 250),

(2, 3, 1, 1200),
(2, 6, 1, 180),

(3, 4, 2, 1100),

(4, 2, 1, 1800),
(4, 5, 1, 250),

(5, 1, 1, 2500),

(6, 3, 2, 1200),
(6, 6, 3, 180);


INSERT INTO projects(name, budget, start_date, end_date) VALUES
('ERP Migration', 150000, '2025-01-01', '2025-06-30'),
('Mobile App', 80000, '2025-02-01', '2025-08-01'),
('Internal Dashboard', 40000, '2025-03-01', '2025-05-30');


INSERT INTO project_members(project_id, employee_id, role) VALUES
(1, 1, 'Tech Lead'),
(1, 2, 'Backend Dev'),
(1, 3, 'Frontend Dev'),

(2, 2, 'Backend Dev'),
(2, 3, 'Frontend Dev'),
(2, 4, 'Project Manager'),

(3, 5, 'Analyst'),
(3, 6, 'Support');


INSERT INTO tasks(project_id, assigned_to, title, status, priority, due_date, completed_at) VALUES
(1, 2, 'Create API', 'done', 'high', '2025-03-10', '2025-03-09'),
(1, 3, 'Frontend UI', 'in_progress', 'medium', '2025-04-01', NULL),
(1, 1, 'Architecture Design', 'done', 'high', '2025-02-15', '2025-02-10'),

(2, 2, 'Push Notifications', 'todo', 'high', '2025-05-01', NULL),
(2, 4, 'Client Meetings', 'done', 'low', '2025-03-20', '2025-03-18'),

(3, 5, 'Business Analysis', 'done', 'medium', '2025-03-15', '2025-03-14'),
(3, 6, 'Support Documentation', 'in_progress', 'low', '2025-04-10', NULL);


INSERT INTO task_comments(task_id, employee_id, comment, created_at) VALUES
(1, 1, 'Looks good', '2025-03-05'),
(1, 2, 'API completed', '2025-03-09'),
(2, 3, 'Still working on UI', '2025-03-20'),
(4, 2, 'Need Firebase integration', '2025-04-01'),
(5, 4, 'Meeting successful', '2025-03-18'),
(6, 5, 'Analysis document delivered', '2025-03-14');


-- EXERCICE SET

-- Get all orders with: customer name, employee name && total order amount
select o.id ,c."name", e."name", sum(oi.quantity * oi.unit_price) from orders o
join order_items oi on oi.order_id = o.id
join employees e on o.employee_id = e.id
join customers c on o.customer_id = c.id
group by o.id, e.name, c."name";
-- Show all products that have never been ordered.
select p.name, p.category_id from products p 
left join order_items oi on oi.product_id = p.id 
where oi.id is null
-- Find customers that only placed paid orders
select * from orders o
join customers c on o.customer_id = c.id
where o.status = 'paid'
-- Show employees and the name of their manager.
select e."name", m."name" from employees e
join employees m on e.manager_id = m.id
where e.manager_id is not null

-- Get the top 3 customers by total money spent.
select c.name, coalesce(sum(oi.quantity * oi.unit_price), 0) as total_spent from customers c
left join orders o on o.customer_id = c.id
left join order_items oi on oi.order_id = o.id
group by c.id,c."name"
order by total_spent desc
limit 3

-- Show total sales per category.
select 
    c.name as category,
    coalesce(sum(oi.quantity * oi.unit_price), 0) as total_sales
from categories c
left join products p 
    on p.category_id = c.id
left join order_items oi 
    on oi.product_id = p.id
group by c.id, c.name
order by total_sales desc;

-- Show how many tasks each employee has by status.
select 
	e."name", 
	sum(
		case
			when t.status = 'in_progress' then 1
			else 0
		end
	) as in_progress,
	sum(
		case
			when t.status = 'done' then 1
			else 0
		end
	) as done,
	sum(
		case
			when t.status = 'todo' then 1
			else 0
		end
	) as pending
from employees e
left join tasks t on t.assigned_to = e.id
group by e."name";

-- Find projects where more than 50% of tasks are completed.
with total_tasks as (
	select 
	p."name", 
	count(t.id) as total_tasks, 
	sum(
		case 
		when t.status = 'done' then 1
		else 0
		end
	) as completed_tasks
from projects p
left join tasks t on t.project_id = p.id
group by p.id,p."name"
)


select 
    *
from total_tasks
where (
    completed_tasks * 100.0
) / total_tasks > 50;

-- Find employees whose salary is above their department average.
with avg_department as (
select e.department, round(avg(e.salary),2) as avg_salary from employees e
group by e.department
)

select * from employees e
join avg_department ad on e.department = ad.department
where e.salary > ad.avg_salary

-- Find customers who spent more than the average customer spending.
with total_spent_by_user as (
    select 
        c.id,
        c.name,
        coalesce(sum(oi.unit_price * oi.quantity), 0) as total_spent

    from customers c
    left join orders o 
        on o.customer_id = c.id
    left join order_items oi 
        on oi.order_id = o.id

    group by c.id, c.name
)


select *
from total_spent_by_user
where total_spent > (
    select avg(total_spent)
    from total_spent_by_user
);