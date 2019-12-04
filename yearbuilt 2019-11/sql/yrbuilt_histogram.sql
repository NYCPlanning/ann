-- Used to create input to Matplotlib Histogram routine

SELECT CAST(yearbuilt / 10 AS VARCHAR) || '0s' AS decade
FROM dcp.pluto191
WHERE yearbuilt <> 0
ORDER BY 1;

-- For checking results
SELECT CAST(yearbuilt / 10 AS VARCHAR) || '0s' AS decade, COUNT(*)
FROM dcp.pluto191
WHERE yearbuilt <> 0
GROUP BY 1
ORDER BY 1;
