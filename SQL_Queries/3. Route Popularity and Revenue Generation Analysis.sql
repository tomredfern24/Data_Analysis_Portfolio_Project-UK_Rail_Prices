-- 3. Analysing popular routes and revenue generation

-- Finding most and least popular routes by passenger volume

SELECT departure_station,
arrival_destination,
COUNT(*) AS total_ticket_sales
FROM railway_working
GROUP BY departure_station, arrival_destination
ORDER BY total_ticket_sales DESC
;

-- Finding which routes generate the most and least revenue, using the SUM aggregate function

SELECT 
departure_station AS station_start, 
arrival_destination AS station_end,
COUNT(*) AS total_ticket_sales,
SUM(price) AS total_revenue
FROM railway_working
GROUP BY station_start, station_end
ORDER BY total_revenue DESC
;

-- Finding which routes sell the most first class tickets, and the percentage proportion of sales which are first class, a
-- also the overall revenue, overall average ticket prices, as well as the average first and standard class ticket prices for each route and the amount of revenue each class of ticket generates


SELECT
	departure_station AS station_start,
	arrival_destination AS station_end,
	CONCAT(departure_station, ' to ', arrival_destination) AS route_name,
	SUM(CASE WHEN ticket_class = 'First Class' THEN 1 ELSE 0 END) AS total_first_class_sales,
	SUM(CASE WHEN ticket_class = 'Standard' THEN 1 ELSE 0 END) AS total_standard_class_sales,
	COUNT(*) AS total_sales,
	ROUND(SUM(CASE WHEN ticket_class = 'First Class' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_first_class,
	ROUND(SUM(CASE WHEN ticket_class = 'Standard' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_standard_class,
	SUM(price) AS total_revenue,
	SUM(CASE WHEN ticket_class = 'First Class' THEN price ELSE 0 END) AS total_first_class_revenue,
	SUM(CASE WHEN ticket_class = 'Standard' THEN price ELSE 0 END) AS total_standard_class_revenue,
	ROUND(SUM(price) / COUNT(*), 2) AS average_ticket_price,
	ROUND(AVG(CASE WHEN ticket_class = 'First Class' THEN price END), 2) AS average_first_class_price,
	ROUND(AVG(CASE WHEN ticket_class = 'Standard' THEN price END), 2) AS average_standard_class_price
FROM railway_working
GROUP BY station_start, station_end, route_name
ORDER BY total_revenue DESC;


-- Query to show the overall revenue and ticket sales for standard and first class, regardless of route

SELECT
ticket_class,
sum(price) AS revenue,
count(*) AS total_sales
FROM railway_working
GROUP BY ticket_class;

-- Query to show revenue by each city

SELECT 
    departure_city AS city,
    SUM(price) AS total_location_revenue,
    COUNT(*) AS total_tickets_sold_each_location
FROM (
    SELECT 
        CASE 
            WHEN LOCATE(' ', departure_station) > 0 
            THEN LEFT(departure_station, LOCATE(' ', departure_station) - 1)
            ELSE departure_station
        END AS departure_city,
        price
    FROM railway_working

    UNION ALL

    SELECT 
        CASE 
            WHEN LOCATE(' ', arrival_destination) > 0 
            THEN LEFT(arrival_destination, LOCATE(' ', arrival_destination) - 1)
            ELSE arrival_destination
        END AS arrival_city,
        price
    FROM railway_working
) AS combined_cities
GROUP BY city;
