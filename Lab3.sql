-- Melissa Iori --
-- Lab 3 --

--1--

select name,city 
from agents 
where name='Bond';

--2--

select pid,name,quantity 
from products 
where priceusd>0.99;

--3--

select ordno,qty
from orders;

--4--

select name,city
from customers 
where city='Duluth';

--5--

select name
from agents 
where city<>'New York' 
	and city<>'London';

--6--

select *
from products 
where city<>'Dallas'
	and city<>'Duluth' 
	and priceusd<=1.00;

--7--

select *
from orders 
where mon='jan' 
	or mon='apr';

--8--

select *
from orders 
where mon='feb' 
	and dollars>200.00;

--9--

select *
from orders 
where cid='C005';
