-- 01_row_counts.sql
-- Purpose: size of the raw table and number of distinct ships.
-- COUNT(*) counts every ping (row); COUNT(DISTINCT MMSI) counts unique ships.
-- Result: 7,167,046 rows, 15,831 unique ships (~453 pings per ship).

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT MMSI) AS unique_ships
FROM `ais-ship-project.raw_ais_data.aw_ais_noaa`;
