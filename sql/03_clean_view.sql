-- 03_clean_view.sql
-- Purpose: cleaned layer, saved as a View (stores the query, not a copy of the data).
-- Keeps the 9 columns needed for movement analysis.
-- Filters: valid coordinates, no negative speed.
-- AIS "not available" placeholder codes are converted to NULL (rows are kept):
--   SOG 102.3 = speed not available, Heading 511 = heading not available.
-- Raw data is left untouched; cleaning happens here (ELT).

CREATE OR REPLACE VIEW `ais-ship-project.raw_ais_data.clean_ais_data` AS
SELECT
  MMSI,
  BaseDateTime,
  LAT,
  LON,
  IF(SOG >= 102.3, NULL, SOG) AS SOG,
  COG,
  IF(Heading = 511, NULL, Heading) AS Heading,
  VesselName,
  Status
FROM `ais-ship-project.raw_ais_data.aw_ais_noaa`
WHERE
  LAT IS NOT NULL
  AND LON IS NOT NULL
  AND SOG >= 0
  AND LAT BETWEEN -90 AND 90
  AND LON BETWEEN -180 AND 180;
