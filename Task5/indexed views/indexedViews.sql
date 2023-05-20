ALTER DATABASE VELO_DWH
    SET ANSI_NULLS ON,
    ANSI_PADDING ON,
    ANSI_WARNINGS ON,
    ARITHABORT ON,
    CONCAT_NULL_YIELDS_NULL ON,
    NUMERIC_ROUNDABORT OFF,
    QUOTED_IDENTIFIER ON,
    RECURSIVE_TRIGGERS OFF;

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

CREATE VIEW dbo.vw_materializedview
    WITH SCHEMABINDING
AS
SELECT dbo.DIM_LOCKS.LOCKID, COUNT_BIG(*) AS NUMTRIPS
FROM dbo.FACT_VELO
         JOIN dbo.DIM_LOCKS ON dbo.FACT_VELO.STARTLOCKID = dbo.DIM_LOCKS.LOCKID
GROUP BY dbo.DIM_LOCKS.LOCKID;

create unique clustered index lock_trips_cindex
on dbo.VW_MATERIALIZEDVIEW(LOCKID);

SELECT DIM_LOCKS.LOCKID, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.LOCKID
ORDER BY NUMTRIPS DESC;


