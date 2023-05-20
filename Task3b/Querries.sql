
-- Question 1: What are the busy times (on a daily basis) during the week compared to the weekend?
-- average duration of trips by day of week
SELECT DATENAME(WEEKDAY, DIM_DATE.DATE) AS DAYOFWEEK,
       AVG(DURATION_MV)                 AS AVGDURATION,
       COUNT(RIDEID)                    AS RIDECOUNT
FROM FACT_VELO
         JOIN DIM_DATE ON FACT_VELO.DATE_SK = DIM_DATE.DATE_SK
GROUP BY DATENAME(WEEKDAY, DIM_DATE.DATE)
ORDER BY IIF(DATENAME(WEEKDAY, DIM_DATE.DATE) IN ('Saturday', 'Sunday'), 1, 0), DATENAME(WEEKDAY, DIM_DATE.DATE);

-- Question2: Do date parameters affect distance traveled?
-- average distance traveled on each day
SELECT DATE_SK, AVG(DISTANCE_MV) AS AVGDISTANCE
FROM FACT_VELO
GROUP BY DATE_SK
ORDER BY DATE_SK;

-- average distance traveled by month
SELECT DATEPART(MONTH, DIM_DATE.DATE) AS MONTH, AVG(DISTANCE_MV) AS AVGDISTANCE
FROM FACT_VELO
         JOIN DIM_DATE ON FACT_VELO.DATE_SK = DIM_DATE.DATE_SK
GROUP BY DATEPART(MONTH, DIM_DATE.DATE)
ORDER BY DATEPART(MONTH, DIM_DATE.DATE);

-- average distance traveled by year
SELECT DATEPART(YEAR, DIM_DATE.DATE) AS YEAR, AVG(DISTANCE_MV) AS AVGDISTANCE
FROM FACT_VELO
         JOIN DIM_DATE ON FACT_VELO.DATE_SK = DIM_DATE.DATE_SK
GROUP BY DATEPART(YEAR, DIM_DATE.DATE)
ORDER BY DATEPART(YEAR, DIM_DATE.DATE);


-- Question 3: --Does weather affect trips?

-- average duration of trips by weather type

SELECT DIM_WEATHER.WEATHER_TYPE, AVG(FACT_VELO.DURATION_MV) AS AVGDURATION, COUNT(*) AS NUMBEROFTRIPS
FROM FACT_VELO
         JOIN DIM_WEATHER ON FACT_VELO.WEATHER_SK = DIM_WEATHER.WEATHER_SK
GROUP BY DIM_WEATHER.WEATHER_TYPE;


-- Number of trips by weather type

SELECT DIM_WEATHER.WEATHER_TYPE, COUNT(*) AS NUMBEROFTRIPS
FROM FACT_VELO
         JOIN DIM_WEATHER ON FACT_VELO.WEATHER_SK = DIM_WEATHER.WEATHER_SK
GROUP BY DIM_WEATHER.WEATHER_TYPE;



-- Question 4: How does the place of residence of users affect bicycle use?

-- Number of trips by city
SELECT DIM_CUSTOMER.CITY, COUNT(*) AS NUMBEROFTRIPS
FROM FACT_VELO
         JOIN DIM_CUSTOMER ON FACT_VELO.DIM_CUSTOMER_SUBSCRIPTION_SK = DIM_CUSTOMER.CUSTOMER_SK
GROUP BY DIM_CUSTOMER.CITY;

-- Average duration of trips by city
SELECT DIM_CUSTOMER.CITY, AVG(FACT_VELO.DURATION_MV) AS AVGDURATION
FROM FACT_VELO
         JOIN DIM_CUSTOMER ON FACT_VELO.DIM_CUSTOMER_SUBSCRIPTION_SK = DIM_CUSTOMER.CUSTOMER_SK
GROUP BY DIM_CUSTOMER.CITY;



-- Question 5: We want to predict which locks need preventive maintenance. See how often lock numbers are used relatively.

-- number of trips that start at each lock.  the ones with the most trips are the ones that need more maintenance
SELECT DIM_LOCKS.LOCKID, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.LOCKID
ORDER BY NUMTRIPS DESC;

-- number of trips that end at each lock. the ones with the most trips are the ones that need more maintenance
SELECT DIM_LOCKS.LOCKID, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.ENDLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.LOCKID
ORDER BY NUMTRIPS DESC;


-- Question 6: How does the type of subscription affect the number of rides?
SELECT DIM_CUSTOMER.SUBSCRIPTIONTYPE, COUNT(*) AS NUMRIDES
FROM FACT_VELO
         JOIN DIM_CUSTOMER ON FACT_VELO.DIM_CUSTOMER_SUBSCRIPTION_SK = DIM_CUSTOMER.CUSTOMER_SK
GROUP BY DIM_CUSTOMER.SUBSCRIPTIONTYPE;



-- Question 7: How does the gender of the user affect the duration of the trip?
-- males tend to have longer trips
SELECT GENDER, AVG(DURATION_MV) AS AVGDURATION
FROM FACT_VELO
         JOIN DIM_CUSTOMER ON FACT_VELO.DIM_CUSTOMER_SUBSCRIPTION_SK = DIM_CUSTOMER.CUSTOMER_SK
GROUP BY GENDER;



-- Question 8:  How does the station location affect the number of trips?
-- the more trips that start at a station the more trips that end at that station
SELECT DIM_LOCKS.LOCKID, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.LOCKID
ORDER BY NUMTRIPS DESC;


-- QUESTION 9: HOW DOES LOCK TYPE AFFECT THE NUMBER OF TRIPS THAT START AT THE LOCK?
SELECT DIM_LOCKS.TYPE, COUNT(*) AS NUMTRIPS
FROM FACT_VELO
         JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
GROUP BY DIM_LOCKS.TYPE
ORDER BY NUMTRIPS DESC;


-- get all the data for ride with id 2616520
SELECT
    f.RideId,
    c.SubscriptionId,
    c.ValidFrom,
    c.SubscriptionType,
    c.UserId,
    c.Gender,
    c.Street,
    c.Number,
    c.City,
    c.ZipCode,
    d.DATE,
    d.DAY_OF_MONTH,
    d.MONTH,
    d.YEAR,
    d.WEEK,
    d.WEEKDAY,
    d.DAY_OF_WEEK,
    d.DAY_OF_YEAR,
    d.HOURS,
    d.MINUTES,
    d.SECONDS,
    l1.LOCKID AS StartLockId,
    l2.LOCKID AS EndLockId,
    f.DURATION_MV,
    f.DISTANCE_MV,
    w.WEATHER_TYPE
FROM dbo.Fact_velo f
         JOIN dbo.dim_Customer c ON f.DIM_CUSTOMER_SUBSCRIPTION_SK = c.CUSTOMER_SK
         JOIN dbo.dim_date d ON f.DATE_SK = d.DATE_SK
         JOIN dbo.dim_locks l1 ON f.Startlockid = l1.LOCKID
         JOIN dbo.dim_locks l2 ON f.EndLockId = l2.LOCKID
            JOIN dbo.dim_weather w ON f.WEATHER_SK = w.WEATHER_SK
WHERE f.RideId = 3033513;







