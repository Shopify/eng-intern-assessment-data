import sqlite3
import csv
import pandas as pd
import os

def create_database(db):
    try:
        # Connect to the SQLite database or create it if it doesn't exist
        conn = sqlite3.connect(db)
        print(f"Database connected/created")

    except sqlite3.Error as e:
        print(f"Error creating database {e}")

    finally:
        if conn:
            conn.close()

# Create tables using the schema.sql file
def create_tables(schema_file, db):
    with open(schema_file, 'r') as schema_file:
        schema_sql = schema_file.read()

    conn = sqlite3.connect(database=db)
    cursor = conn.cursor()

    try:
        # Run sql from schema_file
        cursor.executescript(schema_sql)
        print("Tables created")

    except sqlite3.Error as e:
        # Handle issues creating tables
        print(f"Error creating: {e}")

    finally:
        # Commit and close connection
        conn.commit()
        conn.close()

# Populate tables created from create_tables using the csv files in data folder
def populate_tables(file, table, db):
    conn = sqlite3.connect(database=db)
    cursor = conn.cursor()

    try:
        # Remove previous data in csv (if previously populated or old data)
        cursor.execute(f"DELETE FROM {table};")
        # Populate table with csv
        df = pd.read_csv(file)
        for index, row in df.iterrows():
            insert_query = f"INSERT INTO {table} ({', '.join(df.columns)}) VALUES ({', '.join(['?' for _ in df.columns])})"
            cursor.execute(insert_query, tuple(row))
        print(f"{table} populated")

    except sqlite3.Error as e:
        print(f"Error for {table}: {e}")

    finally:
        # Commit changes and close connection
        conn.commit()
        conn.close()

# Pairs of csv files and their associated table name
csv_table_pairs = [
  ("data/category_data.csv","Categories"),
  ("data/product_data.csv","Products"),
  ("data/user_data.csv","Users"),
  ("data/order_data.csv","Orders"),
  ("data/order_items_data.csv","Order_Items"),
  ("data/review_data.csv","Reviews"),
  ("data/cart_data.csv","Cart"),
  ("data/cart_item_data.csv","Cart_Items"),
  ("data/payment_data.csv","Payments"),
  ("data/shipping_data.csv", "Shipping")
]

schema_path = 'sql/schema.sql'
db_name = 'database.db'

create_database(db=db_name)
create_tables(schema_file=schema_path, db=db_name)
for file, table in csv_table_pairs:
    populate_tables(file=file, table=table, db=db_name)