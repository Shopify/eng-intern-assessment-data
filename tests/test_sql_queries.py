import csv
import os
import unittest
import sqlite3

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Create and connect to in-memory sqlite3 test database
        self.conn = sqlite3.connect(':memory:')
        self.cur = self.conn.cursor()

        # Create tables in the test database
        with open('./sql/schema.sql', 'r') as file:
            sql_query = file.read()
        self.cur.executescript(sql_query)

        # Using order of directory listing to determine table names
        TABLE_NAMES = ['Cart', 'Cart_Items', 'Categories', 'Orders', 'Order_Items', 
                    'Payments', 'Products', 'Reviews', 'Shipping','Users']

        # Load test data from csv files, excluding data.csv which doesn't have corresponding sql table
        csv_files = sorted([file for file in os.listdir('./data/') if file.endswith("_data.csv")])
        for file, table in zip(csv_files, TABLE_NAMES):
            # Load the data, in csv mode, skipping the csv headers
            with open(os.path.join('./data/', file), 'r') as csv_file:
                csv_reader = csv.reader(csv_file)
                next(csv_reader)  # Skip the header
                for row in csv_reader:
                    vals = ', '.join(['?' for _ in row])
                    insert_query = f"INSERT INTO {table} VALUES ({vals})"
                    self.cur.execute(insert_query, row)  
        
        # Clear cursor and commit changes
        self.cur.fetchall()
        self.conn.commit()
        
    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        results = []

        # Get, execute, and store query results
        with open('./sql/task1.sql', 'r') as file:
            queries = file.read()

        # Split queries by semicolon and execute each query
        # Note: the last query is empty (from split), so we pop it off the list
        for query in queries.split(';'):
            self.cur.execute(query)
            tmp = self.cur.fetchall()
            results.append(tmp)
        results.pop()

        expected_result = [
            [
                # Task 1: Question 1
                (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.0), 
                (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.0)
            ],
            [
                # Task 1: Question 2
                (1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), 
                (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1), 
                (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), 
                (10, 'davidmartinez', 1), (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), 
                (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1),
                (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), 
                (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), (21, 'sophiawright', 1), 
                (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), 
                (25, 'emilyward', 1), (26, 'benjamincarter', 1), (27, 'gracestewart', 1), 
                (28, 'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)
            ],
            [
                # Task 1: Question 3
                (1, "Smartphone X", 5.0),
                (2, "Wireless Headphones", 4.0),
                (3, "Laptop Pro", 3.0),
                (4, "Smart TV", 5.0),
                (5, "Running Shoes", 2.0),
                (6, "Designer Dress", 4.0),
                (7, "Coffee Maker", 5.0),
                (8, "Toaster Oven", 3.0),
                (9, "Action Camera", 4.0),
                (10, "Board Game Collection", 1.0),
                (11, "Yoga Mat", 5.0),
                (12, "Skincare Set", 4.0),
                (13, "Vitamin C Supplement", 2.0),
                (14, "Weighted Blanket", 3.0),
                (15, "Mountain Bike", 5.0),
                (16, "Tennis Racket", 4.0),
            ],
            [
                # Task 1: Question 4
                (12, "jasonrodriguez", 160.0),
                (4, "robertbrown", 155.0),
                (8, "chrisharris", 150.0),
                (24, "jamesrogers", 150.0),
                (17, "olivialopez", 145.0)
            ]
        ]
        self.assertEqual(results, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        results = []

        # Get, execute, and store query results
        with open('./sql/task2.sql', 'r') as file:
            queries = file.read()
        for query in queries.split(';'):
            self.cur.execute(query)
            tmp = self.cur.fetchall()
            results.append(tmp)
        results.pop() # Remove empty list at the end

        # Define expected outcome for Task 2 and compare
        expected_result = [
            [   
                # Task 2: Question 5
                (1, 'Smartphone X', 5.0), 
                (4, 'Smart TV', 5.0), 
                (7, 'Coffee Maker', 5.0), 
                (11, 'Yoga Mat', 5.0), 
                (15, 'Mountain Bike', 5.0)
            ],
            [
                # Task 2: Question 6
            ],
            [
                # Task 2: Question 7
            ],
            [
                # Task 2: Question 8
            ]
        ]
        self.assertEqual(results, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        results = []

        # Get, execute, and store query results
        with open('./sql/task3.sql', 'r') as file:
            queries = file.read()
        for query in queries.split(';'):
            self.cur.execute(query)
            tmp = self.cur.fetchall()
            results.append(tmp)
        results.pop()
        
        # Define expected outcome for Task 3 and compare
        expected_result = [
            [
                # Task 3: Question 9
                (8, 'Sports & Outdoors', 155), (4, 'Home & Kitchen', 145), (1, 'Electronics', 125)
            ],
            [
                # Task 3: Question 10
                (5, 'sarahwilson')
            ],
            [
                # Task 3: Question 11
                (1, 'Smartphone X', 1, 500), (3, 'Laptop Pro', 2, 1200), (6, 'Designer Dress', 3, 300), 
                (7, 'Coffee Maker', 4, 80), (9, 'Action Camera', 5, 200), (12, 'Skincare Set', 6, 150), 
                (14, 'Weighted Blanket', 7, 100), (15, 'Mountain Bike', 8, 1000)
            ],
            [
                # Task 3: Question 12
            ]
        ]
        self.assertEqual(results, expected_result, "Task 3: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()