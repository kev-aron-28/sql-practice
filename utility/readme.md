select greatest(28, 10 39);

select least(1,2,3);


select
  name,
  price,
  case
    when price > 100 then 'HIGH'
    when price > 200 then 'medium',
    else 'cheap'
  end
