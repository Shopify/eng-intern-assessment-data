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

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('/sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('/sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()