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
