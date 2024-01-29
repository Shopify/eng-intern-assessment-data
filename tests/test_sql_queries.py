# Importing module 
import unittest
import mysql.connector
from decimal import Decimal

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            database='shopify',
            user='root',
            password='12345',
            host='localhost',
            port='3306',
        )
        self.cur = self.conn.cursor()  
 
    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('sql/task1.sql', 'r') as file:
            sql_queries = file.read().split(';')

            all_results = []  # List to store results of all queries

        for query in sql_queries:
            if query.strip():  # Ignore empty queries
                self.cur.execute(query)
                result = self.cur.fetchall()
                all_results.append(result)  # Store the result in the list

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
            [(15, "Mountain Bike"), (16, "Tennis Racket")],
            [(1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1), (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1), (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)],            
            [(1, 'Smartphone X', Decimal('5.0000')), (2, 'Wireless Headphones', Decimal('4.0000')), (3, 'Laptop Pro', Decimal('3.0000')), (4, 'Smart TV', Decimal('5.0000')), (5, 'Running Shoes', Decimal('2.0000')), (6, 'Designer Dress', Decimal('4.0000')), (7, 'Coffee Maker', Decimal('5.0000')), (8, 'Toaster Oven', Decimal('3.0000')), (9, 'Action Camera', Decimal('4.0000')), (10, 'Board Game Collection', Decimal('1.0000')), (11, 'Yoga Mat', Decimal('5.0000')), (12, 'Skincare Set', Decimal('4.0000')), (13, 'Vitamin C Supplement', Decimal('2.0000')), (14, 'Weighted Blanket', Decimal('3.0000')), (15, 'Mountain Bike', Decimal('5.0000')), (16, 'Tennis Racket', Decimal('4.0000'))], 
            [(12, 'jasonrodriguez', Decimal('160.00')), (4, 'robertbrown', Decimal('155.00')), (24, 'jamesrogers', Decimal('150.00')), (8, 'chrisharris', Decimal('150.00')), (17, 'olivialopez', Decimal('145.00'))]]
        
        self.assertEqual(all_results, expected_result, "Task 1: Query output doesn't match expected result.")
        
        
    def test_task2(self):
        # Task 1: Example SQL query in task1.sql
        with open('sql/task2.sql', 'r') as file:
            sql_queries = file.read().split(';')

            all_results = []  # List to store results of all queries

        for query in sql_queries:
            if query.strip():  # Ignore empty queries
                self.cur.execute(query)
                result = self.cur.fetchall()
                all_results.append(result)  # Store the result in the list
                
        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
            [(1, 'Smartphone X', Decimal('5.0000')), (4, 'Smart TV', Decimal('5.0000')), (7, 'Coffee Maker', Decimal('5.0000')), (11, 'Yoga Mat', Decimal('5.0000')), (15, 'Mountain Bike', Decimal('5.0000'))], 
            [], 
            [], 
            []
            ]
        
        self.assertEqual(all_results, expected_result, "Task 2: Query output doesn't match expected result.")
        
        
    def test_task3(self):
        # Task 1: Example SQL query in task1.sql
        with open('sql/task3.sql', 'r') as file:
            sql_queries = file.read().split(';')

            all_results = []  # List to store results of all queries

        for query in sql_queries:
            if query.strip():  # Ignore empty queries
                self.cur.execute(query)
                result = self.cur.fetchall()
                all_results.append(result)  # Store the result in the list
                
        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
            [(8, 'Sports & Outdoors', Decimal('155.00')), (4, 'Home & Kitchen', Decimal('145.00')), (1, 'Electronics', Decimal('125.00'))], 
            [(5, 'sarahwilson')], 
            [(1, 'Smartphone X', 1, Decimal('500.00')), (3, 'Laptop Pro', 2, Decimal('1200.00')), (6, 'Designer Dress', 3, Decimal('300.00')), (7, 'Coffee Maker', 4, Decimal('80.00')), (9, 'Action Camera', 5, Decimal('200.00')), (12, 'Skincare Set', 6, Decimal('150.00')), (14, 'Weighted Blanket', 7, Decimal('100.00')), (15, 'Mountain Bike', 8, Decimal('1000.00'))], 
            []

            ]
        
        self.assertEqual(all_results, expected_result, "Task 2: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()