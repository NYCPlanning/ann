-- Create a table of all Pluto points. There will be one point per row. This will be the input
-- to a Python routine that determines if a polygon is regular or not.

-- Calculate the percentage of difference between the envelope area and the polygon area. We
-- will only process the record if the difference is greater than 15%.
-- I am also trying to exclude sliver lots.
DROP TABLE IF EXISTS dcp.pluto_points,
	dcp.irrlot_regular,
	dcp.irrlot_irregular;

CREATE TABLE dcp.pluto_points AS
SELECT "BBL" as bbl,
(ST_DumpPoints(geom)).path AS path,
(ST_DumpPoints(geom)).geom AS geom,
"Borough" as borough,
(ST_DumpPoints(geom)).path[1] AS path_1,
(ST_DumpPoints(geom)).path[2] AS path_2,
(ST_DumpPoints(geom)).path[3] AS path_3
FROM dcp.pluto192
WHERE geom IS NOT NULL
AND "LotArea" > 15000
AND (ST_Area(ST_OrientedEnvelope(geom)) - ST_Area(geom)) / ST_Area(geom) * 100 > 15;

UPDATE dcp.pluto_points
SET path_1 = path[1]::int,
path_2 = path[2]::int,
path_3 = path[3]::int;

ALTER TABLE dcp.pluto_points
ADD PRIMARY KEY (bbl, path_1, path_2, path_3);

CREATE INDEX pluto_points_geom_idx ON dcp.pluto_points USING GIST (geom);

-- Run IrrLot Python Routine

-- The CREATE, ALTER, AND UPDATE below are here in case you want to create a Shapefile
-- you can load into ArcMap.

CREATE TABLE dcp.irrlot_regular (
	bbl NUMERIC,
	irrlotcode VARCHAR(1),
	lotarea INTEGER,
	lotfront NUMERIC,
	lotdepth NUMERIC,
	front_depth_product NUMERIC,
	pluto_shape_area NUMERIC,
	geom GEOMETRY(MULTIPOLYGON, 2263),
	PRIMARY KEY (bbl)
);

CREATE TABLE dcp.irrlot_irregular (
	bbl NUMERIC,
	irrlotcode VARCHAR(1),
	lotarea INTEGER,
	lotfront NUMERIC,
	lotdepth NUMERIC,
	front_depth_product NUMERIC,
	pluto_shape_area NUMERIC,
	geom GEOMETRY(MULTIPOLYGON, 2263),
	PRIMARY KEY (bbl)
);

-- Now get the multipolygon geometry from PLUTO.

-- Load these intermediate tables first

--COPY dcp.irrlot_irregular(bbl)
--FROM '/Users/annmorris/Documents/DCP/db-pluto-research/irrlotcde 2016-11-06/output/irregular_angles.csv' DELIMITER ',';

--COPY dcp.irrlot_regular(bbl)
--FROM '/Users/annmorris/Documents/DCP/db-pluto-research/irrlotcde 2016-11-06/output/regular_angles.csv' DELIMITER ',';

UPDATE dcp.irrlot_regular r
SET geom = p.geom,
irrlotcode = p."IrrLotCode",
lotarea = p."LotArea",
lotfront = p."LotFront",
lotdepth = p."LotDepth",
front_depth_product = p."LotFront" * p."LotDepth",
pluto_shape_area = p."Shape_Area"
FROM dcp.pluto192 p
WHERE r.bbl = p."BBL";

UPDATE dcp.irrlot_irregular i
SET geom = p.geom,
irrlotcode = p."IrrLotCode",
lotarea = p."LotArea",
lotfront = p."LotFront",
lotdepth = p."LotDepth",
front_depth_product = p."LotFront" * p."LotDepth",
pluto_shape_area = p."Shape_Area"
FROM dcp.pluto192 p
WHERE i.bbl = p."BBL";
