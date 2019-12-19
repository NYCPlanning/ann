<h3>yearbuilt 2019-11</h3>

<p>This is an effort to research and hopefully correct longstanding issues
with PLUTO's YearBuilt field. Since LPC believes it substantially has the
correct dates, the plan is to correct PLUTO's YearBuilt using LPC's Date_High,
provided that there is only one building on a lot. This is unless we have
reason to believe the building has been demolished and/or rebuilt (rare with
landmarks, but it happens).</p>

<p>As of this writing, this process produces a file for further verification.
It does not directly make any corrections to PLUTO.</p>

<h4>Outstanding questions as of 12-2019</h4>

<ul>
<li>Is it always appropriate to take the historic district designation date, or
should we be taking other designation dates (e.g. individual landmark) into consideration?</li>
<li>Do we need to bypass non-standard building types such as lamppost, or garden? There is
a list of non-standard types in sql/yrbuilt_filter_bldg_types.sql.</li>
<li>We may wish to solicit DOB input before we proceed with production fixes.</li>
</ul>

<h4>What You Need</h4>

<ol>
<li><strong>LPC data.</strong> This serves as a base for the file we are creating. It
is derived from LPC's "Individual Landmark and Historic Building Database," available on <a
href="https://data.cityofnewyork.us/Housing-Development/LPC-Individual-Landmark-and-Historic-District-Buil/7mgd-s57w">NYC Open Data</a>.</li>
<li><strong>lpc_dc_buildings_sites.</strong> Landmarks table, from LPC's "Designated and
Calendared Buildings and Sites." Available on <a href="https://data.cityofnewyork.us/Housing-Development/Designated-and-Calendared-Buildings-and-Sites/ncre-qhxs">NYC Open Data</a>. This is used for the designation year.</li>
<li><strong>PLUTO.</strong> We get several fields from PLUTO, including YearBuilt, NumBldgs, and AppDate.</li>
<li><strong>DOB Footprints.</strong> We obtain CNSTRCT_YR from footprints, provided it is
greater than or equal to 1965.</li>
<li><strong>Housing Development.</strong> New buildings and demolitions from the Housing
Development database. Downloads available from the <a href="https://capitalplanning.nyc.gov/">Capital Planning Platform</a>. (Log in and see "New Housing Developments.")</li>
<li><strong>A .env file.</strong> See env_example in this repository.</li>
</ol>
