-- 4. Ticket Type and Railcard Analysis

-- Query to get Revenue and average price, for each combination of ticket type and railcard type

SELECT
ticket_type,
railcard,
SUM(price) as Revenue,
AVG(price) as average_price
FROM railway_working
GROUP BY ticket_type, railcard;




-- Simple query to get the average price for each ticket type

SELECT
ticket_type,
AVG(price) as average_price
FROM railway_working
GROUP BY ticket_type;



-- Simple query to give the number of people with each distinct type of railcard.

SELECT
railcard,
COUNT(*) as number_of_people
from railway_working
group by railcard;

-- These can be combined using the model view in powerBI