--  6. Refunds and Delays Analysis


-- Query to get breakdown of total journeys, delays, cancellations, on time journeys, refund requests and average delay length grouped by each route

SELECT
	CONCAT(departure_station, ' to ', arrival_destination) AS route_name,
	COUNT(*) AS total_journeys,  -- Total journeys for this route
	COUNT(CASE WHEN journey_status = 'Delayed' THEN 1 END) AS total_delays,
	COUNT(CASE WHEN journey_status = 'Cancelled' THEN 1 END) AS total_cancellations,
	COUNT(CASE WHEN journey_status = 'On Time' THEN 1 END) AS total_on_time,
	COALESCE(AVG(CASE WHEN journey_status = 'Delayed' THEN (TIME_TO_SEC(actual_journey_duration) - TIME_TO_SEC(journey_duration)) / 60 END), 0) AS avg_delay_length,  -- excluding results where there are no delays
	SUM(CASE WHEN refund_request = 'Yes' THEN 1 ELSE 0 END) AS total_refund_requests
FROM railway_working
WHERE journey_status IN ('Delayed', 'Cancelled', 'On time')
GROUP BY route_name
ORDER BY total_delays DESC;

-- Query using CTEs that gives the count of delays for each reason for each route, also gives the total delays for that route as a reference point.

WITH total_delays_per_route AS (
	SELECT
    	CONCAT(departure_station, ' to ', arrival_destination) AS route,
    	COUNT(*) AS total_delays
	FROM railway_working
	WHERE journey_status != 'On Time'
	GROUP BY departure_station, arrival_destination
)
SELECT
	tdr.route,
	rd.reason_for_delay,
	COUNT(*) AS number_delays_for_each_reason,
	tdr.total_delays
FROM railway_working rd
JOIN total_delays_per_route tdr
	ON tdr.route = CONCAT(rd.departure_station, ' to ', rd.arrival_destination)
WHERE rd.journey_status != 'On Time'
GROUP BY tdr.route, rd.reason_for_delay, tdr.total_delays
ORDER BY tdr.route, number_delays_for_each_reason DESC;



-- Query using CTEs that, for journeys that were delayed, splits the length of delay into ranges
-- and gives the count of refund requests for each time ranges (including cancelled journeys)


WITH delays_refund_CTE AS (
	SELECT railcard,
    	actual_journey_duration,
    	journey_duration,
    	ROUND((TIME_TO_SEC(actual_journey_duration) - TIME_TO_SEC(journey_duration)) / 60, 2) AS delay_length,
    	journey_status,
    	refund_request
	FROM railway_working
	WHERE journey_status IN ('Delayed', 'Cancelled')  -- Include both Delayed and Cancelled
),
delays_range_CTE AS (
	SELECT *,
    	CASE
        	WHEN delay_length BETWEEN 1 AND 5 THEN '1-5 mins'
        	WHEN delay_length BETWEEN 6 AND 15 THEN '6-15 mins'
        	WHEN delay_length BETWEEN 16 AND 30 THEN '16-30 mins'
        	WHEN delay_length BETWEEN 31 AND 60 THEN '31-60 mins'
        	WHEN delay_length BETWEEN 61 AND 120 THEN '61-120 mins'
        	WHEN delay_length BETWEEN 121 AND 180 THEN '121-180 mins'
        	WHEN journey_status = 'Cancelled' THEN 'Cancelled'  -- Handle cancellations as a separate range
        	ELSE 'Over 180 mins'
       	 
    	END AS delay_range
	FROM delays_refund_CTE
	WHERE journey_status = 'Cancelled' OR delay_length > 0  -- Include cancellations
)
SELECT delay_range,
	COUNT(*) AS total_journeys,  -- Total journeys in each range
	SUM(CASE WHEN refund_request = 'Yes' THEN 1 ELSE 0 END) AS count_yes,  -- Refund requests (Yes)
	SUM(CASE WHEN refund_request = 'No' THEN 1 ELSE 0 END) AS count_no  -- Refund requests (No)
FROM delays_range_CTE
GROUP BY delay_range
ORDER BY FIELD(delay_range, '1-5 mins', '6-15 mins', '16-30 mins', '31-60 mins', '61-120 mins', '121-180 mins', 'Cancelled', 'Over 180 mins');




-- Simple query to give breakdown of number of refund requests for each delay reason.

SELECT
reason_for_delay,
COUNT(refund_request) AS number_refund_requests
FROM railway_working
WHERE refund_request = 'yes'
GROUP BY reason_for_delay;

 
