/*
================================================================================
PROJECT: Financial Transaction Risk & Fraud Analytics
FILE: 03_fraud_investigation.sql
PURPOSE:
    Investigate fraudulent activity at account, transaction-type, value,
    and balance-anomaly levels.

IMPORTANT:
    Results identify fraudulent/anomalous patterns within the labelled data.
    They should not be interpreted as a production fraud-detection model.
================================================================================
*/

-- ============================================================================
-- SECTION 01: FRAUDULENT ORIGIN ACCOUNTS
-- ============================================================================

SELECT
    nameOrig AS origin_account,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(amount), 2) AS total_fraud_amount,
    ROUND(AVG(amount), 2) AS avg_fraud_amount,
    ROUND(MAX(amount), 2) AS max_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY nameOrig
ORDER BY total_fraud_amount DESC;


-- ============================================================================
-- SECTION 02: TOP 10 ORIGIN ACCOUNTS BY FRAUD AMOUNT
-- ============================================================================

SELECT
    nameOrig AS origin_account,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(amount), 2) AS total_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY nameOrig
ORDER BY total_fraud_amount DESC
LIMIT 10;


-- ============================================================================
-- SECTION 03: FRAUDULENT DESTINATION ACCOUNTS
-- ============================================================================

SELECT
    nameDest AS destination_account,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(amount), 2) AS total_fraud_amount,
    ROUND(AVG(amount), 2) AS avg_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY nameDest
ORDER BY total_fraud_amount DESC;


-- ============================================================================
-- SECTION 04: FRAUD SUMMARY BY TRANSACTION TYPE
-- ============================================================================

SELECT
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate,
    ROUND(
        SUM(
            CASE
                WHEN isFraud = 1 THEN amount
                ELSE 0
            END
        ),
        2
    ) AS fraud_amount
FROM transactions
GROUP BY type
ORDER BY fraud_rate DESC;


-- ============================================================================
-- SECTION 05: HIGH-VALUE FRAUD INVESTIGATION
-- ============================================================================

SELECT
    step,
    type,
    amount,
    nameOrig,
    nameDest,
    oldbalanceOrg,
    newbalanceOrig,
    oldbalanceDest,
    newbalanceDest
FROM transactions
WHERE isFraud = 1
  AND amount >= 10000000
ORDER BY amount DESC;


-- ============================================================================
-- SECTION 06: FRAUD + BALANCE ANOMALY
-- ============================================================================

SELECT
    type,
    nameOrig,
    nameDest,
    amount,
    origin_balance_error,
    destination_balance_error,
    isFraud
FROM transactions
WHERE balance_anomaly = TRUE
  AND isFraud = 1
ORDER BY amount DESC;
