-- This gets the count of lots that touch a given lot.
-- If count of lots that touch the lot in question is 0, the lot is a block assemblage
-- Result set limited to 100 rows - otherwise it takes forever.
-- Note that a block assemblage should not be an island. Is there a good way of identifying an island?
select a.bbl, coalesce(count(b.bbl),0)
from plutofix.pluto191 a
left join plutofix.pluto191 b
on st_touches(a.geom, b.geom)
and a.bbl <> b.bbl
group by a.bbl
having coalesce(count(b.bbl),0) = 0
limit 100;

-- Alley? Should be surrounded on 2 or 3 sides, and have a lot frontage of 12 or fewer feet.
-- Lot fronts with zero values excluded.
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
select a.bbl, count(b.bbl)
from plutofix.pluto191 a
left join plutofix.pluto191 b
on st_touches(a.geom, b.geom)
and a.bbl <> b.bbl
where a.lotfront > 12
group by a.bbl
having count(b.bbl) in (2, 3)
limit 100;

-- Interior lots?
select a.bbl, a.boundary, a.side_length
from
(select x.bbl_1 as bbl, x.boundary as boundary, sum(x.side_length) as side_length
from
(select a.bbl as bbl_1, b.bbl as bbl_2,
ST_Length(ST_Boundary(a.geom)) as boundary,
ST_Length(ST_CollectionExtract(ST_Intersection(a.geom, b.geom), 2)) as side_length
from plutofix.pluto191 a
inner join plutofix.pluto191 b
on st_touches(a.geom, b.geom)
and a.bbl <> b.bbl
where a.bbl = 4021470013) as x
group by x.bbl_1, x.boundary) as a
where a.boundary = a.side_length;
