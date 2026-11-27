import unittest
import psycopg2  # Replace with appropriate database connector based on your database
from decimal import Decimal

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='technicalassessment',
            user='newuser',
            password='123',
            host='localhost',
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('./sql/task1.sql', 'r') as file:
            # last one is empty
            sql_query = file.read().split(';')[:-1]

        for i in range(len(sql_query)):
            self.cur.execute(sql_query[i])
            result = self.cur.fetchall()

            # Define expected outcome for Task 1 and compare
            expected_result = [
                # Define expected rows or values here based on the query output
                [('Mountain Bike',)],
                [(29, 'elliecollins', 1), (10, 'davidmartinez', 1), (9, 'emilythompson', 1), (7, 'lisawilliams', 1), (15, 'sophiawalker', 1), (6, 'michaellee', 1), (26, 'benjamincarter', 1), (12, 'jasonrodriguez', 1), (24, 'jamesrogers', 1), (19, 'emilygonzalez', 1), (25, 'emilyward', 1), (30, 'williamwood', 1), (21, 'sophiawright', 1), (14, 'matthewthomas', 1), (17, 'olivialopez', 1), (28, 'danielturner', 1), (22, 'alexanderhill', 1), (20, 'williamhernandez', 1), (13, 'ashleytaylor', 1), (1, 'johndoe', 4), (5, 'sarahwilson', 1), (18, 'ethanmiller', 1), (16, 'jacobanderson', 1), (27, 'gracestewart', 1), (23, 'madisonmoore', 1), (11, 'amandajohnson', 1), (8, 'chrisharris', 1)],
                [(22, 'Tennis Racket', Decimal('3.0000000000000000')), (11, 'Yoga Mat', Decimal('5.0000000000000000')), (9, 'Action Camera', Decimal('4.0000000000000000')), (15, 'Mountain Bike', Decimal('5.0000000000000000')), (26, 'Tennis Racket', Decimal('4.0000000000000000')), (19, 'Tennis Racket', Decimal('2.0000000000000000')), (30, 'Tennis Racket', Decimal('4.0000000000000000')), (21, 'Tennis Racket', Decimal('5.0000000000000000')), (3, 'Laptop Pro', Decimal('3.0000000000000000')), (17, 'Tennis Racket', Decimal('3.0000000000000000')), (28, 'Tennis Racket', Decimal('3.0000000000000000')), (5, 'Running Shoes', Decimal('2.0000000000000000')), (29, 'Tennis Racket', Decimal('5.0000000000000000')), (4, 'Smart TV', Decimal('5.0000000000000000')), (10, 'Board Game Collection', Decimal('1.00000000000000000000')), (6, 'Designer Dress', Decimal('4.0000000000000000')), (14, 'Weighted Blanket', Decimal('3.0000000000000000')), (13, 'Vitamin C Supplement', Decimal('2.0000000000000000')), (2, 'Wireless Headphones', Decimal('4.0000000000000000')), (16, 'Tennis Racket', Decimal('4.0000000000000000')), (7, 'Coffee Maker', Decimal('5.0000000000000000')), (12, 'Skincare Set', Decimal('4.0000000000000000')), (24, 'Tennis Racket', Decimal('1.00000000000000000000')), (25, 'Tennis Racket', Decimal('5.0000000000000000')), (20, 'Tennis Racket', Decimal('4.0000000000000000')), (1, 'Smartphone X', Decimal('5.0000000000000000')), (18, 'Tennis Racket', Decimal('5.0000000000000000')), (27, 'Tennis Racket', Decimal('2.0000000000000000')), (23, 'Tennis Racket', Decimal('4.0000000000000000')), (8, 'Toaster Oven', Decimal('3.0000000000000000'))],
                [(1, 'johndoe', Decimal('450.00')), (12, 'jasonrodriguez', Decimal('160.00')), (24, 'jamesrogers', Decimal('150.00')), (8, 'chrisharris', Decimal('150.00')), (17, 'olivialopez', Decimal('145.00')), (29, 'elliecollins', Decimal('145.00')), (20, 'williamhernandez', Decimal('140.00')), (26, 'benjamincarter', Decimal('130.00')), (14, 'matthewthomas', Decimal('130.00')), (7, 'lisawilliams', Decimal('125.00'))]
            ]

            self.assertEqual(result, expected_result[i], "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('./sql/task2.sql', 'r') as file:
            sql_query = file.read().split(';')[:-1]

        for i in range(len(sql_query)):
            self.cur.execute(sql_query[i])
            result = self.cur.fetchall()

            # Define expected outcome for Task 2 and compare
            expected_result = [
                # Define expected rows or values here based on the query output
                [(11, 'Yoga Mat', Decimal('5.0000000000000000')), (15, 'Mountain Bike', Decimal('5.0000000000000000')), (21, 'Tennis Racket', Decimal('5.0000000000000000')), (29, 'Tennis Racket', Decimal('5.0000000000000000')), (4, 'Smart TV', Decimal('5.0000000000000000')), (7, 'Coffee Maker', Decimal('5.0000000000000000')), (25, 'Tennis Racket', Decimal('5.0000000000000000')), (1, 'Smartphone X', Decimal('5.0000000000000000')), (18, 'Tennis Racket', Decimal('5.0000000000000000'))],
                [],
                [(33, 'Tennis Racket'), (31, 'Tennis Racket'), (34, 'Tennis Racket'), (32, 'Tennis Racket'), (36, 'Tennis Racket'), (35, 'Tennis Racket')],
                [('(1,johndoe)',)]
            ]

            self.assertEqual(result, expected_result[i], "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks
    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('./sql/task3.sql', 'r') as file:
            sql_query = file.read().split(';')[:-1]

        for i in range(len(sql_query)):
            self.cur.execute(sql_query[i])
            result = self.cur.fetchall()

            # Define expected outcome for Task 3 and compare
            expected_result = [
                # Define expected rows or values here based on the query output
                [(9, 'Automotive', Decimal('605.00')), (4, 'Home & Kitchen', Decimal('145.00')), (1, 'Electronics', Decimal('125.00'))],
                [(5, 'sarahwilson')],
                [(1, 'Smartphone X', 1, Decimal('500.00')), (3, 'Laptop Pro', 2, Decimal('1200.00')), (6, 'Designer Dress', 3, Decimal('300.00')), (7, 'Coffee Maker', 4, Decimal('80.00')), (9, 'Action Camera', 5, Decimal('200.00')), (12, 'Skincare Set', 6, Decimal('150.00')), (14, 'Weighted Blanket', 7, Decimal('100.00')), (15, 'Mountain Bike', 8, Decimal('1000.00')), (16, 'Tennis Racket', 9, Decimal('54.00')), (17, 'Tennis Racket', 9, Decimal('54.00')), (18, 'Tennis Racket', 9, Decimal('54.00')), (19, 'Tennis Racket', 9, Decimal('54.00')), (20, 'Tennis Racket', 9, Decimal('54.00')), (21, 'Tennis Racket', 9, Decimal('54.00')), (22, 'Tennis Racket', 9, Decimal('54.00')), (23, 'Tennis Racket', 9, Decimal('54.00')), (24, 'Tennis Racket', 9, Decimal('54.00')), (25, 'Tennis Racket', 9, Decimal('54.00')), (26, 'Tennis Racket', 9, Decimal('54.00')), (27, 'Tennis Racket', 9, Decimal('54.00')), (28, 'Tennis Racket', 9, Decimal('54.00')), (29, 'Tennis Racket', 9, Decimal('54.00')), (30, 'Tennis Racket', 9, Decimal('54.00')), (31, 'Tennis Racket', 9, Decimal('54.00')), (32, 'Tennis Racket', 9, Decimal('54.00')), (33, 'Tennis Racket', 9, Decimal('54.00')), (34, 'Tennis Racket', 9, Decimal('54.00')), (35, 'Tennis Racket', 9, Decimal('54.00')), (36, 'Tennis Racket', 9, Decimal('54.00'))],
                [(1, 'johndoe')]
            ]

            self.assertEqual(result, expected_result[i], "Task 3: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()