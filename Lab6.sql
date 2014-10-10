-- Melissa Iori --
-- Lab 5 --

-- 1 --

select c.name,c.city
from customers c,
	(select agg.city,max(product_total)
	from (select p.city,count(*) as product_total
	      from products p
	      group by p.city) agg
	 group by agg.city
	 order by max desc
	 limit 2) max_product_cities
where max_product_cities.city = c.city;	 

-- 2 --
-- The two cities are Dallas and Newark. But we only have Dallas
-- customers. --
select c.name,c.city
from customers c,
	(select agg.city,max(product_total)
	from (select p.city,count(*) as product_total
	      from products p
	      group by p.city) agg
	 group by agg.city
	 order by max desc
	 limit 2) max_product_cities
where max_product_cities.city = c.city;	 


-- 3 --

select *
from products
where priceusd > ( 
	select avg(priceusd)
	from products
);

-- 4 --

select c.name,o.pid,o.dollars
from orders o, customers c
where o.cid = c.cid 
order by o.dollars asc;

	
-- 5 --
-- to be revisited --
select c.name,c.cid,sum(),coalesce()
full outer join

-- 6 --

select a.name as Agent,c.name as Customer,p.name as Product
from agents a, customers c, products p, orders o
where o.cid = c.cid
	and o.pid = p.pid
	and o.aid = a.aid
	and a.city = 'New York';

-- 7 --

select o.*
from orders o, products p, customers c
where o.pid = p.pid
	and o.cid = c.cid
	and (p.priceusd * o.qty) - c.discount != o.dollars;
