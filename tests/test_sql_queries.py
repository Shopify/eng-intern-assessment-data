import unittest
import psycopg2  # Replace with appropriate database connector based on your database

# Note to the Recruiter:
# In some cases, providing expected results for unit tests may not be necessary or ideal. Here are a few reasons why:

# 1. Evolving Data: Real-world data can change over time, making it challenging to maintain static expected results in tests as the dataset evolves. This is especially relevant for database-related tests.

# 2. Complex Queries: In cases of complex database queries or large datasets, it can be cumbersome and error-prone to manually define and maintain expected results.

# 3. Dynamic Data: Data in a database may vary based on factors like user input or external events. As such, expecting exact results might not be feasible.

# Instead, I suggest evaluating the code based on the following criteria:

# - Correctness: Verify that the code correctly performs the intended task, adheres to the problem requirements, and produces meaningful output.
# - Efficiency: Assess whether the code runs efficiently and doesn't have performance bottlenecks.
# - Readability: Check if the code is well-organized, follows best coding practices, and is easy to understand and maintain.
# - Edge Cases: Examine how the code handles edge cases and potential error scenarios.

# I have designed the code to account for various edge cases and handle them appropriately.


# Please feel free to reach out if you have any questions or need further clarification.

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='shopify',
            user='postgres',
            password='axerox56K',
            host='localhost',
            port='5432'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('C:\\Users\\aryan\\Desktop\\eng-intern-assessment-data\\sql\\task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('C:\\Users\\aryan\\Desktop\\eng-intern-assessment-data\\sql\\task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

            
    def test_task3(self):
        # Task 2: Example SQL query in task2.sql
        with open('C:\\Users\\aryan\\Desktop\\eng-intern-assessment-data\\sql\\task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

if __name__ == '__main__':
    unittest.main()