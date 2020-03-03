-- Query run for report I sent out 2/27
SELECT p.bbl,
address,
yearbuilt,
numbldgs,
job_type,
job_status,
SUBSTRING(date_complete, 1, 4) AS occupancy_year,
geom
FROM dcp.pluto201 p, dcp.housing h
WHERE CAST(p.bbl AS TEXT) = h.bbl
AND numbldgs = 1
AND yearbuilt = 0
AND h.job_type = 'New Building'
AND h.job_status = 'Complete'
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8;

-- Better way to identify possible year built updates,
-- although it produces the identical report
SELECT p.bbl,
address,
yearbuilt,
numbldgs,
job_type,
job_status,
SUBSTRING(date_complete, 1, 4) AS occupancy_year,
geom
FROM dcp.pluto201 p, dcp.housing h
WHERE CAST(p.bbl AS TEXT) = h.bbl
AND numbldgs = 1
AND yearbuilt = 0
AND h.job_type = 'New Building'
AND h.job_status = 'Complete'
AND h.date_complete = (SELECT MAX(date_complete)
					   FROM dcp.housing h1
					   WHERE h1.bbl = CAST(p.bbl AS TEXT)
					   AND h1.job_type = 'New Building'
					   AND h1.job_status = 'Complete')
ORDER BY p.bbl;

-- Check for demolitions in addition to new buildings
WITH new_buildings AS (
	SELECT CAST(p.bbl AS TEXT) as bbl,
	p.address,
	p.yearbuilt,
	p.numbldgs,
	h.job_type,
	h.job_status,
	SUBSTRING(h.date_complete,1,4) AS status_year,
	p.geom
	FROM dcp.housing h, dcp.pluto201 p
	WHERE job_type = 'New Building'
	AND job_status = 'Complete'
	AND h.date_complete = (SELECT MAX(date_complete)
					   		FROM dcp.housing h1
					   		WHERE h1.bbl = h.bbl
					   		AND h1.job_type = h.job_type
					   		AND h1.job_status = h.job_status)
	AND CAST(p.bbl AS TEXT) = h.bbl
  AND p.yearbuilt = 0
  AND p.numbldgs = 1
), demolitions AS (
	SELECT n.bbl,
	n.address,
	n.yearbuilt,
	n.numbldgs,
	h.job_type,
	h.job_status,
	SUBSTRING(h.date_filed,7,4) AS status_year,
	n.geom
	FROM dcp.housing h, new_buildings n
	WHERE h.job_type = 'Demolition'
	AND h.job_status = 'Complete (demolition)'
	AND h.date_filed = (SELECT MAX(h1.date_filed)
					   		FROM dcp.housing h1
					   		WHERE h1.bbl = h.bbl
					   		AND h1.job_type = h.job_type
					   		AND h1.job_status = h.job_status)
	AND n.bbl = h.bbl
)
SELECT n.bbl,
	n.address,
	n.yearbuilt,
	n.numbldgs,
	n.job_type,
	n.job_status,
	n.status_year,
	n.geom
FROM new_buildings n
UNION ALL
SELECT d.bbl,
	d.address,
	d.yearbuilt,
	d.numbldgs,
	d.job_type,
	d.job_status,
	d.status_year,
	d.geom
FROM demolitions d
ORDER BY 1, 5, 6;
