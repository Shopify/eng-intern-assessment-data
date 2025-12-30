import psycopg2
import os
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

# Database connection parameters
db_name = ""
db_user = ""
db_pass = ""
db_host = ""
db_port = "5432"  # Default PostgreSQL port

# Path to your SQL file and CSV directory
schema_file_path = "/sql/schema.sql"
csv_dir = "/data/"

def load_csv_to_db(conn, csv_file_path, table_name):
    with open(csv_file_path, 'r') as f:
        next(f)  # Skip the header row
        with conn.cursor() as cur:
            cur.copy_from(f, table_name, sep=',') 
    conn.commit()

try:
    # Connect to the database server
    conn = psycopg2.connect(host=db_host, user=db_user, password=db_pass)

    # Set isolation level to AUTOCOMMIT
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)

    # Drop and recreate database
    with conn.cursor() as cur:
        cur.execute(f'DROP DATABASE IF EXISTS "{db_name}";')
        cur.execute(f'CREATE DATABASE "{db_name}";')
    print(f"Database '{db_name}' has been recreated.")

    # Close the connection to the server
    conn.close()

    # Connect to the newly created database
    conn = psycopg2.connect(database=db_name, user=db_user, password=db_pass, host=db_host)

    # Check if the SQL schema file exists
    if os.path.exists(schema_file_path):
        # Open and read the SQL file
        with open(schema_file_path, 'r') as file:
            schema_script = file.read()

        # Execute the schema script
        with conn.cursor() as cur:
            cur.execute(schema_script)
        conn.commit()
        print("Schema script executed successfully")

        # Mapping of CSV files to their corresponding tables
        csv_to_table = {
            "category": "categories",
            "product": "products",
            "user": "users",
            "order": "orders",
            "order_items": "order_items",
            "review": "reviews",
            "cart": "cart",
            "cart_item": "cart_items",
            "payment": "payments",
            "shipping": "shipping",
        }

        # Loop through the mapping and load each CSV file into its corresponding table
        for key, table in csv_to_table.items():
            csv_file = os.path.join(csv_dir, f"{key}_data.csv")  # Construct CSV file path
            load_csv_to_db(conn, csv_file, table)

        print("Data imported successfully into all tables")

    else:
        print(f"File not found: {schema_file_path}")

except Exception as e:
    print(f"An error occurred: {e}")

finally:
    # Close the database connection
    if conn is not None:
        conn.close()
