#!/bin/bash

CSV_DIR="/Users/jiminlee/shopify_assessment/eng-intern-assessment-data/data"  # Directory where CSV files are located

# Database credentials
DB_NAME="test_data"
DB_USER="jiminlee"
# DB_PASSWORD="1004"

table_names="categories products users orders order_items reviews cart cart_items payments shipping"

# Loop for each table name
for table in $table_names; do
    echo "Processing table: $table"
    
    # Construct the CSV file path
    CSV_FILE="$CSV_DIR/${table}_data.csv"

    # Check if the CSV file exists
    if [[ -f "$CSV_FILE" ]]; then
        echo "Importing data from $CSV_FILE into $table"

        # Run the \copy command in psql
        PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d $DB_NAME -c "\copy $table FROM '$CSV_FILE' WITH (FORMAT csv, HEADER, DELIMITER ',')"
    else
        echo "Warning: CSV file $CSV_FILE does not exist, skipping import for $table."
    fi
done