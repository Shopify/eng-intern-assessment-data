import pandas as pd
import sqlite3

def create_db(db_name, csv_table_mapping):
    """
    Function creates a SQLite database and populates tables with data from CSV files.
    It does not make use of the sql/schema.sql file.

    Parameters:
    - db_name (str): Name of the SQLite database
    - csv_table_mapping (dict): Mapping of CSV file paths to table names
    """
    # Create and connect to database
    conn = sqlite3.connect(db_name)

    # Read each CSV file and load data into tables
    for csv_file_path, table_name in csv_table_mapping.items():
        df = pd.read_csv(csv_file_path)
        df.to_sql(table_name, conn, index=False, if_exists='replace')

    # Commit changes and close the connection
    conn.commit()
    conn.close()