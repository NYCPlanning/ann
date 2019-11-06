-- Create a table of all Pluto points. There will be one point per row. This will be the input
-- to a Python routine that determines if a polygon is regular or not.
CREATE TABLE plutofix.pluto_points AS
SELECT bbl,
(ST_DumpPoints(geom)).path AS path,
(ST_DumpPoints(geom)).geom AS geom,
borough
FROM plutofix.pluto191;

ALTER TABLE plutofix.pluto_points
ADD COLUMN path_1 INTEGER,
ADD COLUMN path_2 INTEGER,
ADD COLUMN path_3 INTEGER

UPDATE plutofix.pluto_points
SET path_1 = path[1]::int,
path_2 = path[2]::int,
path_3 = path[3]::int;

ALTER TABLE plutofix.pluto_points
ADD PRIMARY KEY (bbl, path_1, path_2, path_3);

CREATE INDEX pluto_points_geom_idx ON plutofix.pluto_points USING GIST (geom);

-- Run IrrLot Python Routine

CREATE TABLE plutofix.irrlot2_regular (
	bbl numeric,
	PRIMARY KEY (bbl)
);

CREATE TABLE plutofix.irrlot2_irregular (
	bbl numeric,
	PRIMARY KEY (bbl)
);

-- Load these tables using PgAdmin import and CSV files output from Python routine

-- Now get the multipolygon geometry from PLUTO.

ALTER TABLE plutofix.irrlot2_regular
ADD COLUMN geom GEOMETRY(MULTIPOLYGON, 2263);

ALTER TABLE plutofix.irrlot2_irregular
ADD COLUMN geom GEOMETRY(MULTIPOLYGON, 2263);

UPDATE plutofix.irrlot2_regular r
SET geom = p.geom
FROM plutofix.pluto191 p
WHERE r.bbl = p.bbl;

UPDATE plutofix.irrlot2_irregular i
SET geom = p.geom
FROM plutofix.pluto191 p
WHERE i.bbl = p.bbl;

-- Use PostGIS Shapefile exporter utility to create shapefile. Review in ArcMap.

-- Standalone query to check angle values based on vertices sets for a given BBL
SELECT 360 - degrees(ST_Angle(ST_SetSRID(p1.geom, 2263),
ST_SetSRID(p2.geom, 2263),
ST_SetSRID(p3.geom, 2263)))
FROM plutofix.pluto_points p1,
plutofix.pluto_points p2,
plutofix.pluto_points p3
WHERE p1.bbl = 4006360024
AND p1.bbl = p2.bbl
AND p2.bbl = p3.bbl
AND p1.path_1 = 1
AND p1.path_2 = 1
AND p1.path_3 = 1
AND p2.path_1 = 1
AND p2.path_2 = 1
AND p2.path_3 = 2
AND p3.path_1 = 1
AND p3.path_2 = 1
AND p3.path_3 = 3;
