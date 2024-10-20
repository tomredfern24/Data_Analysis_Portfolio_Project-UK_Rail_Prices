Objective 5 - Ticket Price and Journey Characteristic Analysis
##
**Objective:** Understand the relationship between journey length, speed, and ticket pricing.

       Key Questions:
        - Do faster routes have higher ticket prices?
        - Are there routes with unusually high or low prices compared to the average?
For this section I calculated an estimate for expected price per minute for the overall network, and this was used to calculate an expected average price for each route, based on journey duration.

Routes with average prices within +-15% of the expected price were classified as **'As expected'**

Routes with average prices 15% higher than the expected price were classified as **'Higher than expected'**

Routes with average prices 15% lower than the expected price were classified as **'Lower than expected'**

##
**SQL Queries:** 

```

-- Do Faster routes tend to have ticket prices. Is there a relationship?

SELECT departure_station, arrival_destination, ROUND(AVG(price), 2) AS average_price, ROUND((AVG(TIME_TO_SEC(journey_duration)) / 60), 1) AS avg_journey_time_mins
FROM railway_working
GROUP BY departure_station, arrival_destination
ORDER BY avg_journey_time_mins DESC
;
```

```
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
```

##
Power BI Visualisation:

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/5.%20Ticket%20Price%20Analysis.png)
##
**Insights:**

From the scatter plot of Average Price against Average Journey Time, we can see from the trendline that there is a general trend towards higher prices.

In general the highest priced tickets are for journeys between 100 and 150 minutes long. A large proportion of these are priced higher than expected, based on the expected price estimation calculated.

There are some notable outliers, 4 of the longest routes by journey time are on average priced much lower than their expected prices. These are:

- **Birmingham New Street to Edinburgh, priced on average £39.06 lower than the expected price**
- **Edinburgh Waverley to London Kings Cross priced on average £44.60 lower than the expected price**
- **London Kings Cross to Edinburgh Waverley priced on average £48.32 lower than the expected price**
- **York to Edinburgh, priced on average £22.48 lower than the expected price**

From the pie chart in the bottom right we can see that of the 65 total routes, **32 routes** are considered to be priced **Lower than expected**, which is approx 49% of all routes.

We can also see that of the 65 total routes, only **13 routes** are considered to be priced **As expected**, which is approx 20% of all routes.

This means approximately **80%** of all routes deviate significantly from their expected price.

The most expensive route on average is **Manchester to London Paddington** at £114.

For the 15 most expensive routes, all but one are on average priced higher than their expected price.
**Birmingham New Street to Edinburgh, priced on average £39.06 lower than the expected price** is the only exception to this.

##
**Conclusions:**
