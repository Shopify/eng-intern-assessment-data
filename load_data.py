"""A script to load in the data from the given CSVs into a SQLite database, that we'll use for testing the queries."""
import sqlite3
import re

db = sqlite3.connect("data.db")
cursor = db.cursor()

# Create all the tables based off the
schema = open("sql/schema.sql", "r")

# Link the CSVs to the tables they should be loaded into
csv_to_table = {
    "data/cart_data.csv": "Cart",
    "data/cart_item_data.csv": "Cart_Items",
    "data/category_data.csv": "Categories",
    "data/order_data.csv": "Orders",
    "data/order_items_data.csv": "Order_Items",
    "data/payment_data.csv": "Payments",
    "data/product_data.csv": "Products",
    "data/review_data.csv": "Reviews",
    "data/shipping_data.csv": "Shipping",
    "data/user_data.csv": "Users",
}

# Drop all the tables if they exist to clean up
for table in csv_to_table.values():
    cursor.execute(f"DROP TABLE IF EXISTS {table};")

cursor.executescript(schema.read())

db.commit()

# Load the data for each table from each CSV
for csv, table in csv_to_table.items():
    print(f"Loading {csv} into {table}...")
    with open(csv, "r") as f:
        # Ingest the header to know what data is in the CSV columns
        header = f.readline().strip().split(",")

        # For all the subsequent lines, insert the data into the table
        for line in f.readlines():
            values = line.strip().split(",")

            # Prepare the values to be inserted, especially putting quotes around strings, and fomatting dates
            for i, value in enumerate(values):
                if re.match(r"/\d{4}-\d{2}-\d{2}/", value):
                    values[i] = "TO_DATE('{value}','yyyy-mm-dd')"
                elif not value.isnumeric():
                    values[i] = f"'{value}'"
            
            insert_command = f"INSERT INTO {table} ({', '.join(header)}) VALUES ({','.join(values)});"
            cursor.execute(insert_command)
    print(f"Finished loading {csv} into {table}!")

db.commit()

print("Data loaded into database!")
print()
print("Running sanity checks...")
# Just as a sanity check, print out the head of each table
for table in csv_to_table.values():
    print(f"Head of {table}:")
    cursor.execute(f"SELECT * FROM {table} LIMIT 5;")
    for row in cursor.fetchall():
        print(row)
    print("---------------------")

db.close()
