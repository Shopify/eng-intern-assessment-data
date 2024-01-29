import unittest
import mysql.connector

# This is a good way to check if queries are working as expected.
# I only used this test class to test my first query to set up the test, and then all other queries were
# tested directly in MySQL Workbench.
class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database (used MySQL)
        self.conn = mysql.connector.connect(
            host="localhost",
            user="some_user",
            passwd="some_passwd",
            database="shopify_assessment"
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('./sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # print(f'result: {result}')

        # Define expected outcome for Task 1 and compare
        expected_result = [
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.0, 8),
            (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.0, 8)
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('./sql/task2.sql', 'r') as file:
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