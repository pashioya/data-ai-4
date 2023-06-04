-- Question 1: How do the subscription types spread depending on the zipcode and the period of time?
SELECT c.ZipCode, 'Belgium' AS Country, c.SubscriptionType, COUNT(*) AS SubscriptionCount
FROM dbo.Fact_velo f
         JOIN dbo.dim_Customer c ON f.DIM_CUSTOMER_SUBSCRIPTION_SK = c.SubscriptionId
GROUP BY c.ZipCode, c.SubscriptionType

-- Conclusion:
-- Yearly subscriptions are dominant in every zip code
-- however if filtered out we see that monthly are the next most popular in essentially every zip code
-- Dashboard 1:
-- You can choose the types of subscriptions you want to see
-- you can see details of the zipcodes you want to see
-- you can choose the months you want to see

-- Question 2: How does the type of bike affect the number of rides?
SELECT BT.BikeTypeDescription, COUNT(R.RideId) AS RideCount
FROM dbo.Rides R
         JOIN dbo.Vehicles V ON R.VehicleId = V.VehicleId
         JOIN dbo.Bikelots BL ON V.BikeLotId = BL.BikeLotId
         JOIN dbo.BikeTypes BT ON BL.BikeTypeId = BT.BikeTypeId
GROUP BY BT.BikeTypeDescription

-- you can see the graphs showing the number of rides for each type of bike
-- you can see the graphs showing the average ride distance for each type of bike


-- Question 3:
--     How many rides started and ended in each district during a specific month?
SELECT
    start_station.ZipCode,
    DATENAME(MONTH, r.StartTime) AS StartMonth,
    COUNT(DISTINCT r.RideId) AS RideCount,
    'Belgium' AS Country
FROM
    dbo.Rides r
        INNER JOIN dbo.Locks start_lock ON r.Startlockid = start_lock.LockId
        INNER JOIN dbo.Locks end_lock ON r.EndLockId = end_lock.LockId
        INNER JOIN dbo.Stations start_station ON start_lock.StationId = start_station.StationId
        INNER JOIN dbo.Stations end_station ON end_lock.StationId = end_station.StationId
GROUP BY
    start_station.ZipCode,
    DATENAME(MONTH, r.StartTime)

-- Dashboard 2:
-- You can choose the months you want to see
-- You can see the visualisations of the number of rides for each district


