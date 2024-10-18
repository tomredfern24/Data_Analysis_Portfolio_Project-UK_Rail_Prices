Objective 4 - Customer Segment Analysis
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
Power BI Visualisation:

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/4.%20Ticket%20Type%20and%20Railcard%20Analysis.png)
##
Insights:

From the top left pie chart, we can see that the ticket type that accounts for the most revenue are **Advance Tickets** at approximately **41.7%&* of total overall revenue.

The ticket type that accounts for the least revenue are *Anytime tickets* at approximately *28.21%* of total overall revenue.

From the bottom left column chart, we can see that the ticket type with the highest average price are **Anytime Tickets** at **£39.20**

The ticket type with the lowest average price are **Advance Tickets** at **£17.61**. This means on average Anytime Tickets are over **double the price** of Advance Tickets.


##
Conclusions:
