import unittest
import sqlite3
import psycopg2  # Replace with appropriate database connector based on your database

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = sqlite3.connect(database='database.db')
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    # Change the typical | separated outputs from sql into comma separated tuples
    def sql_to_tuples(self, output):
        values = output.split('|')
        output_tuple = tuple(values)
        print(output_tuple)
        return output_tuple
    
    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('sql/task1.sql', 'r') as file:
            sql_queries = file.read().split(';')[:-1]

        results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            results.append(self.cur.fetchall())

        print(*results, sep='\n')
        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
            [(1, 'Smartphone X', 'The Smartphone X is a powerful and feature-rich device that offers a seamless user experience. It comes with a high-resolution display', 500, 1, 1, 'Electronics'),
             (2, 'Wireless Headphones', 'Experience the freedom of wireless audio with these high-quality headphones. They offer crystal-clear sound and a comfortable fit', 150, 1, 1, 'Electronics')
            ],
            [
                (1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1), 
                (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1), 
                (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), 
                (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), 
                (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1), 
                (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)
            ],
            [
                (1, 'Smartphone X', 5.0),
                (2, 'Wireless Headphones', 4.0),
                (3, 'Laptop Pro', 3.0),
                (4, 'Smart TV', 5.0),
                (5, 'Running Shoes', 2.0),
                (6, 'Designer Dress', 4.0),
                (7, 'Coffee Maker', 5.0),
                (8, 'Toaster Oven', 3.0),
                (9, 'Action Camera', 4.0),
                (10, 'Board Game Collection', 1.0),
                (11, 'Yoga Mat', 5.0),
                (12, 'Skincare Set', 4.0),
                (13, 'Vitamin C Supplement', 2.0),
                (14, 'Weighted Blanket', 3.0),
                (15, 'Mountain Bike', 5.0),
                (16, 'Tennis Racket', 4.0)
            ],
            [(12, 'jasonrodriguez', 160), (4, 'robertbrown', 155), (24, 'jamesrogers', 150), (8, 'chrisharris', 150), (29, 'elliecollins', 145)]
        ]

        self.assertEqual(results, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('sql/task2.sql', 'r') as file:
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