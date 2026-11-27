import pandas as pd
import sqlite3

# Connect to SQLite database (it will be created if it doesn't exist)
conn = sqlite3.connect('mod_shopify_data.db')

# List of your CSV files and corresponding table names
csv_files = {
    'cart_data.csv': 'Cart',
    'cart_item_data.csv': 'Cart_Items',
    'category_data.csv': 'Categories',
    'order_data.csv': 'Orders',
    'order_items_data.csv': 'Order_Items',
    'product_data.csv': 'Products',
    'payment_data.csv': 'Payments',
    'review_data.csv': 'Reviews',
    'shipping_data.csv': 'Shipping',
    'user_data.csv': 'Users'
}

# Import each CSV file into a table
for csv_file, table_name in csv_files.items():
    file_path = 'mod_data/' + csv_file
    df = pd.read_csv(file_path)
    df.to_sql(table_name, conn, if_exists='replace', index=False)

# Close the connection
conn.close()
