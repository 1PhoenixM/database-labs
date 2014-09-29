-- Melissa Iori --
-- Lab 4 --

-- 1 --

select distinct city
from agents 
where aid in ( 
	select aid
	from orders 
	where cid in (
		select cid 
		from customers 
		where name='Tiptop'));

-- 2 --

select distinct pid
from orders
where aid in (
	select aid
	from orders
	where cid in (
		select cid
		from customers
		where city='Kyoto'));


-- 3 --

select cid,name
from customers
where cid not in (
	select cid
	from orders
	where aid='a04');

-- 4 --

select cid,name
from customers
where cid in (
	select distinct cid
	from orders
	where pid='p01' and cid in (
		select distinct cid
		from orders
		where pid='p07'));
	
-- 5 --

select pid
from orders 
where cid in ( 
	select cid
	from orders 
	where aid='a04');

-- 6 --

select name,discount
from customers
where cid in ( 
	 select cid
	 from orders
	 where aid in 
		(select aid
		 from agents
		 where city='Dallas' 
			or city='Newark'));

-- 7 --

select * 
from customers 
where discount in (
	select discount
	from customers 
	where city='Dallas' 
		or city='Kyoto' );