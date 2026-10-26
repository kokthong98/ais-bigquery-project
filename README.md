# AIS Ship Data on BigQuery

A small learning project: load real ship-tracking (AIS) data into Google BigQuery, check its quality, clean it, and analyse movement with SQL window functions.

## Data
- AIS position reports for one day (`AIS_2022_03_31.csv`), NOAA / US Coast Guard format.
- Each row is one ping: ship ID (MMSI), timestamp, latitude/longitude, speed (SOG), course (COG), heading, status.
- Source: NOAA / BOEM / US Coast Guard AIS data (Marine Cadastre), 2022 daily files: https://noaaocm.blob.core.windows.net/ais/csv2/csv2022/index.html
- Data dictionary: https://coast.noaa.gov/data/marinecadastre/ais/data-dictionary.pdf
## Flow
CSV -> Cloud Storage (raw landing) -> BigQuery raw table -> cleaned View -> analysis queries

(The CSV was over BigQuery's 100 MB direct-upload limit, so it went through Cloud Storage first.)

## What I found
- 7,167,046 rows from 15,831 ships (about 453 pings per ship).
- No missing coordinates, and every row passed the null/range filters.
- About 23% of rows (1,628,738) have no navigation status. I kept them, because status does not affect position or time.
- AIS uses placeholder codes that look like valid numbers: speed 102.3 (22,587 rows) and heading 511 (3,670,402 rows). Simple NULL and range checks miss them, so I converted them to NULL in the View.
- Using LAG + ST_DISTANCE, the speed calculated from positions and timestamps was close to the speed the ship reported. I tested this on one ship only.

## Queries (in `sql/`)
1. `01_row_counts.sql` - table size and distinct ships
2. `02_null_checks.sql` - missing values
3. `03_clean_view.sql` - cleaned View (placeholders -> NULL)
4. `04_placeholder_check.sql` - detecting AIS "not available" codes
5. `05_previous_ping.sql` - LAG window function
6. `06_distance_speed.sql` - CTEs, distance, time gap, calculated speed

## Skills practised
Cloud Storage -> BigQuery loading, ELT-style cleaning with a View, data quality checks, window functions (LAG), CTEs, BigQuery geography functions.

## Limitations and next steps
- Manual process: nothing runs on a schedule yet.
- Raw and clean objects sit in one dataset; better practice is separate raw and clean datasets.
- Speed comparison was checked on one ship, not the whole dataset.
- Next: build an automated pipeline (scheduled ingestion, quality checks, orchestration) on a new dataset.
