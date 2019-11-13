-- Create a table of all Pluto points. There will be one point per row. This will be the input
-- to a Python routine that determines if a polygon is regular or not.
CREATE TABLE dcp.pluto_points AS
SELECT bbl,
(ST_DumpPoints(geom)).path AS path,
(ST_DumpPoints(geom)).geom AS geom,
borough
FROM dcp.pluto191
WHERE geom IS NOT NULL;

ALTER TABLE dcp.pluto_points
ADD COLUMN path_1 INTEGER,
ADD COLUMN path_2 INTEGER,
ADD COLUMN path_3 INTEGER;

UPDATE dcp.pluto_points
SET path_1 = path[1]::int,
path_2 = path[2]::int,
path_3 = path[3]::int;

ALTER TABLE dcp.pluto_points
ADD PRIMARY KEY (bbl, path_1, path_2, path_3);

CREATE INDEX pluto_points_geom_idx ON dcp.pluto_points USING GIST (geom);

-- Run IrrLot Python Routine

CREATE TABLE dcp.irrlot_regular (
	bbl VARCHAR(10),
	PRIMARY KEY (bbl)
);

CREATE TABLE dcp.irrlot_irregular (
	bbl VARCHAR(10),
	PRIMARY KEY (bbl)
);

-- Load these tables using PgAdmin import and CSV files output from Python routine

-- Now get the multipolygon geometry from PLUTO.

ALTER TABLE dcp.irrlot_regular
ADD COLUMN irrlotcode VARCHAR(1),
ADD COLUMN geom GEOMETRY(MULTIPOLYGON, 2263);

ALTER TABLE dcp.irrlot_irregular
ADD COLUMN irrlotcode VARCHAR(1),
ADD COLUMN geom GEOMETRY(MULTIPOLYGON, 2263);

UPDATE dcp.irrlot_regular r
SET geom = p.geom,
irrlotcode = p.irrlotcode
FROM dcp.pluto191 p
WHERE r.bbl = p.bbl;

UPDATE dcp.irrlot_irregular i
SET geom = p.geom,
irrlotcode = p.irrlotcode
FROM dcp.pluto191 p
WHERE i.bbl = p.bbl;

-- Use PostGIS Shapefile exporter utility to create shapefile. Review in ArcMap.

-- Standalone query to check angle values based on vertices sets for a given BBL
SELECT 360 - degrees(ST_Angle(ST_SetSRID(p1.geom, 2263),
ST_SetSRID(p2.geom, 2263),
ST_SetSRID(p3.geom, 2263)))
FROM dcp.pluto_points p1,
dcp.pluto_points p2,
dcp.pluto_points p3
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

-- See how often the difference between the geometry area and the ST_ORIENTEDENVELOPE area is greater than 100,
-- if the IRRLOTCODE = 'N'. (It happens pretty often - this query returned 56409 rows.)
SELECT bbl, irrlotcode, lotfront, lotdepth, lotarea,
geom,
ST_Area(geom) AS Area_Of_Polygon,
ST_Area(ST_OrientedEnvelope(geom)) AS Area_of_Envelope,
ST_Area(ST_OrientedEnvelope(geom)) - ST_Area(geom) AS diff
FROM dcp.pluto191
WHERE ST_Area(ST_OrientedEnvelope(geom)) - ST_Area(geom) > 20
AND irrlotcode = 'N';
