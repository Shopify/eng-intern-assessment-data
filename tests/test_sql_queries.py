import unittest
import psycopg2  # Replace with appropriate database connector based on your database

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='interndb',
            user='postgres',
            password='d098fu2o3',
            host='localhost',
            port='5432'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    #The original function only executed and checked the last SQL command of each file
    #I have modified the function to execute and check all SQL commands
    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        result = []
        with open('./sql/task1.sql', 'r') as file:
            sql_queries = file.read().split(';')
            #Remove \n at the end
        sql_queries = sql_queries[:-1]
        for sql_command in sql_queries:
            #Adds back the semicolon to the SQL command if it doesn't exist
            #I converted to string so that I can easily compare with expected_result
            if not sql_command.endswith(';'):
                self.cur.execute(sql_command + ';')
                result.append(str(self.cur.fetchall()))
            else:
                self.cur.execute(sql_command)
                result.append(str(self.cur.fetchall()))

        # Define expected outcome for Task 1 and compare
        expected_result = [
            "[('Mountain Bike',), ('Tennis Racket',)]", 
            "[(9, 'emilythompson', 1), (5, 'sarahwilson', 1), (13, 'ashleytaylor', 1), (3, 'maryjones', 1), (15, 'sophiawalker', 1), (18, 'ethanmiller', 1), (11, 'amandajohnson', 1), (2, 'janesmith', 1), (12, 'jasonrodriguez', 1), (27, 'gracestewart', 1), (1, 'johndoe', 1), (29, 'elliecollins', 1), (23, 'madisonmoore', 1), (26, 'benjamincarter', 1), (25, 'emilyward', 1), (17, 'olivialopez', 1), (7, 'lisawilliams', 1), (20, 'williamhernandez', 1), (8, 'chrisharris', 1), (10, 'davidmartinez', 1), (14, 'matthewthomas', 1), (6, 'michaellee', 1), (30, 'williamwood', 1), (4, 'robertbrown', 1), (24, 'jamesrogers', 1), (16, 'jacobanderson', 1), (28, 'danielturner', 1), (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (19, 'emilygonzalez', 1)]",
            "[(29, None, Decimal('5.0000000000000000')), (9, 'Action Camera', Decimal('4.0000000000000000')), (19, None, Decimal('2.0000000000000000')), (8, 'Toaster Oven', Decimal('3.0000000000000000')), (7, 'Coffee Maker', Decimal('5.0000000000000000')), (18, None, Decimal('5.0000000000000000')), (30, None, Decimal('4.0000000000000000')), (25, None, Decimal('5.0000000000000000')), (13, 'Vitamin C Supplement', Decimal('2.0000000000000000')), (3, 'Laptop Pro', Decimal('3.0000000000000000')), (14, 'Weighted Blanket', Decimal('3.0000000000000000')), (27, None, Decimal('2.0000000000000000')), (17, None, Decimal('3.0000000000000000')), (6, 'Designer Dress', Decimal('4.0000000000000000')), (21, None, Decimal('5.0000000000000000')), (22, None, Decimal('3.0000000000000000')), (5, 'Running Shoes', Decimal('2.0000000000000000')), (10, 'Board Game Collection', Decimal('1.00000000000000000000')), (11, 'Yoga Mat', Decimal('5.0000000000000000')), (12, 'Skincare Set', Decimal('4.0000000000000000')), (1, 'Smartphone X', Decimal('5.0000000000000000')), (20, None, Decimal('4.0000000000000000')), (26, None, Decimal('4.0000000000000000')), (23, None, Decimal('4.0000000000000000')), (16, 'Tennis Racket', Decimal('4.0000000000000000')), (15, 'Mountain Bike', Decimal('5.0000000000000000')), (24, None, Decimal('1.00000000000000000000')), (28, None, Decimal('3.0000000000000000')), (2, 'Wireless Headphones', Decimal('4.0000000000000000')), (4, 'Smart TV', Decimal('5.0000000000000000'))]",
            "[(16, 'jacobanderson', Decimal('170.00')), (14, 'matthewthomas', Decimal('130.00')), (13, 'ashleytaylor', Decimal('95.00')), (3, 'maryjones', Decimal('150.00')), (9, 'emilythompson', Decimal('105.00')), (6, 'michaellee', Decimal('90.00')), (17, 'olivialopez', Decimal('115.00')), (7, 'lisawilliams', Decimal('135.00')), (5, 'sarahwilson', Decimal('120.00')), (15, 'sophiawalker', Decimal('145.00')), (2, 'janesmith', Decimal('200.00')), (18, 'ethanmiller', Decimal('150.00')), (8, 'chrisharris', Decimal('160.00')), (4, 'robertbrown', Decimal('175.00')), (10, 'davidmartinez', Decimal('140.00')), (12, 'jasonrodriguez', Decimal('180.00')), (1, 'johndoe', Decimal('100.00')), (11, 'amandajohnson', Decimal('125.00'))]"
            # Define expected rows or values here based on the query output
        ]
        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        result = []
        with open('./sql/task2.sql', 'r') as file:
            sql_queries = file.read().split(';')
            #Remove \n at the end
        sql_queries = sql_queries[:-1]
        for sql_command in sql_queries:
            #Adds back the semicolon to the SQL command if it doesn't exist
            #I converted to string so that I can easily compare with expected_result
            if not sql_command.endswith(';'):
                self.cur.execute(sql_command + ';')
                result.append(str(self.cur.fetchall()))
            else:
                self.cur.execute(sql_command)
                result.append(str(self.cur.fetchall()))
        #print(result)

        # Define expected outcome for Task 2 and compare
        expected_result = [
            "[(Decimal('5.0000000000000000'), 29, None), (Decimal('5.0000000000000000'), 7, 'Coffee Maker'), (Decimal('5.0000000000000000'), 18, None), (Decimal('5.0000000000000000'), 25, None), (Decimal('5.0000000000000000'), 21, None), (Decimal('5.0000000000000000'), 11, 'Yoga Mat'), (Decimal('5.0000000000000000'), 1, 'Smartphone X'), (Decimal('5.0000000000000000'), 15, 'Mountain Bike'), (Decimal('5.0000000000000000'), 4, 'Smart TV')]",
            "[]", 
            "[(34, None), (35, None), (36, None), (31, None), (32, None), (33, None)]", 
            "[]"
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()