/******************************************************************************************
 Project Title   : Customer Churn Prediction & Retention Analysis
 Analyst Name    : Neha Prakash Jogdand
 Tool Used       : MySQL Workbench
 Description     : 
   This project integrates machine learning predictions with SQL-based data analysis 
   to identify customer churn patterns, calculate churn rates, and support business 
   decision-making with actionable insights.

******************************************************************************************/

/*-----------------------------------------------------------------------------------------
SECTION 1: TABLE OVERVIEW
Description: View the first few records to understand the dataset.
-----------------------------------------------------------------------------------------*/
SELECT * 
FROM customer_churn
LIMIT 10;

/*-----------------------------------------------------------------------------------------
SECTION 2: BASIC DATA INSIGHTS
Description: Get key statistics like total customers, churned customers, retention rate.
-----------------------------------------------------------------------------------------*/
-- Total customers, churned, and retained
SELECT 
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) AS Retained_Customers,
    ROUND(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Churn_Rate_Percent
FROM customer_churn;

/*-----------------------------------------------------------------------------------------
SECTION 3: CONTRACT & SERVICE ANALYSIS
Description: Understand how churn rate varies across contracts and services.
-----------------------------------------------------------------------------------------*/
-- Churn Rate by Contract Type
SELECT 
    ContractType AS Contract_Type,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned,
    ROUND(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Churn_Rate_Percent
FROM customer_churn
GROUP BY ContractType
ORDER BY Churn_Rate_Percent DESC;


-- Churn Rate by Internet Service
SELECT 
    InternetService AS Internet_Service,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned,
    ROUND(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Churn_Rate_Percent
FROM customer_churn
GROUP BY InternetService
ORDER BY Churn_Rate_Percent DESC;


/*-----------------------------------------------------------------------------------------
SECTION 4: PREDICTION VALIDATION
Description: Compare ML model predictions vs actual churn using SQL.
-----------------------------------------------------------------------------------------*/
-- Check Model Accuracy
SELECT 
    ROUND(SUM(CASE WHEN Churn = PredictionChurn THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Model_Accuracy_Percent
FROM customer_churn;


-- Confusion Matrix (Actual vs Predicted)
SELECT 
    Churn AS Actual_Churn,
    PredictionChurn AS Predicted_Churn,
    COUNT(*) AS Record_Count
FROM customer_churn
GROUP BY Churn, PredictionChurn
ORDER BY Churn, PredictionChurn;


/*-----------------------------------------------------------------------------------------
SECTION 5: CUSTOMER SEGMENTATION
Description: Identify customer groups with higher churn tendencies.
-----------------------------------------------------------------------------------------*/
-- Churn by Age Group
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Churn_Rate_Percent
FROM customer_churn
GROUP BY Age_Group
ORDER BY Churn_Rate_Percent DESC;




/*-----------------------------------------------------------------------------------------
SECTION 6: REGIONAL ANALYSIS (With JOIN)
Description: Combine payment data with churn table for deeper insights.
-----------------------------------------------------------------------------------------*/
-- Create Payment Info Table (if not exists)
CREATE TABLE IF NOT EXISTS payment_info (
    CustomerID VARCHAR(50),
    BillingRegion VARCHAR(50),
    TotalSpent FLOAT,
    LastPaymentDate DATE
);

INSERT INTO payment_info (CustomerID, BillingRegion, TotalSpent, LastPaymentDate)
VALUES
('CUST1000', 'North', 850.25, '2025-09-01'),
('CUST1001', 'South', 600.10, '2025-08-15'),
('CUST1002', 'West', 950.00, '2025-09-10'),
('CUST1003', 'East', 720.40, '2025-07-30'),
('CUST1004', 'North', 1040.75, '2025-09-20');


-- Example Join Query to analyze churn by region
SELECT 
    p.BillingRegion,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN c.Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN c.Churn = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Churn_Rate_Percent
FROM customer_churn c
JOIN payment_info p ON c.CustomerID = p.CustomerID
GROUP BY p.BillingRegion
ORDER BY Churn_Rate_Percent DESC;



-- Create customer feedback table
CREATE TABLE IF NOT EXISTS customer_feedback (
    CustomerID VARCHAR(50),
    FeedbackScore INT,       -- 1 to 5
    ComplaintCount INT,
    LastInteractionDate DATE
);
-- Insert sample feedback data for matching customers
INSERT INTO customer_feedback (CustomerID, FeedbackScore, ComplaintCount, LastInteractionDate)
VALUES
('CUST1000', 5, 0, '2025-09-25'),   -- Very satisfied, no complaints
('CUST1001', 2, 3, '2025-08-20'),   -- Dissatisfied, 3 complaints
('CUST1002', 4, 1, '2025-09-05'),   -- Satisfied, occasional complaint
('CUST1003', 1, 4, '2025-07-28'),   -- Very dissatisfied, multiple complaints
('CUST1004', 3, 2, '2025-09-18');   -- Neutral experience

/******************************************************************************************
INNER JOIN → Combines customer churn, feedback, and payment data.
Objective: Analyze if low feedback and low spending correlate with higher churn.
******************************************************************************************/
SELECT 
    c.CustomerID,
    c.Churn,
    c.PredictionChurn,
    f.FeedbackScore,
    f.ComplaintCount,
    p.BillingRegion,
    p.TotalSpent
FROM customer_churn c
INNER JOIN customer_feedback f ON c.CustomerID = f.CustomerID
INNER JOIN payment_info p ON c.CustomerID = p.CustomerID
ORDER BY f.FeedbackScore ASC, p.TotalSpent DESC;


/******************************************************************************************
LEFT JOIN → Shows all customers, even those without feedback data.
Objective: Identify customers who did not provide feedback but are still active or churned.
******************************************************************************************/
SELECT 
    c.CustomerID,
    c.Churn,
    c.PredictionChurn,
    f.FeedbackScore,
    f.ComplaintCount,
    p.BillingRegion
FROM customer_churn c
LEFT JOIN customer_feedback f ON c.CustomerID = f.CustomerID
LEFT JOIN payment_info p ON c.CustomerID = p.CustomerID
WHERE f.CustomerID IS NULL OR f.FeedbackScore IS NULL;



/******************************************************************************************
FULL OUTER JOIN → Combine all data even if missing from one of the tables.
Objective: Get a complete view of all customers, their feedback, and payment info.
******************************************************************************************/
SELECT 
    c.CustomerID,
    c.Churn,
    f.FeedbackScore,
    f.ComplaintCount,
    p.BillingRegion,
    p.TotalSpent
FROM customer_churn c
LEFT JOIN customer_feedback f ON c.CustomerID = f.CustomerID
LEFT JOIN payment_info p ON c.CustomerID = p.CustomerID


