Objective 1 - Journey Duration Analysis
##
Objective: Identify routes with the longest and shortest average journey times and assess their consistency with advertised times.

  	Key Questions:
   	- Which routes have the longest and shortest average journey times?
   	- Are there routes where travel times consistently exceed advertised durations?

##
**SQL Queries:** Used to extract route name, average actual journey duration, average advertised journey duration and the difference between the two durations from the dataset.
Full working available [HERE](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/edit/main/SQL_Queries/1.%20Journey%20Duration%20Analysis.sql)

For this objective, I calculated the **actual journey duration** of each rail trip and compared it to the **advertised journey duration**. I had to handle special cases where journeys spanned over midnight (overnight trips).

#### Key Steps:
1. Add a new column for **actual journey duration**, calculating the time difference between the **actual arrival** and **departure time**:

```
ALTER TABLE railway_working
ADD actual_journey_duration time;

UPDATE railway_working
SET actual_journey_duration = TIMEDIFF(actual_arrival_time, departure_time)
WHERE actual_arrival_time IS NOT null;
```
2. Altered calculation for actual_journey_duration to account for overnight journeys (journeys that cross over 00:00:00)
```
UPDATE railway_working
SET actual_journey_duration = CASE
	WHEN actual_arrival_time >= departure_time
		THEN TIMEDIFF(
		CONCAT(date_of_journey, ' ', actual_arrival_time),
		CONCAT(date_of_journey, ' ', departure_time)
		)
		ELSE TIMEDIFF(
		CONCAT(DATE_ADD(date_of_journey, INTERVAL 1 DAY), ' ', actual_arrival_time),
		CONCAT(date_of_journey, ' ', departure_time)
		)
END;

-- Removing results where journey was cancelled (ie actual_arrival_time is NULL)

UPDATE railway_working
SET actual_journey_duration = NULL
WHERE actual_arrival_time IS NULL AND journey_status = 'Cancelled';

```
3. Query to find avertised journey duration, using the same method as above.

```
ALTER TABLE railway_working
ADD journey_duration TIME;

UPDATE railway_working
SET journey_duration = CASE
	WHEN arrival_time >= departure_time
		THEN TIMEDIFF(
		CONCAT(date_of_journey, ' ', arrival_time),
		CONCAT(date_of_journey, ' ', departure_time)
		)
		ELSE TIMEDIFF(
		CONCAT(DATE_ADD(date_of_journey, INTERVAL 1 DAY), ' ', arrival_time),
		CONCAT(date_of_journey, ' ', departure_time)
		)
END;
```

4. Updated query to include the difference between actual and advertised journey times, which I visualized in Power BI:

```
SELECT
    departure_station,
    arrival_destination,
    CONCAT(departure_station, ' to ', arrival_destination) AS route,
    AVG(TIME_TO_SEC(actual_journey_duration)) / 60 AS average_actual_duration_in_minutes,
    AVG(TIME_TO_SEC(journey_duration)) / 60 AS average_advertised_duration_in_minutes,
    ROUND(AVG(TIME_TO_SEC(actual_journey_duration)) / 60 - AVG(TIME_TO_SEC(journey_duration)) / 60, 2) AS difference
FROM railway_working
GROUP BY departure_station, arrival_destination
ORDER BY difference DESC;
```
### Explanation:

The problem required calculating **journey durations** for rail trips where some trips spanned across midnight. To address this:
- I used **CASE statements** in SQL to calculate the journey duration, ensuring that overnight trips were accounted for by adding a day to the **arrival time** when necessary.
- Once I had the actual journey durations, I added another column for the **advertised journey duration** (based on the original scheduled arrival times).
- From this I was able to calculate the difference between the two, which formed the basis for my analysis.

I visualized this in Power BI to show which routes were, on average, consistently running later than advertised, sorted by the difference in actual and advertised journey times.

##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/1.%20Journey%20Duration%20Analysis%20Dashboard.png)

##
**Insights:**

From the visualisation we can see that the route with the longest average journey time is **Edinburgh Waverley to London Kings Cross** at 275.57 minutes. 

The shortest average journey times are **Birmingham New Street to Wolverhampton** and **Reading to Didcot** - both coming in at 15 minutes.

We can also see that for our dataset there are **65 distinct routes** involved (not including reverse journeys), and of those 65 routes there are **18 routes** which are on average running later than their advertised journey time. This means **27.7%** of routes are consistently underperfoming.

The route that has the biggest discrepancy between average and actual journey times is **Manchester Piccadilly - Leeds**, which on average arrives **65 minutes** later than advertised.

Following this is **London Euston - York**, which on average arrives **36 minutes** later than advertised.

Following this is **Liverpool Lime Street - London Euston**, which on average arrives **29 minutes** later than advertised.
##
Conclusions:
