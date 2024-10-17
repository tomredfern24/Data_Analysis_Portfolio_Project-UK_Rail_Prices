Objective 3 - Peak Time Analysis
##
Objective: Evaluate passenger volume and revenue generation across different routes.

       Key Questions:
        - Which routes are the most and least popular?
        - Which routes generate the highest and lowest revenue?
        - Which routes have the highest average ticket prices and most first-class ticket sales?

##
SQL Query: Used to extract route name, average actual journey duration, average advertised journey duration and the difference between the two durations from the dataset.

```
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
```
##
Power BI Visualisation:

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/3.%20Route%20Popularity%20and%20Revenue%20Generation%20Analysis%20Dasboard.png)
![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/3b.%20Revenue%20by%20Location.png)
##
Insights:

##
Conclusions:
