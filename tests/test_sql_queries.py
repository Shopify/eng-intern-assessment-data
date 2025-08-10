import unittest
from config import DATABASE_NAME, PASSW, PORT
import MySQLdb
import os


globalConnection = MySQLdb.connect(
    db=DATABASE_NAME,
    user="root",
    password=PASSW,
    host="localhost",
    port=PORT
)
globalCursor = globalConnection.cursor()


def executeQuery(queryPath):
    with open(queryPath, "r") as file:
        sql_query = file.read()
    globalCursor.execute(sql_query)


def executeSchema():
    executeQuery('./sql/schema.sql')


def populateTable():
    executeQuery('./tests/populateTable.sql')


def nukeDatabase():
    executeQuery('./tests/nuke.sql')


def closeConnection():
    globalConnection.close()


class TestSQLQueries(unittest.TestCase):
    def setUp(self):
        # Establish a connection to your test database
        self.conn = MySQLdb.connect(
            db=DATABASE_NAME,
            user='root',
            password=PASSW,
            host='localhost',
            port=PORT
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        result = []
        try:
            with open('./sql/task1.sql', 'r') as file:
                sql_query = file.read()

            for query in sql_query.split(";"):
                self.cur.execute(query)
                result.append(self.cur.fetchall())

        except MySQLdb.Error as e:
            print("MySQL Error: ", e)

        """
        print(result[0])
        print(result[1])
        print(result[2])
        print(result[3])
        """

        # Define expected outcome for Task 1 and compare
        expected_result = [
            ((15, 'Mountain Bike'), (16, 'Tennis Racket')),

            ((1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), (4, 'robertbrown', 1), (5, 'sarahwilson', 1),
             (6, 'michaellee', 1), (7, 'lisawilliams', 1), (8, 'chrisharris', 1), (9, 'emilythompson', 1), (10, 'davidmartinez', 1),
             (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), (15, 'sophiawalker', 1),
             (16, 'jacobanderson', 1), (17, 'olivialopez', 1), (18, 'ethanmiller', 1), (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1),
             (21, 'sophiawright', 1), (22, 'alexanderhill', 1), (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), (25, 'emilyward', 1),
             (26, 'benjamincarter', 1), (27, 'gracestewart', 1), (28, 'danielturner', 1), (29, 'elliecollins', 1), (30, 'williamwood', 1)),

            ((1, 'Smartphone X', 5.0), (2, 'Wireless Headphones', 4.0), (3, 'Laptop Pro', 3.0), (4, 'Smart TV', 5.0),
             (5, 'Running Shoes', 2.0), (6, 'Designer Dress', 4.0), (7, 'Coffee Maker', 5.0), (8, 'Toaster Oven', 3.0),
             (9, 'Action Camera', 4.0), (10, 'Board Game Collection', 1.0), (11, 'Yoga Mat', 5.0), (12, 'Skincare Set', 4.0),
             (13, 'Vitamin C Supplement', 2.0), (14, 'Weighted Blanket', 3.0), (15, 'Mountain Bike', 5.0), (16, 'Tennis Racket', 4.0)),

            ((12, 'jasonrodriguez', 160.0), (4, 'robertbrown', 155.0), (8, 'chrisharris', 150.0), (24, 'jamesrogers', 150.0), (17, 'olivialopez', 145.0))
        ]

        self.assertEqual(result, expected_result,
                          "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('./sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result,
                         "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks


if __name__ == '__main__':
    # nukeDatabase()
    # executeSchema()
    # populateTable()
   # closeConnection()

    unittest.main()
