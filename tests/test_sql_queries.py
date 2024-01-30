import unittest
import os
import pandas as pd
import psycopg2 # Replace with appropriate database connector based on your database
from psycopg2 import extras

# Instructions for running tests
# 1. Build the Docker image: `docker build -f Dockerfile -t ayanstests .`
# 2. Run the Docker image: `docker run --rm ayanstests`

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='mydatabase',
            user='myuser',
            password='mypassword',
            host='0.0.0.0',
            port='5432'
        )
        self.cur = self.conn.cursor()
        

    def tearDown(self):

        # Close the database connection
        self.cur.close()
        self.conn.close()

    def read_schema(self):
        with open('sql/schema.sql', 'r') as file:
            sql_code = file.read()
        self.cur.execute(sql_code)
        self.conn.commit()

    def read_data(self):
        # List of table names in schema; CSVs are read in a specific order to not violate foreign key constraints
        table_names = [
            'Categories','Products', 'Users', 'Orders',
            'Order_Items','Reviews','Cart','Cart_Items',
            'Payments','Shipping'
        ]
        # List of file names corresponding to tables in schema
        file_names = [
            'category_data.csv','product_data.csv','user_data.csv','order_data.csv',
            'order_items_data.csv', 'review_data.csv','cart_data.csv','cart_item_data.csv',
            'payment_data.csv','shipping_data.csv'
        ]

        # Adds data to the database from all data files
        for table, file in zip(table_names, file_names):
            # Skips any data that causes a foreign key exception
            try:
                file_path = 'data/' + file
                data = pd.read_csv(file_path)
                columns = list(data.columns)
                values = data.values.tolist()
                # Adds data to the database
                query =  f"INSERT INTO {table} ({', '.join(columns)}) VALUES %s"
                extras.execute_values(self.cur, query, values)
                self.conn.commit()
            except psycopg2.DatabaseError as e:
                self.conn.rollback()
        

    def test_task1(self):
        self.read_schema()
        self.read_data()
        # Task 1: Example SQL query in task1.sql
        with open('sql/task1.sql', 'r') as file:
            sql_query = file.read()
        
        self.cur.execute(sql_query)
        result = self.cur.fetchall()
        print(result)

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output

        ]

        #self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()
        print(result)

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        #self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()
        print(result)
        # Define expected outcome for Task 3 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        #self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()