#!/bin/bash

DB_NAME="shopifyOA"
USER="shopify"
PASSWORD="1234"

# spent wayyyyy tooo much time trying to do this automatically but couldnt get around foreign key constraints
FILES=(
    "data/category_data.csv"
    "data/product_data.csv"
    "data/user_data.csv"
    "data/order_data.csv"
    "data/order_items_data.csv"
    "data/review_data.csv"
    "data/cart_data.csv"
    "data/cart_item_data.csv"
)

for file in "${FILES[@]}"
do
    # remove _data.csv from file name to get table name
    table_name=$(basename $file _data.csv)    

    if [ $table_name != "cart" ] && [ $table_name != "shipping" ] && [ $table_name != "order_items" ]
    then
        table_name="${table_name}s"
    fi
    if [ $table_name == "categorys" ]
    then
        table_name="categories"
    fi
    echo "Processing $table_name"
    
    PGPASSWORD=1234 psql -U shopify -d shopifyOA -c "\copy ${table_name} FROM '$file' DELIMITER ',' CSV HEADER;"

done
