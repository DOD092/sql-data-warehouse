#!/bin/bash
set -e

echo "Waiting for SQL Server..."

until /opt/mssql-tools18/bin/sqlcmd \
  -S sqlserver \
  -U sa \
  -P "$MSSQL_SA_PASSWORD" \
  -C \
  -Q "SELECT 1" > /dev/null 2>&1
do
  echo "SQL Server is not ready yet..."
  sleep 5
done

echo "SQL Server is ready."

echo "Step 1: Init database..."
/opt/mssql-tools18/bin/sqlcmd \
  -S sqlserver \
  -U sa \
  -P "$MSSQL_SA_PASSWORD" \
  -C \
  -i /init_database.sql

echo "Step 2: Create Bronze tables..."
/opt/mssql-tools18/bin/sqlcmd \
  -S sqlserver \
  -U sa \
  -P "$MSSQL_SA_PASSWORD" \
  -C \
  -d DataWarehouse \
  -i /scripts/bronze/ddl_bronze.sql

echo "Step 3: Load Bronze..."
/opt/mssql-tools18/bin/sqlcmd \
  -S sqlserver \
  -U sa \
  -P "$MSSQL_SA_PASSWORD" \
  -C \
  -d DataWarehouse \
  -i /scripts/bronze/proc_load_bronze.sql

echo "Bronze pipeline completed successfully."        