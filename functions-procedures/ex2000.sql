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

-- 3. Deposit Money
create or replace procedure deposit (p_account_id int, p_amount numeric)
as $$
declare
	v_balance NUMERIC;
	v_status varchar;
begin

	if p_amount < 0 then
		raise exception 'Negative numbers not allowed';
	end if;
	
	select 
		balance into v_balance,
		status into v_status
	from accounts where id = p_account_id
	for update;
	
	if not found then 
		raise exception 'Account does not exists';
	end if;
	
	if v_status <> 'ACTIVE' then
		raise EXCEPTION 'Account is not active';
	end if;
	
	
	update accounts
	set balance = balance + p_amount
	where id = p_account_id;
	
	insert into transactions (account_id,type,amount,created_at) values 
	(p_account_id,'DEPOSIT',p_amount,now());

end;
$$ LANGUAGE plpgsql;

-- withdraw money
create or replace procedure withdraw(p_account_id int, p_amount NUMERIC)
as $$
declare
	v_status varchar;
	v_balance numeric;
BEGIN

	if p_amount <= 0 then
		raise exception 'No negative amounts';
	end if;
	
	select 
		balance into v_balance,
		status into v_status
	from accounts where id = p_account_id
	for update;
	
	
	if not found then 
		raise exception 'Account not found';
	end if;
	
	if v_status <> 'ACTIVE' then
		raise exception 'Account not active';
	end if;
	
	if p_amount > v_balance then
		raise exception 'Insuficcient funds';
	end if;
	
	update accounts
	set balance = balance - p_amount
	where id = p_account_id;
	
	insert into transactions (account_id,type,amount,created_at) values
	(p_account_id,'WITHDRAW',p_amount,now());
end;
$$ language plpgsql;

-- transfer money between accounts
create or replace procedure transfer(p_from int, p_to int, p_amount numeric)
as $$
declare
	v_from_status varchar;
	v_to_status varchar;
	v_from_balance numeric;
begin

	if p_amount <= 0 then
		raise EXCEPTION 'No negative amount';
	end if;
	
	if p_from = p_to then
		raise EXCEPTION 'Cannot transfer to same account';
	end if;
	
	perform id from accounts
	where id in (p_from, p_to)
	order by id
	for update;


	select balance, status into
	       v_from_balance, v_from_status
	 from accounts where id = p_from;
	 
	 if not found then
	 	raise exception 'From account not found';
	 end if;
	 
	 if v_from_status <> 'ACTIVE' then
	 	raise exception 'From account is not active';
	 end if;
	 
	 if v_from_balance < p_amount then
	 	raise exception 'Insufficient funds in from account';
	 end if;
	 
	 select status into v_to_status
	 from accounts where id = p_to;
	 
	 if not found then
	 	raise EXCEPTION 'to account not found';
	 end if;
	 
	 if v_to_status <> 'ACTIVE' then
	 	raise exception 'To account not active';
	 end if;
	 
	 -- From
	 update accounts
	 set balance = balance - p_amount
	 where id = p_from;
	 
	 -- To
	 
	 update accounts
	 set balance = balance + p_amount
	 where id = p_to;
	 
	INSERT INTO transactions(account_id, type, amount)
    VALUES (p_from, 'TRANSFER_OUT', p_amount);

    INSERT INTO transactions(account_id, type, amount)
    VALUES (p_to, 'TRANSFER_IN', p_amount);
	
end;
$$ language plpgsql;

