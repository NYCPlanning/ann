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
