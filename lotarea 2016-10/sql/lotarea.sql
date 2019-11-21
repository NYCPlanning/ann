-- How many records have a lotarea of zero?
SELECT COUNT(*)
FROM dcp.pluto191
WHERE lotarea = 0;

-- If lotarea = 0, update it using the rounded value in shape_area
UPDATE dcp.pluto191
SET lotarea = ROUND(shape_area)
WHERE lotarea = 0;

-- Produce breakout reports for review:

-- BUILDING CLASS (BLDGCLASS)
CREATE OR REPLACE VIEW la.lotarea_comparison_bldgclass AS
 SELECT p.bldgclass,
    sum(p.lotarea) AS old_lotarea,
    sum(l.lotarea) AS new_lotarea,
    sum(l.lotarea::numeric - p.lotarea::numeric) AS difference
   FROM dcp.pluto191 p, dcp.pluto191_la l
  WHERE p.bbl::text = l.bbl::text
  GROUP BY p.bldgclass
  ORDER BY p.bldgclass;

-- LAND USE CODE (LANDUSE)
CREATE OR REPLACE VIEW la.lotarea_comparison_landuse AS
 SELECT p.landuse,
    sum(p.lotarea) AS total_lotarea_old,
    sum(l.lotarea) AS total_lotarea_new,
    sum(l.lotarea::numeric - p.lotarea::numeric) AS difference
   FROM dcp.pluto191 p, dcp.pluto191_la l
  WHERE p.bbl::text = l.bbl::text
  GROUP BY p.landuse
  ORDER BY (sum(l.lotarea::numeric - p.lotarea::numeric)) DESC;

-- BOROUGH (BORO)
CREATE OR REPLACE VIEW la.lotarea_comparison_boro AS
 SELECT p.boro,
    sum(p.lotarea) AS old_lotarea,
    sum(l.lotarea) AS new_lotarea,
    sum(l.lotarea::numeric - p.lotarea::numeric) AS difference
   FROM dcp.pluto191 p, dcp.pluto191_la l
  WHERE p.bbl::text = l.bbl::text
  GROUP BY p.boro
  ORDER BY p.boro;

-- SUMMARY TOTALS
CREATE OR REPLACE VIEW la.lotarea_comparison_total AS
 SELECT sum(p.lotarea) AS total_lotarea_old,
    sum(l.lotarea) AS total_lotarea_new,
    sum(l.lotarea::numeric - p.lotarea::numeric) AS difference
   FROM dcp.pluto191 p, dcp.pluto191_la l
  WHERE p.bbl::text = l.bbl::text;
