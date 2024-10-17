-- While creating my dashboard I noticed the route names were too long to display nicely on my charts.
-- I wrote this query to split each station into a shortened code system, using the first 3 characters of each departure and arrival station.
-- Since London has multiple stations, and is the only city in the table that does
-- I came up with a method utilising the substring function to add the first 3 letters of the second word to all london stations only.
-- Example:  'Manchester Picadilly to London Paddington' becomes 'Man-LonPad', 'York to Sheffield' becomes 'Yor-She'

SELECT
	CONCAT(
    	-- For departure city and station
    	SUBSTRING(departure_station, 1, 3), -- First 3 characters of departure city
    	CASE
        	-- Check if it's London, if so, include first 3 characters of station name
        	WHEN SUBSTRING(departure_station, 1, 6) = 'London' THEN SUBSTRING(SUBSTRING_INDEX(departure_station, ' ', -1), 1, 3)
        	-- Otherwise, don't include the station
        	ELSE ''
    	END,
    	'-',
    	-- For arrival city and station
    	SUBSTRING(arrival_destination, 1, 3), -- First 3 characters of arrival city
    	CASE
        	-- Check if it's London, if so, include first 3 characters of station name
        	WHEN SUBSTRING(arrival_destination, 1, 6) = 'London' THEN SUBSTRING(SUBSTRING_INDEX(arrival_destination, ' ', -1), 1, 3)
        	-- Otherwise, don't include the station
        	ELSE ''
    	END
	) AS route_code,
	CONCAT(departure_station, ' to ', arrival_destination) AS route_name,
	COUNT(*)
FROM railway_working
GROUP BY route_code, route_name;
