# Azure Financial Transaction Risk & Fraud Analytics

An end-to-end batch analytics project using Python, ADLS Gen2,
Azure Data Factory, Azure SQL and Power BI to analyse
6.36 million financial transactions.

## Project Objective

Understand fraud patterns, compare transaction groups and
identify areas for further investigation through a two-page
Power BI report.

## Dashboard

### Overview and Risk
![Overview and Risk](images/1-overviewandrisk.png)



### Insights and Recommendations
![Insights and Recommendations]((https://github.com/Anaskhan1245/azure-financial-fraud-analytics/blob/main/images/2-Insights%20and%20Recommendations.png))

## Dataset

Source: [Online Payments Fraud Detection Dataset — Kaggle](https://www.kaggle.com/datasets/rupakroy/online-payments-fraud-detection-dataset)

Dataset listing by Rupak Roy.

The source contains transaction types, amounts, account identifiers,
balances and fraud labels. Python preparation adds balance-related
features, amount percentiles and rule-based risk indicators.

The processed table contains 21 columns.
Refer to the source page for dataset terms and documentation.

## Architecture

Kaggle → Python Preparation → Manual Upload to ADLS Gen2
→ Azure Data Factory Copy Activity → Azure SQL → Power BI

PostgreSQL was used for the original local analysis.
The Azure version uses Azure SQL as the report's data source.

## Tools Used

- Python: data preparation, exploratory analysis and feature engineering
- PostgreSQL: original local SQL analysis
- ADLS Gen2: storage of source and processed files
- Azure Data Factory: CSV-to-SQL data movement and column mapping
- Azure SQL Database: data storage, validation and analysis
- Power BI: data modelling, DAX measures and interactive reporting

## Work Completed

1. Prepared and explored the transaction data in Python.
2. Created balance-related features and rule-based risk categories.
3. Performed local analysis using PostgreSQL.
4. Uploaded files to ADLS Gen2.
5. Configured ADF linked services, datasets and a Copy Activity.
6. Mapped 21 source columns to the Azure SQL destination.
7. Validated transaction counts, amount totals and Boolean-field nulls.
8. Connected Power BI to Azure SQL.
9. Built Overview & Risk and Insights & Recommendations pages.
10. Corrected top-five account calculations to handle tied fraud amounts.

## Verified Full-Dataset Totals

| Metric | Result |
|---|---:|
| Total transactions | 6,362,620 |
| Fraud-labelled transactions | 8,213 |
| Total transaction amount | 1,144,392,944,759.77 |
| Fraud-labelled transaction amount | 12,056,415,427.84 |
| Overall fraud rate | Approximately 0.13% |

Amounts are shown in dataset units. No currency is assumed.
Fraud-labelled transaction amount is not a measure of realised loss.

## Analysis Covered

- Transaction volume and amount by transaction type
- Fraud counts, amounts and rates
- Transaction activity by simulation step
- Fraud rates across rule-based risk categories
- Transactions with and without balance anomalies
- High-value transaction fraud rate
- Top-five origin and destination account concentration
- Proposed investigation priorities

## Key Observations

- Fraud represents a small share of transactions by count.
- TRANSFER has the highest fraud amount, followed by CASH_OUT.
- The report shows a higher observed fraud rate in the Low-risk
  category than in the High-risk category, indicating that the
  scoring rules require further evaluation.
- A balance anomaly alone does not establish fraud.

These observations describe the full dataset. Filtered report
results may differ.

## Metric Definitions

**Fraud rate:** fraud-labelled transactions divided by total
transactions in the relevant group.

**High-value transactions:** transactions at or above the full
dataset's 95th percentile amount. Ties can include more than
exactly 5% of transactions.

**Top-five account share:** fraud amount attributed to five
accounts divided by total fraud amount within the selected context.
Account ID breaks ties when fraud amounts are equal.

**Anomaly-group fraud rate:** fraud-labelled transactions with
an anomaly divided by all transactions with an anomaly.

## Repository Guide

| Folder | Contents |
|---|---|
| images/ | Dashboard screenshots |
| notebooks/ | Python preparation and analysis |
| sql/postgresql/ | Original PostgreSQL scripts |
| sql/azure-sql/ | Azure SQL schema, validation and analysis scripts |
| azure/pipeline/ | ADF Copy pipeline definition |
| azure/datasets/ | Source and destination dataset definitions |
| azure/linked-services/ | Connection definitions |
| powerbi/ | Power BI template and usage instructions |

## Open the Power BI Template

1. Download `powerbi/Financial_Fraud_Analytics.pbit`.
2. Open it in Power BI Desktop.
3. Update the Azure SQL connection for your environment.
4. Provide your own credentials and network access.
5. Load the data and check the report results.

The template contains report definitions and queries, but no
imported transaction data. It requires a compatible table/view
structure and does not grant access to the author's database.

## Pipeline Behaviour

The Copy Activity deletes existing rows from `dbo.transactions`
before inserting the processed CSV data.

This is a full-reload approach. A failure after deletion may leave
the destination empty or partially loaded. A production version
would require a more resilient loading and recovery strategy.

## Scope and Limitations

- This is a portfolio batch analytics project.
- Risk scoring is rule-based, not a validated machine-learning model.
- Recommendations and potential benefits are proposals, not measured outcomes.
- Real-time fraud alerts are a future enhancement.
- Azure SQL scripts were reconstructed for documentation; the table
  script covers exported column definitions, not a complete schema export.
- ADF connection settings and permissions must be configured for
  the environment in which the project is reproduced.

## Author

**Anas Khan**

[GitHub Profile](https://github.com/Anaskhan1245)
