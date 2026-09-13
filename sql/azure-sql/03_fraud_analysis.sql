-- Azure SQL: Fraud Analysis
-- Read-only queries. Run each query separately to inspect results.

-- 1. Fraud counts, amounts and rates by transaction type
SELECT
    [type],
    COUNT_BIG(*) AS total_transactions,
    SUM(CAST(isFraud AS BIGINT)) AS fraud_transactions,
    SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END)
        AS fraud_amount,
    ROUND(
        100.0 * SUM(CAST(isFraud AS BIGINT))
        / NULLIF(COUNT_BIG(*), 0),
        2
    ) AS fraud_rate_pct
FROM dbo.transactions
GROUP BY [type]
ORDER BY fraud_amount DESC;


-- 2. Observed fraud rate by rule-based risk category
SELECT
    risk_category,
    COUNT_BIG(*) AS total_transactions,
    SUM(CAST(isFraud AS BIGINT)) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CAST(isFraud AS BIGINT))
        / NULLIF(COUNT_BIG(*), 0),
        2
    ) AS fraud_rate_pct
FROM dbo.transactions
GROUP BY risk_category
ORDER BY fraud_rate_pct DESC;


-- 3. Fraud rate within each balance-anomaly group
SELECT
    balance_anomaly,
    COUNT_BIG(*) AS total_transactions,
    SUM(CAST(isFraud AS BIGINT)) AS fraud_transactions,
    ROUND(
        100.0 * SUM(CAST(isFraud AS BIGINT))
        / NULLIF(COUNT_BIG(*), 0),
        2
    ) AS fraud_rate_pct
FROM dbo.transactions
GROUP BY balance_anomaly;


-- 4. Top five origin accounts: share of total fraud amount
;WITH Top5Origin AS (
    SELECT TOP (5)
        nameOrig,
        SUM(amount) AS fraud_amount
    FROM dbo.transactions
    WHERE isFraud = 1
    GROUP BY nameOrig
    ORDER BY SUM(amount) DESC, nameOrig ASC
)
SELECT
    SUM(fraud_amount) AS top5_origin_amount,
    ROUND(
        100.0 * SUM(fraud_amount)
        / NULLIF(
            (SELECT SUM(amount)
             FROM dbo.transactions
             WHERE isFraud = 1),
            0
        ),
        2
    ) AS top5_origin_share_pct
FROM Top5Origin;


-- 5. Top five destination accounts: share of total fraud amount
;WITH Top5Destination AS (
    SELECT TOP (5)
        nameDest,
        SUM(amount) AS fraud_amount
    FROM dbo.transactions
    WHERE isFraud = 1
    GROUP BY nameDest
    ORDER BY SUM(amount) DESC, nameDest ASC
)
SELECT
    SUM(fraud_amount) AS top5_destination_amount,
    ROUND(
        100.0 * SUM(fraud_amount)
        / NULLIF(
            (SELECT SUM(amount)
             FROM dbo.transactions
             WHERE isFraud = 1),
            0
        ),
        2
    ) AS top5_destination_share_pct
FROM Top5Destination;
