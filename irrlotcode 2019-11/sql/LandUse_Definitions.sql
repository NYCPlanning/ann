-- Table: dcp.landuse_definitions

-- DROP TABLE dcp.landuse_definitions;

CREATE TABLE dcp.landuse_definitions
(
    landuse character varying(2) COLLATE pg_catalog."default" NOT NULL,
    def text COLLATE pg_catalog."default",
    CONSTRAINT landuse_definitions_pkey PRIMARY KEY (landuse)
)

TABLESPACE pg_default;

ALTER TABLE dcp.landuse_definitions
    OWNER to postgres;

INSERT INTO dcp.landuse_definitions VALUES
('01', 'One and Two Family Buildings'),
('02', 'Multi-Family Walkup Buildings'),
('03', 'Multi-Family Elevator Buildings'),
('04', 'Mixed Residential and Commercial'),
('05', 'Commercial and Office'),
('06', 'Industrial and Manufacturing'),
('07', 'Transportation and Utility'),
('08', 'Public Facilities and Institutions'),
('09', 'Open Space and Outdoor Recreation'),
('10', 'Parking Facilities'),
('11', 'Vacant Land');
