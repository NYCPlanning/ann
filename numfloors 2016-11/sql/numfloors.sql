-- Get situations where the bldgarea / lotarea exceeds twice the number of floors

SELECT bbl, bldgarea, lotarea, numfloors, address,
CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) AS bldgarea_lotarea_ratio
FROM dcp.pluto191 p
WHERE CAST(numfloors AS NUMERIC) > (2 * CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC)) 
AND CAST(lotarea AS NUMERIC) <> 0
ORDER BY 6 DESC;

-- Highest number of floors per borough

SELECT p1.bbl, p1.address, max.borough, max.max_numfloors
FROM dcp.pluto191 p1,
(SELECT borough, MAX(numfloors) AS max_numfloors
FROM dcp.pluto191 p2
WHERE p2.borough in ('MN', 'BX', 'BK', 'QN', 'SI')
GROUP BY p2.borough) AS max
WHERE p1.borough = max.borough
AND p1.numfloors = max.max_numfloors;

-- Get top 5 numfloors values by borough

SELECT rank_filter.* FROM (
		SELECT p.borough, p.bbl, p.address, p.numfloors, rank() OVER (
				PARTITION BY borough
				ORDER BY numfloors DESC
		)
		FROM dcp.pluto191 p
		WHERE numfloors IS NOT NULL
) rank_filter WHERE rank <= 5;

-- Get situations where the bldgarea / lotarea exceeds twice the number of floors,
-- and there is only one building on the lot, and the building's ground elevation
-- divided by 10 does not equal the number of floors. (The difference must be
-- within 10 feet.) Assumption is that stories in most buildings are around 10 feet.

SELECT bbl, numfloors, groundelev, numbldgs, bldgarea, lotarea, address,
heightroof / 10 AS floorelev,
heightroof / 10 - numfloors AS diff_floorelev_numfloors,
p.geom AS lot_geom, f.geom AS footprints_geom
FROM dcp.pluto191 p, dcp.bldg_footprints f
WHERE p.bbl = f.base_bbl
AND numbldgs = 1
AND (heightroof / 10 - numfloors > 10 OR heightroof / 10 - numfloors < -10)
AND CAST(bldgarea AS NUMERIC) / CAST(lotarea AS NUMERIC) > 2 * CAST(numfloors AS NUMERIC)
AND CAST(lotarea AS NUMERIC) <> 0
ORDER BY 8 DESC;
