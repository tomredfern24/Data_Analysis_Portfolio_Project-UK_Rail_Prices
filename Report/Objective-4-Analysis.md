Objective 4 - Peak Time Analysis
##
Objective: Explore the relationship between ticket type, railcard usage, and revenue contribution.

       Key Questions:
        - Do railcards account for higher revenue?
        - Which ticket types contribute the most to total revenue?
        - How does the average ticket price differ by ticket type?
        - What is the comparison between railcard and non-railcard revenue?

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
Power BI Viusalisation:

[![alt text]((https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/2.%20Peak%20Time%20Analysis%20Dashboard.png))]
##
Insights:

##
Conclusions:
