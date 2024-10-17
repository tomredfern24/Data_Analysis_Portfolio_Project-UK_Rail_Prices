-- 5. Ticket Price and Journey


-- Do Faster routes tend to have ticket prices. Is there a relationship?

SELECT departure_station, arrival_destination, ROUND(AVG(price), 2) AS average_price, ROUND((AVG(TIME_TO_SEC(journey_duration)) / 60), 1) AS avg_journey_time_mins
FROM railway_working
GROUP BY departure_station, arrival_destination
ORDER BY avg_journey_time_mins DESC
;


-- Query using two CTEs to find the average price per minute based on the whole network, the second CTE then uses this calculation
-- to calculate and 'expected price' for each route as a way to estimate what it should be.
-- We then select the route, average price, average journey time,
-- expected price and use a case statement to give us a price comparison
-- Average prices within +-15% of expected price are 'As expected', 15% lower than expected price are 'Lower than Expected etc. 

    
    
    WITH average_price_per_minute AS (   -- 1st CTE calculates the average price per minute of journey
	SELECT
    	SUM(price) / SUM(TIME_TO_SEC(journey_duration) / 60) AS price_per_minute
	FROM
    	railway_working
	WHERE
    	journey_duration IS NOT NULL
),
route_pricing AS ( -- 2 CTE to calculate pricing information for each route based on departure and arrival
	SELECT
    	departure_station,
    	arrival_destination,
    	AVG(price) AS average_price,
    	(AVG(TIME_TO_SEC(journey_duration)) / 60) AS avg_journey_time_mins,
    	(AVG(TIME_TO_SEC(journey_duration)) / 60) * (SELECT price_per_minute FROM average_price_per_minute) AS expected_price 
	FROM
    	railway_working
	GROUP BY
    	departure_station,
    	arrival_destination
)
SELECT
	departure_station,
	arrival_destination,
	CONCAT(departure_station, ' to ', arrival_destination) AS route_name,
	average_price,
	avg_journey_time_mins,
	expected_price,
	CASE
    	WHEN average_price > expected_price * 1.15 THEN 'Higher than expected'
    	WHEN average_price < expected_price * 0.85 THEN 'Lower than expected'
    	ELSE 'As expected'
	END AS price_comparison
FROM
	route_pricing
ORDER BY
	price_comparison DESC, average_price DESC;
