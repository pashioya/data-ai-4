
-- Question 1: What are the busy times (on a daily basis) during the week compared to the weekend?
-- average duration of trips by day of week
SELECT DATENAME(WEEKDAY, dim_date.DATE) AS DayOfWeek,
       AVG(DURATION_MV) AS AvgDuration,
       COUNT(RideId) AS RideCount
FROM Fact_velo
         JOIN dim_date ON Fact_velo.DATE_SK = dim_date.date_sk
GROUP BY DATENAME(WEEKDAY, dim_date.DATE)
ORDER BY IIF(DATENAME(WEEKDAY, dim_date.DATE) IN ('Saturday', 'Sunday'), 1, 0), DATENAME(WEEKDAY, dim_date.DATE);


-- Question2: Do date parameters affect distance traveled?
-- average distance traveled on each day
SELECT DATE_SK, AVG(DISTANCE_MV) AS AvgDistance
FROM Fact_velo
GROUP BY DATE_SK
ORDER BY DATE_SK;

-- average distance traveled by month
SELECT DATEPART(MONTH, dim_date.date) AS Month, AVG(DISTANCE_MV) AS AvgDistance
FROM Fact_velo
         JOIN dim_date ON Fact_velo.DATE_SK = dim_date.date_sk
GROUP BY DATEPART(MONTH, dim_date.date)
ORDER BY DATEPART(MONTH, dim_date.date);


-- average distance traveled by year
SELECT DATEPART(YEAR, dim_date.date) AS Year, AVG(DISTANCE_MV) AS AvgDistance
FROM Fact_velo
         JOIN dim_date ON Fact_velo.DATE_SK = dim_date.date_sk
GROUP BY DATEPART(YEAR, dim_date.date)
ORDER BY DATEPART(YEAR, dim_date.date);


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





-- Question 7: How does the gender of the user affect the duration of the trip?
-- males tend to have longer trips
SELECT Gender, AVG(DURATION_MV) AS AvgDuration
FROM Fact_velo
         JOIN dim_Customer ON Fact_velo.DIM_CUSTOMER_SUBSCRIPTION_SK = dim_Customer.CUSTOMER_SK
GROUP BY Gender;




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








