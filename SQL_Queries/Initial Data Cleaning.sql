
-- Searching for Duplicates using ROW_NUMBER() OVER(PARTITION BY)

WITH duplicates_CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY 
        transaction_id, 
        date_of_purchase, 
        time_of_purchase, 
        purchase_type, 
        payment_method, 
        railcard, 
        ticket_class, 
        ticket_type, 
        price, 
        departure_station, 
        arrival_destination, 
        date_of_journey, 
        departure_time, 
        arrival_time,
        actual_arrival_time,
        journey_status , 
        reason_for_delay,
        refund_request,
        ORDER BY (SELECT NULL)) AS row_num
    FROM 
        railway_working
)
SELECT 
    *
FROM 
    duplicates_CTE
WHERE 
    row_num > 1;

-- Searching for distinct values 

SELECT
DISTINCT(departure_station)
FROM railway_working;

SELECT
DISTINCT(arrival_destination)
FROM railway_working;

SELECT
DISTINCT(ticket_class)
FROM railway_working;

SELECT
DISTINCT(ticket_type)
FROM railway_working;

SELECT
DISTINCT(reason_for_delay)
FROM railway_working;

-- Reason for delay contains redundant entries, writing a query to update this:

UPDATE railway_working
SET reason_for_delay = CASE 
    WHEN reason_for_delay IN ('Weather', 'Weather Conditions') THEN 'Weather'
    WHEN reason_for_delay IN ('Staffing', 'Staff Shortages') THEN 'Staffing'
    -- Add more cases as needed
    ELSE reason_for_delay -- This ensures other values remain unchanged
END
WHERE reason_for_delay IN ('Weather', 'Weather Conditions', 'Staffing', 'Staff Shortages');


-- Converting blank spaces in reason_for_delay to NULL

UPDATE railway_working
SET reason_for_delay = null
WHERE reason_for_delay = '';


-- Date and time columns were in TEXT format, converting all to correct DATE and TIME formats

UPDATE railway_working
SET 
    date_of_purchase = STR_TO_DATE(date_of_purchase, '%Y-%m-%d'),
    time_of_purchase = STR_TO_DATE(time_of_purchase, '%H:%i:%s'),
    date_of_journey = STR_TO_DATE(date_of_journey, '%Y-%m-%d'),
    departure_time = STR_TO_DATE(departure_time, '%H:%i:%s'),    
    arrival_time = STR_TO_DATE(arrival_time, '%H:%i:%s'),
    actual_arrival_time = STR_TO_DATE(actual_arrival_time, '%H:%i:%s')
    
-- Verifying these changes applied correctly

SELECT *
FROM railway_working
WHERE 
    date_of_purchase IS NULL OR
    time_of_purchase IS NULL OR
    date_of_journey IS NULL OR
    departure_time IS NULL OR
    arrival_time IS NULL OR
    actual_arrival_time IS NULL;



-- Changing 00:00:00 actual_arrival time to NULL for all cancelled trains, as this will affect calculations

UPDATE railway_working
SET actual_arrival_time = NULL
WHERE journey_status = 'Cancelled';


