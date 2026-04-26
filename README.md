# 🚴 Bike Store ETL Pipeline (Big Data Project)

## 📌 Overview

This project demonstrates a complete **end-to-end Big Data ETL pipeline** using modern data engineering tools.

It simulates a real-world workflow:

* Extract data from a relational database (MariaDB)
* Ingest into HDFS using Sqoop
* Transform data using Apache Spark
* Load clean data into an Apache Hive Data Warehouse
* Generate analytical datasets and visualize insights using Power BI

---

## 🏗️ Architecture

MariaDB → Sqoop → HDFS (Staging) → Apache Spark -> Apache Hive -> Power BI

---

## 🛠️ Tech Stack

* Database: MariaDB
* Ingestion: Apache Sqoop
* Storage: Hadoop HDFS
* Processing: Apache Spark (PySpark)
* Data Warehousing: Apache Hive
* Visualization: Microsoft Power BI
* Cluster Manager: YARN

---

## 📂 Project Structure
```text
├── scripts/                            # Bash scripts for Hadoop/Sqoop operations
│   ├── sqoop_ingest_to_hdfs.sh         # Ingests MariaDB data into HDFS
│   └── verify_sqoop_ingest_to_hdfs.sh  # Verifies successful HDFS data transfer
│
├── Hive_Queries.sql                    # SQL script containing analytical Hive queries
├── MariaDB_SQL_Statements.sql          # SQL script to initialize the relational database
├── README.md                           # Project documentation
├── bike-store-dashboard-project.pbix   # Power BI interactive dashboard file
└── bike_store_spark.ipynb              # Jupyter Notebook for PySpark ETL transformations
```


---

## ⚙️ Step-by-Step Pipeline

### 1️⃣ Create Database & Load Data

Run:

```
MariaDB_SQL_Statements.sql
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

<img width="1722" height="932" alt="1 sqoop_bash_finish" src="https://github.com/user-attachments/assets/799bf909-c37c-40e9-a75c-c8ea500ff865" />

<img width="1101" height="667" alt="2  data in hdfs" src="https://github.com/user-attachments/assets/53c4d48c-c656-4b03-a8e3-707276656d7d" />

<img width="1103" height="321" alt="3" src="https://github.com/user-attachments/assets/32790c9f-7577-485b-9565-7752d047b540" />

### 3️⃣ Verify Ingestion

```bash
bash scripts/verify_sqoop_ingest_to_hdfs.sh
```

<img width="977" height="476" alt="4  verify script" src="https://github.com/user-attachments/assets/84608bdf-b588-4cea-a5d1-da61a241f5ff" />


---

### 4️⃣ Run Spark ETL

Open and run:

```
bike_store_spark.ipynb
```

The PySpark notebook performs the heavy lifting for data transformation:

* Data Cleaning: Converts timestamps to Date format, casts numeric fields, and removes hidden carriage return characters.
* Data Transformation: Joins 9 normalized tables into a single analytical Fact table.
* Aggregation: Computes line-level revenue and generates distinct analytical summary tables.

All outputs are saved as Parquet files in /staging_area/Analysis/

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


---

### 5. Hive Data Warehousing & Analytics

The Spark outputs are mapped to External Tables in Apache Hive to allow standard SQL querying without moving the physical files.

The following analytical queries were executed in Hive (Hue) to generate the final business reports:

**Q1: Which store generates the most revenue?**
```sql
SELECT 
    store_name, 
    city, 
    state,
    total_revenue,
    total_orders,
    ROUND(total_revenue / total_orders, 2) AS avg_order_value
FROM revenue_by_store
ORDER BY total_revenue DESC;
```
<br>
<img width="1317" height="673" alt="1" src="https://github.com/user-attachments/assets/ac8eab37-0792-4c1d-9b37-3dd8e2f0658a" />
<br><br>

**Q2: Best-selling category by units sold?**
```sql
SELECT 
    category_name,
    total_units_sold,
    total_revenue,
    ROUND(total_revenue / total_units_sold, 2) AS avg_price_per_unit
FROM revenue_by_category
ORDER BY total_units_sold DESC;
```
<br>
<img width="1278" height="632" alt="2" src="https://github.com/user-attachments/assets/b64b2f0e-c144-4870-b0ba-3f5dc43f549a" />
<br><br>

**Q3: Top 5 customers by lifetime value?**
```sql
SELECT 
    customer_name, 
    customer_city, 
    customer_state,
    lifetime_value, 
    total_orders, 
    last_order_date
FROM top_customers
ORDER BY lifetime_value DESC
LIMIT 5;
```
<br>
<img width="1295" height="622" alt="3" src="https://github.com/user-attachments/assets/56a1b27e-97ad-4409-8dee-70a66531cb40" />
<br><br>

**Q4: Which year had the highest revenue?**
```sql
SELECT 
    year,
    ROUND(SUM(total_revenue), 2) AS yearly_revenue,
    SUM(total_orders) AS yearly_orders,
    SUM(total_units_sold) AS yearly_units
FROM monthly_revenue
GROUP BY year
ORDER BY yearly_revenue DESC;
```
<br>
<img width="1293" height="545" alt="4" src="https://github.com/user-attachments/assets/5b8a2d91-3e46-4cd2-8275-b6797d140274" />
<br><br>

**Q5: Which staff member handled the most orders?**
```sql
SELECT 
    staff_name, 
    store_name,
    completed_orders,
    total_revenue_generated,
    unique_customers_served
FROM staff_performance
ORDER BY completed_orders DESC
LIMIT 5;
```
<br>
<img width="1277" height="601" alt="5" src="https://github.com/user-attachments/assets/eb37ead6-5429-4a8f-b85f-8e5f687b4724" />
<br><br>

**Q6: Stores with critical stock levels (quantity = 0)?**
```sql
SELECT 
    store_name,
    COUNT(*) AS out_of_stock_products
FROM low_stock_alert
WHERE quantity = 0
GROUP BY store_name
ORDER BY out_of_stock_products DESC;
```
<br>
<img width="1307" height="485" alt="6" src="https://github.com/user-attachments/assets/c51172b0-0a69-4ab1-906e-a1237067cdea" />

---


### 6. Data Visualization (Power BI)

The final CSV reports generated by Hive were imported into Microsoft Power BI to build an interactive Executive Dashboard. 

The dashboard provides high-level KPIs, store-level revenue breakdowns, staff performance metrics, and automated inventory alerts.

<img width="1342" height="753" alt="powerbi" src="https://github.com/user-attachments/assets/119bf56b-8574-4f80-a965-010a3dc004f0" />



---

## Sample Insights

* Baldwin Bikes generates the highest revenue.
* Cruisers Bicycles are the highest-selling category by total units.
* Strong seasonal revenue trends observed, peaking in mid-2017.
* Automated tracking identified specific stores with immediate zero-stock inventory alerts.

---

## 🚀 How to Run

```bash
# Step 1: Set up DB
mysql < MariaDB_SQL_Statements.sql

# Step 2: Ingest data
bash scripts/sqoop_ingest_to_hdfs.sh

# Step 3: Verify
bash scripts/verify_sqoop_ingest_to_hdfs.sh

# Step 4: Run Spark
jupyter notebook notebooks/bike_store_spark.ipynb

# Step 5: Run Hive Queries
# Execute the provided queries in the Hive CLI or Hue interface
```

---

## Future Improvements

* Automate the end-to-end pipeline using Apache Airflow
* Add incremental data ingestion logic for daily updates
* Implement real-time streaming data using Apache Kafka

---

## Author

Abeer Omar
