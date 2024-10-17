-- 2. Peak Travel Time Analysis

-- Time of day most tickets are sold regardless of route, taking the hour value only from each depature time, and showing the total sales at each hour. This is done from 0-23 for every day of the week. Could be visualised as a heatmap to show peak hours.
    
   SELECT
	DAYNAME(date_of_journey) AS day_of_week_travelled,
	HOUR(departure_time) AS hour_of_day,
	COUNT(*) AS total_sales
FROM railway_working
GROUP BY day_of_week_travelled, hour_of_day
ORDER BY
	CASE
    	WHEN LOWER(day_of_week_travelled) = 'monday' THEN 1
    	WHEN LOWER(day_of_week_travelled) = 'tuesday' THEN 2
    	WHEN LOWER(day_of_week_travelled) = 'wednesday' THEN 3
    	WHEN LOWER(day_of_week_travelled) = 'thursday' THEN 4
    	WHEN LOWER(day_of_week_travelled) = 'friday' THEN 5
    	WHEN LOWER(day_of_week_travelled) = 'saturday' THEN 6
    	WHEN LOWER(day_of_week_travelled) = 'sunday' THEN 7
	END ASC,
	hour_of_day;


-- Query count all journeys at each distinct departure time. This will allow for a plot of journeys against time.

SELECT
departure_time,
count(*) as total_journeys
FROM railway_working
GROUP BY departure_time
ORDER BY departure_time;
