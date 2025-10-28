create or replace function sell_product(p_product_id int, p_quantity int)
returns integer as $$
declare 
	current_stock integer := 0;
BEGIN
	select stock into current_stock from products where id = p_product_id;
	
	if current_stock is null then 
		raise EXCEPTION 'No enough';
	elsif current_stock < p_quantity THEN
		raise EXCEPTION 'not enough stock';
	end if;
	
	update products
	set stock = stock - quantity
	where id = p_product_id;
	
	insert into sales_log (product_id, quantity) values(p_product_id, p_quantity);
	
	return current_stock - p_quantity;
end;
$$
LANGUAGE plpgsql;
