import mysql.connector
import os
import subprocess
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def run_sql_script(file_path, db_config):
    try:
        # Connect without specifying a database
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        
        with open(file_path, 'r') as sql_file:
            sql_script = sql_file.read()
        
        for statement in sql_script.split(';'):
            if statement.strip():
                cursor.execute(statement)
        
        connection.commit()
        print(f"Executed SQL script: {file_path}")
    except mysql.connector.Error as e:
        print(f"Error: {e}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

def run_python_script(file_path, db_config):
    # Modify db_config to include the specific database name
    db_config_with_db = db_config.copy()
    db_config_with_db['database'] = 'shopify_assessment'
    try:
        # Connect to the specific database
        connection = mysql.connector.connect(**db_config_with_db)
        subprocess.run(['python', file_path], check=True)
        print(f"Executed Python script: {file_path}")
    finally:
        if connection.is_connected():
            connection.close()

if __name__ == "__main__":
    db_config = {
        'user': os.getenv('DB_USER'),
        'password': os.getenv('DB_PASSWORD'),
        'host': os.getenv('DB_HOST')
    }

    # Run schema.sql to set up the database schema
    run_sql_script('../sql/schema.sql', db_config)

    # Run script.py to insert data into shopify_assessment
    run_python_script('../scripts/script.py', db_config)
