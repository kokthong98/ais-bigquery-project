-- 02_null_checks.sql
-- Purpose: measure missing values in key columns of the raw table.
-- COUNTIF counts only the rows where the condition is true.
-- Result: 17,201 missing VesselName; 1,628,738 missing Status (~23%); 0 missing coordinates.

SELECT
  COUNTIF(VesselName IS NULL) AS missing_vessel_name,
  COUNTIF(Status IS NULL) AS missing_status,
  COUNTIF(LAT IS NULL OR LON IS NULL) AS missing_coordinates,
  COUNT(*) AS total_rows
FROM `ais-ship-project.raw_ais_data.aw_ais_noaa`;
