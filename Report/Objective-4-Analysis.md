Objective 4 - Customer Segment Analysis
##
Objective: Explore the relationship between ticket type, railcard usage, and revenue contribution.

       Key Questions:
        - Do railcards account for higher revenue?
        - Which ticket types contribute the most to total revenue?
        - How does the average ticket price differ by ticket type?
        - What is the comparison between railcard and non-railcard revenue?

##
**SQL Queries:** 
```

-- Query to get Revenue and average price, for each combination of ticket type and railcard type

SELECT
ticket_type,
railcard,
SUM(price) as Revenue,
AVG(price) as average_price
FROM railway_working
GROUP BY ticket_type, railcard;
```


```
-- Simple query to get the average price for each ticket type

SELECT
ticket_type,
AVG(price) as average_price
FROM railway_working
GROUP BY ticket_type;
```


```
-- Simple query to give the number of people with each distinct type of railcard.

SELECT
railcard,
COUNT(*) as number_of_people
from railway_working
group by railcard;

```
##
**Power BI Visualisation:**

![alt text](https://github.com/tomredfern24/UK-Rail-Ticket-Sales-Analysis-SQL-PowerBI/blob/main/Visualisations/4.%20Ticket%20Type%20and%20Railcard%20Analysis.png)
##
**Insights:**

The customer segment analysis highlights the relationships between ticket type, railcard usage, and revenue contributions:

- Revenue by Ticket Type:
        - The Advance Ticket category contributes the most to overall revenue, generating approximately 41.7% of total revenue.
        - Conversely, Anytime Tickets contribute the least, accounting for 28.21% of total revenue.

- Average Ticket Price:
        - Anytime Tickets have the highest average price at £39.20, more than double the price of Advance Tickets, which average £17.61.
        - This indicates that Anytime Tickets are significantly more expensive than Advance Tickets, but they contribute less overall to total revenue, suggesting that they may be less frequently purchased.

- Railcard vs. Non-Railcard Revenue:
        - A significant majority of ticket sales are from passengers without railcards, contributing £573,700, or 77.3% of total revenue.
        - Only £168,220 (or 22.7%) of revenue is generated from passengers using railcards, underscoring the dominance of non-railcard users in overall revenue.

- Revenue by Railcard Type:
        - The most popular railcard is the Adult Railcard, accounting for £86,330 (or 11.64% of total revenue).
        - The Senior Railcard is the least popular, contributing just £29,620 (or 3.99% of total revenue).

- Top Ticket & Railcard Combination:
        - The combination of Advance Tickets without Railcards generates the highest revenue across the network, bringing in £239,833.

##
**Conclusions:**

This analysis reveals key insights into customer behaviors and revenue generation. Advance Tickets are the most significant driver of revenue, although their average price is lower than Anytime Tickets. On the other hand, Anytime Tickets command the highest average price but account for a smaller portion of total revenue, likely due to fewer sales.

Railcards play a relatively small role in overall revenue generation, with non-railcard passengers contributing over 77% of the total. Among railcard users, the Adult Railcard is the most popular, though the contribution of railcards overall remains modest.

To enhance revenue, targeting non-railcard passengers with tailored promotions or encouraging more railcard adoption could be beneficial. Additionally, the discrepancy between Anytime and Advance Tickets suggests there might be opportunities to balance pricing strategies and optimise ticket sales across both categories.
