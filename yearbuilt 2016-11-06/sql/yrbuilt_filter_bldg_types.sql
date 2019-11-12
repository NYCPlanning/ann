-- lpc_yrbuilt is a copy of the lpc (Landmarks) table.
-- Table: yrbuilt.lpc_yrbuilt
-- New fields start after "geom"

-- DROP TABLE dcp.lpc_yrbuilt;

-- 35,909 records selected

CREATE TABLE dcp.lpc_yrbuilt AS
SELECT * FROM dcp.lpc
WHERE build_type NOT IN ('Lamppost', 'Parking Lot', 'Garden', 'Bridge',
'Pier', 'Zoo', 'Pool', 'Other', 'Swimming Pool Structure', 'Restroom',
'Cemetery Structure', 'Carport', 'Greenhouse', 'Fence', 'Garage and Laundry',
'Roller Coaster', 'Cemetery Gate', 'Gazebo', 'Sign', 'Iron Fence');

-- Add new, empty columns

ALTER TABLE dcp.lpc_yrbuilt
ADD COLUMN no_pluto_bbl character(1) COLLATE pg_catalog."default",
ADD COLUMN yrbuilt_eq_date_high character(1) COLLATE pg_catalog."default",
ADD COLUMN date_high_eq_0 character(1) COLLATE pg_catalog."default",
ADD COLUMN numbldgs_pluto smallint,
ADD COLUMN appdate_pluto date,
ADD COLUMN cnstrct_yr_footprints bigint,
ADD COLUMN job_type character varying(12) COLLATE pg_catalog."default",
ADD COLUMN job_number integer,
ADD COLUMN status character varying(21) COLLATE pg_catalog."default",
ADD COLUMN status_dat character varying(22) COLLATE pg_catalog."default",
ADD COLUMN year_built_date_high_diff integer,
ADD COLUMN yearbuilt_pluto smallint

-- Index: index_bbl_lpc_yrbuilt

-- DROP INDEX yrbuilt.index_bbl_lpc_yrbuilt;

CREATE INDEX index_lpc_yrbuilt_bbl
    ON dcp.lpc_yrbuilt USING btree
    (bbl COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: index_bin_lpc_yrbuilt

-- DROP INDEX yrbuilt.index_bin_lpc_yrbuilt;

CREATE INDEX index_lpc_yrbuilt_bin
    ON dcp.lpc_yrbuilt USING btree
    (bin)
    TABLESPACE pg_default;

-- no_pluto_bbl
UPDATE dcp.lpc_yrbuilt
SET no_pluto_bbl = 'Y';

-- 35686 records updated
UPDATE dcp.lpc_yrbuilt l
SET no_pluto_bbl = 'N'
FROM dcp.pluto191 p
WHERE l.bbl = p.bbl;

-- yearbuilt_pluto, yrbuilt_eq_date_high
-- 35686 records updated
UPDATE dcp.lpc_yrbuilt l
SET yearbuilt_pluto = p.yearbuilt
FROM dcp.pluto191 p
WHERE p.bbl = l.bbl;

UPDATE dcp.lpc_yrbuilt
SET yrbuilt_eq_date_high = 'N';

-- 2186 records updated
UPDATE dcp.lpc_yrbuilt
SET yrbuilt_eq_date_high = 'Y'
WHERE yearbuilt_pluto = date_high;

-- date_high_eq_0
UPDATE dcp.lpc_yrbuilt
SET date_high_eq_0 = 'N';

-- 2279 records updated
UPDATE dcp.lpc_yrbuilt
SET date_high_eq_0 = 'Y'
WHERE date_high = 0;

-- numbldgs_pluto
-- 31267 records updated
UPDATE dcp.lpc_yrbuilt l
SET numbldgs_pluto = p.numbldgs
FROM dcp.pluto191 p
WHERE p.bbl = l.bbl
AND l.no_pluto_bbl = 'N'
AND l.yrbuilt_eq_date_high = 'N'
AND l.date_high_eq_0 = 'N';

-- appdate_pluto
UPDATE dcp.lpc_yrbuilt l
SET appdate_pluto = CAST(p.appdate AS DATE)
FROM dcp.pluto191 p
WHERE p.bbl = l.bbl
AND no_pluto_bbl = 'N'
AND yrbuilt_eq_date_high = 'N'
AND date_high_eq_0 = 'N';

-- cnstrct_yr_footprints
-- 689 records updated
UPDATE dcp.lpc_yrbuilt l
SET cnstrct_yr_footprints = f.cnstrct_yr
FROM dcp.bldg_footprints f
WHERE f.bin = l.bin
AND f.cnstrct_yr >= 1965
AND no_pluto_bbl = 'N'
AND yrbuilt_eq_date_high = 'N'
AND date_high_eq_0 = 'N';

-- job_type, job_number, status, status_dat
-- 43 records updated
UPDATE dcp.lpc_yrbuilt l
SET job_type = h.job_type,
job_number = h.job_number,
status = h.status,
status_dat = h.status_dat
FROM dcp.housing_development h
WHERE l.no_pluto_bbl = 'N'
AND l.yrbuilt_eq_date_high = 'N'
AND l.date_high_eq_0 = 'N'
AND h.bin = l.bin
AND h.status_dat = (SELECT MAX(h2.status_dat) FROM dcp.housing_development h2 WHERE h2.bin = l.bin);

-- year_built_date_high_diff
-- 31267 records updated
UPDATE dcp.lpc_yrbuilt l
SET year_built_date_high_diff = yearbuilt_pluto - date_high
WHERE no_pluto_bbl = 'N'
AND yrbuilt_eq_date_high = 'N'
AND date_high_eq_0 = 'N';
