SELECT "BBL",
"ZoneDist1",
"ZoneDist2",
"ZoneDist3",
"ZoneDist4"
"Overlay1",
"Overlay2",
"SPDist1",
"SPDist2",
"SPDist3",
"ResidFAR",
"CommFAR",
"FacilFAR",
"SplitZone",
"Address",
"NumFloors",
geom
FROM dcp.pluto192_corr
WHERE "ZoneDist1" IN ('R1-1', 'R1-2', 'R1-2A', 'R2', 'R2A', 'R2X',
					  'R3-1', 'R3-2', 'R3A', 'R3X', 'R4', 'R4-1', 'R4A', 'R4B',
					  'R5', 'R5A', 'R5B', 'R5D')
AND "SplitZone" = 'N'
AND "NumFloors" > 1
ORDER BY "ZoneDist1", "NumFloors" DESC;
