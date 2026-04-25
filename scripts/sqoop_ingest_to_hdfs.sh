#!/bin/bash
set -e # Exit immediately if any command fails

echo "=========================================================="
echo " Starting Data Ingestion: MariaDB -> HDFS via Sqoop       "
echo " Target Directory: /staging_area                          "
echo "=========================================================="

# ─────────────────────────────────────────────
# 1. Create HDFS staging directories
# ─────────────────────────────────────────────
echo "--> Creating HDFS directories..."
hdfs dfs -mkdir -p /staging_area/Sales
hdfs dfs -mkdir -p /staging_area/Production

# ─────────────────────────────────────────────
# 2. Sales database tables
# ─────────────────────────────────────────────
echo "--> Importing Sales Database Tables..."

sqoop import \
--connect jdbc:mysql://localhost:3306/sales \
--username student \
--password student \
--table customers \
--target-dir /staging_area/Sales/Customer \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/sales \
--username student \
--password student \
--table orders \
--target-dir /staging_area/Sales/Orders \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/sales \
--username student \
--password student \
--table order_items \
--target-dir /staging_area/Sales/Order_Items \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/sales \
--username student \
--password student \
--table stores \
--target-dir /staging_area/Sales/Stores \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/sales \
--username student \
--password student \
--table staffs \
--target-dir /staging_area/Sales/Staffs \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

# ─────────────────────────────────────────────
# 3. Production database tables
# ─────────────────────────────────────────────
echo "--> Importing Production Database Tables..."

sqoop import \
--connect jdbc:mysql://localhost:3306/production \
--username student \
--password student \
--table brands \
--target-dir /staging_area/Production/Brands \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/production \
--username student \
--password student \
--table categories \
--target-dir /staging_area/Production/Categories \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/production \
--username student \
--password student \
--table products \
--target-dir /staging_area/Production/Products \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

sqoop import \
--connect jdbc:mysql://localhost:3306/production \
--username student \
--password student \
--table stocks \
--target-dir /staging_area/Production/Stocks \
--delete-target-dir \
--as-parquetfile \
--num-mappers 1

echo "=========================================================="
echo " Sqoop Ingestion Script Completed Successfully!           "
echo "=========================================================="
