-- 1. Journey Duration Analysis

 
 -- Adding a column for actual journey duration, 
 
ALTER TABLE railway_working
ADD actual_journey_duration time;

UPDATE railway_working
SET actual_journey_duration = TIMEDIFF(actual_arrival_time, departure_time)
WHERE actual_arrival_time is not null;

-- Upon running this query some entries are incorrect as this query has not taken into account changes of date due to overnight journeys
-- Updated Query to find actual journey duration, taking into account overnight journeys (ie where arrival time is less than departure time in the calculation)

SELECT departure_station, arrival_destination, date_of_journey, departure_time, actual_arrival_time,
CASE
	WHEN actual_arrival_time >= departure_time
		THEN TIMEDIFF(
		CONCAT(date_of_journey, ' ', actual_arrival_time),
		CONCAT(date_of_journey, ' ', departure_time)
		)
		ELSE TIMEDIFF(
		CONCAT(DATE_ADD(date_of_journey, INTERVAL 1 DAY), ' ', actual_arrival_time),
		CONCAT(date_of_journey, ' ', departure_time)
		)
END AS actual_journey_duration
FROM railway_working
WHERE actual_arrival_time is not null;


-- Updating table to reflect this calculation

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
WHERE actual_arrival_time IS NULL;

-- I now want to write a query to find routes where the average travel time is higher than advertised
-- Similar to what was done previously, I am going to create a new column for journey_duration, which I will use to compare to actual_journey_duration

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

-- Query to show all journeys where the average actual journey duration is higher than the advertised duration based on the arrival time on the ticket



SELECT departure_station, arrival_destination, 
	AVG(TIME_TO_SEC(actual_journey_duration)) / 60 AS average_actual_duration_in_minutes,
	AVG(TIME_TO_SEC(journey_duration)) / 60 AS average_advertised_duration_in_minutes
FROM railway_working
GROUP BY departure_station, arrival_destination
HAVING average_actual_duration_in_minutes > average_advertised_duration_in_minutes 
ORDER BY 3 DESC
;

-- Updating query to include the difference, and ranking by the greatest difference between actual and advertised journey durations (in minutes). This is what I will import to Power BI to create my dashboard.

SELECT
	departure_station,
	arrival_destination,
	CONCAT(departure_station, ' to ', arrival_destination) AS route,
	AVG(TIME_TO_SEC(actual_journey_duration)) / 60 AS average_actual_duration_in_minutes,
	AVG(TIME_TO_SEC(journey_duration)) / 60 AS average_advertised_duration_in_minutes,
	ROUND(((AVG(TIME_TO_SEC(actual_journey_duration)) / 60) - (AVG(TIME_TO_SEC(journey_duration)) / 60)), 2) AS difference
FROM railway_working
GROUP BY departure_station, arrival_destination, route
ORDER BY difference DESC
;