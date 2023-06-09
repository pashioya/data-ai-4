-- query that we want to optimize
-- I took this one firstly because it is one of the few queries that don't use the AVG() function,
-- secondly because it was one of the queries that took the most amount of time to run.
SELECT DIM_LOCKS.LOCKID, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.LOCKID
ORDER BY NUMTRIPS DESC;

-- set options for indexed views
-- these options have to be set this way to assure that the indexed view returns consistent results
-- and to avoid null values
ALTER DATABASE VELO_DWH
    SET ANSI_NULLS ON,
    ANSI_PADDING ON,
    ANSI_WARNINGS ON,
    ARITHABORT ON,
    CONCAT_NULL_YIELDS_NULL ON,
    NUMERIC_ROUNDABORT OFF,
    QUOTED_IDENTIFIER ON,
    RECURSIVE_TRIGGERS OFF;

-- verify that the options are set correctly
SELECT IS_ANSI_NULLS_ON,
       IS_ANSI_PADDING_ON,
       IS_ANSI_WARNINGS_ON,
       IS_ARITHABORT_ON,
       IS_CONCAT_NULL_YIELDS_NULL_ON,
       IS_NUMERIC_ROUNDABORT_ON,
       IS_QUOTED_IDENTIFIER_ON,
       IS_RECURSIVE_TRIGGERS_ON
FROM SYS.DATABASES
WHERE NAME = 'velo_dwh';

-- create view of the query
-- we use schemabinding to ensure data integrity and optimal performance optimization
CREATE VIEW dbo.vw_materializedview
    WITH SCHEMABINDING
AS
SELECT dbo.DIM_LOCKS.LOCKID, COUNT_BIG(*) AS NUMTRIPS
FROM dbo.FACT_VELO
         JOIN dbo.DIM_LOCKS ON dbo.FACT_VELO.STARTLOCKID = dbo.DIM_LOCKS.LOCKID
GROUP BY dbo.DIM_LOCKS.LOCKID;

-- create clustered index for the view
-- By creating a unique clustered index on the LOCKID column of the view,
-- we are specifying that the LOCKID values must be unique within the view,
-- and the data will be physically stored and sorted based on this column.
create unique clustered index lock_trips_cindex
on dbo.VW_MATERIALIZEDVIEW(LOCKID);

-- lets try the same query again:
SELECT DIM_LOCKS.LOCKID, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.LOCKID
ORDER BY NUMTRIPS DESC;


-- query without indexed view: total cost = 18.0907, time = ~120ms
-- query with indexed view   : total cost = 0.0772,  time = ~80ms

-- conclusion: The indexed view decreased by 99.57% so it is definitely for the best to use this query



