import unittest
import mysql.connector

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            host='localhost',
            user='root',
            password='password',
            database='dbname',
            auth_plugin='mysql_native_password'
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

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
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

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('./sql/task3.sql', 'r') as file:
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