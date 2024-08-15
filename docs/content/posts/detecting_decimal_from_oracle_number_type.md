+++
title = 'Detecting decimal from Oracle number type'
date = 2024-07-09T11:28:47Z
draft = true
tags = ['oracle', 'database']

+++

## Motivation
- Detecting specific dataypes for parquet file generation

## Data
* https://www.kaggle.com/datasets/arnavsmayan/fitness-tracker-dataset

## Version
- Oracle Database 23ai Free Release 23.0.0.0.0

## Setup
- Imported dataset 5 times for a total of 5 million rows
- Created index
```sql
CREATE INDEX sleep_hrs_idx ON FITNESS.FITNESS_TRACKER ("sleep_hours");
```

## Tests
|Query|Time|
|:---|---:|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE ROUND("sleep_hours") != "sleep_hours";`|0.100s|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE TRUNC("sleep_hours") != "sleep_hours";`|0.100s|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE FLOOR("sleep_hours") != "sleep_hours";`|0.107s|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE TRUNC("sleep_hours", 0) != "sleep_hours";`|0.108s|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE CAST("sleep_hours" AS INTEGER) != "sleep_hours";`|0.147s|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE "sleep_hours" LIKE '%.%';`|0.194s|
|`SELECT count(*) FROM FITNESS.FITNESS_TRACKER WHERE MOD("sleep_hours", 1) != 0;`|0.222s|
|`SELECT COUNT(*) FROM FITNESS.FITNESS_TRACKER WHERE NOT REGEXP_LIKE("sleep_hours", '^[0-9]+$')`|0.970s|