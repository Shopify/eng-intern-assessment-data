import unittest
import psycopg2  # Replace with appropriate database connector based on your database


class TestSQLQueries(unittest.TestCase):
    dbname = 'patelh'
    user = 'patelh'
    password = ''
    host = 'localhost'
    port = '5431'

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname=self.dbname,
            user=self.user,
            password=self.password,
            host=self.host,
            port=self.port
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('../sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare

        # Task 1:
        # expected_result = [(15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.',
        #                     1000.00, 8),
        #                    (16, 'Tennis Racket', 'Take your tennis game to the next level with this '
        #                                          'professional-grade racket.', 54.00,8)]

        # Task 2:
        # expected_result = [(1, 'johndoe', 1),
        #                    (2, 'janesmith', 1),
        #                    (3, 'maryjones', 1),
        #                    (4, 'robertbrown', 1),
        #                    (5, 'sarahwilson', 1),
        #                    (6, 'michaellee', 1),
        #                    (7, 'lisawilliams', 1),
        #                    (8, 'chrisharris', 1),
        #                    (9, 'emilythompson', 1),
        #                    (10, 'davidmartinez', 1),
        #                    (11, 'amandajohnson', 1),
        #                    (12, 'jasonrodriguez', 1),
        #                    (13, 'ashleytaylor', 1),
        #                    (14, 'matthewthomas', 1),
        #                    (15, 'sophiawalker', 1),
        #                    (16, 'jacobanderson', 1),
        #                    (17, 'olivialopez', 1),
        #                    (18, 'ethanmiller', 1),
        #                    (19, 'emilygonzalez', 1),
        #                    (20, 'williamhernandez', 1),
        #                    (21, 'sophiawright', 1),
        #                    (22, 'alexanderhill', 1),
        #                    (23, 'madisonmoore', 1),
        #                    (24, 'jamesrogers', 1),
        #                    (25, 'emilyward', 1),
        #                    (26, 'benjamincarter', 1),
        #                    (27, 'gracestewart', 1),
        #                    (28, 'danielturner', 1),
        #                    (29, 'elliecollins', 1),
        #                    (30, 'williamwood', 2)]

        # Task 3:
        # expected_result = [(1, 'Smartphone X', 4),
        #                    (2, 'Wireless Headphones', 4.5),
        #                    (3, 'Laptop Pro', 2.5),
        #                    (4, 'Smart TV', 4.5),
        #                    (5, 'Running Shoes', 3.5),
        #                    (6, 'Designer Dress', 3.5),
        #                    (7, 'Coffee Maker', 4.5),
        #                    (8, 'Toaster Oven', 2),
        #                    (9, 'Action Camera', 4.5),
        #                    (10, 'Board Game Collection', 2.5),
        #                    (11, 'Yoga Mat', 3.5),
        #                    (12, 'Skincare Set', 3.5),
        #                    (13, 'Vitamin C Supplement', 3.5),
        #                    (14, 'Weighted Blanket', 3.5),
        #                    (15, 'Mountain Bike', 5),
        #                    (16, 'Tennis Racket', 4)]

        # Task 4:
        expected_result = [(30, 'williamwood', 170.00),
                           (12, 'jasonrodriguez', 160.00),
                           (4, 'robertbrown', 155.00),
                           (24, 'jamesrogers', 150.00),
                           (8, 'chrisharris', 150.00)]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('../sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare

        # Task 5:
        # expected_result = [(4, 'Smart TV', 4.5),
        #                    (7, 'Coffee Maker', 4.5),
        #                    (9, 'Action Camera', 4.5)]

        # Task 6:
        # expected_result = [(9, 'emilythompson'), (15, 'sophiawalker')]

        # Task 7:
        # expected_result = [(15, 'Mountain Bike'), (16, 'Tennis Racket')]

        # Task 8:
        expected_result = [(29, 'elliecollins'), (30, 'williamwood')]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('../sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 and compare

        # Task 9:
        # expected_result = []

        # Task 10:
        # expected_result = []

        # Task 11:
        # expected_result = []

        # Task 12:
        expected_result = []

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")


if __name__ == '__main__':
    unittest.main()