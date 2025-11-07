-- -- create or REPLACE function update_timestap()
-- -- returns trigger as  $$
-- -- BEGIN
-- -- 	NEW.updated_at = NOW();
-- -- 	return NEW;
-- -- end;
-- -- $$
-- -- LANGUAGE plpgsql;


-- create trigger add_updated_at
-- before update on users
-- for each row
-- EXECUTE function update_timestap();


-- insert into users (name, email) values ('Kevin', 'kevaron_28@hotmail.com');

-- update users
-- set name  = 'Aron'
-- where id = 1;


-- CREATE TABLE user_logs (
--     log_id SERIAL PRIMARY KEY,
--     user_id INT,
--     old_name VARCHAR(100),
--     new_name VARCHAR(100),
--     changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );


-- create or replace function add_user_log()
-- returns trigger as $$
-- BEGIN
-- 	if new.name is DISTINCT from old.name THEN
-- 		insert into users_logs (user_id, old_name, new_name) values (new.id, old.name, new.name);
-- 	end if;
	
	
-- 	return new;

-- END;
-- $$ LANGUAGE plpgsql;

-- create trigger user_log
-- after update on users
-- EXECUTE function add_user_log();


update users
set name  = 'kevaron'
where id = 1;

