import psycopg2
import pandas as pd
from psycopg2 import extras
import os

class DataLoader:
    def __init__(self, db_name, user, password, host, port, data_folder, sql_file_path, file_to_table_mapping):
        self.db_name = db_name
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.data_folder = data_folder
        self.sql_file_path = sql_file_path
        self.file_to_table_mapping = file_to_table_mapping

    def create_database(self):
        conn = None
        try:
            # Connect to the default 'postgres' database
            conn = psycopg2.connect(dbname='postgres', user=self.user, password=self.password, host=self.host, port=self.port)
            conn.autocommit = True  # Enable autocommit for database creation

            with conn.cursor() as cursor:
                cursor.execute(f"DROP DATABASE IF EXISTS {self.db_name};")
                cursor.execute(f"CREATE DATABASE {self.db_name};")

            print(f"Database {self.db_name} created successfully.")
        except Exception as e:
            print(f"Error creating database: {e}")
        finally:
            if conn:
                conn.close()
                
    def execute_sql_from_file(self, cursor, file_path):
        with open(file_path, 'r') as file:
            sql_script = file.read()
            cursor.execute(sql_script)
        print(f"Executed SQL script from {file_path}")

    def load_csv_to_db(self, connection, cursor, file_path, table_name, products_file_path=None):
        try:
            data = pd.read_csv(file_path, dtype=str)

            # Filter the data for specific tables based on product IDs in the 'Products' table
            if table_name in ['order_items', 'cart_items', 'reviews'] and products_file_path:
                products_data = pd.read_csv(products_file_path, dtype=str)
                valid_product_ids = set(products_data['product_id'])
                data = data[data['product_id'].isin(valid_product_ids)]

            tuples = [tuple(x) for x in data.values]
            cols = ','.join(f'"{col}"' for col in data.columns)
            query = f"INSERT INTO {table_name}({cols}) VALUES %s ON CONFLICT DO NOTHING"
            extras.execute_values(cursor, query, tuples)
            connection.commit()
            
            print(f"Data loaded successfully into {table_name}.")
        except Exception as e:
            connection.rollback()
            print(f"Error loading {file_path}: {e}")

    def run(self):
        """
        Run the process of creating the database, setting up schema, and loading data.
        """
        # Create the database first
        self.create_database()

        # Connect to the newly created database
        conn_params = {
            'dbname': self.db_name,
            'user': self.user,
            'password': self.password,
            'host': self.host,
            'port': self.port
        }
        with psycopg2.connect(**conn_params) as conn:
            with conn.cursor() as cur:
                # Execute SQL schema setup script
                self.execute_sql_from_file(cur, self.sql_file_path)
                conn.commit()

                # Path to the Products CSV file
                products_file_path = os.path.join(self.data_folder, 'product_data.csv')

                # Iterate over each CSV file and table mapping
                for csv_file, table_name in self.file_to_table_mapping.items():
                    full_path_to_file = os.path.join(self.data_folder, csv_file)

                    # Filter data and load into the database for specific tables
                    if table_name in ['order_items', 'cart_items', 'reviews']:
                        self.load_csv_to_db(conn, cur, full_path_to_file, table_name, products_file_path)
                    else:
                        # For other tables, call the method without product file path
                        self.load_csv_to_db(conn, cur, full_path_to_file, table_name)

                conn.commit()
                
                

if __name__ == "__main__":
    db_name = 'db_name' # Replace with your database name
    user = 'user' # Replace with your username
    password = 'password' # Replace with your password
    host = 'localhost' # Replace with your host     
    port = 'port'  # Replace with your port
    data_folder = '/data'  # Replace with the path to data folder
    sql_file_path = '/sql/schema.sql'  # Replace with the path to SQL schema file

    # Mapping of CSV file names to their corresponding database table names
    file_to_table_mapping = {
                'category_data.csv': 'categories',
                'product_data.csv': 'products',
                'user_data.csv': 'users',
                'order_data.csv': 'orders',
                'order_items_data.csv': 'order_items',
                'cart_data.csv': 'cart',
                'cart_item_data.csv': 'cart_items',
                'review_data.csv': 'reviews',
                'payment_data.csv': 'payments',
                'shipping_data.csv': 'shipping'
    }


    data_loader = DataLoader(db_name, user, password, host, port, data_folder, sql_file_path, file_to_table_mapping)
    data_loader.run()
