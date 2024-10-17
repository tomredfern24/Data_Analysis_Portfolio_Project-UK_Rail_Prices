Objective 5 - Ticket Price and Journey Characteristic Analysis
##
Objective: Understand the relationship between journey length, speed, and ticket pricing.

       Key Questions:
        - Do faster routes have higher ticket prices?
        - Are there routes with unusually high or low prices compared to the average?

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

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/5.%20Ticket%20Price%20Analysis.png)
##
Insights:

##
Conclusions:
