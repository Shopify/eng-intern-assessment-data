import unittest
import pandas as pd
import sys
from pathlib import Path
sys.path.append(str((Path(__file__).parent).parent))
from create_and_populate_database import DatabaseSetup

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        db_set = DatabaseSetup()
        db_set.databaseConnection()
        self.conn, self.cur = db_set.conn, db_set.cur
        
    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def get_queries(self, path):
        '''
            Method fetches queries to check
            ---
            Params:
                path (str): Path to a file with queries
            
            Returns:
                sep_queries (list): List of queries
        '''
        with open(path, 'r') as file:
            sql_query = file.read()
        
        sep_queries = sql_query.split('\n\n')

        return sep_queries[:4]

    def get_result_for_all_problems_in_task(self, queries_to_check, task_n):
        '''
            Method iterate through queries for all problems in a task and compares results with expected results
            ---
            Params:
                queries_to_check (list): list of queries to check
                task_n (int): task number
            
            Returns:
                task_result (bool): Method returns True or False
                    True - if all results matches expected results in the task;
                    False - otherwise
        '''
        task_result = True
        
        add = 1                         # Because iterator starts from 0
        if task_n==2:
            add=5                       # Problems starts from 5. for task 2
        elif task_n==3:
            add=9                       # Problems starts from 9. for task 3
        
        for iter in range(len(queries_to_check)):
            print(f"\n---------------------------------------------------------------------- \
                  \nTASK {task_n}. PROBLEM {iter+add}")
            result = pd.read_sql_query(queries_to_check[iter], self.conn)
            path = 'results/problem'+str(iter+add)
            expected_result = pd.read_csv(path)
            print(f'RESULT: \n {result}')
            print(f'\nEXPECTED RESULT: \n {expected_result}')
            print(f'\nActual and expected are equal: {expected_result.equals(result)}')
            task_result&=expected_result.equals(result)
        
        return task_result

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        queries_task1 = self.get_queries(path = 'sql/task1.sql')
        task1_result = self.get_result_for_all_problems_in_task(queries_to_check = queries_task1, task_n = 1)

        # Final check
        self.assertEqual(True,task1_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        queries_task2 = self.get_queries(path = 'sql/task2.sql')
        task2_result = self.get_result_for_all_problems_in_task(queries_to_check = queries_task2, task_n = 2)

        # Final check
        self.assertEqual(True,task2_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        queries_task3 = self.get_queries(path = 'sql/task3.sql')
        task3_result = self.get_result_for_all_problems_in_task(queries_to_check = queries_task3, task_n = 3)

        # Final check
        self.assertEqual(True,task3_result, "Task 3: Query output doesn't match expected result.")

if __name__ == '__main__':
    db_set = DatabaseSetup()
    db_set.databaseConnection()
    db_set.createTables()
    db_set.populateData()
    unittest.main()
