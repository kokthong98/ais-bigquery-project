-- 05_previous_ping.sql
-- Purpose: attach each ping's previous position and time using the LAG window function.
-- PARTITION BY MMSI  -> compare only within the same ship.
-- ORDER BY BaseDateTime -> "previous" means earlier in time.
-- The first ping of each ship has NULL previous values (no earlier row).

SELECT
  MMSI,
  BaseDateTime,
  LAT,
  LON,
  LAG(LAT) OVER (PARTITION BY MMSI ORDER BY BaseDateTime) AS prev_lat,
  LAG(LON) OVER (PARTITION BY MMSI ORDER BY BaseDateTime) AS prev_lon,
  LAG(BaseDateTime) OVER (PARTITION BY MMSI ORDER BY BaseDateTime) AS prev_time
FROM `ais-ship-project.raw_ais_data.clean_ais_data`
WHERE MMSI = 367599790
ORDER BY BaseDateTime
LIMIT 20;
