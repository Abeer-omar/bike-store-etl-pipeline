# 🚴 Bike Store ETL Pipeline (Big Data Project)

## 📌 Overview

This project demonstrates a complete **end-to-end Big Data ETL pipeline** using modern data engineering tools.

It simulates a real-world workflow:

* Extract data from a relational database (**MariaDB**)
* Ingest into **HDFS** using **Sqoop**
* Transform data using **Apache Spark**
* Generate analytical datasets for business insights

---

## 🏗️ Architecture

MariaDB → Sqoop → HDFS (Staging) → Spark → Analysis Outputs

---

## 🛠️ Tech Stack

* **Database:** MariaDB
* **Ingestion:** Apache Sqoop
* **Storage:** Hadoop HDFS
* **Processing:** Apache Spark (PySpark)
* **Cluster Manager:** YARN

---

## 📂 Project Structure

* `sql/` → Database schema & data loading
* `scripts/` → Sqoop ingestion + verification
* `notebooks/` → Spark ETL & analysis
* `docs/` → Architecture diagrams
* `output/` → Sample outputs

---

## ⚙️ Step-by-Step Pipeline

### 1️⃣ Create Database & Load Data

Run:

```sql
sql/mariaDB_schema.sql
```

Creates:

* Sales DB (customers, orders, etc.)
* Production DB (products, brands, etc.)

---

### 2️⃣ Ingest Data to HDFS

```bash
bash scripts/sqoop_ingest_to_hdfs.sh
```

* Imports all tables into HDFS
* Stores data as **Parquet**
* Organized into:

```
/staging_area/Sales/
/staging_area/Production/
```

---

### 3️⃣ Verify Ingestion

```bash
bash scripts/verify_sqoop_ingest_to_hdfs.sh
```

---

### 4️⃣ Run Spark ETL

Open and run:

```
notebooks/bike_store_spark.ipynb
```

---

## 🔧 Data Processing Steps

### ✔ Data Cleaning

* Convert Unix timestamps → Date format
* Cast numeric fields (price, discount)
* Remove hidden characters (`\r`, `\n`)

### ✔ Data Transformation

* Join **9 tables** into a single fact table
* Filter only completed orders
* Calculate:

```
line_revenue = quantity × price × (1 - discount)
```

---

## 📊 Analysis Outputs

The pipeline produces 8 analytical datasets:

| Dataset             | Description             |
| ------------------- | ----------------------- |
| revenue_by_store    | Store performance       |
| revenue_by_brand    | Brand performance       |
| revenue_by_category | Category insights       |
| top_customers       | Customer lifetime value |
| staff_performance   | Staff productivity      |
| monthly_revenue     | Time trends             |
| product_summary     | Product analytics       |
| low_stock_alert     | Inventory monitoring    |

All outputs are saved as **Parquet**:

```
/staging_area/Analysis/
```

---

## 📈 Sample Insights

* 🚀 Baldwin Bikes generates the highest revenue
* 🏆 Trek is the top-performing brand
* 📅 Strong seasonal revenue trends observed
* ⚠️ Several products identified with low stock

---

## 🚀 How to Run

```bash
# Step 1: Setup DB
mysql < sql/mariaDB_schema.sql

# Step 2: Ingest data
bash scripts/sqoop_ingest_to_hdfs.sh

# Step 3: Verify
bash scripts/verify_sqoop_ingest_to_hdfs.sh

# Step 4: Run Spark
jupyter notebook notebooks/bike_store_spark.ipynb
```

---

## 💡 Future Improvements

* Add Hive warehouse layer
* Build Power BI dashboard
* Automate pipeline with Airflow
* Add incremental data ingestion

---

## 👨‍💻 Author

Abeer Omar
