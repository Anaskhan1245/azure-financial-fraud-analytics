# Azure SQL Scripts

This folder contains T-SQL scripts for the Azure version
of the Financial Transaction Risk & Fraud Analytics project.

## Files

| File | Purpose |
|---|---|
| 01_create_tables.sql | Reconstruct the transactions table's 21 columns from exported metadata. |
| 02_validate_load.sql | Check transaction counts, amount totals, missing flags and invalid fraud labels. |
| 03_fraud_analysis.sql | Analyse fraud by transaction type, risk category, balance anomaly and top-five accounts. |

## Usage

- Use 01_create_tables.sql for initial setup in a new database.
  It skips creation if dbo.transactions already exists.
- Load the processed data using Azure Data Factory.
- Run validation and analysis queries individually.
- Compare SQL results with Power BI using all slicers cleared.

## Previously Verified Load Results

| Metric | Value |
|---|---:|
| Total transactions | 6,362,620 |
| Fraud-labelled transactions | 8,213 |
| Total transaction amount | 1,144,392,944,759.77 |
| Fraud-labelled transaction amount | 12,056,415,427.84 |

Amounts are expressed in dataset units, not a confirmed currency.

## Notes

These scripts were reconstructed for project documentation.
They are not recovered copies of the original query history.

The table script preserves exported column definitions.
Indexes, constraints and permissions are not included.

Validation and analysis scripts are read-only.
Newly added checks must be executed before claiming they passed.

PostgreSQL scripts are maintained separately in ../postgresql/.
