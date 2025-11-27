CREATE TABLE it_ticket_data (
    ticket_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(150),
    customer_age INT,
    customer_gender VARCHAR(10),
    product_purchased VARCHAR(100),
    date_of_purchase DATE,
    ticket_type VARCHAR(50),
    ticket_subject TEXT,it_ticket_data,
    ticket_description TEXT,
    ticket_status VARCHAR(50),
    resolution TEXT,
    ticket_priority VARCHAR(20),
    ticket_channel VARCHAR(50),
    first_response_time DATETIME,
    time_to_resolution DATETIME,
    customer_satisfaction_rating FLOAT,
    first_response_hours FLOAT,
    resolution_hours FLOAT
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:\\IT_Ticket_Cleaned.csv'
INTO TABLE it_ticket_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ticket_id, customer_name, customer_email, customer_age, customer_gender,
 product_purchased, date_of_purchase, ticket_type, ticket_subject, ticket_description,
 ticket_status, resolution, ticket_priority, ticket_channel,
 first_response_time, time_to_resolution, customer_satisfaction_rating,
 first_response_hours, resolution_hours);

SELECT * FROM it_ticket_data;
SHOW VARIABLES LIKE 'local_infile';


# Track Average Resolution Time per Priority
SELECT 
    ticket_priority,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
FROM it_ticket_data
WHERE resolution_hours IS NOT NULL
GROUP BY ticket_priority
ORDER BY avg_resolution_hours;

# Helps IT teams see if high-priority tickets are being resolved faster than low-priority ones.

SELECT 
    ticket_channel,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_time
FROM it_ticket_data
GROUP BY ticket_channel
ORDER BY total_tickets DESC;

# Shows which channel (email, chat, phone) gets the most tickets and how efficient each one is.


SELECT 
    ticket_id,
    ticket_priority,
    ticket_type,
    resolution_hours
FROM it_ticket_data
WHERE resolution_hours > 24
ORDER BY resolution_hours DESC;

# Highlights tickets breaching SLA (Service Level Agreement) so managers can act quickly.


SELECT 
    ROUND(AVG(customer_satisfaction_rating), 2) AS avg_satisfaction,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_time
FROM it_ticket_data;

# Correlation between how fast tickets are resolved and how happy customers are.



SELECT 
    product_purchased,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_time
FROM it_ticket_data
GROUP BY product_purchased
ORDER BY total_tickets DESC;

# Identifies which product line generates the most issues — valuable for product improvement teams.


SELECT 
    ticket_type,
    ROUND(AVG(customer_satisfaction_rating), 2) AS avg_satisfaction,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_time
FROM it_ticket_data
GROUP BY ticket_type
ORDER BY avg_satisfaction ASC;

# Ticket types with low satisfaction or high resolution time indicate training needs or process issues.


SELECT 
    COUNT(*) AS total_tickets,
    COUNT(CASE WHEN ticket_status = 'Closed' THEN 1 END) AS closed_tickets,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(first_response_hours), 2) AS avg_first_response_hours,
    ROUND(AVG(customer_satisfaction_rating), 2) AS avg_customer_satisfaction
FROM it_ticket_data;


