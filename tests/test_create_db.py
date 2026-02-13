import sqlite3
import os

def create_db(db_filepath, schema_filepath, data_dir):
    """
    Create an SQLite3 database as described in schema_filepath from the
    provided files in data_dir.

    Precondition: All data files are present in the data_dir. 
    Unexpected behavior occurs if this is not met (as this is a test case).
    """
    # Connect to the database
    conn = sqlite3.connect(db_filepath)
    cur = conn.cursor()

    # Create the tables as described in the schema
    with open(schema_filepath, "r") as f_schema:
        schema_commands = f_schema.read()
    cur.executescript(schema_commands)
    conn.commit()

    # For each data file, read its data into the database.
    # Assumes each table has a file "table_data.csv" and ignores "data.csv"
    for data_file in os.listdir(data_dir):
        if data_file == "data.csv":
            continue
        # From "table_name_data.csv", extract "table_name"
        table_name = "_".join(data_file.split(".")[0].split("_")[:-1])

        # Read the data file, accumulating data in a list
        data_values = []
        with open(f"{data_dir}/{data_file}", "r") as f_data:
            line = f_data.readline() # Skip the header line
            line = f_data.readline()
            while line != "":
                # Inserting all data as strings is bad practice, but works. 
                # We have no trivial access to the column datatypes.
                data_values.append(tuple(line.strip("\n").split(",")))
                line = f_data.readline()
        
        # Insert the data from the file into the table
        # Create "?, ?, ..." with a "?" per column in the table
        placeholders = ", ".join(["?" for _ in data_values[0]])
        insert_query = f"INSERT INTO {table_name} values ({placeholders})"
        cur.executemany(insert_query, data_values)
        conn.commit()

    # Close the connection to the database
    conn.close()


if __name__ == "__main__":
    create_db("tests/test.db", "sql/schema.sql", "data/")
