-- Drop intermediate tables
DROP TABLE IF EXISTS dcp.blocks, dcp.block_points;

-- Create a table of blocks with a union of lots
CREATE TABLE dcp.blocks AS
SELECT "Borough",
"Block",
ST_Union(geom) AS geom
FROM dcp.pluto192
GROUP BY "Borough", "Block";

-- Dump the blocks to points
CREATE TABLE dcp.block_points AS
SELECT "Borough" as borough,
"Block" as block,
(ST_DumpPoints(geom)).path AS path,
(ST_DumpPoints(geom)).geom AS geom,
(ST_DumpPoints(geom)).path[1] AS path_1,
(ST_DumpPoints(geom)).path[2] AS path_2,
(ST_DumpPoints(geom)).path[3] AS path_3
FROM dcp.blocks
WHERE geom IS NOT NULL;
