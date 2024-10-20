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

The analysis of ticket prices and journey characteristics reveals several patterns and key takeaways:

- General Price Trends:

	- From the scatter plot, we observe that longer journeys tend to have higher prices, as shown by the general upward trend in the data.
	- Journeys lasting between 100 and 150 minutes are generally the most expensive, with many priced higher than expected based on the average price-per-minute calculation.

- Outliers with Lower Prices:

	- Despite longer journey durations, four notable routes are priced much lower than expected:
		- Birmingham New Street to Edinburgh: Priced on average £39.06 lower than expected.
		- Edinburgh Waverley to London Kings Cross: Priced on average £44.60 lower than expected.
		- London Kings Cross to Edinburgh Waverley: Priced on average £48.32 lower than expected.
		- York to Edinburgh: Priced on average £22.48 lower than expected.

- Route Price Classification:

	- 49% of all routes (32 out of 65) are priced lower than expected, indicating that nearly half of the routes offer ticket prices below the estimated average price for their respective journey durations.
 	- Only 20% of routes (13 out of 65) fall within the expected price range, meaning that around 80% of routes deviate significantly from their expected price—either higher or lower.
  	- Of the 65 routes analysed, the majority either offer more affordable tickets or charge higher-than-expected prices, with fewer routes aligning with the predicted cost.

- Most Expensive Route:

	- The most expensive route on average is Manchester to London Paddington, priced at £114. This route stands out as the priciest in the analysis.

- High-Priced Routes:
	- For the 15 most expensive routes, all but one are priced higher than expected. The exception is Birmingham New Street to Edinburgh, which remains priced much lower than expected despite its long journey time.

##
**Conclusions:**

The analysis demonstrates a clear correlation between longer journey durations and higher ticket prices, with most long-distance routes priced above the expected range. However, there are notable exceptions where long routes—especially those between Edinburgh and major cities—are priced significantly lower than anticipated.

Around half of the routes offer prices that are lower than expected, suggesting potential value for passengers. However, only 20% of routes fall within the expected price range, meaning a large proportion of tickets are either over or underpriced in comparison to the average journey cost.

These findings suggest that pricing strategies could be further optimised, particularly for long-distance routes where prices deviate notably from the predicted cost.
