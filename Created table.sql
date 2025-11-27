DROP TABLE IF EXISTS payment_info;
DROP TABLE IF EXISTS customer_feedback;

-- Create payment_info table
CREATE TABLE IF NOT EXISTS payment_info (
    CustomerID VARCHAR(50),
    BillingRegion VARCHAR(50),
    TotalSpent FLOAT,
    LastPaymentDate DATE
);

-- Create customer_feedback table
CREATE TABLE IF NOT EXISTS customer_feedback (
    CustomerID VARCHAR(50),
    FeedbackScore INT,
    ComplaintCount INT,
    LastInteractionDate DATE
);

SELECT COUNT(*) FROM payment_info;
SELECT COUNT(*) FROM customer_feedback;


SELECT * FROM payment_info;
SELECT * FROM customer_feedback;