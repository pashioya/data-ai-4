-- Station: represents a station with properties including Street and Number, ZipCode, District, GPSCoord
SELECT StationId, StationNr, Type, Street, Number as StreetNumber, ZipCode,
       CASE District
           WHEN 'ANTWERPEN' THEN 1
           WHEN 'BERCHEM' THEN 2
           WHEN 'BORGERHOUT' THEN 3
           WHEN 'DEURNE' THEN 4
           WHEN 'HOBOKEN' THEN 5
           WHEN 'MERKSEM' THEN 6
           WHEN 'WILRIJK' THEN 7
           END AS NeighborhoodId
FROM Stations;


-- Neighborhood: represents a neighborhood
SELECT ROW_NUMBER() OVER (ORDER BY District) AS NeighborhoodId, District AS Name
FROM Stations
GROUP BY District;


-- Relation : Belongs to : Station belongs to a neighborhood
Select StationId, District as Name
From Stations;

-- Journey: represents a journey with properties including StartPoint, EndPoint, StartTime, EndTime, VehicleId, SubscriptionId, StartLockId, EndLockId
SELECT RideId, StartTime, EndTime, v.VehicleId, Rides.SubscriptionId, subt.Description as SubscriptionType ,st.StationNr as StartStationNR, sl.StationLockNr as StartStationLockNr, en.StationNr as EndStationNR, el.StationLockNr as EndStationLockNr
FROM Rides
         join Vehicles v on Rides.VehicleId = v.VehicleId
         join Locks sl on Rides.StartLockId = sl.LockId
         join Locks el on Rides.EndLockId = el.LockId
         join Stations st on sl.StationId = st.StationId
         join Stations en on el.StationId = en.StationId
         join Subscriptions sub on Rides.SubscriptionId = sub.SubscriptionId
         join SubscriptionTypes subt on sub.SubscriptionTypeId = subt.SubscriptionTypeId
WHERE CONVERT(date, StartTime) = '2019-06-13';


