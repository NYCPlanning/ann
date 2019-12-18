<h3>IrrLotCode Analysis</h3>

<p>This is an effort to identify lots classified as regular (IRRLOTCODE = 'N')
that should be irregular (IRRLOTCODE = 'Y').</p>

<p>There are three conditions for reclassifying a lot:</p>

<ol>
<li>The lot's envelope must be at least 15% larger than the lot.</li>
<li>The lot must not be a sliver lot (area must be greater than 15K).</li>
<li>There must be more than 4 non-straight line angles in the polygon's geometry.</li>
</ol>

<p>The process involves numerous POSTGIS queries and a Python script called IrrLot.py, which
loops through the polygon's points in sets of three, calculates the angle sizes, and
counts them up.</p>

<p>The process is available to run in the enclosed jupyter notebook.</p>

<h4>What You Need</h4>

<ul>
<li><strong>PLUTO.</strong> As a PostgreSQL table.</li>
<li><strong>LandUse Definitions.</strong> A PostgreSQL table called landuse_definitions that contains landuse codes and their definitions. This is helpful for analysis by landuse code.
See the DDL available in this repository: sql/LandUse_Definitions.sql.</li>
<li><strong>An .env file.</strong> See env_example in this repository.</li>
</ul>
