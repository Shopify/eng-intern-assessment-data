import mysql.connector
import random
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

# Function to generate mock product data
def generate_product_data(start_id, end_id):
    products = []
    for product_id in range(start_id, end_id + 1):
        product_name = f"Product {product_id}"
        description = f"Description for Product {product_id}"
        price = round(random.uniform(10, 1000), 2)  # Random price between 10 and 1000
        category_id = random.randint(1, 50)  # Random category_id between 1 and 50
        products.append((product_id, product_name, description, price, category_id))
    return products

# Function to insert product data into MySQL
def insert_product_data(products):
    try:
        connection = mysql.connector.connect(**config)
        cursor = connection.cursor()

        # SQL query to insert data
        sql_query = "INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (%s, %s, %s, %s, %s)"

        # Execute the SQL query for each product
        for product in products:
            cursor.execute(sql_query, product)

        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# Generate mock product data and insert it into the database
mock_products = generate_product_data(17, 50)
insert_product_data(mock_products)
