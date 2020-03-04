WITH pluto AS (
	SELECT CAST(bbl AS TEXT),
		landuse,
    bldgclass,
		CAST(numfloors AS NUMERIC) AS numfloors,
		CASE
    		WHEN landuse IN ('1', '2', '3') THEN 10
			ELSE 12
		END AS floor_height,
		numbldgs,
		address,
		geom
	FROM dcp.pluto201
	WHERE CAST(numbldgs AS NUMERIC) < 2
	AND CAST(numfloors AS NUMERIC) > 0
), footprints AS (
    SELECT mpluto_bbl
	FROM dcp.footprints
	WHERE CAST(heightroof AS NUMERIC) > 0
	GROUP BY mpluto_bbl
  HAVING COUNT(*) = 1
), footprints_height AS (
	SELECT f1.mpluto_bbl,
	CAST(heightroof AS NUMERIC) as heightroof
	FROM dcp.footprints f1, footprints f
	WHERE f1.mpluto_bbl = f.mpluto_bbl
), housing AS (
	SELECT bbl,
		job_number,
		job_type,
		job_status,
		date_complete
	FROM dcp.housing
	WHERE job_type = 'New Building' AND SUBSTRING(date_complete,1,4) > '2013'
), calc_differential AS (
	SELECT p.bbl,
		p.landuse,
		p.bldgclass,
		p.address,
		p.numbldgs,
		p.numfloors,
		ROUND(f1.heightroof / p.floor_height, 3) AS footprints_floors,
		f1.heightroof,
		p.floor_height,
		ABS(p.numfloors - ROUND(f1.heightroof / p.floor_height, 3)) AS differential,
		p.geom
	FROM pluto p
	INNER JOIN footprints_height f1
	ON p.bbl = f1.mpluto_bbl
	WHERE p.bbl NOT IN (SELECT h.bbl FROM housing h)
)
SELECT * FROM calc_differential
WHERE (differential > (1.5 * numfloors) OR differential > (1.5 * footprints_floors))
AND (numfloors > 10 OR footprints_floors > 10)
AND SUBSTRING(bldgclass,1,1) NOT IN ('M', 'Q')
ORDER BY numfloors DESC;
