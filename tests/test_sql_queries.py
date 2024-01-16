import unittest
# import psycopg2 
import mysql.connector
import pandas as pd

class TestSQLQueries(unittest.TestCase):
    def setUp(self):
        # Establish a connection to shopify local database
        self.conn =  mysql.connector.connect(
            database='shopify_test2',
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
        task_num = 1
        with open(f'/sql/task{task_num}.sql', 'r') as file:
            sql_query = file.read()

        queries = self.sql_query_separator(sql_query)

        for i in range(len(queries)):
            self.cur.execute(queries[i])
            result = self.cur.fetchall()

            expected_result = self.expected_results(task_num=task_num, problem= i + 1)

            self.assertEqual(result, expected_result, f"Task {task_num} Problem {i + 1}: Query output doesn't match expected result.")
        
    # Tests task 2
    def test_task2(self):
        task_num = 2
        with open(f'/sql/task{task_num}.sql', 'r') as file:
            sql_query = file.read()

        queries = self.sql_query_separator(sql_query)

        for i in range(len(queries)):
            self.cur.execute(queries[i])
            result = self.cur.fetchall()

            expected_result = self.expected_results(task_num=task_num, problem= i + 1)

            self.assertEqual(result, expected_result, f"Task {task_num} Problem {i + 1}: Query output doesn't match expected result.")
    
    # Tests task 3
    def test_task3(self):
        task_num = 3
        with open(f'/sql/task{task_num}.sql', 'r') as file:
            sql_query = file.read()

        queries = self.sql_query_separator(sql_query)

        for i in range(len(queries)):
            self.cur.execute(queries[i])
            result = self.cur.fetchall()

            expected_result = self.expected_results(task_num=task_num, problem= i + 1)

            self.assertEqual(result, expected_result, f"Task {task_num} Problem {i + 1}: Query output doesn't match expected result.")
    

    def sql_query_separator(sql_query):
        lines = sql_query.split("\n")
        all_queries = []
        query = []
        for line in lines:
            query.append(line)
            if line.endswith(";"):
                all_queries.append("\n".join(query))
                query = []
        return all_queries
    
    def expected_results(task_num, problem):
        # Read CSV file into a pandas DataFrame, excluding the header
        data = pd.read_csv(f'./results/{problem}.csv', header=None)

        # Convert the DataFrame to the test readable format
        formatted_data = [tuple(row) for row in data.values]

        return formatted_data





if __name__ == '__main__':
    unittest.main()