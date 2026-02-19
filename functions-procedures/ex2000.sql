CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    balance NUMERIC(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(id),
    type VARCHAR(20), -- DEPOSIT, WITHDRAW, TRANSFER_IN, TRANSFER_OUT
    amount NUMERIC(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (name, email, country) VALUES
('Alice Johnson', 'alice@mail.com', 'USA'),
('Bob Smith', 'bob@mail.com', 'USA'),
('Carlos Ruiz', 'carlos@mail.com', 'Mexico');

INSERT INTO accounts (customer_id, balance) VALUES
(1, 1000.00),
(2, 500.00),
(3, 2000.00);

INSERT INTO transactions (account_id, type, amount) VALUES
(1, 'DEPOSIT', 1000.00),
(2, 'DEPOSIT', 500.00),
(3, 'DEPOSIT', 2000.00);


-- 1. Function: Get Account Balance
-- get_account_balance(p_account_id INT)
-- RETURNS NUMERIC
create or replace function get_account_balance(p_account_id int)
returns numeric as $$
declare
	current_balance NUMERIC := 0.0;
begin
	select
		balance into current_balance
	from accounts
	where customer_id = p_account_id;
	
	return current_balance;
end;
$$ LANGUAGE plpgsql;

select get_account_balance(1)

-- 2. Function: Count Customer Accounts
create or replace function count_customer_accounts(p_customer_id int)
returns integer as $$
declare
	total_accounts integer := 0;

begin
	select 
		count(customer_id) into total_accounts
	from accounts
	where customer_id = p_customer_id;

	return total_accounts;
end;
$$ LANGUAGE plpgsql;

-- 3. 