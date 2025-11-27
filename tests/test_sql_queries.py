import unittest
import psycopg2  # Replace with appropriate database connector based on your database

"""
I have created a test database called 'test_data' in psql and created all necessary tables using schema.sql
Notes: 
1. I edited csv file names to be more consistent with the table names in schema.sql. 
   Apologies if this isn't appropriate, but I really didn't want to go line by line to 
   map the csv file names to the table names because of the small pluralization differences in naming convention.
   You can see my automated process to populate 'test_data' in the 'copy_csv_data.sh' script file.
2. products_data.csv have items 1-16, while product_id 17 and greater are referenced in order_items, reviews, and cart_items.
   I saw that this was raised as an issue multiple times in the github repo but didn't see any responses from Shopify (this is being written on Jan 23)
   so I decided to just populate the database with products_id 1-16 only.
"""

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='test_data',
            user='jiminlee',
            port='5433'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('/sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            (15, "Mountain Bike", "Conquer the trails with this high-performance mountain bike.", 1000.00, 8),
            (16, "Tennis Racket", "Take your tennis game to the next level with this professional-grade racket.", 54.00, 8)
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('/sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()