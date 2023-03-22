
-- Question 1: What are the busy times (on a daily basis) during the week compared to the weekend?
-- average duration of trips by day of week
SELECT DayOfWeek,
       AVG(DURATION_MV) AS AvgDuration,
       COUNT(RideId) AS RideCount
FROM (
         SELECT RideId,
                DURATION_MV,
                DATENAME(WEEKDAY, CONVERT(DATE, CONVERT(VARCHAR(8), DATE_SK))) AS DayOfWeek
         FROM Fact_velo
     ) AS Subquery
GROUP BY DayOfWeek
ORDER BY CASE WHEN DayOfWeek IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END, DayOfWeek;




-- Question2: Do date parameters affect distance traveled?
-- not sure how to do this one
-- SELECT AVG(DISTANCE_MV) AS AvgDistance
-- FROM Fact_velo
-- WHERE DATE_SK BETWEEN [Start_Date] AND [End Date];




-- Question 3: --Does weather affect trips?

-- average duration of trips by weather type

SELECT dim_weather.WEATHER_TYPE, AVG(Fact_velo.DURATION_MV) AS AvgDuration
FROM Fact_velo
         JOIN dim_weather ON Fact_velo.WEATHER_SK = dim_weather.WEATHER_SK
GROUP BY dim_weather.WEATHER_TYPE;

-- Number of trips by weather type

SELECT dim_weather.WEATHER_TYPE, count(*) AS NumberOfTrips
FROM Fact_velo
         JOIN dim_weather ON Fact_velo.WEATHER_SK = dim_weather.WEATHER_SK
GROUP BY dim_weather.WEATHER_TYPE;





-- Question 4: How does the place of residence of users affect bicycle use?

-- Number of trips by city
SELECT dim_Customer.City, COUNT(*) AS NumberOfTrips
FROM Fact_velo
         JOIN dim_Customer ON Fact_velo.DIM_CUSTOMER_SUBSCRIPTION_SK = dim_Customer.CUSTOMER_SK
GROUP BY dim_Customer.City;

-- Average duration of trips by city
SELECT dim_Customer.City, AVG(Fact_velo.DURATION_MV) AS AvgDuration
FROM Fact_velo
         JOIN dim_Customer ON Fact_velo.DIM_CUSTOMER_SUBSCRIPTION_SK = dim_Customer.CUSTOMER_SK
GROUP BY dim_Customer.City;






-- Question 5: We want to predict which locks need preventive maintenance. See how often lock numbers are used relatively.

-- number of trips that start at each lock.  the ones with the most trips are the ones that need more maintenance
SELECT dim_locks.LOCKID, COUNT(*) AS NumTrips
FROM Fact_velo
         JOIN dim_locks ON Fact_velo.Startlockid = dim_locks.LOCKID
GROUP BY dim_locks.LOCKID
ORDER BY NumTrips DESC;

-- number of trips that end at each lock. the ones with the most trips are the ones that need more maintenance
SELECT dim_locks.LOCKID, COUNT(*) AS NumTrips
FROM Fact_velo
         JOIN dim_locks ON Fact_velo.EndLockId = dim_locks.LOCKID
GROUP BY dim_locks.LOCKID
ORDER BY NumTrips DESC;






-- Question 6: How does the type of subscription affect the number of rides?
SELECT dim_Customer.SubscriptionType, COUNT(*) AS NumRides
FROM Fact_velo
         JOIN dim_Customer ON Fact_velo.DIM_CUSTOMER_SUBSCRIPTION_SK = dim_Customer.CUSTOMER_SK
GROUP BY dim_Customer.SubscriptionType;






-- Question 7: How does the length of a trip affect the distance traveled?
-- the higher the duration the higher the distance traveled on average
SELECT DURATION_MV, round(AVG(DISTANCE_MV),0) AS AvgDistance
FROM Fact_velo
where DURATION_MV > 0
GROUP BY DURATION_MV
ORDER BY DURATION_MV;






-- Question 8:  How does the station location affect the number of trips?
-- the more trips that start at a station the more trips that end at that station
SELECT dim_locks.LOCKID, COUNT(*) AS NumTrips
FROM Fact_velo
         JOIN dim_locks ON Fact_velo.Startlockid = dim_locks.LOCKID
GROUP BY dim_locks.LOCKID
ORDER BY NumTrips DESC;








-- Question 9: How does lock type affect the number of trips that start at the lock?
SELECT dim_locks.TYPE, COUNT(*) AS NumTrips
FROM Fact_velo
         JOIN dim_locks ON Fact_velo.Startlockid = dim_locks.LOCKID
GROUP BY dim_locks.TYPE
ORDER BY NumTrips DESC;









