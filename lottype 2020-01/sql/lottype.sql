-- Drop intermediate tables
DROP TABLE IF EXISTS dcp.blocks,
dcp.block_points,
dcp.lot_points;

-- Create a table of blocks by dissolving lots with the
-- same borough and block values
CREATE TABLE dcp.blocks AS
SELECT "Borough" AS borough,
"Block" AS block,
ST_Union(geom) AS geom
FROM dcp.pluto192
WHERE geom IS NOT NULL
GROUP BY "Borough", "Block";

-- Dump the blocks to points
CREATE TABLE dcp.block_points AS
SELECT borough, block,
(ST_DumpPoints(geom)).path AS path,
(ST_DumpPoints(geom)).geom AS geom,
(ST_DumpPoints(geom)).path[1] AS path_1,
(ST_DumpPoints(geom)).path[2] AS path_2,
(ST_DumpPoints(geom)).path[3] AS path_3
FROM dcp.blocks
WHERE geom IS NOT NULL;

-- Adding this step because COALESCE didn't work.
UPDATE dcp.block_points
SET path_3 = 0
WHERE path_3 IS NULL;

-- Create a table of block assemblages
CREATE TABLE dcp.block_assemblages AS
SELECT "BBL", ST_AsText(geom)
FROM dcp.pluto192 a,
dcp.blocks b
WHERE ST_Equals(a.geom, b.geom);

-- Primary keys and indexes for blocks table.
ALTER TABLE dcp.blocks ADD PRIMARY KEY (borough, block);
CREATE INDEX block_geom_idx ON dcp.blocks USING GIST(geom);

-- Now dump the lots to points. Do not bother
-- with block assemblages.
CREATE TABLE dcp.lot_points AS
SELECT a."Borough" AS borough,
a."Block" as block,
a."Lot" as lot,
(ST_DumpPoints(a.geom)).path AS path,
(ST_DumpPoints(a.geom)).geom AS geom,
(ST_DumpPoints(a.geom)).path[1] AS path_1,
(ST_DumpPoints(a.geom)).path[2] AS path_2,
(ST_DumpPoints(a.geom)).path[3] AS path_3
FROM dcp.pluto192 a, dcp.blocks b
WHERE geom IS NOT NULL
AND NOT ST_Equals(a.geom, b.geom);

-- Primary keys and indexes for points tables.
ALTER TABLE dcp.block_points ADD PRIMARY KEY (borough, block, path_1, path_2, path_3);
ALTER TABLE dcp.lot_points ADD PRIMARY KEY (borough, block, lot, path_1, path_2, path_3);
CREATE INDEX block_points_geom_idx ON dcp.block_points USING GIST (geom);
CREATE INDEX lot_points_geom_idx ON dcp.lot_points USING GIST (geom);
