# This is SQL designed to handle only those lots that
# are coded as regular, where the rounded product of the
# lotfront and the lotdepth does not equal the lotarea. It
# creates a table called pluto_points_regular that is input to
# the Python script Irrlot_Regular_Only.py. See the Python folder.

CREATE TABLE dcp.pluto_points_irregular AS
SELECT bbl,
(ST_DumpPoints(geom)).path AS path,
(ST_DumpPoints(geom)).geom AS geom,
borough
FROM dcp.pluto191
WHERE geom IS NOT NULL
AND irrlotcode = 'Y'
AND lotarea = ROUND(lotfront * lotdepth);

ALTER TABLE dcp.pluto_points_irregular
ADD COLUMN path_1 INTEGER,
ADD COLUMN path_2 INTEGER,
ADD COLUMN path_3 INTEGER;

UPDATE dcp.pluto_points_irregular
SET path_1 = path[1]::int,
path_2 = path[2]::int,
path_3 = path[3]::int;

ALTER TABLE dcp.pluto_points_irregular
ADD PRIMARY KEY (bbl, path_1, path_2, path_3);

CREATE INDEX pluto_points_irregular_geom_idx ON dcp.pluto_points_irregular USING GIST (geom);

CREATE TABLE dcp.irrlot_y_regular (
	bbl VARCHAR(10),
	PRIMARY KEY (bbl)
);

CREATE TABLE dcp.irrlot_y_irregular (
	bbl VARCHAR(10),
	PRIMARY KEY (bbl)
);

-- Load these tables using PgAdmin import and CSV files output from Python routine

-- Now get the multipolygon geometry from PLUTO.

ALTER TABLE dcp.irrlot_y_regular
ADD COLUMN irrlotcode VARCHAR(1),
ADD COLUMN geom GEOMETRY(MULTIPOLYGON, 2263);

ALTER TABLE dcp.irrlot_y_irregular
ADD COLUMN irrlotcode VARCHAR(1),
ADD COLUMN geom GEOMETRY(MULTIPOLYGON, 2263);

UPDATE dcp.irrlot_y_regular r
SET geom = p.geom,
irrlotcode = p.irrlotcode
FROM dcp.pluto191 p
WHERE r.bbl = p.bbl;

UPDATE dcp.irrlot_y_irregular i
SET geom = p.geom,
irrlotcode = p.irrlotcode
FROM dcp.pluto191 p
WHERE i.bbl = p.bbl;

-- Use PostGIS Shapefile exporter utility or QGIS to create shapefile. Review in ArcMap.
