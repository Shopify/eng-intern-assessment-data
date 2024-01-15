import unittest
# import psycopg2 
import mysql.connector

class TestSQLQueries(unittest.TestCase):
    def setUp(self):
        # Establish a connection to shopify local database
        self.conn =  mysql.connector.connect(
            database='shopify_test',
            user='sam-admin',
            passwd='14121822sS@',
            host='127.0.0.1',
            port='3306'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    # Tests task 1
    def test_task1(self):
        with open('/sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    # Tests task 2
    def test_task2(self):
        with open('/sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")
    
    # Tests task 3
    def test_task3(self):
        with open('/sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()