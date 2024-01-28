import unittest
import psycopg2  # Replace with appropriate database connector based on your database
from decimal import Decimal # needed library for SQL queries

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='data-eng-intern-test',
            user='postgres',
            password='hidden',
            host='127.0.0.1',
            port='5432'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        with open('/sql/task1.sql', 'r') as file:
            sql_queries = file.read().split(';')

        sql_queries = [query.strip() for query in sql_queries if query.strip()]

        expected_result = [
            [
                (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.',
                 Decimal(1000.00), 8, 8, 'Sports & Outdoors'),
                (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.',
                 Decimal('54.00'), 8, 8, 'Sports & Outdoors')
            ],
            [
                (1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones',
                                                         1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1),
                (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris',
                                                               1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1),
                (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13,
                                                                      'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1),
                (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller',
                                                                   1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1),
                (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23,
                                                                    'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1),
                (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28,
                                                                     'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)
            ],
            [
                (11, 'Yoga Mat', Decimal('5.0')), (9,
                                                   'Action Camera', Decimal('4.0')),
                (15, 'Mountain Bike', Decimal('5.0')
                 ), (3, 'Laptop Pro', Decimal('3.0')),
                (5, 'Running Shoes', Decimal('2.0')
                 ), (4, 'Smart TV', Decimal('5.0')),
                (10, 'Board Game Collection', Decimal('1.0')
                 ), (6, 'Designer Dress', Decimal('4.0')),
                (14, 'Weighted Blanket', Decimal('3.0')), (13, 'Vitamin C Supplement', Decimal(
                    '2.0')), (2, 'Wireless Headphones', Decimal('4.0')),
                (16, 'Tennis Racket', Decimal('4.0')), (7, 'Coffee Maker',
                                                        Decimal('5.0')), (12, 'Skincare Set', Decimal('4.0')),
                (1, 'Smartphone X', Decimal('5.0')
                 ), (8, 'Toaster Oven', Decimal('3.0'))
            ],
            [(12, 'jasonrodriguez', Decimal('160.00')), (4, 'robertbrown', Decimal('155.00')), (8, 'chrisharris', Decimal(
                '150.00')), (24, 'jamesrogers', Decimal('150.00')), (29, 'elliecollins', Decimal('145.00'))]
        ]
        for i, query in enumerate(sql_queries):
            if query:
                self.cur.execute(query)
                result = self.cur.fetchall()
                self.assertEqual(result, expected_result[i], f"Task 1, Query {i+1}: Query output doesn't match expected result.")

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

if __name__ == '__main__':
    unittest.main()