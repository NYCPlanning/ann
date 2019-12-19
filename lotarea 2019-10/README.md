<h3>lotarea 2019-10</h3>

<p>This is for a simple lotarea update using the ESRI Shape_Area, a
change was that was first implemented for PLUTO 19v2.
If the PLUTO lotarea is zero, we update it using the Shape_Area.
We then create before and after breakout reports.</p>

<p>There is also a python script to create a bar chart of before
and after lotarea amounts, by land use code.</p>

<p>The breakout reports and bar chart were converted to a Jupyter Notebook
12/2019. This supercedes the SQL and Python bar chart module, which were used
at production time.</p>

<h4>What You Need</h4>

<ol>
<li><strong>PLUTO.</strong> A Postgres copy of PLUTO before the lotarea updates.
The logic will SUM lotarea values as well as ESRI Shape_Area values, and compute
the differences.</li>
<li><strong>A landuse definition table.</strong> See the irrlotcode 2019-11/sql folder in this repository for the DDL.</li>
<li><strong>Various Python modules.</strong> See the first cell in the notebook for  
a list.</li>
</ol>
