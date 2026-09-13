/*
================================================================================
PROJECT: Financial Transaction Risk & Fraud Analytics
FILE: 04_risk_analysis.sql
PURPOSE:
    Analyze the rule-based risk framework created during Python processing
    and compare risk categories with observed fraud labels.

IMPORTANT PROJECT NOTE:
    The risk score is a rule-based analytical framework, not a validated
    machine-learning or production fraud model. Risk categories should be
    interpreted as analytical indicators until formally validated.
================================================================================
*/

-- ============================================================================
-- SECTION 01: RISK CATEGORY PERFORMANCE
-- ============================================================================

SELECT
    risk_category,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY risk_category
ORDER BY fraud_rate DESC;


-- ============================================================================
-- SECTION 02: RISK CATEGORY WITH TOTAL TRANSACTION VALUE
-- ============================================================================

SELECT
    risk_category,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY risk_category
ORDER BY fraud_rate DESC;


-- ============================================================================
-- SECTION 03: RISK SCORE DISTRIBUTION
-- ============================================================================

SELECT
    risk_score,
    COUNT(*) AS transaction_count,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY risk_score
ORDER BY risk_score;


-- ============================================================================
-- SECTION 04: HIGH-RISK TRANSACTION INVESTIGATION
-- ============================================================================

SELECT
    step,
    type,
    amount,
    nameOrig,
    nameDest,
    risk_score,
    risk_category,
    balance_anomaly,
    isFraud
FROM transactions
ORDER BY risk_score DESC, amount DESC
LIMIT 100;


-- ============================================================================
-- SECTION 05: HIGH-RISK TRANSACTIONS WITH OBSERVED FRAUD
-- ============================================================================

SELECT
    step,
    type,
    amount,
    nameOrig,
    nameDest,
    risk_score,
    risk_category,
    balance_anomaly,
    isFraud
FROM transactions
WHERE risk_category = 'High'
  AND isFraud = 1
ORDER BY amount DESC;


-- ============================================================================
-- SECTION 06: RISK CATEGORY BY TRANSACTION TYPE
-- ============================================================================

SELECT
    type,
    risk_category,
    COUNT(*) AS transaction_count,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY
    type,
    risk_category
ORDER BY
    type,
    fraud_rate DESC;


-- ============================================================================
-- SECTION 07: FLAGGED FRAUD ANALYSIS
-- ============================================================================

SELECT
    isFlaggedFraud,
    COUNT(*) AS transaction_count,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY isFlaggedFraud
ORDER BY isFlaggedFraud;


-- ============================================================================
-- SECTION 08: BALANCE ANOMALY + RISK CATEGORY
-- ============================================================================

SELECT
    risk_category,
    balance_anomaly,
    COUNT(*) AS transaction_count,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        SUM(isFraud) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY
    risk_category,
    balance_anomaly
ORDER BY
    risk_category,
    balance_anomaly;
