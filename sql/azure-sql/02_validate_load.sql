-- Azure SQL: Data Load Validation
-- These queries only read data; they do not modify it.

-- 1. Verify transaction counts and amounts
SELECT
    COUNT_BIG(*) AS total_transactions,
    SUM(
        CAST(CASE WHEN isFraud = 1 THEN 1 ELSE 0 END AS BIGINT)
    ) AS fraud_transactions,
    SUM(amount) AS total_amount,
    SUM(
        CASE WHEN isFraud = 1 THEN amount ELSE 0 END
    ) AS fraud_amount
FROM dbo.transactions;


-- 2. Check missing values in Boolean flag columns
SELECT
    SUM(
        CAST(CASE WHEN origin_zero_balance IS NULL
             THEN 1 ELSE 0 END AS BIGINT)
    ) AS origin_flag_nulls,
    SUM(
        CAST(CASE WHEN destination_zero_balance IS NULL
             THEN 1 ELSE 0 END AS BIGINT)
    ) AS destination_flag_nulls,
    SUM(
        CAST(CASE WHEN balance_anomaly IS NULL
             THEN 1 ELSE 0 END AS BIGINT)
    ) AS anomaly_flag_nulls
FROM dbo.transactions;


-- 3. Check unexpected fraud-label values
SELECT
    COUNT_BIG(*) AS invalid_fraud_labels
FROM dbo.transactions
WHERE isFraud IS NULL
   OR isFraud NOT IN (0, 1);
