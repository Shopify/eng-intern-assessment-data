import mysql.connector
import csv
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Database connection parameters
config = {
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST'),
    'database': os.getenv('DB_NAME'),
    'raise_on_warnings': True
}

# Function to import CSV data into MySQL
def import_csv_to_mysql(table_name, csv_file_path):
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()

        # Open the CSV file and read the number of columns
        with open(csv_file_path, 'r') as csv_file:
            csv_reader = csv.reader(csv_file)
            headers = next(csv_reader)  # Capture the header row
            num_columns = len(headers)

            # Prepare the SQL query with the appropriate number of placeholders
            placeholders = ', '.join(['%s'] * num_columns)
            sql_query = f"INSERT INTO {table_name} VALUES ({placeholders})"

            # Execute the SQL query for each row in the CSV file
            for row in csv_reader:
                cursor.execute(sql_query, row)

        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# Dictionary mapping table names to CSV files
table_to_csv = {
    'Categories': '../data/category_data.csv',
    'Users': '../data/user_data.csv',
    'Products': '../data/product_data.csv',
    'Orders': '../data/order_data.csv',
    'Order_Items': '../data/order_items_data.csv',
    'Reviews': '../data/review_data.csv',
    'Cart': '../data/cart_data.csv',
    'Cart_Items': '../data/cart_item_data.csv',
    'Payments': '../data/payment_data.csv',
    'Shipping': '../data/shipping_data.csv'
}


# Import CSV files into MySQL
for table, csv_path in table_to_csv.items():
    if os.path.exists(csv_path):
        import_csv_to_mysql(table, csv_path)
    else:
        print(f"File not found: {csv_path}")