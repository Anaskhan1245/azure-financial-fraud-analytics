# Azure Data Factory Pipeline

`pl_fraud_csv_to_sql.json` copies processed CSV data
from ADLS Gen2 into Azure SQL with 21 column mappings.

Source dataset: `ds_fraud_cleaned_csv`
Destination dataset: `ds_sql_transactions`

Load strategy: delete existing destination rows, then insert
source records. A failed load may leave the table empty or
partially loaded.

Referenced datasets and linked services are required separately.
