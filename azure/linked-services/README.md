# ADF Linked Services

## ls_sql_fraud

Connects Azure Data Factory to Azure SQL Database using
the factory's system-assigned managed identity.

- Database: fraud_analytics
- Encryption: mandatory
- Trust server certificate: false

For reuse, replace the server and database with your own.
Grant the new factory's managed identity the required SQL
permissions and configure network access.
