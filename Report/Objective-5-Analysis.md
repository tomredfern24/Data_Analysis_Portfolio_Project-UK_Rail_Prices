Objective 5 - Ticket Price and Journey Characteristic Analysis
##
**Objective:** Understand the relationship between journey length, speed, and ticket pricing.

       Key Questions:
        - Do faster routes have higher ticket prices?
        - Are there routes with unusually high or low prices compared to the average?
For this section I calculared an estimate for expected price per minute for the overall network, and this was used to calculate an expected average price for each route, based on journey duration.

Routes with average prices within +-15% of the expected price were classified as **'As expected'**
Routes with average prices 15% higher than the expected price were classified as **'Higher than expected'**
Routes with average prices 15% lower than the expected price were classified as **'Lower than expected'**
##
**SQL Queries:** 

```
SELECT

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

##
**Conclusions:**
