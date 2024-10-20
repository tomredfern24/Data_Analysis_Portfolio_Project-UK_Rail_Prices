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
##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/3.%20Route%20Popularity%20and%20Revenue%20Generation%20Analysis%20Dasboard.png)
![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/3b.%20Revenue%20and%20Journeys%20by%20City.png)
##
**Insights:**

*Note, these revenue calculations are not taking into account refunds, that will be looked at in further detail in the refunds analysis section.

The top 3 most popular routes by ticket sales (passenger volume) are **Manchester Piccadilly to Livepool Lime Street**, **London Euston to Birmingham New Street**, **London Kings Cross to York** at 4628, 4210 and 3920 total tickets sold respectively.

The top 3 least popular routes by ticket sales (passenger volume) are **Livepool Lime Street to Birmingham New Street**, **Manchester Piccadilly to Warrington**, **Manchester Piccadilly to York** at 14, 15, 15 total tickets respectively.

Despite seeling the most tickets, the Manchester Piccadilly to Livepool Lime Street route only generates £17,310 in total revenue, although this is likely because of the low average ticket price of £3.74.

The routes that generate the highest revenue are **London Kings Cross to York** and **Liverpool Lime Street to London Euston**, at £183,193 and £113,299 respectively. Although London Kings Cross to York has a lower average ticket price (£46.71) compared to Liverpool Lime Street to London Euston (£103.28), London Kings Cross has far higher ticket sales at 3922 compared to 1097 ticket sales.


The routes that generate the lowest revenue are **London Euston to Oxford** and **Manchester Piccadilly to Warrington**, at £41 and £53 respectively. The respective ticket sales and average ticket price are 16 sales & £2.56, 15 sales and £3.53.

##
**Conclusions:**
