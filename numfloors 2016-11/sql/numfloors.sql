-- Get situations where the bldgarea / lotarea exceeds twice the number of floors

SELECT bbl, bldgarea, lotarea, numfloors,
CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) as bldgarea_lotarea_ratio
FROM dcp.pluto191 p
WHERE CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) > 2 * CAST(numfloors AS NUMERIC)
AND CAST(lotarea AS NUMERIC) <> 0
ORDER BY 5 DESC;

-- Highest number of floors per borough

SELECT p1.bbl, p1.address, max.borough, max.max_numfloors
FROM dcp.pluto191 p1,
(SELECT borough, MAX(numfloors) as max_numfloors
FROM dcp.pluto191 p2
WHERE p2.borough in ('MN', 'BX', 'BK', 'QN', 'SI')
GROUP BY p2.borough) as max
WHERE p1.borough = max.borough
AND p1.numfloors = max.max_numfloors;

-- Get situations where the bldgarea / lotarea exceeds twice the number of floors,
-- and there is only one building on the lot, and the building's ground elevation
-- divided by 10 does not equal the number of floors.

SELECT bbl, numfloors, groundelev, numbldgs, bldgarea, lotarea,
groundelev / 10 AS floorelev, p.geom AS lot_geom, f.geom AS footprints_geom
FROM dcp.pluto191 p,
dcp.bldg_footprints f
WHERE p.bbl = f.base_bbl
AND numbldgs = 1
AND groundelev / 10 <> numfloors
AND CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) > 2 * CAST(numfloors AS NUMERIC)
AND CAST(lotarea AS NUMERIC) <> 0
ORDER BY 7 DESC;
