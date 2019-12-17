lotarea 2019-10

This is for a simple lotarea update using the ESRI Shape_Area.
If the PLUTO lotarea is zero, we update it using the Shape_Area.
We then create before and after breakout reports.

There is also a python script to create a barchart of before
and after lotarea amounts, by land use code.

1. lotarea.sql identifies PLUTO records where the lotarea is zero,
and updates these with the shape area. These are rounded to the nearest
digit as lotarea does not allow for decimal places to the right of
the decimal point.

Having updated the lotarea, the sql proceeds to create several
breakout reports: by land use code, by building class, by borough,
in addition to summary totals. These queries will create database
views. The land use view may be used for barchart creation.

2. lotarea_barchart.py can be run on the command line as follows:

python3 lotarea_barchart.py

Before you run it, you need a landuse.csv file such as the one in
the data directory in this repository. The necessary data should
be in the view created by lotarea.sql, lotarea_comparison_landuse,
and it will need to reside in the data folder.
