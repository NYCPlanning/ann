-- Get situations where the bldgarea / lotarea exceeds twice the number of floors

SELECT bbl, bldgarea, lotarea, numfloors, address,
CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) as bldgarea_lotarea_ratio
FROM dcp.pluto191 p
WHERE CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) > 2 * CAST(numfloors AS NUMERIC)
AND CAST(lotarea AS NUMERIC) <> 0
ORDER BY 6 DESC;

-- Highest number of floors per borough

SELECT p1.bbl, p1.address, max.borough, max.max_numfloors
FROM dcp.pluto191 p1,
(SELECT borough, MAX(numfloors) as max_numfloors
FROM dcp.pluto191 p2
WHERE p2.borough in ('MN', 'BX', 'BK', 'QN', 'SI')
GROUP BY p2.borough) AS max
WHERE p1.borough = max.borough
AND p1.numfloors = max.max_numfloors;

-- Get top 5 numfloors values by borough

SELECT floors.*
FROM
((SELECT borough, bbl, address, numfloors
FROM dcp.pluto191
WHERE borough = 'MN'
AND numfloors IS NOT NULL
ORDER BY numfloors DESC
LIMIT 5)
UNION
(SELECT borough, bbl, address, numfloors
FROM dcp.pluto191
WHERE borough = 'BX'
AND numfloors IS NOT NULL
ORDER BY numfloors DESC
LIMIT 5)
UNION
(SELECT borough, bbl, address, numfloors
FROM dcp.pluto191
WHERE borough = 'BK'
AND numfloors IS NOT NULL
ORDER BY numfloors DESC
LIMIT 5)
UNION
(SELECT borough, bbl, address, numfloors
FROM dcp.pluto191
WHERE borough = 'QN'
AND numfloors IS NOT NULL
ORDER BY numfloors DESC
LIMIT 5)
UNION
(SELECT borough, bbl, address, numfloors
FROM dcp.pluto191
WHERE borough = 'SI'
AND numfloors IS NOT NULL
ORDER BY numfloors DESC
LIMIT 5)) AS floors
ORDER BY 1, 4 DESC;

-- Get situations where the bldgarea / lotarea exceeds twice the number of floors,
-- and there is only one building on the lot, and the building's ground elevation
-- divided by 10 does not equal the number of floors. (The difference must be
-- within 10 feet.) Assumption is that stories in most buildings are around 10 feet.

SELECT bbl, numfloors, groundelev, numbldgs, bldgarea, lotarea, address,
groundelev / 10 AS floorelev, p.geom AS lot_geom, f.geom AS footprints_geom
FROM dcp.pluto191 p, dcp.bldg_footprints f
WHERE p.bbl = f.base_bbl
AND numbldgs = 1
AND (groundelev / 10 - numfloors > 10 OR groundelev / 10 - numfloors < -10)
AND CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) > 2 * CAST(numfloors AS NUMERIC)
AND CAST(lotarea AS NUMERIC) <> 0
ORDER BY 8 DESC;
