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

    run_init_database = BashOperator(
        task_id="run_init_database",
        bash_command="""
        docker exec sql_data_warehouse /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "YourStrong@Passw0rd" \
        -C \
        -i /init_database.sql
        """
    )

    run_ddl_bronze = BashOperator(
        task_id="run_ddl_bronze",
        bash_command="""
        docker exec sql_data_warehouse /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "YourStrong@Passw0rd" \
        -C \
        -d DataWarehouse \
        -i /scripts/bronze/ddl_bronze.sql
        """
    )

    load_bronze = BashOperator(
        task_id="load_bronze",
        bash_command="""
        docker exec sql_data_warehouse /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "YourStrong@Passw0rd" \
        -C \
        -d DataWarehouse \
        -i /scripts/bronze/proc_load_bronze.sql
        """
    )

    run_dbt_debug = BashOperator(
        task_id="run_dbt_debug",
        bash_command="""
        docker exec dbt_dw dbt debug --profiles-dir /usr/app
        """
    )

    run_dbt_build = BashOperator(
        task_id="run_dbt_build",
        bash_command="""
        docker exec dbt_dw dbt build --profiles-dir /usr/app
        """
    )

    run_init_database >> run_ddl_bronze >> load_bronze >> run_dbt_debug >> run_dbt_build