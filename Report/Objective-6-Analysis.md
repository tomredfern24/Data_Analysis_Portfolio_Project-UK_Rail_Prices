Objective 6 - Refunds and Delays Analysis
##
Objective: Investigate the impact of delays and cancellations on refund requests.

       Key Questions:
        - Is there a correlation between delay length and refund requests?
        - Which routes experience the most delays or cancellations, and what are the common causes?

##
**SQL Queries:** 


```
--  6. Refunds and Delays Analysis


-- Query to get breakdown of total journeys, delays, cancellations, on time journeys, refund requests and average delay length grouped by each route

SELECT
	CONCAT(departure_station, ' to ', arrival_destination) AS route_name,
	COUNT(*) AS total_journeys,  -- Total journeys for this route
	COUNT(CASE WHEN journey_status = 'Delayed' THEN 1 END) AS total_delays,
	COUNT(CASE WHEN journey_status = 'Cancelled' THEN 1 END) AS total_cancellations,
	COUNT(CASE WHEN journey_status = 'On Time' THEN 1 END) AS total_on_time,
	COALESCE(AVG(CASE WHEN journey_status = 'Delayed' THEN (TIME_TO_SEC(actual_journey_duration) - TIME_TO_SEC(journey_duration)) / 60 END), 0) AS avg_delay_length,  -- excluding results where there are no delays
	SUM(CASE WHEN refund_request = 'Yes' THEN 1 ELSE 0 END) AS total_refund_requests
FROM railway_working
WHERE journey_status IN ('Delayed', 'Cancelled', 'On time')
GROUP BY route_name
ORDER BY total_delays DESC;
```

```
-- Query using CTEs that gives the count of delays for each reason for each route, also gives the total delays for that route as a reference point.

WITH total_delays_per_route AS (
	SELECT
    	CONCAT(departure_station, ' to ', arrival_destination) AS route,
    	COUNT(*) AS total_delays
	FROM railway_working
	WHERE journey_status != 'On Time'
	GROUP BY departure_station, arrival_destination
)
SELECT
	tdr.route,
	rd.reason_for_delay,
	COUNT(*) AS number_delays_for_each_reason,
	tdr.total_delays
FROM railway_working rd
JOIN total_delays_per_route tdr
	ON tdr.route = CONCAT(rd.departure_station, ' to ', rd.arrival_destination)
WHERE rd.journey_status != 'On Time'
GROUP BY tdr.route, rd.reason_for_delay, tdr.total_delays
ORDER BY tdr.route, number_delays_for_each_reason DESC;
```

```
-- Query using CTEs that, for journeys that were delayed, splits the length of delay into ranges
-- and gives the count of refund requests for each time ranges (including cancelled journeys)

WITH delays_refund_CTE AS (
	SELECT railcard,
    	actual_journey_duration,
    	journey_duration,
    	ROUND((TIME_TO_SEC(actual_journey_duration) - TIME_TO_SEC(journey_duration)) / 60, 2) AS delay_length,
    	journey_status,
    	refund_request
	FROM railway_working
	WHERE journey_status IN ('Delayed', 'Cancelled')  -- Include both Delayed and Cancelled
),
delays_range_CTE AS (
	SELECT *,
    	CASE
        	WHEN delay_length BETWEEN 1 AND 5 THEN '1-5 mins'
        	WHEN delay_length BETWEEN 6 AND 15 THEN '6-15 mins'
        	WHEN delay_length BETWEEN 16 AND 30 THEN '16-30 mins'
        	WHEN delay_length BETWEEN 31 AND 60 THEN '31-60 mins'
        	WHEN delay_length BETWEEN 61 AND 120 THEN '61-120 mins'
        	WHEN delay_length BETWEEN 121 AND 180 THEN '121-180 mins'
        	WHEN journey_status = 'Cancelled' THEN 'Cancelled'  -- Handle cancellations as a separate range
        	ELSE 'Over 180 mins'
       	 
    	END AS delay_range
	FROM delays_refund_CTE
	WHERE journey_status = 'Cancelled' OR delay_length > 0  -- Include cancellations
)
SELECT delay_range,
	COUNT(*) AS total_journeys,  -- Total journeys in each range
	SUM(CASE WHEN refund_request = 'Yes' THEN 1 ELSE 0 END) AS count_yes,  -- Refund requests (Yes)
	SUM(CASE WHEN refund_request = 'No' THEN 1 ELSE 0 END) AS count_no  -- Refund requests (No)
FROM delays_range_CTE
GROUP BY delay_range
ORDER BY FIELD(delay_range, '1-5 mins', '6-15 mins', '16-30 mins', '31-60 mins', '61-120 mins', '121-180 mins', 'Cancelled', 'Over 180 mins');
```


```
-- Simple query to give breakdown of number of refund requests for each delay reason.

SELECT
reason_for_delay,
COUNT(refund_request) AS number_refund_requests
FROM railway_working
WHERE refund_request = 'yes'
GROUP BY reason_for_delay;
```


##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/6.%20Refund%20and%20Delay%20Analysis.png)
##

**Insights:**

Across the entire network, there were a total of **4172** delays & cancellations out of the 31653 total journeys made (approx 13.2%)

Out of these, **1880 journeys were cancelled** (approx 5.9%), **2292 journeys were delayed** (approx 7.2%).

Out of the 4172 delayed and cancelled journeys, there were **1118 refund requests**. Approximately 26.8% of all delayed/cancelled journeys resulted in refund requests. 

The average delay length for delayed journeys across the entire network was **40.67 minutes**.


In general there is not a strong correlation between delay length and number of refund requests, it seems to wildly vary by route.

From the refund requests by length of delay line plot, we can see the delay range with the largest number of refund requests is between *16 and 30 minutes** with 233 requests. Then it is **6-15 minutes** and **31-60 minutes** with 127 and 107 requests respectively.

Unexpectedly, there are **no delay requests for delays over 60 minutes long**


The majority of refund requests come from cancelled journeys, with a total of **572 refund requests**

From the plot of delay lengths for each route that experienced delays, we can see the route with by far the longest delays on average is **Manchester Piccadilly to Leeds** at **144 minutes**, with **65 total delays and cancellations**. 
We saw this in objective 1 where this route was on average running 65 minutes later than the advertised journey duration, however this analysis is calculating the average delay length ONLY for journeys which were delayed.

Interestingly, this route recorded **0 total refund requests**.

The route with the second longest delays on average is **York to Doncaster** at **69 minutes**, with **38 total delays and cancellations**. This route only recorded **3 refund requests**.


The total revenue lost to refund across all route is **£38,700**. The total revenue generated by sales, not taking into account refunds, across the entire network is £741,920, after refunds the revenue total would be £703,220 which is a 5.22% loss. It is important to note this dataset does not give any information about refund amounts or even if the requests were accepted, only that a request was or wasn't made for each ticket. If this information was available the value would likely be lower, as the current calculation is based on the assumption that all refund requests were refunded the full amount.

The route with the highest number or refund requests by far is **Liverpool Lime Street to London Euston**. The average length of delay is is **36.6 minutes**.
This is also the route with the **highest number of delays and cancellations overall** at **879**, we can see that this route has the the highest amount of revenue lost to refunds at **£13,126**. This accounts for just over a third (33.9%) of the total amount of revenue lost to refunds across the entire network.

From the pie charts we can see that the most common reason for delays across the entire network was **Weather**, accounting for 32.89% of all delays and cancellations.

Of the 5 main reasons for delays across the network they can be split into two categories: networks problems (Signal Failure, Staffing, Techincal Issues) and condition problems for (Traffic, Weather)

Of these two categories, network problems made up the majority of all reasons for delays at 59.5%, which indicates more work could be done to prevent delays and reduce refunds.

From the breakdown of number of refund requests for each delay reason, **Technical Issues** has by far the most at **34.7%**, 388 refund requests. The least number of refund requests were for journeys delayed by **Weather**.


Considering the two categories previously discussed - 77.28% of all refund requests were for delays caused by network problems. Only 22.72% of refund requests were made by passengers delayed by traffic or weather. This indicates passengers are more likely to requests refunds for journeys delayed by network problems.


##
**Conclusions:**
