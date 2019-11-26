-- lpc_yrbuilt is a copy of the lpc (Landmarks) table.
-- Table: yrbuilt.lpc_yrbuilt
-- New fields start after "geom"

DROP TABLE dcp.lpc_yrbuilt;

-- 35,799 records selected
-- dcp.lpc contains data downloaded from Open Data: LPC's "Individual Landmark and Historic Building Database"

CREATE TABLE dcp.lpc_yrbuilt AS
SELECT *
FROM dcp.lpc;

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
ADD COLUMN yearbuilt_pluto smallint,
ADD COLUMN year_desig varchar;

-- Index: index_bbl_lpc_yrbuilt

-- DROP INDEX dcp.index_lpc_yrbuilt_bbl;

CREATE INDEX index_lpc_yrbuilt_bbl
    ON dcp.lpc_yrbuilt USING btree
    (bbl COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- DROP INDEX dcp.index_lpc_yrbuilt_bbl_num;

CREATE INDEX index_lpc_yrbuilt_bbl_num
    ON dcp.lpc_yrbuilt USING btree
    (bbl COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: index_bin_lpc_yrbuilt

-- DROP INDEX dcp.index_lpc_yrbuilt_bin;

CREATE INDEX index_lpc_yrbuilt_bin
    ON dcp.lpc_yrbuilt USING btree
    (bin)
    TABLESPACE pg_default;

-- year_desig
-- dcp.lpc_dc_buildings_sites contains data from open data: "Designated and Calendared Buildings and Sites"
-- Right now this query is only updating rows where BBL appears once on designated and calendared table.
UPDATE dcp.lpc_yrbuilt l
SET year_desig = CAST(EXTRACT(YEAR FROM b.date_desda) AS VARCHAR)
FROM dcp.lpc_dc_buildings_sites b
WHERE b.bbl IN
(SELECT b.bbl
FROM dcp.lpc_dc_buildings_sites b
GROUP BY b.bbl
HAVING COUNT(*) = 1)
AND l.bbl = b.bbl;

-- no_pluto_bbl
UPDATE dcp.lpc_yrbuilt
SET no_pluto_bbl = 'Y';

-- 36373 records updated
UPDATE dcp.lpc_yrbuilt l
SET no_pluto_bbl = 'N'
FROM dcp.pluto192 p
WHERE l.bbl_num = p."BBL";

-- yearbuilt_pluto, yrbuilt_eq_date_high
-- 36373 records updated
UPDATE dcp.lpc_yrbuilt l
SET yearbuilt_pluto = p."YearBuilt"
FROM dcp.pluto192 p
WHERE p."BBL" = l.bbl_num;

UPDATE dcp.lpc_yrbuilt
SET yrbuilt_eq_date_high = 'N';

-- 2223 records updated
UPDATE dcp.lpc_yrbuilt
SET yrbuilt_eq_date_high = 'Y'
WHERE yearbuilt_pluto = date_high;

-- date_high_eq_0
UPDATE dcp.lpc_yrbuilt
SET date_high_eq_0 = 'N';

-- 2328 records updated
UPDATE dcp.lpc_yrbuilt
SET date_high_eq_0 = 'Y'
WHERE date_high = 0;

-- numbldgs_pluto
-- 31878 records updated
UPDATE dcp.lpc_yrbuilt l
SET numbldgs_pluto = p."NumBldgs"
FROM dcp.pluto192 p
WHERE p."BBL" = l.bbl_num
AND l.no_pluto_bbl = 'N'
AND l.yrbuilt_eq_date_high = 'N'
AND l.date_high_eq_0 = 'N';

-- appdate_pluto
-- 31878 records updated
UPDATE dcp.lpc_yrbuilt l
SET appdate_pluto = CAST(p."APPDate" AS DATE)
FROM dcp.pluto192 p
WHERE p."BBL" = l.bbl_num
AND no_pluto_bbl = 'N'
AND yrbuilt_eq_date_high = 'N'
AND date_high_eq_0 = 'N';

-- cnstrct_yr_footprints
-- 403 records updated
UPDATE dcp.lpc_yrbuilt l
SET cnstrct_yr_footprints = f.cnstrct_yr
FROM dcp.bldg_footprints f
WHERE f.bin = l.bin
AND f.base_bbl = l.bbl
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
-- 31878 records updated
UPDATE dcp.lpc_yrbuilt l
SET year_built_date_high_diff = yearbuilt_pluto - date_high
WHERE no_pluto_bbl = 'N'
AND yrbuilt_eq_date_high = 'N'
AND date_high_eq_0 = 'N';
