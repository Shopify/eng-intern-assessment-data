import unittest
import psycopg2 # Replace with appropriate database connector based on your database

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


    def test_task1(self):
        self.read_schema()
        # Task 1: Example SQL query in task1.sql
        with open('sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        self.read_schema()
        # Task 2: Example SQL query in task2.sql
        with open('sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")
    
    def test_task3(self):
        self.read_schema()
        # Task 1: Example SQL query in task1.sql
        with open('sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()