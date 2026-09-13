-- Azure SQL Database (T-SQL)
-- Reconstructed from exported dbo.transactions column metadata.
-- Preserves the 21 column names, types, lengths, precision, scale and nullability.
-- Indexes, keys, defaults, identity/computed properties and permissions were not
-- included in the supplied metadata; this is not a full database schema export.
-- Use for initial setup in a new database. Does not replace an existing table.

IF OBJECT_ID(N'dbo.transactions', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[transactions] (
        [step] INT NULL,
        [type] VARCHAR(20) NULL,
        [amount] DECIMAL(18,2) NULL,
        [nameOrig] VARCHAR(50) NULL,
        [oldbalanceOrg] DECIMAL(18,2) NULL,
        [newbalanceOrig] DECIMAL(18,2) NULL,
        [nameDest] VARCHAR(50) NULL,
        [oldbalanceDest] DECIMAL(18,2) NULL,
        [newbalanceDest] DECIMAL(18,2) NULL,
        [isFraud] INT NULL,
        [isFlaggedFraud] INT NULL,
        [origin_balance_change] DECIMAL(18,2) NULL,
        [origin_balance_error] DECIMAL(18,2) NULL,
        [destination_balance_change] DECIMAL(18,2) NULL,
        [destination_balance_error] DECIMAL(18,2) NULL,
        [origin_zero_balance] BIT NULL,
        [destination_zero_balance] BIT NULL,
        [amount_percentile] DECIMAL(10,6) NULL,
        [risk_score] INT NULL,
        [risk_category] VARCHAR(20) NULL,
        [balance_anomaly] BIT NULL
    );
END;
