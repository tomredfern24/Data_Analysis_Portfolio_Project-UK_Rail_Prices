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

From the refund requests by length of delay line plot, we can see the delay range with the largest number of refund requests is between *16 and 30 minutes** with 233 requests. Then it is **6-15 minutes** and **31-60 minutes** with 127 and 107 requests respectively.

Unexpectedly, there are **no delay requests for delays over 60 minutes long**


The majority of refund requests come from cancelled journeys, with a total of **572 refund requests**

From the plot of delay lengths for each route that experienced delays, we can see the route with by far the longest delays on average is **Manchester Piccadilly to Leeds** at **144 minutes**, with **65 total delays and cancellations**. 
We saw this in objective 1 where this route was on average running 65 minutes later than the advertised journey duration, however this analysis is calculating the average delay length ONLY for journeys which were delayed.

Interestingly, this route recorded **0 total refund requests**.

The route with the second longest delays on average is **York to Doncaster** at **69 minutes**, with **38 total delays and cancellations**. This route only recorded **3 refund requests**.


The total revenue lost to refund across all route is **£38700**. The total revenue generated across the entire network is £741920, so 

The route with the highest number or refund requests by far is **Liverpool Lime Street to London Euston**. The average length of delay is is **36.6 minutes**.
This is also the route with the **highest number of delays and cancellations overall** at **879**, we can see that this route has the the highest amount of revenue lost to refunds at **£13,126**. This account just over a third (33.9%) of the total amount of revenue lost to refunds across the entire network.


##
**Conclusions:**
