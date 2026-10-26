-- 06_distance_speed.sql
-- Purpose: calculate distance, time gap and speed between consecutive pings,
-- then compare the calculated speed with the speed the ship reports (SOG).
-- Step 1 (pings): previous position/time via LAG.
-- Step 2 (moves): distance in metres (ST_DISTANCE) and seconds between pings.
-- Final SELECT: speed = metres / seconds, x 1.94384 to convert m/s to knots.
-- Note: ST_GEOGPOINT takes longitude first, then latitude.
-- Result (one ship tested): calculated speed was close to reported SOG.

WITH pings AS (
  SELECT
    MMSI, BaseDateTime, LAT, LON, SOG,
    LAG(LAT) OVER (PARTITION BY MMSI ORDER BY BaseDateTime) AS prev_lat,
    LAG(LON) OVER (PARTITION BY MMSI ORDER BY BaseDateTime) AS prev_lon,
    LAG(BaseDateTime) OVER (PARTITION BY MMSI ORDER BY BaseDateTime) AS prev_time
  FROM `ais-ship-project.raw_ais_data.clean_ais_data`
  WHERE MMSI = 367599790
),
moves AS (
  SELECT
    *,
    ST_DISTANCE(ST_GEOGPOINT(LON, LAT), ST_GEOGPOINT(prev_lon, prev_lat)) AS dist_m,
    TIMESTAMP_DIFF(BaseDateTime, prev_time, SECOND) AS secs
  FROM pings
)
SELECT
  MMSI, BaseDateTime, SOG,
  ROUND(dist_m, 1) AS dist_m,
  secs,
  ROUND(SAFE_DIVIDE(dist_m, secs) * 1.94384, 1) AS calc_speed_knots
FROM moves
ORDER BY BaseDateTime
LIMIT 20;
