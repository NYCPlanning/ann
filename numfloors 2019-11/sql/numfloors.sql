-- Get situations where the bldgarea / lotarea exceeds twice the number of floors

SELECT "BBL", "BldgArea", "LotArea", "NumFloors", "Address",
CAST("BldgArea" AS NUMERIC) / CAST("LotArea" AS NUMERIC) AS bldgarea_lotarea_ratio
FROM dcp.pluto192 p
WHERE CAST("NumFloors" AS NUMERIC) > (2 * CAST("BldgArea" AS NUMERIC) / CAST("LotArea" AS NUMERIC))
AND CAST("LotArea" AS NUMERIC) <> 0
ORDER BY 6 DESC;

-- Highest number of floors per borough

SELECT p1."BBL", p1."Address", max.borough, max.max_numfloors
FROM dcp.pluto192 p1,
(SELECT p2."Borough" as borough, MAX("NumFloors") AS max_numfloors
FROM dcp.pluto192 p2
WHERE p2."Borough" in ('MN', 'BX', 'BK', 'QN', 'SI')
GROUP BY p2."Borough") AS max
WHERE p1."Borough" = max.borough
AND p1."NumFloors" = max.max_numfloors;

-- Get top 5 numfloors values by borough

SELECT rank_filter.* FROM (
		SELECT p."Borough", p."BBL", p."Address", p."NumFloors", rank() OVER (
				PARTITION BY p."Borough"
				ORDER BY p."NumFloors" DESC
		)
		FROM dcp.pluto192 p
		WHERE p."NumFloors" IS NOT NULL
) rank_filter WHERE rank <= 5;

-- Get situations where the bldgarea / lotarea exceeds twice the number of floors,
-- and there is only one building on the lot, and the building's roof height
-- divided by 10 does not equal the number of floors. (The difference must be
-- within 10 feet.) Assumption is that stories in most buildings are around 10 feet.

SELECT "BBL", "NumFloors", heightroof, "NumBldgs", "BldgArea", "LotArea", "Address",
heightroof / 10 AS floorelev,
heightroof / 10 - "NumFloors" AS diff_floorelev_numfloors,
p.geom AS lot_geom, f.geom AS footprints_geom
FROM dcp.pluto192 p, dcp.bldg_footprints f
WHERE CAST(p."BBL" AS VARCHAR) = f.base_bbl
AND "NumBldgs" = 1
AND (heightroof / 10 - "NumFloors" > 10 OR heightroof / 10 - "NumFloors" < -10)
AND CAST("BldgArea" AS NUMERIC) / CAST("LotArea" AS NUMERIC) > 2 * CAST("NumFloors" AS NUMERIC)
AND CAST("LotArea" AS NUMERIC) <> 0
ORDER BY 8 DESC;

-- Calculate the mean number of floors for each borough,
-- as well as the percentage of the mean that each number
-- of floors represents. Sort the result set by percentages,
-- largest percentages first. This should help to identify
-- the extreme outliers.
SELECT "BBL", p."Borough", p."Address", p."NumFloors", borough_mean, p."NumFloors" / borough_mean AS "Percent of Mean"
FROM dcp.pluto192 p,
		(SELECT "Borough", AVG("NumFloors") AS borough_mean
		FROM dcp.pluto192
		WHERE "NumFloors" > 0 AND "NumFloors" IS NOT NULL
		GROUP BY "Borough") AS borough_mean
WHERE p."Borough" = borough_mean."Borough"
AND "NumFloors" > 0 AND "NumFloors" IS NOT NULL
ORDER BY 6 DESC
LIMIT 100;

-- Outliers with zScores.
SELECT p."BBL",
p."Borough",
p."Address",
p."NumFloors",
((p."NumFloors" - Average) /  Std) AS "zScore"
FROM dcp.pluto192 p,
		(SELECT p2."Borough" as boro, AVG(p2."NumFloors") AS Average, stddev(p2."NumFloors") AS Std
		FROM dcp.pluto192 p2
		WHERE p2."NumFloors" IS NOT NULL AND p2."NumFloors" > 0
		GROUP BY p2."Borough") AS std_borough
WHERE p."Borough" = std_borough.boro
AND p."NumFloors" IS NOT NULL AND p."NumFloors" > 0
ORDER BY 5 DESC
LIMIT 100;
