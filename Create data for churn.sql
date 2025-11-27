CREATE DATABASE churn_db;
USE churn_db;

CREATE TABLE customer_churn (
    CustomerID VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Tenure INT,
    PlanType VARCHAR(50),
    MonthlyCharges FLOAT,
    InternetService VARCHAR(50),
    ContractType VARCHAR(50),
    PaymentMethod VARCHAR(50),
    TechSupport VARCHAR(10),
    OnlineSecurity VARCHAR(10),
    DeviceProtection VARCHAR(10),
    StreamingTV VARCHAR(10),
    StreamingMovies VARCHAR(10),
    PaperlessBilling VARCHAR(10),
    TotalCharges FLOAT,
    Churn INT
    );

ALTER TABLE customer_churn ADD COLUMN PredictionChurn INT;


SELECT CustomerID, Churn, PredictionChurn
FROM customer_churn
LIMIT 10;

SELECT COUNT(*) FROM customer_churn;


ALTER TABLE customer_churn DROP COLUMN PredictedChurn;


SELECT CustomerID FROM customer_churn LIMIT 5;


SET SQL_SAFE_UPDATES = 0;

SELECT CustomerID, Churn, PredictionChurn
FROM customer_churn
LIMIT 10;




