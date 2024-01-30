import unittest
import psycopg2  # Replace with appropriate database connector based on your database

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='ShopifyDB',
            user='Hersh',
            password='123',
            host='localhost',
            port='5432'
        )
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
            [15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.0],
            [16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.0]
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
            [1, 'johndoe', 1],
            [2, 'janesmith', 1],
            [3, 'maryjones', 1],
            [4, 'robertbrown', 1],
            [5, 'sarahwilson', 1],
            [6, 'michaellee', 1],
            [7, 'lisawilliams', 1],
            [8, 'chrisharris', 1],
            [9, 'emilythompson', 1],
            [10, 'davidmartinez', 1],
            [11, 'amandajohnson', 1],
            [12, 'jasonrodriguez', 1],
            [13, 'ashleytaylor', 1],
            [14, 'matthewthomas', 1],
            [15, 'sophiawalker', 1],
            [16, 'jacobanderson', 1],
            [17, 'olivialopez', 1],
            [18, 'ethanmiller', 1],
            [19, 'emilygonzalez', 1],
            [20, 'williamhernandez', 1],
            [21, 'sophiawright', 1],
            [22, 'alexanderhill', 1],
            [23, 'madisonmoore', 1],
            [24, 'jamesrogers', 1],
            [25, 'emilyward', 1],
            [26, 'benjamincarter', 1],
            [27, 'gracestewart', 1],
            [28, 'danielturner', 1],
            [29, 'elliecollins', 1],
            [30, 'williamwood', 1]
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('/sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 and compare
        expected_result = [
            [1, 'Smartphone X', 5.0],
            [2, 'Wireless Headphones', 4.0],
            [3, 'Laptop Pro', 3.0],
            [4, 'Smart TV', 5.0],
            [5, 'Running Shoes', 2.0],
            [6, 'Designer Dress', 4.0],
            [7, 'Coffee Maker', 5.0],
            [8, 'Toaster Oven', 3.0],
            [9, 'Action Camera', 4.0],
            [10, 'Board Game Collection', 1.0],
            [11, 'Yoga Mat', 5.0],
            [12, 'Skincare Set', 4.0],
            [13, 'Vitamin C Supplement', 2.0],
            [14, 'Weighted Blanket', 3.0],
            [15, 'Mountain Bike', 5.0],
            [16, 'Tennis Racket', 4.0]
        ]
        
        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")

    def test_task4(self):
        # Task 4: Example SQL query in task4.sql
        with open('/sql/task4.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 4 and compare
        expected_result = [
            [12, 'jasonrodriguez', 160.0],
            [4, 'robertbrown', 155.0],
            [8, 'chrisharris', 150.0],
            [24, 'jamesrogers', 150.0],
            [17, 'olivialopez', 145.0]
        ]

        self.assertEqual(result, expected_result, "Task 4: Query output doesn't match expected result.")

    def test_task5(self):
        # Task 5: Example SQL query in task5.sql
        with open('/sql/task5.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 5 and compare
        expected_result = [
            [1, 'Smartphone X', 5.0],
            [4, 'Smart TV', 5.0],
            [7, 'Coffee Maker', 5.0],
            [11, 'Yoga Mat', 5.0],
            [15, 'Mountain Bike', 5.0]
            # Products with IDs 18, 21, 25, and 29 also have the highest average rating of 5.0,
            # but their names are missing in the provided dataset.
        ]

        self.assertEqual(result, expected_result, "Task 5: Query output doesn't match expected result.")

    def test_task6(self):
        # Task 6: Example SQL query in task6.sql
        with open('/sql/task6.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 6 and compare
        expected_result = [
        ]

        self.assertEqual(result, expected_result, "Task 6: Query output doesn't match expected result.")

    def test_task7(self):
        # Task 7: Example SQL query in task7.sql
        with open('/sql/task7.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 7 and compare
        expected_result = [
        ]

        self.assertEqual(result, expected_result, "Task 7: Query output doesn't match expected result.")

    def test_task8(self):
        # Task 8: Example SQL query in task8.sql
        with open('/sql/task8.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 8 and compare
        expected_result = [
        ]

        self.assertEqual(result, expected_result, "Task 8: Query output doesn't match expected result.")

    def test_task9(self):
        # Task 9: Example SQL query in task9.sql
        with open('/sql/task9.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 9 and compare
        expected_result = [
            [1, 'Electronics', 155.00],
            [3, 'Clothing', 145.00],
            [5, 'Toys & Games', 125.00]
        ]

        self.assertEqual(result, expected_result, "Task 9: Query output doesn't match expected result.")

    def test_task10(self):
        # Task 10: Example SQL query in task10.sql
        with open('/sql/task10.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 10 and compare
        expected_result = [
            [5, 'sarahwilson'],
        ]

        self.assertEqual(result, expected_result, "Task 10: Query output doesn't match expected result.")

    def test_task11(self):
        # Task 11: Example SQL query in task11.sql
        with open('/sql/task11.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 11 and compare
        expected_result = [
            [1, 'Smartphone X', 1, 500.00],
            [3, 'Laptop Pro', 2, 1200.00],
            [6, 'Designer Dress', 3, 300.00]
            [7, 'Coffee Maker', 4, 80.00],
            [9, 'Action Camera', 5, 200.00],
            [12, 'Skincare Set', 6, 150.00]
            [14, 'Weighted Blanket', 7, 100.00],
            [15, 'Mountain Bike', 8, 1000.00],
        ]

        self.assertEqual(result, expected_result, "Task 11: Query output doesn't match expected result.")

    def test_task12(self):
        # Task 12: Example SQL query in task12.sql
        with open('/sql/task12.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 12 and compare
        expected_result = [
        ]

        self.assertEqual(result, expected_result, "Task 12: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()