import unittest
import sqlite3

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        try:
            self.conn = sqlite3.connect('data.db')
        except Exception as e:
            print(f"Error connecting to database: {e}")
            print("Make sure you have run load_data.py to create the database, and are running this script from the top level.")
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        print("Running Task 1...")
        # Task 1: Example SQL query in task1.sql
        with open('sql/task1.sql', 'r') as file:
            task_queries = file.read()

        # Split the SQL queries into individual queries from the file
        sql_queries = [f"{task};"for task in task_queries.split(';')][:-1]

        # Execute each query and store the results
        actual_results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            actual_results.append(self.cur.fetchall())

        # Define expected outcome for Task 1 and compare
        expected_results = [
            [
                (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000, 8, 8, 'Sports & Outdoors'), (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54, 8, 8, 'Sports & Outdoors'),
            ],
            [
                (1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1), (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1), (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 2), (30, 'williamwood', 0)
            ],
            [
                (1, 'Smartphone X', 3.0), (2, 'Wireless Headphones', 2.0), (3, 'Laptop Pro', None), (4, 'Smart TV', None), (5, 'Running Shoes', None), (6, 'Designer Dress', None), (7, 'Coffee Maker', None), (8, 'Toaster Oven', None), (9, 'Action Camera', None), (10, 'Board Game Collection', None), (11, 'Yoga Mat', None), (12, 'Skincare Set', None), (13, 'Vitamin C Supplement', None), (14, 'Weighted Blanket', None), (15, 'Mountain Bike', None), (16, 'Tennis Racket', None)
            ],
            [
                (29, 'elliecollins', 290), (12, 'jasonrodriguez', 160), (4, 'robertbrown', 155), (8, 'chrisharris', 150), (24, 'jamesrogers', 150)
            ],
        ]

        for i in range(max(len(actual_results), len(expected_results))):
            actual = ""
            if i < len(actual_results):
                actual = actual_results[i]
            expected = ""
            if i < len(expected_results):
                expected = expected_results[i]

            print(f"Actual: {actual}")
            print("--")
            print(f"Expected: {expected}")
            print("------")

        print("Finished running Task 1!")
        self.assertEqual(actual_results, expected_results, "Task 1: Query output doesn't match expected result.")
        print()

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('sql/task2.sql', 'r') as file:
            task_queries = file.read()

        # Split the SQL queries into individual queries from the file
        sql_queries = [f"{task};"for task in task_queries.split(';')][:-1]

        # Execute each query and store the results
        actual_results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            actual_results.append(self.cur.fetchall())

        # Define expected outcome for Task 1 and compare
        expected_results = [
        ]

        for i in range(max(len(actual_results), len(expected_results))):
            actual = ""
            if i < len(actual_results):
                actual = actual_results[i]
            expected = ""
            if i < len(expected_results):
                expected = expected_results[i]

            print(f"Actual: {actual}")
            print("--")
            print(f"Expected: {expected}")
            print("------")
        self.assertEqual(actual_results, expected_results, "Task 1: Query output doesn't match expected result.")

    

if __name__ == '__main__':
    unittest.main()