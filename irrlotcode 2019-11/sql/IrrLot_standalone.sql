-- Use PostGIS Shapefile exporter utility or QGIS to create shapefile from the irrlot_regular and irrlot_irregular tables.
-- Review in ArcMap.

-- Standalone query to check angle values based on vertices sets for a given BBL
-- Used this to check results. It's used to check individual situations and is
-- not a regular part of the process.

SELECT 360 - degrees(ST_Angle(ST_SetSRID(p1.geom, 2263),
ST_SetSRID(p2.geom, 2263),
ST_SetSRID(p3.geom, 2263)))
FROM dcp.pluto_points p1,
dcp.pluto_points p2,
dcp.pluto_points p3
WHERE p1.bbl = '4006360024'
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
