WITH RankedTable AS (
    SELECT "Borough", "NumFloors",
        ROW_NUMBER() OVER (PARTITION BY "Borough" ORDER BY "NumFloors") AS Rnk,
        COUNT(*) OVER (PARTITION BY "Borough") AS Count
    FROM dcp.pluto192
)
SELECT "Borough", "NumFloors"
FROM RankedTable
WHERE Rnk = Count / 2 + 1;
