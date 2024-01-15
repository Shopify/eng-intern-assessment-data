import unittest
import psycopg2  # Replace with appropriate database connector based on your database

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='technicalassessment',
            user='newuser',
            password='123',
            host='localhost',
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
            (29, 'elliecollins', 1), (4, 'robertbrown', 1), (10, 'davidmartinez', 1), (9, 'emilythompson', 1), (7, 'lisawilliams', 1), (15, 'sophiawalker', 1), (6, 'michaellee', 1), (26, 'benjamincarter', 1), (12, 'jasonrodriguez', 1), (24, 'jamesrogers', 1), (19, 'emilygonzalez', 1), (25, 'emilyward', 1), (30, 'williamwood', 1), (21, 'sophiawright', 1), (14, 'matthewthomas', 1), (3, 'maryjones', 1), (17, 'olivialopez', 1), (28, 'danielturner', 1), (22, 'alexanderhill', 1), (20, 'williamhernandez', 1), (13, 'ashleytaylor', 1), (1, 'johndoe', 1), (5, 'sarahwilson', 1), (18, 'ethanmiller', 1), (2, 'janesmith', 1), (16, 'jacobanderson', 1), (27, 'gracestewart', 1), (23, 'madisonmoore', 1), (11, 'amandajohnson', 1), (8, 'chrisharris', 1),
            #('Mountain Bike')
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    # def test_task2(self):
    #     # Task 2: Example SQL query in task2.sql
    #     with open('./sql/task2.sql', 'r') as file:
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