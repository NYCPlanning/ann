-- Report records where
-- 1. LotDepth * LotFront is far from LotArea (either less than LotArea minus 100 or greater than LotArea plus 100), AND
-- 2. LotDepth * LotFront is reasonably close to Shape_Area (greater than Shape_Area minus 100 and less than Shape_Area + 100)

SELECT "BBL",
"LotDepth",
"LotFront",
"LotArea",
"LotFront" * "LotDepth" AS "Front x Depth",
"Shape_Area",
ABS("Shape_Area" - ("LotFront" * "LotDepth")) AS "Shape_Area / Front x Depth Difference (Absolute value)",
"IrrLotCode"
FROM dcp.pluto192
WHERE (ROUND("LotDepth" * "LotFront") < "LotArea" - 100
OR ROUND("LotDepth" * "LotFront") > "LotArea" + 100)
AND (ROUND("LotDepth" * "LotFront") > (ROUND("Shape_Area") - 100)
AND (ROUND("LotDepth" * "LotFront") < (ROUND("Shape_Area") + 100)))
ORDER BY 7;

-- This was not requested, but perhaps a summary by landuse code would be of interest.

SELECT "LandUse",
SUM("Shape_Area" - "LotArea") AS "LotArea Difference"
FROM dcp.pluto192
WHERE (ROUND("LotDepth" * "LotFront") < "LotArea" - 100
OR ROUND("LotDepth" * "LotFront") > "LotArea" + 100)
AND (ROUND("LotDepth" * "LotFront") > (ROUND("Shape_Area") - 100)
AND (ROUND("LotDepth" * "LotFront") < (ROUND("Shape_Area") + 100)))
GROUP BY "LandUse"
ORDER BY "LandUse";

-- Add the count

SELECT "LandUse", COUNT(*) AS "Records Affected"
FROM dcp.pluto192
WHERE (ROUND("LotDepth" * "LotFront") < "LotArea" - 100
OR ROUND("LotDepth" * "LotFront") > "LotArea" + 100)
AND (ROUND("LotDepth" * "LotFront") > (ROUND("Shape_Area") - 100)
AND (ROUND("LotDepth" * "LotFront") < (ROUND("Shape_Area") + 100)))
GROUP BY "LandUse"
ORDER BY "LandUse";
