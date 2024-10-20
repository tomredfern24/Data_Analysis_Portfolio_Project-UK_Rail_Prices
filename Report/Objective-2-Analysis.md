Objective 2 - Peak Time Analysis
##
**Objective:** Analyse hourly and daily travel patterns to identify peak and off-peak periods.

       Key Questions:
        - What are the busiest travel times and days of the week by passenger volume (ticket sales)?
        - What proportion of journeys occur on weekdays vs. weekends?

##
**SQL Queries:** 
```
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

```
```

-- Query to count all journeys at each distinct departure time. This will allow for a plot of journeys against time.

SELECT
departure_time,
count(*) as total_journeys
FROM railway_working
GROUP BY departure_time
ORDER BY departure_time;
```
##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/2.%20Peak%20Time%20Analysis%20Dashboard.png)
##
**Insights:**

From the visualisations (heatmap and line plot), several key patterns regarding passenger volume and peak times emerge:

1. Peak Travel Hours:
	- The busiest travel periods are 6AM-9AM and 4PM-7PM, reflecting typical commuter patterns. These hours consistently see the highest volume of ticket sales across the week.
 	- Of the 31,653 total tickets sold in the dataset, 16,390 tickets (approximately 51.7%) were sold during these peak hours, meaning that just over half of all journeys occur during these times.

2. Busiest and Least Busy Days:
	- Wednesday is the busiest day for travel, with 4,692 ticket sales, while Friday ranks as the least busy day with 4,351 ticket sales.
 	- This contrasts with general assumptions that Fridays may be busier due to end-of-week travel, and may warrant further investigation.

3. Specific Hourly Peaks:
	- The busiest hour of the week is 6PM-7PM on Tuesdays, with 496 tickets sold during this period.
 	- Conversely, the least busy hour is 7PM-8PM on Thursdays, with only 43 tickets sold.

4. Weekday vs. Weekend Travel:
	- 28.39% of all journeys are made during the weekend, indicating that the majority of travel occurs on weekdays. This reinforces the idea that weekday travel is driven largely by work or routine activities, while weekend travel could be more leisure-oriented or less frequent overall.

##
**Conclusions:**

The analysis of hourly and daily travel patterns highlights that peak commuting times **(6AM-9AM and 4PM-7PM)** account for more than half of all journeys, reflecting typical commuter behavior. The busiest travel day, **Wednesday**, deviates from common assumptions, with **Friday** being surprisingly the least busy day. Additionally, the weekend accounts for just over a quarter of all journeys (28.39%), demonstrating that weekday travel significantly outpaces weekend travel.

These insights suggest that rail operators could focus resource allocation, such as staffing and train frequency, to better manage demand during peak hours and on busy days like Tuesdays and Wednesdays. On the other hand, the significantly quieter hours, such as Thursday evenings, may represent opportunities for cost savings through reduced service or more efficient use of resources.

Further analysis could explore variations in travel patterns during public holidays or seasonal changes, potentially identifying additional trends in off-peak travel. This would help optimize scheduling and improve operational efficiency across the network.
