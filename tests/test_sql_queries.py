import unittest
import mysql.connector # Replace with appropriate database connector based on your database
from decimal import Decimal
import os
from dotenv import load_dotenv

load_dotenv()


class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_NAME')
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('../sql/task1.sql', 'r') as file:
            sql_queries = file.read().split(';')[:-1]  # Split by ';' and remove the last empty element

        # self.cur.execute(sql_query)
        # result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_results = {
            0: [
                (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', Decimal('1000.00')),
                (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', Decimal('54.00'))
            ],
            1: [
                (1, 'johndoe', 1),
                (2, 'janesmith', 1),
                (3, 'maryjones', 1),
                (4, 'robertbrown', 1),
                (5, 'sarahwilson', 1),
                (6, 'michaellee', 1),
                (7, 'lisawilliams', 1),
                (8, 'chrisharris', 1),
                (9, 'emilythompson', 1),
                (10, 'davidmartinez', 1),
                (11, 'amandajohnson', 1),
                (12, 'jasonrodriguez', 1),
                (13, 'ashleytaylor', 1),
                (14, 'matthewthomas', 1),
                (15, 'sophiawalker', 1),
                (16, 'jacobanderson', 1),
                (17, 'olivialopez', 1),
                (18, 'ethanmiller', 1),
                (19, 'emilygonzalez', 1),
                (20, 'williamhernandez', 1),
                (21, 'sophiawright', 1),
                (22, 'alexanderhill', 1),
                (23, 'madisonmoore', 1),
                (24, 'jamesrogers', 1),
                (25, 'emilyward', 1),
                (26, 'benjamincarter', 1),
                (27, 'gracestewart', 1),
                (28, 'danielturner', 1),
                (29, 'elliecollins', 1),
                (30, 'williamwood', 1)
            ],
            2: [
                (1, 'Smartphone X', Decimal('5.0000')),
                (2, 'Wireless Headphones', Decimal('4.0000')),
                (3, 'Laptop Pro', Decimal('3.0000')),
                (4, 'Smart TV', Decimal('5.0000')),
                (5, 'Running Shoes', Decimal('2.0000')),
                (6, 'Designer Dress', Decimal('4.0000')),
                (7, 'Coffee Maker', Decimal('5.0000')),
                (8, 'Toaster Oven', Decimal('3.0000')),
                (9, 'Action Camera', Decimal('4.0000')),
                (10, 'Board Game Collection', Decimal('1.0000')),
                (11, 'Yoga Mat', Decimal('5.0000')),
                (12, 'Skincare Set', Decimal('4.0000')),
                (13, 'Vitamin C Supplement', Decimal('2.0000')),
                (14, 'Weighted Blanket', Decimal('3.0000')),
                (15, 'Mountain Bike', Decimal('5.0000')),
                (16, 'Tennis Racket', Decimal('4.0000')),
                (17, 'Product 17', Decimal('3.0000')),
                (18, 'Product 18', Decimal('5.0000')),
                (19, 'Product 19', Decimal('2.0000')),
                (20, 'Product 20', Decimal('4.0000')),
                (21, 'Product 21', Decimal('5.0000')),
                (22, 'Product 22', Decimal('3.0000')),
                (23, 'Product 23', Decimal('4.0000')),
                (24, 'Product 24', Decimal('1.0000')),
                (25, 'Product 25', Decimal('5.0000')),
                (26, 'Product 26', Decimal('4.0000')),
                (27, 'Product 27', Decimal('2.0000')),
                (28, 'Product 28', Decimal('3.0000')),
                (29, 'Product 29', Decimal('5.0000')),
                (30, 'Product 30', Decimal('4.0000')),
                (31, 'Product 31', None),
                (32, 'Product 32', None),
                (33, 'Product 33', None),
                (34, 'Product 34', None),
                (35, 'Product 35', None),
                (36, 'Product 36', None),
                (37, 'Product 37', None),
                (38, 'Product 38', None),
                (39, 'Product 39', None),
                (40, 'Product 40', None),
                (41, 'Product 41', None),
                (42, 'Product 42', None),
                (43, 'Product 43', None),
                (44, 'Product 44', None),
                (45, 'Product 45', None),
                (46, 'Product 46', None),
                (47, 'Product 47', None),
                (48, 'Product 48', None),
                (49, 'Product 49', None),
                (50, 'Product 50', None)
            ],
            3: [
                (12, 'jasonrodriguez', Decimal('160.000')),
                (4, 'robertbrown', Decimal('155.00')),
                (24, 'jamesrogers', Decimal('150.00')),
                (8, 'chrisharris', Decimal('150.00')),
                (17, 'olivialopez', Decimal('145.00')),
            ]
            
            # Define expected results for other queries similarly
        }

        # Execute and test each query
        for i, sql_query in enumerate(sql_queries):
            if sql_query.strip():  # Check if the query is not empty
                self.cur.execute(sql_query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_results.get(i, []), f"Task {i+1}: Query output doesn't match expected result.")

    def test_task2(self):
    # Task 2: Example SQL queries in task2.sql
        with open('../sql/task2.sql', 'r') as file:
            sql_queries = file.read().split(';')[:-1]  # Split by ';' and remove the last empty element

        # Define expected outcome for Task 2 and compare
        expected_results = {
            0: [
                (1, 'Smartphone X', Decimal('5.0000')),
                (4, 'Smart TV', Decimal('5.0000')),
                (7, 'Coffee Maker', Decimal('5.0000')),
                (11, 'Yoga Mat', Decimal('5.0000')),
                (15, 'Mountain Bike', Decimal('5.0000')),
                (18, 'Product 18', Decimal('5.0000')),
                (21, 'Product 21', Decimal('5.0000')),
                (25, 'Product 25', Decimal('5.0000')),
                (29, 'Product 29', Decimal('5.0000')),
            ],
            1: [
                # EMPTY
            ],
            2: [
                (31, 'Product 31'),
                (32, 'Product 32'),
                (33, 'Product 33'),
                (34, 'Product 34'),
                (35, 'Product 35'),
                (36, 'Product 36'),
                (37, 'Product 37'),
                (38, 'Product 38'),
                (39, 'Product 39'),
                (40, 'Product 40'),
                (41, 'Product 41'),
                (42, 'Product 42'),
                (43, 'Product 43'),
                (44, 'Product 44'),
                (45, 'Product 45'),
                (46, 'Product 46'),
                (47, 'Product 47'),
                (48, 'Product 48'),
                (49, 'Product 49'),
                (50, 'Product 50')
            ],
            3: [
                # EMPTY
            ]
            # Add more as needed for additional problems in task2.sql
        }

        # Execute and test each query
        for i, sql_query in enumerate(sql_queries):
            if sql_query.strip():  # Check if the query is not empty
                self.cur.execute(sql_query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_results.get(i, []), f"Task 2, Query {i+1}: Query output doesn't match expected result.")


    def test_task3(self):
        # Task 3: Example SQL queries in task3.sql
        with open('../sql/task3.sql', 'r') as file:
            sql_queries = file.read().split(';')[:-1]  # Split by ';' and remove the last empty element

        # Define expected outcome for Task 3 and compare
        expected_results = {
            0: [
                (8, 'Sports & Outdoors', Decimal('155.00')),
                (4, 'Home & Kitchen', Decimal('145.00')),
                (1, 'Electronics', Decimal('125.00')),
            ],
            1: [
                (5, 'sarahwilson')
            ],
            2: [
                (1, 'Smartphone X', 1, Decimal('500.00')),
                (3, 'Laptop Pro', 2, Decimal('1200.00')),
                (6, 'Designer Dress', 3, Decimal('300.00')),
                (7, 'Coffee Maker', 4, Decimal('80.00')),
                (9, 'Action Camera', 5, Decimal('200.00')),
                (12, 'Skincare Set', 6, Decimal('150.00')),
                (14, 'Weighted Blanket', 7, Decimal('100.00')),
                (15, 'Mountain Bike', 8, Decimal('1000.00')),
                (17, 'Product 17', 9, Decimal('39.72')),
                (18, 'Product 18', 10, Decimal('962.12')),
                (19, 'Product 19', 11, Decimal('287.34')),
                (20, 'Product 20', 12, Decimal('833.29')),
                (21, 'Product 21', 13, Decimal('828.37')),
                (22, 'Product 22', 14, Decimal('321.34')),
                (23, 'Product 23', 15, Decimal('924.24')),
                (24, 'Product 24', 16, Decimal('81.09')),
                (25, 'Product 25', 17, Decimal('394.50')),
                (26, 'Product 26', 18, Decimal('313.03')),
                (27, 'Product 27', 19, Decimal('181.19')),
                (28, 'Product 28', 20, Decimal('628.64')),
                (29, 'Product 29', 21, Decimal('693.93')),
                (30, 'Product 30', 22, Decimal('900.66')),
                (31, 'Product 31', 23, Decimal('912.92')),
                (32, 'Product 32', 24, Decimal('28.76')),
                (33, 'Product 33', 25, Decimal('226.54')),
                (34, 'Product 34', 26, Decimal('237.07')),
                (35, 'Product 35', 27, Decimal('490.67')),
                (36, 'Product 36', 28, Decimal('257.05')),
                (37, 'Product 37', 29, Decimal('751.31')),
                (38, 'Product 38', 30, Decimal('14.61')),
                (39, 'Product 39', 31, Decimal('534.62')),
                (40, 'Product 40', 32, Decimal('481.80')),
                (41, 'Product 41', 33, Decimal('366.50')),
                (42, 'Product 42', 34, Decimal('528.34')),
                (43, 'Product 43', 35, Decimal('790.88')),
                (44, 'Product 44', 36, Decimal('75.01')),
                (45, 'Product 45', 37, Decimal('734.62')),
                (46, 'Product 46', 38, Decimal('766.84')),
                (47, 'Product 47', 39, Decimal('564.81')),
                (48, 'Product 48', 40, Decimal('138.25')),
                (49, 'Product 49', 41, Decimal('925.08')),
                (50, 'Product 50', 42, Decimal('15.62'))
            ],
            3:[
                # EMPTY
            ],
        }

        # Execute and test each query
        for i, sql_query in enumerate(sql_queries):
            if sql_query.strip():  # Check if the query is not empty
                self.cur.execute(sql_query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_results.get(i, []), f"Task 3, Query {i+1}: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()