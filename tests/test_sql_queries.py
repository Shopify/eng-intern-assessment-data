import unittest
import psycopg2
from decimal import Decimal

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='testdb',
            user='user',
            password='password',
            host='localhost'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Expected result for Problem 1
        expected_result_p1 = [
            (15,'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.00),
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.00)
        ]
        
        # Expected result for Problem 2
        expected_result_p2 = [
            (1, 'johndoe', 1),
            (2, 'janesmith', 1),
            (3, 'maryjones', 2),
            (4, 'robertbrown', 2),
            (5, 'sarahwilson', 1),
            (6, 'michaellee', 0),
            (7, 'lisawilliams', 1),
            (8, 'chrisharris', 1),
            (9, 'emilythompson', 0),
            (10, 'davidmartinez', 1),
            (11, 'amandajohnson', 1),
            (12, 'jasonrodriguez', 1),
            (13, 'ashleytaylor', 1),
            (14, 'matthewthomas', 1),
            (15, 'sophiawalker', 1),
            (16, 'jacobanderson', 5),
            (17, 'olivialopez', 1),
            (18, 'ethanmiller', 0),
            (19, 'emilygonzalez', 0),
            (20, 'williamhernandez', 0),
            (21, 'sophiawright', 0),
            (22, 'alexanderhill', 0),
            (23, 'madisonmoore', 0),
            (24, 'jamesrogers', 0),
            (25, 'emilyward', 0),
            (26, 'benjamincarter', 0),
            (27, 'gracestewart', 0),
            (28, 'danielturner', 0),
            (29, 'elliecollins', 0),
            (30, 'williamwood', 0)
        ]

        # Expected result for Problem 3
        expected_result_p3 = [
            (1, 'Smartphone X', None),
            (2, 'Wireless Headphones', 2),
            (3, 'Laptop Pro', 1),
            (4, 'Smart TV', 3.5),
            (5, 'Running Shoes', 3.75),
            (6, 'Designer Dress', 4.5),
            (7, 'Coffee Maker', Decimal('4.3333333333333333')),
            (8, 'Toaster Oven', Decimal('4.3333333333333333')),
            (9, 'Action Camera', None),
            (10, 'Board Game Collection', 4),
            (11, 'Yoga Mat', 5),
            (12, 'Skincare Set', 3.5),
            (13, 'Vitamin C Supplement', 5),
            (14, 'Weighted Blanket', 3),
            (15, 'Mountain Bike', Decimal('3.6666666666666667')),
            (16, 'Tennis Racket', 3)
        ]
        
        # Expected result for Problem 4
        expected_result_p4 = [
            (2, 'janesmith', 3750.00),
            (17, 'olivialopez', 3130.00),
            (5, 'sarahwilson', 2700.00),
            (4, 'robertbrown', 2640.00),
            (8, 'chrisharris', 1350.00),
        ]

        expected_results_t1 = [expected_result_p1, expected_result_p2,
                            expected_result_p3, expected_result_p4]

        with open('/home/mehdi/eng-intern-assessment-data/sql/task1.sql', 'r') as file:
            sql_queries = file.read().split(";")

        for i, query in enumerate(sql_queries):
            self.cur.execute(query)
            result = self.cur.fetchall()
            self.assertEqual(result, expected_results_t1[i], f"Problem {i + 1}: Query output doesn't match expected result.")

    def test_task2(self):
        # Expected result for Problem 5
        expected_result_p5 = [
            (11, 'Yoga Mat', 5),
            (13, 'Vitamin C Supplement', 5)
        ]
        
        # Expected result for Problem 6
        expected_result_p6 = [(17, 'olivialopez')]

        # Expected result for Problem 7
        expected_result_p7 = [
            (1, 'Smartphone X'),
            (9, 'Action Camera')
        ]
        
        # Expected result for Problem 8
        expected_result_p8 = [(4, 'robertbrown'), (16, 'jacobanderson')]

        expected_results_t2 = [expected_result_p5, expected_result_p6,
                            expected_result_p7, expected_result_p8]

        with open('/home/mehdi/eng-intern-assessment-data/sql/task2.sql', 'r') as file:
            sql_queries = file.read().split(';')

        for i, query in enumerate(sql_queries):
            self.cur.execute(query)
            result = self.cur.fetchall()
            self.assertEqual(result, expected_results_t2[i], f"Problem {5 + i}: Query output doesn't match expected result.")

    def test_task3(self):
        # Expected result for Problem 9
        expected_result_p9 = [
            (2, 'Books', 12800.00),
            (8, 'Sports & Outdoors', 2162.00),
            (3, 'Clothing', 1400.00)
        ]
        
        # Expected result for Problem 10
        expected_result_p10 = [(5, 'sarahwilson')]

        # Expected result for Problem 11
        expected_result_p11 = [
            (1, 1, 'Smartphone X', 500.00),
            (2, 3, 'Laptop Pro', 1200.00),
            (3, 6, 'Designer Dress', 300.00),
            (4, 7, 'Coffee Maker', 80.00),
            (5, 9, 'Action Camera', 200.00),
            (6, 12, 'Skincare Set', 150.00),
            (7, 14, 'Weighted Blanket', 100.00),
            (8, 15, 'Mountain Bike', 1000.00)
        ]
        
        # Expected result for Problem 12
        expected_result_p12 = [(16, 'jacobanderson')]

        expected_results_t3 = [expected_result_p9, expected_result_p10,
                            expected_result_p11, expected_result_p12]

        with open('/home/mehdi/eng-intern-assessment-data/sql/task3.sql', 'r') as file:
            sql_queries = file.read().split(';')

        for i, query in enumerate(sql_queries):
            self.cur.execute(query)
            result = self.cur.fetchall()
            self.assertEqual(result, expected_results_t3[i], f"Problem {9 + i}: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()
