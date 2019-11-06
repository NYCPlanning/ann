-- lpc_yrbuilt is a copy of the lpc (Landmarks) table.
-- Table: yrbuilt.lpc_yrbuilt
-- New fields start after "geom"

-- DROP TABLE yrbuilt.lpc_yrbuilt;

CREATE TABLE yrbuilt.lpc_yrbuilt
(
    gid integer,
    objectid_1 bigint,
    objectid bigint,
    bin bigint,
    bbl character varying(10) COLLATE pg_catalog."default",
    doitt_id bigint,
    height_roo numeric,
    ground_ele bigint,
    borough character varying(2) COLLATE pg_catalog."default",
    block bigint,
    lot integer,
    zipcode bigint,
    address character varying(28) COLLATE pg_catalog."default",
    ownername character varying(21) COLLATE pg_catalog."default",
    numfloors numeric,
    yearbuilt integer,
    yearalter1 integer,
    yearalter2 integer,
    des_addres character varying(100) COLLATE pg_catalog."default",
    circa integer,
    date_low integer,
    date_high integer,
    date_combo character varying(25) COLLATE pg_catalog."default",
    alt_date_1 character varying(25) COLLATE pg_catalog."default",
    alt_date_2 character varying(25) COLLATE pg_catalog."default",
    arch_build character varying(60) COLLATE pg_catalog."default",
    own_devel character varying(60) COLLATE pg_catalog."default",
    alt_arch_1 character varying(60) COLLATE pg_catalog."default",
    alt_arch_2 character varying(60) COLLATE pg_catalog."default",
    altered integer,
    style_prim character varying(50) COLLATE pg_catalog."default",
    style_sec character varying(50) COLLATE pg_catalog."default",
    style_oth character varying(50) COLLATE pg_catalog."default",
    noncontrib integer,
    mat_prim character varying(50) COLLATE pg_catalog."default",
    mat_sec character varying(50) COLLATE pg_catalog."default",
    mat_third character varying(50) COLLATE pg_catalog."default",
    mat_four character varying(50) COLLATE pg_catalog."default",
    mat_other character varying(50) COLLATE pg_catalog."default",
    use_orig character varying(50) COLLATE pg_catalog."default",
    use_other character varying(50) COLLATE pg_catalog."default",
    build_type character varying(50) COLLATE pg_catalog."default",
    build_oth character varying(50) COLLATE pg_catalog."default",
    build_nme character varying(65) COLLATE pg_catalog."default",
    notes character varying(250) COLLATE pg_catalog."default",
    newconst integer,
    hist_dist character varying(125) COLLATE pg_catalog."default",
    era character varying(25) COLLATE pg_catalog."default",
    lm_orig character varying(150) COLLATE pg_catalog."default",
    lm_new character varying(150) COLLATE pg_catalog."default",
    hd_flag integer,
    il_flag integer,
    shape_leng numeric,
    bbl_2 numeric,
    shape_star numeric,
    shape_stle numeric,
    geom geometry(MultiPolygon),
    no_pluto_bbl character(1) COLLATE pg_catalog."default",
    yrbuilt_eq_date_high character(1) COLLATE pg_catalog."default",
    date_high_eq_0 character(1) COLLATE pg_catalog."default",
    numbldgs_pluto smallint,
    appdate_pluto date,
    cnstrct_yr_footprints bigint,
    job_type character varying(12) COLLATE pg_catalog."default",
    job_number integer,
    status character varying(21) COLLATE pg_catalog."default",
    status_dat character varying(22) COLLATE pg_catalog."default",
    year_built_date_high_diff integer,
    yearbuilt_pluto smallint
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE yrbuilt.lpc_yrbuilt
    OWNER to postgres;

-- Index: index_bbl_lpc_yrbuilt

-- DROP INDEX yrbuilt.index_bbl_lpc_yrbuilt;

CREATE INDEX index_bbl_lpc_yrbuilt
    ON yrbuilt.lpc_yrbuilt USING btree
    (bbl COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: index_bin_lpc_yrbuilt

-- DROP INDEX yrbuilt.index_bin_lpc_yrbuilt;

CREATE INDEX index_bin_lpc_yrbuilt
    ON yrbuilt.lpc_yrbuilt USING btree
    (bin)
    TABLESPACE pg_default

-- no_pluto_bbl
update yrbuilt.lpc_yrbuilt
set no_pluto_bbl = 'Y';

update yrbuilt.lpc_yrbuilt l
set no_pluto_bbl = 'N'
where l.bbl in (select p.bbl from yrbuilt.pluto191 p);

-- yearbuilt_pluto, yrbuilt_eq_date_high
update yrbuilt.lpc_yrbuilt l
set yearbuilt_pluto = p.yearbuilt
FROM yrbuilt.pluto1191 p
where p.bbl = l.bbl;

update ybuilt.lpc_yrbuilt
set yrbuilt_eq_date_high = 'N';

update.yrbuilt.lpc_yrbuilt
set yrbuilt_eq_date_high = 'Y'
where yearbuilt_pluto = date_high;

-- date_high_eq_0
update yrbuilt.lpc_yrbuilt
set date_high_eq_0 = 'N';

update yrbuilt.lpc_yrbuilt
set date_high_eq_0 = 'Y'
where date_high = 0;

-- numbldgs_pluto
update yrbuilt.lpc_yrbuilt l
set numbldgs_pluto = p.numbldgs
FROM yrbuilt.pluto191 p
where p.bbl = l.bbl
and l.no_pluto_bbl = 'N'
and l.yrbuilt_eq_date_high = 'N'
and l.date_high_eq_0 = 'N';

-- appdate_pluto
update yrbuilt.lpc_yrbuilt l
set appdate_pluto = p.appdate
FROM yrbuilt.pluto191 p
where p.bbl = l.bbl
and no_pluto_bbl = 'N'
and yrbuilt_eq_date_high = 'N'
and date_high_eq_0 = 'N';

-- cnstrct_yr_footprints
update yrbuilt.lpc_yrbuilt l
set cnstrct_yr_footprints = f.cnstrct_yr
FROM yrbuilt.bldg_footprints f
where f.bin = l.bin
and f.cnstrct_yr >= 1965
and no_pluto_bbl = 'N'
and yrbuilt_eq_date_high = 'N'
and date_high_eq_0 = 'N';

-- job_type, job_number, status, status_dat
update yrbuilt.lpc_yrbuilt2 l2
set job_type = h.job_type,
job_number = h.job_number,
status = h.status,
status_dat = h.status_dat
from yrbuilt.lpc_yrbuilt2 l, yrbuilt.housing_development h
where l.no_pluto_bbl = 'N'
and l.yrbuilt_eq_date_high = 'N'
and l.date_high_eq_0 = 'N'
and h.bin = l.bin
and h.status_dat = (select max(h2.status_dat) from yrbuilt.housing_development h2 where h2.bin = l.bin);

-- year_built_date_high_diff
update yrbuilt.lpc_yrbuilt l
set year_built_date_high_diff = yearbuilt_pluto - date_high
where no_pluto_bbl = 'N'
and yrbuilt_eq_date_high = 'N'
and date_high_eq_0 = 'N';
