-- Question 1: How does the zipcode affect the subscription type?
SELECT c.ZipCode, 'Belgium' AS Country, c.SubscriptionType, COUNT(*) AS SubscriptionCount
FROM dbo.Fact_velo f
         JOIN dbo.dim_Customer c ON f.DIM_CUSTOMER_SUBSCRIPTION_SK = c.SubscriptionId
GROUP BY c.ZipCode, c.SubscriptionType

-- Conclusion:
-- Yearly subscriptions are dominant in every zip code
-- however if filtered out we see that monthly are the next most popular in essentially every zip code

-- Question 2: How does the type of bike affect the number of rides?
SELECT BT.BikeTypeDescription, COUNT(R.RideId) AS RideCount
FROM dbo.Rides R
         JOIN dbo.Vehicles V ON R.VehicleId = V.VehicleId
         JOIN dbo.Bikelots BL ON V.BikeLotId = BL.BikeLotId
         JOIN dbo.BikeTypes BT ON BL.BikeTypeId = BT.BikeTypeId
GROUP BY BT.BikeTypeDescription

SELECT BT.BikeTypeDescription, COUNT(R.RideId) AS RideCount, AVG(RideDistance) AS AverageDistance
FROM dbo.Rides R
         JOIN dbo.Vehicles V ON R.VehicleId = V.VehicleId
         JOIN dbo.Bikelots BL ON V.BikeLotId = BL.BikeLotId
         JOIN dbo.BikeTypes BT ON BL.BikeTypeId = BT.BikeTypeId
GROUP BY BT.BikeTypeDescription


-- Question 3:

