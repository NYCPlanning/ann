<h3>LotArea 2019-12</h3>

<p>Here I am trying to find records where the lot front * the lot depth is not
close to the lot area value, but is reasonably close to the ESRI Shape_Area's value.</p>

<p>Lot front * lot depth is either < lot area - 100 or > lot area + 100, <em>AND</em>
Lot front * lot depth is within 100 square feet of Shape_Area.</p>

<p>A summary report by LandUse code is also included.</p>

<h4>What You Need</h4>

<ol>
<li><strong>PLUTO.</strong></li>
<li><strong>LandUse Definitions.</strong> See the LandUse_Definitions DDL file in the irrlotcode 2019-11 folder of this repository.</li>
</ol>
