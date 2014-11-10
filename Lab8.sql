drop table if exists Castings;
drop table if exists MoviesDirectors;
drop table if exists Actors;
drop table if exists Directors;
drop table if exists Movies;
drop table if exists People;

create table People (
	pid text primary key,
	person_first_name text,
	person_last_name text,
	residence text
);
create table Actors(
	pid text primary key references People(pid),
	dob_unitedstates_format text, -- i.e. mm-dd-yy  --
	hair_color text,
	eye_color text,
	height_inches int,
	weight_pounds int,
	screen_actors_guild_anniversary_date_unitedstates_format text
);
create table Directors(
	pid text primary key references People(pid),
	school_attended text,
	directors_guild_anniversary_date_unitedstates_format text
);
create table Movies(
	mid text primary key,
	movie_name text,
year_released int check ( year_released >= 1900 and year_released < 2100 ),	
domestic_box_office_sales_usd int,
foreign_box_office_sales_usd int,
dvd_bluray_sales_usd int
);
create table Castings(
	pid text references People(pid),
	mid text references Movies(mid)
);
create table MoviesDirectors(
	pid text references People(pid),
	mid text references Movies(mid)
);


insert into People (pid, person_first_name, person_last_name, residence)
values ('p01', 'Ben', 'Affleck', 'Los Angeles'),
	('p02', 'Leonardo', 'DiCaprio', 'Los Angeles'),
	('p03', 'Keanu', 'Reeves', 'Hollywood'),
	('p04', 'Sean', 'Connery', 'Bahamas'),
	('p05', 'Gus', 'Van Sant', 'Portland'),
	('p06', 'James', 'Cameron', 'Wairarapa'),
	('p07', 'Lana', 'Wachowski', 'Chicago'),
	('p08', 'Andrew', 'Wachowski', 'Chicago'),
	('p09', 'Guy', 'Hamilton', 'Paris'),
	('p10', 'Hugo', 'Weaving', 'Sydney');

insert into Actors (pid, dob_unitedstates_format, hair_color, eye_color, height_inches, weight_pounds, screen_actors_guild_anniversary_date_unitedstates_format)
values ('p01', '08-15-72', 'brown', 'brown', 76, NULL, '1-25-13'),
	('p02', '11-11-74', 'brown', 'blue', 65, 168, '1-25-98'),
	('p03', '09-02-64', 'brown', 'brown', 73, NULL, NULL),
	('p04', '08-25-30', 'gray', 'brown', 75, NULL, NULL),
	('p10', '04-04-60', 'brown', 'blue', 74, NULL, '1-25-04');

insert into Directors(pid, school_attended, directors_guild_anniversary_date_unitedstates_format)
values ('p01', 'Occidental College', '1-13-2012'),
('p05', 'Rhode Island School of Design', '1-13-2008'),
	('p06', 'Fullerton College', '1-13-2009'),
	('p07', 'Emerson College', NULL),
	('p08', 'Bard College', NULL),
	('p09', NULL, NULL);

insert into Movies (mid, movie_name, year_released, domestic_box_office_sales_usd, foreign_box_office_sales_usd, dvd_bluray_sales_usd)
values ('m01', 'Good Will Hunting', 1997, 138433435, 87500000, 485060),
('m02', 'Titanic', 1997, 658672302, 1528100000, 6328727),
('m03', 'The Matrix', 1999, 171479930, 292037453, 1537785),
('m04', 'Goldfinger', 1964, 51100000, 73800000, NULL),
('m05', 'Argo', 2012, 136025503, 96300000, 38751906);

insert into Castings (pid, mid)
values ('p01', 'm01'),
	('p02', 'm02'),
	('p03', 'm03'),
	('p04', 'm04'),
	('p01', 'm05'),
	('p10', 'm03');

insert into MoviesDirectors (pid, mid)
values ('p05', 'm01'),
	('p06', 'm02'),
	('p07', 'm03'),
	('p08', 'm03'),
	('p09', 'm04'),
	('p01', 'm05');


	select person_first_name, person_last_name
from Directors d, People p
where d.pid = p.pid
and d.pid in (
		select pid
		from MoviesDirectors
		where mid in (
				select mid
				from Castings
				where pid in (
						select pid
						from People
						where person_first_name = 'Sean'
							and person_last_name = 'Connery'
					         )
				)
);