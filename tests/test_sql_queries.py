import unittest
import sqlite3

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your SQLite database
        self.conn = sqlite3.connect('shopify_data.db')  # Replace with the path to your SQLite database file
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def execute_and_test_query(self, path, query_number, expected_result):
        # Task: Example SQL query in task1.sql
        with open(path, 'r') as file:  # Adjust the path as necessary
            sql_query = file.read()
        
        sql_query = sql_query.split(';')[query_number-1]
        
        self.cur.execute(sql_query)
        result = self.cur.fetchall()
        
        self.assertEqual(result, expected_result, f"{path}.{query_number}: Query output doesn't match expected result.")
 
    
    def test_task1(self):
       self.execute_and_test_query('sql/task1.sql', 1, [(15, 'Mountain Bike'), (16, 'Tennis Racket')])
       
       self.execute_and_test_query('sql/task1.sql', 2, [(1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), 
        (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1),
        (9, 'emilythompson', 1), (10, 'davidmartinez', 1), (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1),
        (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), (16, 'jacobanderson', 1),
        (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1),
        (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1),
        (25, 'emilyward', 1), (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1),
        (29, 'elliecollins', 1), (30, 'williamwood', 1)])
       
       self.execute_and_test_query('sql/task1.sql', 3, [(1, 'Smartphone X', 5.0), (2, 'Wireless Headphones', 4.0), (3, "Laptop Pro", 3.0), (4, 'Smart TV', 5.0), (5, 'Running Shoes', 2.0), (6, 'Designer Dress', 4.0), (7, 'Coffee Maker', 5.0), (8, 'Toaster Oven', 3.0), (9, 'Action Camera', 4.0), (10, 'Board Game Collection', 1.0), (11, 'Yoga Mat', 5.0), (12, 'Skincare Set', 4.0), (13, 'Vitamin C Supplement', 2.0), (14, 'Weighted Blanket', 3.0), (15, 'Mountain Bike', 5.0), (16, 'Tennis Racket', 4.0)])
       
       self.execute_and_test_query('sql/task1.sql', 4, [(12, 'jasonrodriguez', 160.0), (4, 'robertbrown', 155.0), (8, 'chrisharris', 150.0), (24, 'jamesrogers', 150.0), (17, 'olivialopez', 145.0)])
        


    # def test_task2(self):
    #     # Task 2: Example SQL query in task2.sql
    #     with open('sql/task2.sql', 'r') as file:  # Adjust the path as necessary
    #         all_sql_queries = file.read()

    #     # Execute the query and fetch all results
    #     sql_queries = all_sql_queries.split(';')
        
    #     result = []
        
    #     for sql_query in sql_queries:
    #         self.cur.execute(sql_query)
    #         r = self.cur.fetchall()
    #         result.append(r)
            
    #     # Define expected outcome for Task 2 and compare
    #     expected_result = [
    #         # Define expected rows or values here based on the query output
    #     ]

    #     self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()
