-- Melissa Iori --
-- Lab 5 --

-- 1 --

select distinct a.city
from orders o, customers c, agents a
where o.cid = c.cid
	and o.aid = a.aid 
	and c.name = 'Tiptop';

-- 2 --
-- to be revisited --
select o.pid
from orders o, agents a, customers c
where c.city = 'Kyoto';

-- 3 --

select name
from customers
where cid not in (select cid from orders);


-- 4 --

select distinct customers.name
from orders
full outer join customers
on orders.cid=customers.cid
where orders.cid is null;
	
-- 5 --

select distinct a.name as Agent, c.name as Customer
from orders o, agents a, customers c
where a.city = c.city 
	and o.cid = c.cid
	and o.aid = a.aid;


-- 6 --

select a.name as Agent,c.name as Customer,a.city as City
from agents a, customers c
where a.city = c.city;

-- 7 --
-- to be revisited --
select aggregate.city,min(product_total)
from (select p.city,count(*) as product_total
      from products p
      group by p.city) aggregate, customers c
where aggregate.city = c.city
group by aggregate.city;