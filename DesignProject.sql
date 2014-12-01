-- Melissa Iori --
-- Travaria DB Implementation --
-- Tested with PostgresSQL 9.3 --

-- Set up a new database with pgAdmin III. --
-- Select the new database and click on the SQL tool. --
-- Copy and paste this script in its entirety into the text editor. --
-- Click "Run" to create and populate the database. --

drop view if exists Politicians_As_Governors_and_Mayors;
drop view if exists Climate;

drop table if exists Jurisdiction_Of_Natural_Locations;
drop table if exists Governor_Terms;
drop table if exists Mayor_Terms;
drop table if exists Notable_Residents;
drop table if exists Cities;
drop table if exists States;
drop table if exists Lakes;
drop table if exists Forests;
drop table if exists Mountains;
drop table if exists Mayors;
drop table if exists Governors;
drop table if exists People;
drop table if exists Political_Locations;
drop table if exists Natural_Locations;
drop table if exists Locations;

drop type if exists industry;
drop type if exists natural_resource;

create type industry as enum('mining', 'timber', 'oil_refinement', 'technology', 'agriculture', 'fishing', 'textiles');
create type natural_resource as enum('gold', 'silver', 'oil', 'wood', 'petroleum', 'salmon', 'soil');

create table People (
	pid text primary key,
	first_name text,
	last_name text,
	date_of_birth_us_format text
);

create table Governors (
	gid text references People(pid),
	approval_rating int,
	check (approval_rating <= 100),
	primary key(gid)
);

create table Mayors (
	ma_id text references People(pid),
	approval_rating int,
	check (approval_rating <= 100),
	primary key(ma_id)
);


create table Locations (
	lo_id text primary key,
	location_name text,
	latitude int,
	longitude int,
	area_square_miles int,
	tourists_per_year int,
	unique(latitude, longitude)
);

create table Political_Locations (
	pl_id text references Locations(lo_id),
	population int,
	primary key(pl_id)
);

create table Natural_Locations (
	nl_id text references Locations(lo_id),
	avg_revenue_per_year_usd int,
	protected_status boolean default false,
	primary key(nl_id)
);

create table States (
	sid text references Political_Locations(pl_id),
	current_governor text references Governors(gid),
	avg_yearly_temperature_fahrenheit int,
	avg_yearly_precipitation_inches int,
	gross_state_product_usd bigint,
	main_industry industry,
	main_natural_resource natural_resource,
	year_annexed int default 1777,
	check (year_annexed >= 1777),
	primary key(sid),
	unique(current_governor)
);

create table Cities (
	cid text references Political_Locations(pl_id),
	current_mayor text references Mayors(ma_id),
	state text references States(sid),
	is_capital boolean default false,
	year_settled int default 1777,
	check (year_settled >= 1777),
	primary key(cid),
	unique(current_mayor)
);

create table Notable_Residents (
	nr_id text references People(pid),
	living boolean default true,
	city_of_residence text references Cities(cid),
	primary key(nr_id)
);

create table Lakes (
	la_id text references Natural_Locations(nl_id),
	depth_feet int,
	primary key(la_id)
);

create table Forests (
	fid text references Natural_Locations(nl_id),
	percentage_of_paths_open_to_tourists int,
	check (percentage_of_paths_open_to_tourists <= 100),
	primary key(fid)
);

create table Mountains (
	mo_id text references Natural_Locations(nl_id),
	height_feet int,
	primary key(mo_id)
);

create table Governor_Terms (
	gid text references Governors(gid),
	sid text references States(sid),
	year_term_started int not null,
	year_term_ended int,
	check (year_term_started >= 1777),
	check (year_term_ended >= 1777 and year_term_ended >= year_term_started)
);
	
create table Mayor_Terms (
	ma_id text references Mayors(ma_id),
	cid text references Cities(cid),
	year_term_started int not null,
	year_term_ended int,
	check (year_term_started >= 1777),
	check (year_term_ended >= 1777 and year_term_ended >= year_term_started)
);
	
create table Jurisdiction_Of_Natural_Locations (
	sid text references States(sid),
	nl_id text references Natural_Locations(nl_id)
);

insert into People (pid, first_name, last_name, date_of_birth_us_format)
values ('p01', 'Glen', 'Forester', '10/20/1950'),
	   ('p02', 'Esther', 'Segwin', '05/06/1965'),
	   ('p03', 'Alex', 'Grace', '01/07/1890'),
	   ('p04', 'Lillith', 'Hall', '06/23/1960'),
	   ('p05', 'Steven', 'Jobs', '02/24/1955'),
	   ('p06', 'Louis', 'McVay', '11/10/1947');

insert into Governors (gid, approval_rating)
values ('p01', 90),
       ('p06', 85);

insert into Mayors (ma_id, approval_rating)
values ('p02', 97),
       ('p06', 94);

insert into Locations (lo_id, location_name, latitude, longitude, area_square_miles, tourists_per_year)
values ('l01', 'New Opalshire', 220, 291, 50000, 87000000),
	   ('l02', 'Travopolis', 304, 178, 200, 9000000),
	   ('l03', 'Lunar Lake', 304, 123, 100, 1000000),
	   ('l04', 'Grace Forest', 330, 167, 500, 500000),
	   ('l05', 'Mount Gulden', 203, 90, 200, 1000000),
	   ('l06', 'Jasmia', 302, 66, 30000, 60000000);
	   
insert into Political_Locations (pl_id, population)
values ('l01', 20000000),
	('l02', 4000000),
	('l06', 10000000);

insert into Natural_Locations (nl_id, avg_revenue_per_year_usd, protected_status)
values ('l03', 40000000, false),
	   ('l04', 10000000, true),
	   ('l05', 32000000, true);

insert into States (sid, current_governor, avg_yearly_temperature_fahrenheit, avg_yearly_precipitation_inches, gross_state_product_usd, main_industry, main_natural_resource, year_annexed)
values ('l01', 'p01', 67, 133, 4000000000000, 'fishing', 'salmon', 1882),
	('l06', 'p06', 62, 120, 4600000000000, 'mining', 'gold', 1890);

insert into Cities (cid, current_mayor, state, is_capital, year_settled)
values ('l02', 'p02', 'l01', true, 1892);

insert into Notable_Residents (nr_id, living, city_of_residence)
values ('p03', false, 'l02'),
	   ('p04', true, 'l02'),
	   ('p05', false, 'l02');

insert into Lakes (la_id, depth_feet)
values ('l03', 900);

insert into Forests (fid, percentage_of_paths_open_to_tourists)
values ('l04', 80);

insert into Mountains (mo_id, height_feet)
values ('l05', 19000);

insert into Governor_Terms (gid, sid, year_term_started, year_term_ended)
values ('p01', 'l01', 2008, 2012),
	('p06', 'l01', 2004, 2008);

insert into Mayor_Terms (ma_id, cid, year_term_started, year_term_ended)
values ('p02', 'l02', 2008, 2012),
	('p06', 'l02', 2004, 2008);

insert into Jurisdiction_Of_Natural_Locations (sid, nl_id)
values ('l01', 'l03'),
	   ('l01', 'l04'),
	   ('l01', 'l05'),
	   ('l06', 'l04');

-- Doing stuff with the data. --

-- Return all People who have been both a Governor and a Mayor and their approval ratings. --
create view Politicians_As_Governors_and_Mayors as
	select first_name as First_Name, 
		last_name as Last_Name, 
		g.approval_rating as Governor_Approval_Rating,
		m.approval_rating as Mayor_Approval_Rating
	from People p, Governors g, Mayors m
	where p.pid = g.gid and p.pid = m.ma_id;

-- Get the average temperature and precipitation for all states. --
create view Climate as
	select l.location_name as state, 
	avg(s.avg_yearly_temperature_fahrenheit) as temp, 
	avg(s.avg_yearly_precipitation_inches) as precipitation
	from States s, Locations l
	where s.sid = l.lo_id
	group by state
	order by state;

-- Shows which natural locations are getting the most revenue per tourist. --
select l.location_name as Location_Name,
       (nl.avg_revenue_per_year_usd / l.tourists_per_year) as Revenue_Per_Tourist_USD
       from Locations l, Natural_Locations nl
       where l.lo_id = nl.nl_id
       order by Revenue_Per_Tourist_USD desc;

-- Gets the gross state product per capita - that is, the total amount of all goods and services produced --
-- in that state, divided by population. --
select l.location_name as Location_Name,
       (s.gross_state_product_usd / pl.population) as GSP_Per_Capita
       from Locations l, Political_Locations pl, States s
       where l.lo_id = pl.pl_id and pl.pl_id = s.sid
       order by GSP_Per_Capita desc;


-- Gets the names and tourists per year of all states with 5m population or greater. --
select max(l.location_name) as Location_Name,
	min(l.tourists_per_year) as Tourists_Per_Year
		from Locations l, Political_Locations pl
		where l.lo_id = pl.pl_id
			and l.lo_id in(
				select sid
				from states
			)
		group by pl.population
		having pl.population > 5000000
		order by Tourists_Per_Year desc;
		
-- Stored procedure that returns a table of one column, states, giving all states that have jurisdiction over the given natural location -- --name. --
create or replace function getStatesHostingNaturalLocation(varchar(100), REFCURSOR) returns refcursor as 
$$
	declare
		NaturalLocation varchar(100) := $1;
		resultset REFCURSOR := $2;
	begin
		 open resultset for select forState.location_name as States
	     from Locations forState, Locations forNatural, Jurisdiction_Of_Natural_Locations j
	     where j.sid = forState.lo_id and j.nl_id = forNatural.lo_id and forNatural.location_name = NaturalLocation;
	return resultset;	     
	end;
$$
language plpgsql;

select getStatesHostingNaturalLocation('Grace Forest', 'results');
Fetch all from results;

-- Credit/inspiration for this structure of trigger: --
-- http://labouseur.com/courses/db/projects/little-league.pdf --
-- These triggers check for an attempted insert to a _Terms table. --
-- If that person has already started another term office that year, they cannot take on another office. --
-- The insert will be cancelled and return an exception. Otherwise, everything will work normally. --
create or replace function check_governor() returns trigger as $check_governor$
	begin
		if
		exists
			(select g.year_term_started
			from Governor_Terms g
			where g.gid = NEW.gid
			and g.year_term_started = NEW.year_term_started)
		or exists
			(select m.year_term_started
			from Mayor_Terms m
			where m.ma_id = NEW.gid
			and m.year_term_started = NEW.year_term_started)
		then
			raise exception 'This governor has already started a term as governor or mayor this year. Cannot serve concurrent terms.';
		end if;
		return new;
	end;
$check_governor$ LANGUAGE plpgsql;

create or replace function check_mayor() returns trigger as $check_mayor$
	begin
		if
		exists
			(select g.year_term_started
			from Governor_Terms g
			where g.gid = NEW.ma_id
			and g.year_term_started = NEW.year_term_started)
		or exists
			(select m.year_term_started
			from Mayor_Terms m
			where m.ma_id = NEW.ma_id
			and m.year_term_started = NEW.year_term_started)
		then
			raise exception 'This mayor has already started a term as governor or mayor this year. Cannot serve concurrent terms.';
		end if;
		return new;
	end;
$check_mayor$ LANGUAGE plpgsql;

create trigger check_leader before insert on Governor_Terms
For EACH row execute procedure check_governor();

create trigger check_leader before insert on Mayor_Terms
For EACH row execute procedure check_mayor();

-- Security roles for a political analyst and tourism analyst. --
drop role if exists political_analyst;
drop role if exists tourism_analyst;
create role political_analyst;
create role tourism_analyst;
grant select,update on Governors,Mayors to political_analyst;
grant select,update on Locations,Political_Locations,Natural_Locations to tourism_analyst;
grant select on Forests to tourism_analyst;