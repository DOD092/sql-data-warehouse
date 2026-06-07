from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


with DAG(
    dag_id="sql_data_warehouse_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["sql-server", "dbt", "data-warehouse"],
) as dag:

    init_database = BashOperator(
        task_id="init_database",
        bash_command="""
        /opt/mssql-tools18/bin/sqlcmd \
        -S sqlserver,1433 \
        -U sa \
        -P 'YourStrong@Passw0rd' \
        -C \
        -i /opt/airflow/scripts/init_database.sql
        """
    )

    load_bronze = BashOperator(
        task_id="load_bronze",
        bash_command="""
        /opt/mssql-tools18/bin/sqlcmd \
        -S sqlserver,1433 \
        -U sa \
        -P 'YourStrong@Passw0rd' \
        -C \
        -i /opt/airflow/scripts/bronze/proc_load_bronze.sql
        """
    )

    dbt_debug = BashOperator(
        task_id="dbt_debug",
        bash_command="""
        cd /opt/airflow/dbt_dw &&
        dbt debug --profiles-dir .
        """
    )

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command="""
        cd /opt/airflow/dbt_dw &&
        dbt build --profiles-dir .
        """
    )

    init_database >> load_bronze >> dbt_debug >> dbt_build