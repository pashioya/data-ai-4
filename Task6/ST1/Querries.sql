--question 1: how many locks are there per person per zipcode ?
SELECT COUNT(DISTINCT DIM_LOCKS.LOCKID)            AS LOCKCOUNT,
       COUNT(DISTINCT DIM_CUSTOMER.SUBSCRIPTIONID) AS SUBSCRIPTIONCOUNT,
       DIM_CUSTOMER.ZIPCODE
FROM DIM_LOCKS
         RIGHT JOIN DIM_CUSTOMER ON DIM_LOCKS.ZIPCODE = DIM_CUSTOMER.ZIPCODE
GROUP BY DIM_CUSTOMER.ZIPCODE;


--dashboard 1
--sheet 1: antwerp map with lock-count/subscription-count per zipcode
--sheet 2: bar chart with lock-count/subscription-count per zipcode with dynamic set for highlights

--Conclusion: a lot of zipcodes dont have locks at all even when there are people subscribed to velo
--            there needs to be locks installed in those places

-- Question2: How many locks are there compared to the amount of trips
--number of trips taken per zipcode
SELECT NUMTRIPS.ZIPCODE, SUM(NUMTRIPS) as TRIPS
FROM (SELECT DIM_LOCKS.ZIPCODE, COUNT(STARTLOCKID) + COUNT(ENDLOCKID) AS NUMTRIPS
      FROM FACT_VELO
               JOIN DIM_LOCKS ON FACT_VELO.STARTLOCKID = DIM_LOCKS.LOCKID
      WHERE LOCKID != 0
      GROUP BY DIM_LOCKS.LOCKID, DIM_LOCKS.ZIPCODE) AS NUMTRIPS
GROUP BY NUMTRIPS.ZIPCODE;

--number of locks per zipcode
SELECT ZIPCODE, COUNT(LOCKID) FROM DIM_LOCKS WHERE LOCKID != 0 GROUP BY ZIPCODE;


--dashboard 2
--sheet 1: scatter plot of number of locks for each zipcode on the y axis and number of trips for each zipcode on the x axis
--sheet 2: another way to visualize sheet 1,
--         the size of the circles is the amount of trips per zipcode and the amount of locks is written as well as the zipcode
--sheet 3: antwerp map with locks/trips for each zipcode

--Conclusion: Zones in very light blue need to install more locks in that zone