/*
================================================================================
PROJECT: Financial Transaction Risk & Fraud Analytics
FILE: 01_schema_and_data_quality.sql
PURPOSE:
    Create the transaction table and perform initial data-quality validation.

DATABASE:
    PostgreSQL

TABLE:
    transactions

NOTE:
    This script assumes the cleaned CSV has already been imported into the
    transactions table where applicable.
================================================================================
*/

-- ============================================================================
-- SECTION 01: CREATE TRANSACTIONS TABLE
-- ============================================================================

CREATE TABLE transactions (
    step INTEGER,
    type VARCHAR(20),
    amount NUMERIC(18,2),
    nameOrig VARCHAR(50),
    oldbalanceOrg NUMERIC(18,2),
    newbalanceOrig NUMERIC(18,2),
    nameDest VARCHAR(50),
    oldbalanceDest NUMERIC(18,2),
    newbalanceDest NUMERIC(18,2),
    isFraud INTEGER,
    isFlaggedFraud INTEGER,
    origin_balance_change NUMERIC(18,2),
    origin_balance_error NUMERIC(18,2),
    destination_balance_change NUMERIC(18,2),
    destination_balance_error NUMERIC(18,2),
    origin_zero_balance BOOLEAN,
    destination_zero_balance BOOLEAN,
    amount_percentile NUMERIC(10,6),
    risk_score INTEGER,
    risk_category VARCHAR(20),
    balance_anomaly BOOLEAN
);


-- ============================================================================
-- SECTION 02: DATASET SIZE
-- ============================================================================

SELECT
    COUNT(*) AS total_rows
FROM transactions;


-- ============================================================================
-- SECTION 03: SAMPLE TRANSACTION RECORDS
-- ============================================================================

SELECT *
FROM transactions
LIMIT 10;


-- ============================================================================
-- SECTION 04: NULL VALUE CHECK
-- ============================================================================

SELECT
    COUNT(*) FILTER (WHERE step IS NULL)       AS step_null,
    COUNT(*) FILTER (WHERE type IS NULL)       AS type_null,
    COUNT(*) FILTER (WHERE amount IS NULL)     AS amount_null,
    COUNT(*) FILTER (WHERE nameOrig IS NULL)   AS origin_null,
    COUNT(*) FILTER (WHERE nameDest IS NULL)   AS destination_null,
    COUNT(*) FILTER (WHERE isFraud IS NULL)    AS fraud_null
FROM transactions;


-- ============================================================================
-- SECTION 05: DUPLICATE CHECK
-- ============================================================================

SELECT
    COUNT(*) -
    COUNT(DISTINCT (
        step,
        type,
        amount,
        nameOrig,
        nameDest
    )) AS duplicate_rows
FROM transactions;


-- ============================================================================
-- SECTION 06: FRAUD VS NON-FRAUD DISTRIBUTION
-- ============================================================================

SELECT
    isFraud,
    COUNT(*) AS transaction_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM transactions
GROUP BY isFraud
ORDER BY isFraud;
