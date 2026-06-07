# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀

This project demonstrates a complete data warehousing and analytics solution using **SQL Server**, **dbt**, **Docker**, and **Apache Airflow**. It follows the **Medallion Architecture** to process raw data from CRM and ERP systems into clean, analytics-ready datasets for business reporting.

---

## 📌 Project Overview

The goal of this project is to build a modern data warehouse that consolidates sales-related data from multiple source systems and transforms it into a structured analytical model.

The pipeline covers:

```text
Raw CSV Data
    ↓
Bronze Layer
    ↓
Silver Layer
    ↓
Gold Layer
    ↓
Analytics & Reporting
```

The final Gold layer is designed using a **Star Schema**, making it suitable for business intelligence, dashboarding, and analytical queries.

---

## 🚀 Project Requirements

### 1. Building the Data Warehouse

#### Objective

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications

* **Data Sources**: Import data from two source systems, ERP and CRM, provided as CSV files.
* **Data Quality**: Clean and resolve data quality issues before analysis.
* **Integration**: Combine ERP and CRM data into a unified analytical data model.
* **Scope**: Focus on the latest dataset only. Historization is not required.
* **Documentation**: Provide clear documentation of the data model for business and analytics users.

---

### 2. BI: Analytics & Reporting

#### Objective

Develop SQL-based analytics to generate insights into:

* Customer behavior
* Product performance
* Sales trends

These insights support better business decision-making and provide a foundation for dashboards and reports.

---

## 🏗️ Data Architecture

This project follows the **Medallion Architecture**:

### Bronze Layer

The Bronze layer stores raw data loaded directly from CSV files.

Main tables:

```text
bronze.crm_cust_info
bronze.crm_prd_info
bronze.crm_sales_details
bronze.erp_cust_az12
bronze.erp_loc_a101
bronze.erp_px_cat_g1v2
```

---

### Silver Layer

The Silver layer contains cleaned, standardized, and transformed data.

Main transformations include:

* Removing duplicate records
* Standardizing gender and marital status values
* Cleaning product and customer information
* Handling invalid dates
* Fixing inconsistent sales, quantity, and price values
* Standardizing country names

---

### Gold Layer

The Gold layer provides business-ready data modeled as a Star Schema.

Main models:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
```

These models are used for analytics and reporting.

---

## 🛠️ Technologies Used

* SQL Server
* Docker
* Docker Compose
* dbt
* Apache Airflow
* SQLCMD
* WSL/Linux Terminal
* VS Code
* Git/GitHub

---

## 📂 Project Structure

```text
sql-data-warehouse/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── dbt_dw/
│   ├── models/
│   │   ├── silver/
│   │   └── gold/
│   ├── tests/
│   ├── dbt_project.yml
│   └── profiles.yml
│
├── orchestration/
│   ├── dags/
│   │   └── sql_data_warehouse_dag.py
│   ├── logs/
│   └── plugins/
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── init_database.sql
│
├── tests/
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
├── docker-compose.yml
├── Dockerfile.dbt
├── requirements.txt
└── README.md
```

---

## ⚙️ How to Run This Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/DD092/sql-data-warehouse.git
cd sql-data-warehouse
```

---

### Step 2: Start Docker Containers

```bash
docker compose up -d
```

Check running containers:

```bash
docker ps
```

Expected containers:

```text
sql_data_warehouse
dbt_dw
```

---

### Step 3: Start Airflow Webserver

Open the first WSL/Linux terminal:

```bash
export AIRFLOW_HOME=/mnt/c/Users/ADMIN/Desktop/project/sql-data-warehouse/orchestration
export PATH="$HOME/.local/bin:$PATH"

airflow webserver --port 8080
```

---

### Step 4: Start Airflow Scheduler

Open the second WSL/Linux terminal:

```bash
export AIRFLOW_HOME=/mnt/c/Users/ADMIN/Desktop/project/sql-data-warehouse/orchestration
export PATH="$HOME/.local/bin:$PATH"

airflow scheduler
```

---

### Step 5: Open Airflow UI

Open your browser:

```text
http://localhost:8080
```

Login:

```text
Username: admin
Password: admin
```

---

### Step 6: Run the Pipeline

In Airflow UI, trigger the DAG:

```text
sql_data_warehouse_pipeline
```

The pipeline runs the following tasks:

```text
run_init_database
    ↓
run_ddl_bronze
    ↓
load_bronze
    ↓
run_dbt_debug
    ↓
run_dbt_build
```

---

## ✅ Data Quality Checks

The project includes SQL-based quality checks for Silver and Gold layers.

Examples of checks:

* Duplicate primary keys
* Null values in key columns
* Invalid dates
* Unwanted spaces
* Negative or null cost values
* Sales calculation consistency
* Fact-to-dimension relationship checks

Quality check files:

```text
tests/quality_checks_silver.sql
tests/quality_checks_gold.sql
```

---

## 📊 Final Analytics Output

After the pipeline runs successfully, the final analytics-ready models are available in the Gold layer:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
```

These models can be used for:

* Customer analysis
* Product analysis
* Sales performance analysis
* BI dashboards
* Business reporting

---


## 📌 Notes

* SQL Server runs inside Docker.
* dbt runs inside the `dbt_dw` container.
* Airflow runs locally through WSL/Linux.
* The Airflow DAG uses Docker commands to execute SQL Server and dbt tasks.
* The default Airflow login is:

```text
admin / admin
```

---

## 👤 Author

**Thanh Dat**

This project was built as a portfolio project to demonstrate practical skills in data engineering, data warehousing, orchestration, transformation, and analytics.
