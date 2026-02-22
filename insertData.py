#Code to insert data into database
#Code made by Shaun Meric Menezes
import sqlite3
import csv
import pandas as pd
import os

#Connecting to the sqllite database
conn = sqlite3.connect('webstore.db')
cursor = conn.cursor()

# Defining the list of tables and corresponding data file
dataBundle = [
    {'dataFile':'category_data','tableName':'Categories'},
    {'dataFile':'product_data','tableName':'Products'},
    {'dataFile':'user_data','tableName':'Users'},
    {'dataFile':'order_data','tableName':'Orders'},
    {'dataFile':'order_items_data','tableName':'Order_Items'},
    {'dataFile':'review_data','tableName':'Reviews'},
    {'dataFile':'cart_data','tableName':'Cart'},
    {'dataFile':'cart_item_data','tableName':'Cart_Items'},
    {'dataFile':'payment_data','tableName':'Payments'},
    {'dataFile':'shipping_data','tableName':'Shipping'},
]


for data in dataBundle:
    try:
        df = pd.read_csv(f'data/{data["dataFile"]}.csv')
        df.to_sql(data['tableName'], conn, if_exists='append', index=False)
        print(f"Data Insertion succesful")
    except:
        print(f"Data Insertion Unsuccesful")



#closing the connection
conn.commit()
conn.close()