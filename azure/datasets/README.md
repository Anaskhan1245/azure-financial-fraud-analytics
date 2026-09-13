# ADF Datasets

## Source: ds_fraud_cleaned_csv

Defines the processed CSV input in ADLS Gen2.

- Linked service: ls_adls_fraud
- Container: fraud-data
- Folder: processed
- File: financial_transaction_risk_cleaned.csv
- Format: comma-separated text with a header row
- Schema: 21 columns

Data types are converted through the Copy Activity mappings.

## Destination: ds_sql_transactions

Defines the Azure SQL destination table.

- Linked service: ls_sql_fraud
- Schema: dbo
- Table: transactions
- Columns: 21

The dataset describes the destination; it does not create the table.
