Objective 5 - Ticket Price and Journey Characteristic Analysis
##
**Objective:** Understand the relationship between journey length, speed, and ticket pricing.

       Key Questions:
        - Do faster routes have higher ticket prices?
        - Are there routes with unusually high or low prices compared to the average?

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

- **Birmingham New Street to Edinburgh, at 270 minutes Average Journey Time, approx **
- **Edinburgh Waverley to London Kings Cross - at 260 minutes Average Journey Time**
- **London Kings Cross to Edinburgh Waverley - at 260 minutes Average Journey Time**
- **York to Edinburgh - at 150 minutes Average Journey Time**

##
**Conclusions:**
