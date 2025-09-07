create database instagram;

create table users (
  idw serial primary key,
  updated_at timestap with time zone default current_timestamp,
  created_at timestap with time zone default current_timestamp,
  username varchar(30) not null,
  bio varchar(300) not null default '',
  avatar varchar(200)
  phone_number varchar(40),
  email varchar(40) not null,
  status varchar(40) not null default "active",
  check(coalesce(email, phone) is not null),
  check(coalesce(email, password) is not null)
);


create table posts(
  id serial primary key,
  created_at timestap with time zone default current_timestamp,
  updated_at timestap with time zone default current_timestamp,
  url varchar(200) not null,
  caption varchar(50) default '',
  lat real check(lat is null or (lat >= -90 and lat <= 90)),
  lng real check(lng is null or (lng >= -180 and lng <= 180)),
  user_id integer not null references users(id)
);


create table comments(
  id serial primary key,
  created_at timestap with time zone default current_timestamp,
  updated_at timestap with time zone default current_timestamp,
  contents varchar(240) not null,
  user_id integer not null references users(id) on delete cascade,
  post_id integer not null references posts(id)
);


create table likes(
  id serial primary key,
  created_at timestap with time zone default,
  user_id integer not null references users(id) on delete cascade,
  post_id integer references posts(id) on delete cascade,
  comment_id integer references comments(id) on delete cascade,
  check(
    coalesce((post_id)::boolean::integer, 0)
    +
    coalesce((comment_id)::boolean:integer, 0)
    = 1
  ),
  unique(user_id, post_id, comment_id)
);


create table photo_tags(
  id serial primary key,
  created_at timestap with time zone default current_timestamp,
  updated_at timestap with time zone default current_timestamp,
  user_id integer not null references users(id) on delete cascade,
  post_id integer not null references posts(id) on delete cascade,
  x integer not null,
  y integer not null,
  unique(user_id, post_id)
);


create table caption_tags(
  id serial primary key,
  created_at timestap with time zone default current_timestamp,
  user_id integer not null references users(id) on delete cascade,
  post_id integer not null references posts(id) on delete cascade,
);


create table hashtags(
  id serial primary key,
  created_at timestap with time zone default current_timestamp,
  title varchar(20) not null unique,
);

create table hashtags_posts(
  id serial primary key,
  hashtag_id integer not null references hashtags(id) on delete cascade,
  post_id integer not null references posts(id) on delete cascade,
  unique(hashtag_id, post_id)
); 

-- User with 3 highst ids
select id from users
order by id DESC
limit 3;


-- Join the users and posts table show the username of user id 200
-- and the captions of all posts they have created

select username, captions from users
inner join posts 
on posts.user_id = users.id
where posts.user_id = 200;


-- show each username and the number of likes that they
-- have created

select username, count(*) from users
join likes on users.id = likes.user_id
group by username;

