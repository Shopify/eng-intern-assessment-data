import unittest
import psycopg2  # Replace with appropriate database connector based on your database
import os

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='your_dbname',
            user='your_username',
            password='your_password',
            host='your_host',
            port='your_port'
        )
        self.cur = self.conn.cursor()
        

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(dir_path, '../sql/task1.sql')

        with open(file_path, 'r') as file:
            # Read the SQL querys from the file
            sql_queries = file.read().split(';')

        # clean up querys 
        for query in sql_queries:
            query = query.strip()
            if not query:
                sql_queries.remove(query)


        expected_result = [
            [
                # problem 1 expected
            ],
            [ 
                # problem 2 expected
            ],
            [
                # problem 3 expected
            ],
            [
                # problem 4 expected
            ]
        ]

        for i, query in enumerate(sql_queries):
            if query:
                self.cur.execute(query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_result[i], f"Task 1: Query for problem {i+1} doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(dir_path, '../sql/task2.sql')

        with open(file_path, 'r') as file:
            # Read the SQL querys from the file
            sql_queries = file.read().split(';')

        # clean up querys 
        for query in sql_queries:
            query = query.strip()
            if not query:
                sql_queries.remove(query)


        expected_result = [
            [
                # problem 5 expected
            ],
            [ 
                # problem 6 expected
            ],
            [
                # problem 7 expected
            ],
            [
                # problem 8 expected
            ]
        ]

        for i, query in enumerate(sql_queries):
            if query:
                self.cur.execute(query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_result[i], f"Task 2: Query for problem {i+5} doesn't match expected result.")

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        dir_path = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(dir_path, '../sql/task3.sql')

        with open(file_path, 'r') as file:
            # Read the SQL querys from the file
            sql_queries = file.read().split(';')

        # clean up querys 
        for query in sql_queries:
            query = query.strip()
            if not query:
                sql_queries.remove(query)


        expected_result = [
            [
                # problem 9 expected
            ],
            [ 
                # problem 10 expected
            ],
            [
                # problem 11 expected
            ],
            [
                # problem 12 expected
            ]
        ]

        for i, query in enumerate(sql_queries):
            if query:
                self.cur.execute(query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_result[i], f"Task 3: Query for problem {i+9} doesn't match expected result.")
                
if __name__ == '__main__':
    unittest.main()