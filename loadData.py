import psycopg2
import pandas as pd
from psycopg2 import extras
import os

class DataLoader:
    def __init__(self, conn_params, data_folder, sql_file_path, file_to_table_mapping):
        self.conn_params = conn_params
        self.data_folder = data_folder
        self.sql_file_path = sql_file_path
        self.file_to_table_mapping = file_to_table_mapping

    def execute_sql_from_file(self, cursor, file_path):
        with open(file_path, 'r') as file:
            sql_script = file.read()
            cursor.execute(sql_script)
        print(f"Executed SQL script from {file_path}")

    def disable_foreign_keys(self, cursor):
        cursor.execute("""
            SELECT 'ALTER TABLE ' || table_schema || '.' || table_name || ' DISABLE TRIGGER ALL;'
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
        """)
        for query in cursor.fetchall():
            cursor.execute(query[0])

    def enable_foreign_keys(self, cursor):
        cursor.execute("""
            SELECT 'ALTER TABLE ' || table_schema || '.' || table_name || ' ENABLE TRIGGER ALL;'
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
        """)
        for query in cursor.fetchall():
            cursor.execute(query[0])

    def load_csv_to_db(self, connection, cursor, file_path, table_name):
        try:
            print(f"Loading data from {file_path} into {table_name}...")
            data = pd.read_csv(file_path, dtype=str)
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
        with psycopg2.connect(**self.conn_params) as conn:
            with conn.cursor() as cur:
                self.execute_sql_from_file(cur, self.sql_file_path)
                self.disable_foreign_keys(cur) # Disable foreign keys to allow data loading, this is not recommended for production but I was facing issues with foreign key constraints
                conn.commit()

                for csv_file, table_name in self.file_to_table_mapping.items():
                    full_path_to_file = os.path.join(self.data_folder, csv_file)
                    self.load_csv_to_db(conn, cur, full_path_to_file, table_name)

                self.enable_foreign_keys(cur) # Enable foreign keys after data loading
                conn.commit()

if __name__ == "__main__":
    conn_params = {
        'dbname': 'your_dbname',
        'user': 'your_username',
        'password': 'your_password',
        'host': 'your_host',
        'port': 'your_port'
    }
    data_folder = '/data'
    sql_file_path = '/sql/schema.sql'
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

    data_loader = DataLoader(conn_params, data_folder, sql_file_path, file_to_table_mapping)
    data_loader.run()
