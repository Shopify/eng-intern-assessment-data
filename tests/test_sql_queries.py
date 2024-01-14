import unittest
import mysql.connector # Replace with appropriate database connector based on your database
from decimal import Decimal

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            user='root',
            password='Yoreo123!',
            host='localhost',
            database='shopify_assessment'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('../sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', Decimal('1000.00')),
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', Decimal('54.00')),
            (19, 'Product 19', 'Description for Product 19', Decimal('287.34')),
            (48, 'Product 48', 'Description for Product 48', Decimal('138.25'))
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    # def test_task2(self):
    #     # Task 2: Example SQL query in task2.sql
    #     with open('/sql/task2.sql', 'r') as file:
    #         sql_query = file.read()

    #     self.cur.execute(sql_query)
    #     result = self.cur.fetchall()

    #     # Define expected outcome for Task 2 and compare
    #     expected_result = [
    #         # Define expected rows or values here based on the query output
    #     ]

    #     self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()