Objective 1 - Journey Duration Analysis
##
**Objective:** Identify routes with the longest and shortest average journey times and assess their consistency with advertised times.

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

4. Updated query to include the difference between actual and advertised journey times, which I visualised in Power BI:

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

I visualised this in Power BI to show which routes were, on average, consistently running later than advertised, sorted by the difference in actual and advertised journey times.

##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/1.%20Journey%20Duration%20Analysis%20Dashboard.png)

##
**Insights:**

1. Longest and Shortest Routes:

	- The longest average journey time is for the route from Edinburgh Waverley to London Kings Cross, with an average duration of 275.57 minutes.
	- The shortest average journey times are observed for the Birmingham New Street to Wolverhampton and Reading to Didcot routes, both averaging around 15 minutes.

2. On-time Performance:

	 - Out of the 65 distinct routes analysed (excluding reverse journeys), 18 routes (or 27.7%) consistently exceed their advertised journey times, highlighting underperformance in almost a third of the dataset's routes.

3. Significant Delays:
	
	 - The route with the largest discrepancy between the actual and advertised journey times is Manchester Piccadilly to Leeds, which averages 65 minutes later than scheduled.
	 - Other notable underperformers include:
	   - London Euston to York, which averages 36 minutes later than advertised.
	   - Liverpool Lime Street to London Euston, arriving an average of 29 minutes late.

##
**Conclusions:**

The analysis highlights that while most routes adhere to their advertised durations, a substantial portion (nearly 28%) experience delays, with certain routes consistently running late by significant margins. The most notable delays are on key long-distance routes, particularly Manchester Piccadilly to Leeds, London Euston to York, and Liverpool Lime Street to London Euston, which all show large deviations from the advertised times.

These findings could indicate operational inefficiencies or external factors affecting these routes. Further analysis could investigate potential causes such as infrastructure issues, scheduling conflicts, or high passenger volumes, which may contribute to these delays. Addressing these factors could lead to improved punctuality and customer satisfaction, particularly on routes with significant delays.

Future steps could include a deeper investigation into seasonal patterns or the impact of external factors (e.g., weather, network congestion) on journey durations, alongside potential mitigation strategies to improve punctuality on the most affected routes.
