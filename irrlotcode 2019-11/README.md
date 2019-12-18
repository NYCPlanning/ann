<h3>IrrLotCode Analysis</h3>

<p>This is an effort to identify lots classified as regular (IRRLOTCODE = 'N')
that should be irregular (IRRLOTCODE = 'Y').</p>

<p>The process is available to run in the enclosed jupyter notebook.</p>

<h4>What You Need</h4>

<ul>
<li><strong>PLUTO.</strong> As a PostgreSQL table.</li>
<li><strong>LandUse Definitions.</strong> A PostgreSQL table called landuse_definitions that contains landuse codes and their definitions. This is helpful for analysis by landuse code.
See the DDL available in this repository: sql/LandUse_Definitions.sql.</li>
<li><strong>An .env file.</strong> See env_example in this repository.</li>
</ul>
