/*
================================================================================
PROJECT: Financial Transaction Risk & Fraud Analytics
FILE: 02_transaction_analysis.sql
PURPOSE:
    Analyze transaction volume, transaction value, amount thresholds,
    fraud-rate segmentation, and transaction-level patterns.
================================================================================
*/

-- ============================================================================
-- SECTION 01: TRANSACTION TYPE PERFORMANCE
-- ============================================================================

SELECT
    type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY type
ORDER BY total_transactions DESC;


-- ============================================================================
-- SECTION 02: FRAUD RATE BY TRANSACTION TYPE
-- ============================================================================

SELECT
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY type
ORDER BY fraud_rate DESC;


-- ============================================================================
-- SECTION 03: FRAUD AMOUNT BY TRANSACTION TYPE
-- ============================================================================

SELECT
    type,
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(amount), 2) AS total_fraud_amount,
    ROUND(AVG(amount), 2) AS average_fraud_amount,
    ROUND(MAX(amount), 2) AS maximum_fraud_amount
FROM transactions
WHERE isFraud = 1
GROUP BY type
ORDER BY total_fraud_amount DESC;


-- ============================================================================
-- SECTION 04: TOP 5% HIGH-VALUE TRANSACTIONS
-- ============================================================================

WITH transaction_percentile AS (
    SELECT
        *,
        NTILE(20) OVER (
            ORDER BY amount DESC
        ) AS amount_group
    FROM transactions
)

SELECT
    COUNT(*) AS high_value_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transaction_percentile
WHERE amount_group = 1;


-- ============================================================================
-- SECTION 05: BALANCE ANOMALY ANALYSIS
-- ============================================================================

SELECT
    balance_anomaly,
    COUNT(*) AS transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY balance_anomaly
ORDER BY balance_anomaly;


-- ============================================================================
-- SECTION 06: AMOUNT RISK CLASSIFICATION
-- ============================================================================

SELECT
    type,
    amount,
    isFraud,
    CASE
        WHEN amount >= 1000000 THEN 'Very High'
        WHEN amount >= 500000  THEN 'High'
        WHEN amount >= 100000  THEN 'Medium'
        ELSE 'Low'
    END AS amount_risk_level
FROM transactions
LIMIT 20;


-- ============================================================================
-- SECTION 07: FRAUD VS NON-FRAUD TRANSACTION VALUE
-- ============================================================================

SELECT
    CASE
        WHEN isFraud = 1 THEN 'Fraud'
        ELSE 'Non-Fraud'
    END AS transaction_status,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY
    CASE
        WHEN isFraud = 1 THEN 'Fraud'
        ELSE 'Non-Fraud'
    END
ORDER BY transaction_count DESC;


-- ============================================================================
-- SECTION 08: TRANSACTION TYPES WITH FRAUD ACTIVITY
-- ============================================================================

SELECT
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions
FROM transactions
GROUP BY type
HAVING SUM(isFraud) > 0
ORDER BY fraud_transactions DESC;


-- ============================================================================
-- SECTION 09: TRANSACTION TYPES ABOVE FRAUD-RATE THRESHOLD
-- ============================================================================

SELECT
    type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY type
HAVING SUM(isFraud) * 100.0 / COUNT(*) > 0.10
ORDER BY fraud_rate DESC;


-- ============================================================================
-- SECTION 10: FRAUD-RATE CTE ANALYSIS
-- ============================================================================

WITH fraud_analysis AS (
    SELECT
        type,
        COUNT(*) AS total_transactions,
        SUM(isFraud) AS fraud_transactions,
        SUM(isFraud) * 100.0 / COUNT(*) AS fraud_rate
    FROM transactions
    GROUP BY type
)

SELECT
    type,
    total_transactions,
    fraud_transactions,
    ROUND(fraud_rate, 2) AS fraud_rate
FROM fraud_analysis
WHERE fraud_rate > 0.10
ORDER BY fraud_rate DESC;


-- ============================================================================
-- SECTION 11: TRANSACTIONS ABOVE OVERALL AVERAGE AMOUNT
-- ============================================================================

SELECT
    COUNT(*) AS high_value_transactions
FROM transactions
WHERE amount > (
    SELECT AVG(amount)
    FROM transactions
);


-- ============================================================================
-- SECTION 12: FRAUD TRANSACTIONS ABOVE AVERAGE FRAUD AMOUNT
-- ============================================================================

SELECT
    type,
    amount,
    nameOrig,
    nameDest
FROM transactions
WHERE isFraud = 1
  AND amount > (
      SELECT AVG(amount)
      FROM transactions
      WHERE isFraud = 1
  )
ORDER BY amount DESC;


-- ============================================================================
-- SECTION 13: TRANSACTION RANK WITHIN EACH TYPE
-- ============================================================================

SELECT
    type,
    amount,
    isFraud,
    ROW_NUMBER() OVER (
        PARTITION BY type
        ORDER BY amount DESC
    ) AS transaction_rank
FROM transactions;


-- ============================================================================
-- SECTION 14: TOP 3 TRANSACTIONS BY TYPE
-- ============================================================================

WITH ranked_transactions AS (
    SELECT
        type,
        amount,
        nameOrig,
        nameDest,
        isFraud,
        ROW_NUMBER() OVER (
            PARTITION BY type
            ORDER BY amount DESC
        ) AS rn
    FROM transactions
)

SELECT
    type,
    amount,
    nameOrig,
    nameDest,
    isFraud
FROM ranked_transactions
WHERE rn <= 3
ORDER BY type, amount DESC;


-- ============================================================================
-- SECTION 15: RANK BY TRANSACTION AMOUNT
-- ============================================================================

SELECT
    type,
    amount,
    RANK() OVER (
        PARTITION BY type
        ORDER BY amount DESC
    ) AS amount_rank
FROM transactions;


-- ============================================================================
-- SECTION 16: DENSE RANK BY TRANSACTION AMOUNT
-- ============================================================================

SELECT
    type,
    amount,
    DENSE_RANK() OVER (
        PARTITION BY type
        ORDER BY amount DESC
    ) AS amount_rank
FROM transactions;


-- ============================================================================
-- SECTION 17: PREVIOUS TRANSACTION AMOUNT
-- ============================================================================

SELECT
    step,
    type,
    amount,
    LAG(amount) OVER (
        ORDER BY step
    ) AS previous_amount
FROM transactions
ORDER BY step;


-- ============================================================================
-- SECTION 18: TRANSACTION-TO-TRANSACTION AMOUNT CHANGE
-- ============================================================================

WITH transaction_history AS (
    SELECT
        step,
        type,
        amount,
        LAG(amount) OVER (
            ORDER BY step
        ) AS previous_amount
    FROM transactions
)

SELECT
    step,
    type,
    amount,
    previous_amount,
    ROUND(
        amount - previous_amount,
        2
    ) AS amount_difference
FROM transaction_history
ORDER BY step;


-- ============================================================================
-- SECTION 19: CUMULATIVE TRANSACTION VALUE
-- ============================================================================

SELECT
    step,
    amount,
    SUM(amount) OVER (
        ORDER BY step
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total
FROM transactions
ORDER BY step;
