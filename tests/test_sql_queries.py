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
                (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000, 8, 8, 'Sports & Outdoors'), (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54, 8, 8, 'Sports & Outdoors'), (24, 'FAKE', '', 0, 8, 8, 'Sports & Outdoors'),
            ],
            [
                (1, 'johndoe', 2), (2, 'janesmith', 5), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1), (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1), (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 2), (30, 'williamwood', 0)
            ],
            [
                (1, 'Smartphone X', 3.0), (2, 'Wireless Headphones', 4.0), (3, 'Laptop Pro', 3.0), (4, 'Smart TV', 5.0), (5, 'Running Shoes', 2.0), (6, 'Designer Dress', 4.0), (7, 'Coffee Maker', 5.0), (8, 'Toaster Oven', 3.0), (9, 'Action Camera', 4.0), (10, 'Board Game Collection', 1.0), (11, 'Yoga Mat', 5.0), (12, 'Skincare Set', 4.0), (13, 'Vitamin C Supplement', 2.0), (14, 'Weighted Blanket', 3.0), (15, 'Mountain Bike', 5.0), (16, 'Tennis Racket', 4.0), (17, 'FAKE', 3.0), (18, 'FAKE', 5.0), (19, 'FAKE', 2.0), (20, 'FAKE', 4.0), (21, 'FAKE', 5.0), (22, 'FAKE', 3.0), (23, 'FAKE', 4.0), (24, 'FAKE', 1.0), (25, 'FAKE', 5.0), (26, 'FAKE', 4.0), (27, 'FAKE', 2.0), (28, 'FAKE', 3.0), (29, 'FAKE', 3.0), (30, 'FAKE', None), (31, 'FAKE', None), (32, 'FAKE', None), (33, 'FAKE', None), (34, 'FAKE', None), (35, 'FAKE', None), (36, 'FAKE', None), (37, 'FAKE', None), (38, 'FAKE', None), (39, 'FAKE', None), (40, 'FAKE', None), (41, 'FAKE', None), (42, 'FAKE', None), (43, 'FAKE', None), (44, 'FAKE', None), (45, 'FAKE', None), (46, 'FAKE', None), (47, 'FAKE', None), (48, 'FAKE', None), (49, 'FAKE', None), (50, 'FAKE', None), (51, 'FAKE', None), (52, 'FAKE', None), (53, 'FAKE', None), (54, 'FAKE', None), (55, 'FAKE', None), (56, 'FAKE', None), (57, 'FAKE', None), (58, 'FAKE', None), (59, 'FAKE', None), (60, 'FAKE', None), (61, 'FAKE', None), (62, 'FAKE', None), (63, 'FAKE', None), (64, 'FAKE', None), (65, 'FAKE', None), (66, 'FAKE', None)
            ],
            [
                (29, 'elliecollins', 290), (1, 'johndoe', 200), (12, 'jasonrodriguez', 160), (4, 'robertbrown', 155), (2, 'janesmith', 150)
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
        print("Running Task 2...")
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

        # Define expected outcome for Task 2 and compare
        expected_results = [
            [
                (4, 'Smart TV', 5.0), (7, 'Coffee Maker', 5.0), (11, 'Yoga Mat', 5.0), (15, 'Mountain Bike', 5.0), (18, 'FAKE', 5.0), (21, 'FAKE', 5.0), (25, 'FAKE', 5.0), (2, 'Wireless Headphones', 4.0), (6, 'Designer Dress', 4.0), (9, 'Action Camera', 4.0), (12, 'Skincare Set', 4.0), (16, 'Tennis Racket', 4.0), (20, 'FAKE', 4.0), (23, 'FAKE', 4.0), (26, 'FAKE', 4.0), (1, 'Smartphone X', 3.0), (3, 'Laptop Pro', 3.0), (8, 'Toaster Oven', 3.0), (14, 'Weighted Blanket', 3.0), (17, 'FAKE', 3.0), (22, 'FAKE', 3.0), (28, 'FAKE', 3.0), (29, 'FAKE', 3.0), (5, 'Running Shoes', 2.0), (13, 'Vitamin C Supplement', 2.0), (19, 'FAKE', 2.0), (27, 'FAKE', 2.0), (10, 'Board Game Collection', 1.0), (24, 'FAKE', 1.0), (30, 'FAKE', None), (31, 'FAKE', None), (32, 'FAKE', None), (33, 'FAKE', None), (34, 'FAKE', None), (35, 'FAKE', None), (36, 'FAKE', None), (37, 'FAKE', None), (38, 'FAKE', None), (39, 'FAKE', None), (40, 'FAKE', None), (41, 'FAKE', None), (42, 'FAKE', None), (43, 'FAKE', None), (44, 'FAKE', None), (45, 'FAKE', None), (46, 'FAKE', None), (47, 'FAKE', None), (48, 'FAKE', None), (49, 'FAKE', None), (50, 'FAKE', None), (51, 'FAKE', None), (52, 'FAKE', None), (53, 'FAKE', None), (54, 'FAKE', None), (55, 'FAKE', None), (56, 'FAKE', None), (57, 'FAKE', None), (58, 'FAKE', None), (59, 'FAKE', None), (60, 'FAKE', None), (61, 'FAKE', None), (62, 'FAKE', None), (63, 'FAKE', None), (64, 'FAKE', None), (65, 'FAKE', None), (66, 'FAKE', None)
            ],
            [
                (1, 'johndoe')
            ],
            [
                (30, 'FAKE'), (31, 'FAKE'), (32, 'FAKE'), (33, 'FAKE'), (34, 'FAKE'), (35, 'FAKE'), (36, 'FAKE'), (37, 'FAKE'), (38, 'FAKE'), (39, 'FAKE'), (40, 'FAKE'), (41, 'FAKE'), (42, 'FAKE'), (43, 'FAKE'), (44, 'FAKE'), (45, 'FAKE'), (46, 'FAKE'), (47, 'FAKE'), (48, 'FAKE'), (49, 'FAKE'), (50, 'FAKE'), (51, 'FAKE'), (52, 'FAKE'), (53, 'FAKE'), (54, 'FAKE'), (55, 'FAKE'), (56, 'FAKE'), (57, 'FAKE'), (58, 'FAKE'), (59, 'FAKE'), (60, 'FAKE'), (61, 'FAKE'), (62, 'FAKE'), (63, 'FAKE'), (64, 'FAKE'), (65, 'FAKE'), (66, 'FAKE')
            ],
            [
                (1, 'johndoe'), (2, 'janesmith')
            ]
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
        self.assertEqual(actual_results, expected_results, "Task 2: Query output doesn't match expected result.")
        print("Finished running Task 2!")

    def test_task3(self):
        print("Running Task 3...")
        # Task 3: Example SQL query in task3.sql
        with open('sql/task3.sql', 'r') as file:
            task_queries = file.read()

        # Split the SQL queries into individual queries from the file
        sql_queries = [f"{task};"for task in task_queries.split(';')][:-1]

        # Execute each query and store the results
        actual_results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            actual_results.append(self.cur.fetchall())

        # Define expected outcome for Task 3 and compare
        expected_results = [
            # Add your expected results here
            [(8, 'Sports & Outdoors', 370), (4, 'Home & Kitchen', 340), (7, 'Health & Household', 310)],
            [(1, 'johndoe')],
            [(1, 'Smartphone X', 1, 500), (3, 'Laptop Pro', 2, 1200), (6, 'Designer Dress', 3, 300), (7, 'Coffee Maker', 4, 80), (9, 'Action Camera', 5, 200), (12, 'Skincare Set', 6, 150), (14, 'Weighted Blanket', 7, 100), (15, 'Mountain Bike', 8, 1000), (25, 'FAKE', 9, 0), (26, 'FAKE', 10, 0), (27, 'FAKE', 11, 0), (28, 'FAKE', 12, 0), (29, 'FAKE', 13, 0), (30, 'FAKE', 14, 0), (31, 'FAKE', 15, 0), (32, 'FAKE', 16, 0), (33, 'FAKE', 17, 0), (34, 'FAKE', 18, 0), (35, 'FAKE', 19, 0), (36, 'FAKE', 20, 0), (37, 'FAKE', 21, 0), (38, 'FAKE', 22, 0), (39, 'FAKE', 23, 0), (40, 'FAKE', 24, 0), (41, 'FAKE', 25, 0), (42, 'FAKE', 26, 0), (43, 'FAKE', 27, 0), (44, 'FAKE', 28, 0), (45, 'FAKE', 29, 0), (46, 'FAKE', 30, 0), (47, 'FAKE', 31, 0), (48, 'FAKE', 32, 0), (49, 'FAKE', 33, 0), (50, 'FAKE', 34, 0), (51, 'FAKE', 35, 0), (52, 'FAKE', 36, 0), (53, 'FAKE', 37, 0), (54, 'FAKE', 38, 0), (55, 'FAKE', 39, 0), (56, 'FAKE', 40, 0), (57, 'FAKE', 41, 0), (58, 'FAKE', 42, 0), (59, 'FAKE', 43, 0), (60, 'FAKE', 44, 0), (61, 'FAKE', 45, 0), (62, 'FAKE', 46, 0), (63, 'FAKE', 47, 0), (64, 'FAKE', 48, 0), (65, 'FAKE', 49, 0), (66, 'FAKE', 50, 0)],
            [(2, 'janesmith')],
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
        self.assertEqual(actual_results, expected_results, "Task 3: Query output doesn't match expected result.")
        print("Finished running Task 3!")

if __name__ == '__main__':
    unittest.main()