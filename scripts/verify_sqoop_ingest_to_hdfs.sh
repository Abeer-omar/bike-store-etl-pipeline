#!/bin/bash

echo "=========================================================="
echo " Verification: Checking for Parquet files in HDFS         "
echo "=========================================================="

# Variable to track if any table failed
MISSING_DATA=0

echo "=== Sales Tables ==="
for t in Customer Orders Order_Items Stores Staffs; do
  if hdfs dfs -ls /staging_area/Sales/$t/ 2>/dev/null | grep -q ".parquet"; then
    echo "  $t : SUCCESS"
  else
    echo "  $t : NOT COMPLETE"
    MISSING_DATA=1
  fi
done

echo "=== Production Tables ==="
for t in Brands Categories Products Stocks; do
  if hdfs dfs -ls /staging_area/Production/$t/ 2>/dev/null | grep -q ".parquet"; then
    echo "  $t : SUCCESS"
  else
    echo "  $t : NOT COMPLETE"
    MISSING_DATA=1
  fi
done

# If any table was missing, fail the script
if [ $MISSING_DATA -eq 1 ]; then
    echo "=========================================================="
    echo " ERROR: Some tables did not ingest correctly!             "
    echo "=========================================================="
    exit 1  
else
    echo "=========================================================="
    echo " SUCCESS: All tables verified successfully!               "
    echo "=========================================================="
    exit 0  
fi
