-- 04_placeholder_check.sql
-- Purpose: find AIS placeholder codes that pass simple NULL/range filters.

-- (a) Run against the View BEFORE the placeholder fix in 03_clean_view.sql:
--     SOG >= 102.3 -> 22,587 rows; Heading = 511 -> 3,670,402 rows (of 7,167,046).
SELECT
  COUNTIF(SOG >= 102.3) AS sog_not_available,
  COUNTIF(Heading = 511) AS heading_not_available,
  COUNT(*) AS total_rows
FROM `ais-ship-project.raw_ais_data.clean_ais_data`;

-- (b) Run AFTER the fix: placeholders should be 0, NULL counts should be higher,
--     and total_rows must stay the same (values converted, rows not deleted).
SELECT
  COUNTIF(SOG >= 102.3) AS sog_placeholder_left,
  COUNTIF(Heading = 511) AS heading_placeholder_left,
  COUNTIF(SOG IS NULL) AS sog_null,
  COUNTIF(Heading IS NULL) AS heading_null,
  COUNT(*) AS total_rows
FROM `ais-ship-project.raw_ais_data.clean_ais_data`;
