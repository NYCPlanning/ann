-- QUERY #1 - BLOCK ASSEMBLAGES

-- This gets the count of lots that touch a given lot.
-- If count of lots that touch the lot in question is 0, the lot is a block assemblage
-- I am joining the pluto table to a table I created called lottype_combos which contains
-- BBLs and associated lottype combinations, whether they are logical combinations or not.
-- Note that a block assemblage should not be an island. Is there a good way of identifying an island?
select c.bbl, lottype_1, lottype_2, lottype_3, coalesce(count(p.bbl),0)
from plutofix.lottype_combos c
left join plutofix.pluto191 p
on st_touches(c.geom, p.geom)
and p.bbl <> cast(c.bbl as numeric)
where lottype_1 = '0'
and lottype_2 = '1'
and lottype_3 = ''
group by c.bbl
having coalesce(count(p.bbl),0) = 0;

-- QUERY 2 - INTERIOR lots
-- What this example of subquery hell does is to identify lots touching a lot, calculate the lengths of the sides
-- of the potential interior lot, and check it against the total of boundaries of other lots touching that lot.
-- If they are equal, it's an interior lot.

select a.bbl, a.boundary, a.side_length
from
    (select x.bbl_1 as bbl, x.boundary as boundary, sum(x.side_length) as side_length
      from
          (select c.bbl as bbl_1, p.bbl as bbl_2,
                  ST_Length(ST_Boundary(c.geom)) as boundary,
                  ST_Length(ST_CollectionExtract(ST_Intersection(c.geom, p.geom), 2)) as side_length
            from plutofix.lottype_combos c
            inner join plutofix.pluto191 p
            on st_touches(c.geom, p.geom)
            and cast(c.bbl as numeric) <> p.bbl
            and lottype_1 = '0'
            and lottype_2 = '5'
            and lottype_3 = '6'
            and lottype_4 = '') as x
      group by x.bbl_1, x.boundary) as a
where a.boundary = a.side_length;

-- Alley? Should be surrounded on 2 or 3 sides, and have a lot frontage of 12 or fewer feet.
-- Lot fronts with zero values excluded.
-- This query is questionable.
select a.bbl, count(b.bbl)
from plutofix.pluto191 a
left join plutofix.pluto191 b
on st_touches(a.geom, b.geom)
and a.bbl <> b.bbl
where a.lotfront > 0
and a.lotfront <= 12
group by a.bbl
having count(b.bbl) in (2, 3);

-- Inside lots would be surrounded by 2 or 3 polygons, but would have wider lot frontage than alleys.
-- Note that this query would need to exclude waterfront and submerged lots.
-- And how would you know this is not a corner?
-- Questionable
select a.bbl, count(b.bbl)
from plutofix.pluto191 a
left join plutofix.pluto191 b
on st_touches(a.geom, b.geom)
and a.bbl <> b.bbl
where a.lotfront > 12
group by a.bbl
having count(b.bbl) in (2, 3)
limit 100;
