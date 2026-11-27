import unittest
import psycopg2  # Replace with appropriate database connector based on your database
from config import DB_CONFIG

class TestSQLQueries(unittest.TestCase):

    def read_sql_file(self, filepath):
        with open(filepath, 'r') as file:
            file_content = file.read()

        # split content by delimiter ':'
        queries = file_content.split(':')
        return queries[1:] #ignore first split

    def setUp(self):
        # Establish a connection to your test database

        # using config.py
        # self.conn = psycopg2.connect(
        #     dbname='your_dbname',
        #     user='your_username',
        #     password='your_password',
        #     host='your_host',
        #     port='your_port'
        # )

        self.conn = psycopg2.connect(**DB_CONFIG)
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    # Task 1, problem 1
    def test_task1_prob1(self):
        quries = self.read_sql_file('sql/task1.sql')
        query1 = quries[0]

        self.cur.execute(query1)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 problem 1 and compare
        expected_result = [
            ('Smartphone X',),
            ('Wireless Headphones',)
        ]

        self.assertEqual(result, expected_result, "Task 1, problem 1: Query output doesn't match expected result.")
    
    # Task 1, problem 2
    def test_task1_prob2(self):
        quries = self.read_sql_file('sql/task1.sql')
        query2 = quries[1]

        self.cur.execute(query2)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 problem 2 and compare
        expected_result = [
            (1, "johndoe", 1),
            (2, "janesmith", 1),
            (3, "maryjones", 1),
            (4, "robertbrown", 1),
            (5, "sarahwilson", 1),
            (6, "michaellee", 1),
            (7, "lisawilliams", 1),
            (8, "chrisharris", 1),
            (9, "emilythompson", 1),
            (10, "davidmartinez", 1),
            (11, "amandajohnson", 1),
            (12, "jasonrodriguez", 1),
            (13, "ashleytaylor", 1),
            (14, "matthewthomas", 1),
            (15, "sophiawalker", 1),
            (16, "jacobanderson", 1),
            (17, "olivialopez", 1),
            (18, "ethanmiller", 1),
            (19, "emilygonzalez", 1),
            (20, "williamhernandez", 1),
            (21, "sophiawright", 1),
            (22, "alexanderhill", 1),
            (23, "madisonmoore", 1),
            (24, "jamesrogers", 1),
            (25, "emilyward", 1),
            (26, "benjamincarter", 1),
            (27, "gracestewart", 1),
            (28, "danielturner", 1),
            (29, "elliecollins", 1),
            (30, "williamwood", 1)
        ]
        self.assertEqual(result, expected_result, "Task 1, problem 2: Query output doesn't match expected result.")
    
    # Task 1, problem 3
    def test_task1_prob3(self):
        quries = self.read_sql_file('sql/task1.sql')
        query3 = quries[2]

        self.cur.execute(query3)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 problem 3 and compare
        expected_result = [
            (1, "Smartphone X", 5.0),
            (4, "Smart TV", 5.0),
            (7, "Coffee Maker", 5.0),
            (11, "Yoga Mat", 5.0),
            (15, "Mountain Bike", 5.0),
            (2, "Wireless Headphones", 4.0),
            (6, "Designer Dress", 4.0),
            (9, "Action Camera", 4.0),
            (12, "Skincare Set", 4.0),
            (16, "Tennis Racket", 4.0),
            (3, "Laptop Pro", 3.0),
            (8, "Toaster Oven", 3.0),
            (14, "Weighted Blanket", 3.0),
            (17, "Honda Civic Tire", 3.0),
            (5, "Running Shoes", 2.0),
            (13, "Vitamin C Supplement", 2.0),
            (10, "Board Game Collection", 1.0)
        ]

        self.assertEqual(result, expected_result, "Task 1, problem 3: Query output doesn't match expected result.")

        # Task 1, problem 4
    def test_task1_prob4(self):
        quries = self.read_sql_file('sql/task1.sql')
        query4 = quries[3]

        self.cur.execute(query4)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 problem 4 and compare
        expected_result = [
            (12, "jasonrodriguez", 160.00),
            (4, "robertbrown", 155.00),
            (8, "chrisharris", 150.00),
            (24, "jamesrogers", 150.00),
            (29, "elliecollins", 145.00)
        ]

        self.assertEqual(result, expected_result, "Task 1, problem 4: Query output doesn't match expected result.")

    # Task 2, problem 1
    def test_task2_prob1(self):
        quries = self.read_sql_file('sql/task2.sql')
        query1 = quries[0]

        self.cur.execute(query1)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 problem 1 and compare
        expected_result = [
            (1, "Smartphone X", 5.0),
            (4, "Smart TV", 5.0),
            (7, "Coffee Maker", 5.0),
            (11, "Yoga Mat", 5.0),
            (15, "Mountain Bike", 5.0)
        ]

        self.assertEqual(result, expected_result, "Task 2, problem 1: Query output doesn't match expected result.")

    # Task 2, problem 2
    def test_task2_prob2(self):
        quries = self.read_sql_file('sql/task2.sql')
        query2 = quries[1]

        self.cur.execute(query2)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 problem 2 and compare
        expected_result = []

        self.assertEqual(result, expected_result, "Task 2, problem 2: Query output doesn't match expected result.")

    # Task 2, problem 3
    def test_task2_prob3(self):
        quries = self.read_sql_file('sql/task2.sql')
        query3 = quries[2]

        self.cur.execute(query3)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 problem 3 and compare
        expected_result = []

        self.assertEqual(result, expected_result, "Task 2, problem 3: Query output doesn't match expected result.")
    
    # Task 2, problem 4
    def test_task2_prob4(self):
        quries = self.read_sql_file('sql/task2.sql')
        query4 = quries[3]

        self.cur.execute(query4)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 problem 4 and compare
        expected_result = []

        self.assertEqual(result, expected_result, "Task 2, problem 4: Query output doesn't match expected result.")
    
    # Task 3, problem 1
    def test_task3_prob1(self):
        quries = self.read_sql_file('sql/task3.sql')
        query1 = quries[0]

        self.cur.execute(query1)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 problem 1 and compare
        expected_result = [
            (8, "Sports & Outdoors", 155.00),
            (4, "Home & Kitchen", 145.00),
            (1, "Electronics", 125.00)
        ]

        self.assertEqual(result, expected_result, "Task 3, problem 1: Query output doesn't match expected result.")
    
    # Task 3, problem 2
    def test_task3_prob2(self):
        quries = self.read_sql_file('sql/task3.sql')
        query2 = quries[1]

        self.cur.execute(query2)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 problem 2 and compare
        expected_result = [(5,	"sarahwilson")]

        self.assertEqual(result, expected_result, "Task 3, problem 2: Query output doesn't match expected result.")

    # Task 3, problem 3
    def test_task3_prob3(self):
        quries = self.read_sql_file('sql/task3.sql')
        query3 = quries[2]

        self.cur.execute(query3)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 problem 3 and compare
        expected_result = [
            (1, "Smartphone X", 1, 500.00),
            (3, "Laptop Pro", 2, 1200.00),
            (6, "Designer Dress", 3, 300.00),
            (7, "Coffee Maker", 4, 80.00),
            (9, "Action Camera", 5, 200.00),
            (12, "Skincare Set", 6, 150.00),
            (14, "Weighted Blanket", 7, 100.00),
            (15, "Mountain Bike", 8, 1000.00),
            (17, "Honda Civic Tire", 9, 300.00)
        ]


        self.assertEqual(result, expected_result, "Task 3, problem 3: Query output doesn't match expected result.")

    # Task 3, problem 4
    def test_task3_prob4(self):
        quries = self.read_sql_file('sql/task3.sql')
        query4 = quries[3]

        self.cur.execute(query4)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 problem 4 and compare
        expected_result = []

        self.assertEqual(result, expected_result, "Task 3, problem 4: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()