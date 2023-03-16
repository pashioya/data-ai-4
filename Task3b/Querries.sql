-- rides table
-- vehicleid Fk
-- subscriptionid fk
-- startlockid fk
-- endlockid fk
-- startpoint
-- endpoint
-- distance
-- starttime
-- endtime
-- duration
-- weather

CREATE TABLE rides (
    RIDEID BIGINT PRIMARY KEY,
    SUBSCRIPTIONID INTEGER,
    STARTLOCKID INTEGER,
    ENDLOCKID INTEGER,
    DISTANCE NUMERIC(10,2),
    STARTTIME TIMESTAMP,
    ENDTIME TIMESTAMP,
    DURATION BIGINT,
    WEATHER NVARCHAR(50)
);