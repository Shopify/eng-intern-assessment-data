import unittest
import sqlite3
import os
import pandas as pd

# Author's note: this doesn't seem to be working right now, tried my best to get this working with SQLite
# I opted to test in DBeaver instead
class TestSQLQueries(unittest.TestCase):

    table_names = ['Cart', 'Cart_Items', 'Categories', 'Data', 'Orders', 'Order_Items', 'Payments', 'Products', 'Reviews', 'Shipping', 'Users']

    def loadSchema(self):
        with open('./sql/schema.sql', 'r') as file:
            sql_query = file.read()
        self.cur.executescript(sql_query)
        result = self.cur.fetchall()
    
    def loadData(self):
        folder_path = '/home/byip/eng-intern-assessment-data/data'
        files = sorted(os.listdir(folder_path))
        for file_name, table_name in zip(files, self.table_names):
            if file_name.endswith(".csv"):
                # Construct the full file path
                file_path = os.path.join(folder_path, file_name)

                # Read CSV file into a pandas DataFrame
                df = pd.read_csv(file_path)

                # Write DataFrame to SQLite table
                df.to_sql(table_name, self.conn, index=False, if_exists='replace')
    
    def setUp(self):
        # Establish a connection to your test database
        self.conn = sqlite3.connect("shop.db")
        self.cur = self.conn.cursor()
        self.loadSchema()
        self.loadData()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()
        os.remove('shop.db')

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('./sql/task1.sql', 'r') as file:
            sql_query = file.read()
        self.cur = self.cur.executescript(sql_query)
        result = self.cur.fetchall()
        print(f'Query result is: {result}')
        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('./sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.executescript(sql_query)
        result = self.cur.fetchall()
        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

    def test_task3(self):
        # Task 2: Example SQL query in task2.sql
        with open('./sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.executescript(sql_query)
        result = self.cur.fetchall()
        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")
if __name__ == '__main__':
    unittest.main()