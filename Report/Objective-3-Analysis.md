Objective 3 - Route Popularity and Revenue Analysis
##
**Objective:** Evaluate passenger volume and revenue generation across different routes.

       Key Questions:
        - Which routes are the most and least popular by passenger volume?
	- Which routes have the most first-class ticket sales?
        - Which routes generate the highest and lowest revenue?
        - Which routes have the highest average ticket prices?

##
**SQL Queries:** 

```
-- Finding most and least popular routes by passenger volume

SELECT departure_station,
arrival_destination,
COUNT(*) AS total_ticket_sales
FROM railway_working
GROUP BY departure_station, arrival_destination
ORDER BY total_ticket_sales DESC
;
```

```
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
```

```
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
```


```
-- Query to show the overall revenue and ticket sales for standard and first class, regardless of route

SELECT
ticket_class,
sum(price) AS revenue,
count(*) AS total_sales
FROM railway_working
GROUP BY ticket_class;

```

```

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

```

##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/3.%20Route%20Popularity%20and%20Revenue%20Generation%20Analysis%20Dasboard.png)
![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/3b.%20Revenue%20and%20Journeys%20by%20City.png)
##
**Insights:**

*Note, these revenue calculations are not taking into account refunds, that will be looked at in further detail in the refunds analysis section.

The analysis of route popularity and revenue generation reveals several significant trends:

1. Top Routes by Passenger Volume:
	- The most popular routes by ticket sales are:
	  	- Manchester Piccadilly to Liverpool Lime Street with 4,628 tickets sold.
		- London Euston to Birmingham New Street with 4,210 tickets sold.
		- London Kings Cross to York with 3,920 tickets sold.

2. Least Popular Routes:
	- The least popular routes by passenger volume are:
 		- Liverpool Lime Street to Birmingham New Street (14 total sales).
		- Manchester Piccadilly to Warrington and Manchester Piccadilly to York, both with 15 total sales.

3. Revenue Generation:
	- The routes generating the highest revenue are:
 		- London Kings Cross to York with £183,193.
		- Liverpool Lime Street to London Euston with £113,299.
		- Although Manchester Piccadilly to Liverpool Lime Street has the highest passenger volume, it only generates £17,310, likely due to its low average ticket price of £3.74.

4. Lowest Revenue Routes:
	- The routes generating the least revenue are:
 		- London Euston to Oxford with £41 (16 sales, average ticket price £2.56).
		- Manchester Piccadilly to Warrington with £53 (15 sales, average ticket price £3.53).

5. Ticket Pricing Insights:
	- The route with the highest average ticket price is Manchester Piccadilly to London Paddington at £114.11, followed by Liverpool Lime Street to London St Pancras (£104.77), and Liverpool Lime Street to London Euston (£103.28).

6. First-Class Ticket Sales:
	- The route with the most first-class ticket sales is Manchester Piccadilly to Liverpool Lime Street with 422 sales.
 	- Overall, first-class tickets make up 9.7% of total ticket sales (3,058 first-class sales out of 31,650 tickets), generating £149,400 (approximately 20.1% of total revenue).
	- Standard-class ticket sales generate £592,520, with an average ticket price of £29.90, while first-class ticket prices average £56.29.



##
**Conclusions:**

The analysis indicates that while some routes like Manchester Piccadilly to Liverpool Lime Street are popular by passenger volume, they contribute less to overall revenue due to lower average ticket prices. On the other hand, routes like London Kings Cross to York and Liverpool Lime Street to London Euston generate significantly higher revenue, despite having fewer passengers, due to higher ticket prices.

Interestingly, first-class tickets account for a relatively small portion of total sales (9.7%), yet they contribute disproportionately to revenue (20.1%). This highlights the importance of premium ticket offerings for overall profitability.

In summary, focusing on high-revenue routes and optimising the balance between passenger volume and ticket pricing could enhance overall profitability. Additionally, further exploration of low-performing routes, such as London Euston to Oxford and Manchester Piccadilly to Warrington, might reveal opportunities for service adjustments or targeted marketing to boost revenue on these underutilised routes.
