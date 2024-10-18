Objective 6 - Refunds and Delays Analysis
##
Objective: Investigate the impact of delays and cancellations on refund requests.

       Key Questions:
        - Is there a correlation between delay length and refund requests?
        - Which routes experience the most delays or cancellations, and what are the common causes?

##
**SQL Queries:** 

```
SELECT

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

From the plot of delay lengths for each route that experienced delays, we can see the route with by far the longest delays on average is **Manchester Piccadilly to Leeds** at **144 minutes**, with **65 total delays and cancellations**. 
We saw this in objective 1 where this route was on average running 65 minutes later than the advertised journey duration, however this analysis is calculating the average delay length ONLY for journeys which were delayed.

Interestingly, this route recorded **0 total refund requests**.

The route with the second longest delays on average is **York to Doncaster** at **69 minutes**, with **38 total delays and cancellations**. This route only recorded **3 refund requests**.

The route with the highest number or refund requests by far is **Liverpool Lime Street to London Euston**. The average 

##
**Conclusions:**
