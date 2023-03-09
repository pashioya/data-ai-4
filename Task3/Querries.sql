-- creating dim customer table
drop table dim_Customer;
CREATE TABLE dim_Customer (
                              SubscriptionId INT,
                              ValidFrom DATE,
                              SubscriptionType VARCHAR(255),
                              UserId INT,
                              Gender VARCHAR(10),
                              Street VARCHAR(255),
                              Number VARCHAR(255),
                              City VARCHAR(255),
                              ZipCode VARCHAR(255),
                              SCD_Start DATE,
                              SCD_End DATE,
                              SCD_VERSION INT,
                              SCD_ACTIVE VARCHAR(255)
);

-- creating dim locks table
drop table dim_locks;
create table dim_locks(
                          LOCKID smallint not null ,
                          STATIONLOCKNR tinyint not null ,
                          STATIONID smallint not null ,
                          TYPE nvarchar(20) not null ,
                          ZIPCODE nvarchar(20) not null ,
                          DISTRICT nvarchar(100) not null
);


-- select query for the dim customer table
SELECT Subscriptions.SubscriptionId, Subscriptions.ValidFrom, SubscriptionTypes.Description AS SubscriptionType,
       Velo.dbo.Users.UserId,
       IIF(CAST(CAST(NEWID() AS VARBINARY) AS INT) % 2 = 0, 'Male', 'Female') AS Gender,
       Street, Number, City, Zipcode
FROM Velo.dbo.Subscriptions
         JOIN Velo.dbo.Users ON Subscriptions.UserId = Users.UserId
         JOIN SubscriptionTypes ON Subscriptions.SubscriptionTypeId = SubscriptionTypes.SubscriptionTypeId
ORDER BY SubscriptionId;


-- select query for the dim locks table
SELECT
    l.LockId,
    l.StationLockNr,
    l.StationId,
    s.Type,
    s.ZipCode,
    s.District,
    s.GPSCoord
FROM dbo.Locks l
         INNER JOIN dbo.Stations s
                    ON l.StationId = s.StationId;
