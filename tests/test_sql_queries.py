import unittest
import sqlite3
from create_database import create_db

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Create a test database
        db_name = 'shopify_db'
        csv_table_mapping = {
            'data/cart_data.csv': 'Cart',
            'data/cart_item_data.csv': 'Cart_Items',
            'data/category_data.csv': 'Categories',
            'data/order_data.csv': 'Orders',
            'data/order_items_data.csv': 'Order_Items',
            'data/product_data.csv': 'Products',
            'data/payment_data.csv': 'Payments',
            'data/review_data.csv': 'Reviews',
            'data/shipping_data.csv': 'Shipping',
            'data/user_data.csv': 'Users'
        }
        create_db(db_name, csv_table_mapping)

        # Establish a connection to the test database
        self.conn = sqlite3.connect('shopify_db')
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()
    
    def execute_indiv_queries(self, task_file_path):
        # Read queries in task
        with open(task_file_path, 'r') as file:
            # Use ; to separate queries. Remove last element, which is empty
            sql_queries = file.read().split(';')[:-1]

        # Execute each query separately and record output to list
        results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            result = self.cur.fetchall()
            results.append(result)

        return results

    def test_task1(self):
        # SQL query results from task1.sql
        result = self.execute_indiv_queries('sql/task1.sql')

        # Define expected results for task1.sql
        expected_result = [
            [(15, 'Mountain Bike'), (16, 'Tennis Racket')],

            [(1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1), 
             (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1), 
             (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), 
             (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), 
             (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1), 
             (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)],

            [(1, 'Smartphone X', 5.0), (2, 'Wireless Headphones', 4.0), (3, 'Laptop Pro', 3.0), (4, 'Smart TV', 5.0),
             (5, 'Running Shoes', 2.0), (6, 'Designer Dress', 4.0), (7, 'Coffee Maker', 5.0), (8, 'Toaster Oven', 3.0),
             (9, 'Action Camera', 4.0), (10, 'Board Game Collection', 1.0), (11, 'Yoga Mat', 5.0), (12, 'Skincare Set', 4.0),
             (13, 'Vitamin C Supplement', 2.0), (14, 'Weighted Blanket', 3.0), (15, 'Mountain Bike', 5.0), (16, 'Tennis Racket', 4.0)],

            [(12, 'jasonrodriguez', 160.0), (4, 'robertbrown', 155.0), (8, 'chrisharris', 150.0), (24, 'jamesrogers', 150.0), (17, 'olivialopez', 145.0)]
        ]

        # Compare real and expected results
        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # SQL query results from task2.sql
        result = self.execute_indiv_queries('sql/task2.sql')

        # Define expected results for task2.sql
        expected_result = [
            [(1, 'Smartphone X', 5), (4, 'Smart TV', 5), (7, 'Coffee Maker', 5), (11, 'Yoga Mat', 5), (15, 'Mountain Bike', 5)],

            [],

            [],

            []
        ]

        # Compare real and expected results
        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        # SQL query results from task3.sql
        result = self.execute_indiv_queries('sql/task3.sql')

        # Define expected results for task3.sql
        expected_result = [
            [(8, 'Sports & Outdoors', 155.0), (4, 'Home & Kitchen', 145.0), (1, 'Electronics', 125.0)],

            [(5, 'sarahwilson')],

            [(1, 'Smartphone X', 1, 500.0), (3, 'Laptop Pro', 2, 1200.0), (6, 'Designer Dress', 3, 300.0),(7, 'Coffee Maker', 4, 80.0), 
             (9, 'Action Camera', 5, 200.0), (12, 'Skincare Set', 6, 150.0), (14, 'Weighted Blanket', 7, 100.0), (15, 'Mountain Bike', 8, 1000.0)],

            []
        ]

        # Compare real and expected results
        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()