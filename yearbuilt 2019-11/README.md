<h3>yearbuilt 2019-11</h3>

<p>This is an effort to research and hopefully correct longstanding issues
with PLUTO's YearBuilt field. Since LPC believes it substantially has the
correct dates, the plan is to correct PLUTO's YearBuilt using LPC's Date_High,
provided that there is only one building on a lot.</p>

<p>As of this writing, this process produces a file for further verification.
It does not directly make any corrections to PLUTO.</p>

<h4>What You Need</h4>

<ol>
<li><strong>LPC data.</strong> This serves as a base for the file we are creating. It
is derived from LPC's "Individual Landmark and Historic Building Database," available on <a
target="_blank" href="https://data.cityofnewyork.us/Housing-Development/LPC-Individual-Landmark-and-Historic-District-Buil/7mgd-s57w">NYC Open Data</a>.</li>
<li><strong>lpc_dc_buildings_sites.</strong> Landmarks table, from LPC's "Designated and
Calendared Buildings and Sites." Available on <a target="_blank" href="https://data.cityofnewyork.us/Housing-Development/Designated-and-Calendared-Buildings-and-Sites/ncre-qhxs">NYC Open Data</a>.</li>
<li><strong>PLUTO</strong> We get several fields from PLUTO, including YearBuilt, and NumBldgs, AppDate.</li>
<li><strong>DOB Footprints</strong> We obtain CNSTRCT_YR from footprints, provided it is
greater than or equal to 1965.</li>
<li><strong>Housing Development</strong> New buildings and demolitions from the Housing
Development database. Downloads available from the <a href="https://capitalplanning.nyc.gov/">Capital Planning Platform</a>.</li>
</ol>
