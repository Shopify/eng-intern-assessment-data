import unittest
import psycopg2  # Replace with appropriate database connector based on your database

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='your_dbname',
            user='your_username',
            password='your_password',
            host='your_host',
            port='your_port'
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
        

        # Get all quries from the file without comments
        sql_query = '\n'.join(line for line in sql_query.split('\n') if line.strip() and not line.strip().startswith('--'))


        # Split the querys into a list
        querys=sql_query.split(';')

        #Problem 1
        self.cur.execute(querys[0])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            ('Mountain Bike',), ('Tennis Racket',)
        ]

        self.assertEqual(result, expected_result, "Task 1 Problem 1: Query output doesn't match expected result.")


        #Problem 2
        self.cur.execute(querys[1])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [(1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1), (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1), (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1), (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)]


        self.assertEqual(result, expected_result, "Task 1 Problem 2: Query output doesn't match expected result.")

        #Problem 3
        self.cur.execute(querys[2])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = "[(1, 'Smartphone X', Decimal('5.0')), (2, 'Wireless Headphones', Decimal('4.0')), (3, 'Laptop Pro', Decimal('3.0')), (4, 'Smart TV', Decimal('5.0')), (5, 'Running Shoes', Decimal('2.0')), (6, 'Designer Dress', Decimal('4.0')), (7, 'Coffee Maker', Decimal('5.0')), (8, 'Toaster Oven', Decimal('3.0')), (9, 'Action Camera', Decimal('4.0')), (10, 'Board Game Collection', Decimal('1.0')), (11, 'Yoga Mat', Decimal('5.0')), (12, 'Skincare Set', Decimal('4.0')), (13, 'Vitamin C Supplement', Decimal('2.0')), (14, 'Weighted Blanket', Decimal('3.0')), (15, 'Mountain Bike', Decimal('5.0')), (16, 'Tennis Racket', Decimal('4.0')), (17, None, Decimal('3.0')), (18, None, Decimal('5.0')), (19, None, Decimal('2.0')), (20, None, Decimal('4.0')), (21, None, Decimal('5.0')), (22, None, Decimal('3.0')), (23, None, Decimal('4.0')), (24, None, Decimal('1.0')), (25, None, Decimal('5.0')), (26, None, Decimal('4.0')), (27, None, Decimal('2.0')), (28, None, Decimal('3.0')), (29, None, Decimal('5.0')), (30, None, Decimal('4.0')), (31, None, None), (32, None, None), (33, None, None), (34, None, None), (35, None, None), (36, None, None)]"

        self.assertEqual(str(result), expected_result, "Task 1 Problem 3: Query output doesn't match expected result.")

        #Problem 4
        self.cur.execute(querys[3])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = "[(12, 'jasonrodriguez', Decimal('160.00')), (4, 'robertbrown', Decimal('155.00')), (8, 'chrisharris', Decimal('150.00')), (24, 'jamesrogers', Decimal('150.00')), (29, 'elliecollins', Decimal('145.00'))]"

        self.assertEqual(str(result), expected_result, "Task 1 Problem 4: Query output doesn't match expected result.")

    def test_task2(self):
        
        # Task 2
        with open('/sql/task2.sql', 'r') as file:
            sql_query = file.read()        
        

        # Get all quries from the file without comments
        sql_query = '\n'.join(line for line in sql_query.split('\n') if line.strip() and not line.strip().startswith('--'))


        # Split the querys into a list
        querys=sql_query.split(';')

        #Problem 5
        self.cur.execute(querys[0])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = "[(11, 'Yoga Mat', Decimal('5.0')), (15, 'Mountain Bike', Decimal('5.0')), (21, None, Decimal('5.0')), (29, None, Decimal('5.0')), (4, 'Smart TV', Decimal('5.0')), (7, 'Coffee Maker', Decimal('5.0')), (25, None, Decimal('5.0')), (1, 'Smartphone X', Decimal('5.0')), (18, None, Decimal('5.0'))]"

        self.assertEqual(str(result), expected_result, "Task 2 Problem 5: Query output doesn't match expected result.")


        #Problem 6
        self.cur.execute(querys[1])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = []


        self.assertEqual(result, expected_result, "Task 2 Problem 6: Query output doesn't match expected result.")

        #Problem 3
        self.cur.execute(querys[2])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [(1, 'Smartphone X'), (2, 'Wireless Headphones'), (3, 'Laptop Pro'), (4, 'Smart TV'), (5, 'Running Shoes'), (6, 'Designer Dress'), (7, 'Coffee Maker'), (8, 'Toaster Oven'), (9, 'Action Camera'), (10, 'Board Game Collection'), (11, 'Yoga Mat'), (12, 'Skincare Set'), (13, 'Vitamin C Supplement'), (14, 'Weighted Blanket'), (15, 'Mountain Bike'), (16, 'Tennis Racket'), (17, None), (18, None), (19, None), (20, None), (21, None), (22, None), (23, None), (24, None), (25, None), (26, None), (27, None), (28, None), (29, None), (30, None)]

        self.assertEqual(result, expected_result, "Task 2 Problem 7: Query output doesn't match expected result.")

        #Problem 4
        self.cur.execute(querys[3])
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = []

        self.assertEqual(result, expected_result, "Task 2 Problem 8: Query output doesn't match expected result.")

    def test_task3(self):
            
            # Task 3
            with open('/sql/task3.sql', 'r') as file:
                sql_query = file.read()        
            

            # Get all quries from the file without comments
            sql_query = '\n'.join(line for line in sql_query.split('\n') if line.strip() and not line.strip().startswith('--'))


            # Split the querys into a list
            querys=sql_query.split(';')

            #Problem 9
            self.cur.execute(querys[0])
            result = self.cur.fetchall()

            # Define expected outcome for Task 1 and compare
            expected_result = "[(8, 'Sports & Outdoors', Decimal('155.00')), (4, 'Home & Kitchen', Decimal('145.00')), (1, 'Electronics', Decimal('125.00'))]"

            self.assertEqual(str(result), expected_result, "Task 3 Problem 9: Query output doesn't match expected result.")


            #Problem 10
            self.cur.execute(querys[1])
            result = self.cur.fetchall()

            # Define expected outcome for Task 1 and compare
            expected_result = [(5, 'sarahwilson')]


            self.assertEqual(result, expected_result, "Task 3 Problem 10: Query output doesn't match expected result.")

            #Problem 11
            self.cur.execute(querys[2])
            result = self.cur.fetchall()

            # Define expected outcome for Task 1 and compare
            expected_result = "[(1, 'Smartphone X', 1, Decimal('500.00')), (3, 'Laptop Pro', 2, Decimal('1200.00')), (6, 'Designer Dress', 3, Decimal('300.00')), (7, 'Coffee Maker', 4, Decimal('80.00')), (9, 'Action Camera', 5, Decimal('200.00')), (12, 'Skincare Set', 6, Decimal('150.00')), (14, 'Weighted Blanket', 7, Decimal('100.00')), (15, 'Mountain Bike', 8, Decimal('1000.00'))]"

            self.assertEqual(str(result), expected_result, "Task 3 Problem 11: Query output doesn't match expected result.")

            #Problem 12
            self.cur.execute(querys[3])
            result = self.cur.fetchall()

            # Define expected outcome for Task 1 and compare
            expected_result = []

            self.assertEqual(result, expected_result, "Task 3 Problem 12: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()