-- Melissa Iori --
-- Lab 10 --
drop function PreReqsFor(int);
drop function IsPreReqFor(int);
drop function AllPreReqsFor(int);
-- Returns immediate prerequisites for the given course number. --
create or replace function PreReqsFor(int) returns setof int as 
$$
declare
   givenCourseNum int    := $1;
begin
      return query
      select num
      from   courses
       where num in (
	select preReqNum
	from Prerequisites
	where courseNum = givenCourseNum	
       );
end;
$$ 
language plpgsql;

select PreReqsFor(499);


-- Returns courses for which the given course number is an immediate prerequisite. -- 
create or replace function IsPreReqFor(int) returns setof int as 
$$
declare
   givenCourseNum int    := $1;
begin
      return query
      select num
      from   courses
       where num in (
	select courseNum
	from Prerequisites
	where preReqNum = givenCourseNum	
       );
end;
$$ 
language plpgsql;

select IsPreReqFor(120);

-- Returns all prerequisites for the given course. --
create or replace function AllPreReqsFor(int) returns setof int as 
$$
declare
   givenCourseNum int    := $1;
   course RECORD;
begin
   for course in select AllPreReqsFor(givenCourseNum) loop
	 select AllPreReqsFor(course);
   end loop;
   return;
end;
$$ 
language plpgsql;

select AllPreReqsFor(499);

CREATE OR REPLACE FUNCTION AllPreReqsFor(int) RETURNS SETOF prerequisites AS
$$
DECLARE
    givenCourseNum int := $1;
    r prerequisites%rowtype;
BEGIN
    FOR r IN SELECT * FROM PreReqsFor(givenCourseNum)
    LOOP
        RETURN NEXT r;
    END LOOP;
    RETURN;
END
$$
LANGUAGE 'plpgsql' ;

SELECT * FROM AllPreReqsFor(499);