import unittest
import sqlite3
import test_create_db
import os

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Create the database from example data
        test_create_db.create_db("tests/test.db", "sql/schema.sql", "data/")
        # Establish a connection to your test database
        self.conn = sqlite3.connect("tests/test.db")
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

        # Delete the database
        os.remove("tests/test.db")

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('sql/task1.sql', 'r') as file:
            sql_script = file.read()
        sql_commands = sql_script_to_commands(sql_script)

        # Problem 1
        self.cur.execute(sql_commands[0])
        result1 = self.cur.fetchall()
        # Define expected outcome for Problem 1 and compare
        expected_result1 = [
            (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000, 8, 8, 'Sports & Outdoors'), 
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54, 8, 8, 'Sports & Outdoors')
        ]
        self.assertEqual(result1, expected_result1, "Problem 1: Query output doesn't match expected result.")

        # Problem 2
        self.cur.execute(sql_commands[1])
        result2 = self.cur.fetchall()
        # Define expected outcome for Problem 2 and compare
        expected_result2 = [
            (1, 'johndoe', 1), (2, 'janesmith', 1), (3, 'maryjones', 1), 
            (4, 'robertbrown', 1), (5, 'sarahwilson', 1), (6, 'michaellee', 1),
            (7, 'lisawilliams', 1), (8, 'chrisharris', 1), 
            (9, 'emilythompson', 1), (10, 'davidmartinez', 1), 
            (11, 'amandajohnson', 1), (12, 'jasonrodriguez', 1), 
            (13, 'ashleytaylor', 1), (14, 'matthewthomas', 1), 
            (15, 'sophiawalker', 1), (16, 'jacobanderson', 1), 
            (17, 'olivialopez', 1), (18, 'ethanmiller', 1), 
            (19, 'emilygonzalez', 1), (20, 'williamhernandez', 1), 
            (21, 'sophiawright', 1), (22, 'alexanderhill', 1),
            (23, 'madisonmoore', 1), (24, 'jamesrogers', 1), 
            (25, 'emilyward', 1), (26, 'benjamincarter', 1),
            (27, 'gracestewart', 1), (28, 'danielturner', 1),
            (29, 'elliecollins', 1), (30, 'williamwood', 1)
        ]
        self.assertEqual(result2, expected_result2, "Problem 2: Query output doesn't match expected result.")

        # Problem 3
        self.cur.execute(sql_commands[2])
        result3 = self.cur.fetchall()
        # Define expected outcome for Problem 3 and compare
        expected_result3 = [
            (1, 'Smartphone X', 5.0), (2, 'Wireless Headphones', 4.0), 
            (3, 'Laptop Pro', 3.0), (4, 'Smart TV', 5.0), 
            (5, 'Running Shoes', 2.0), (6, 'Designer Dress', 4.0), 
            (7, 'Coffee Maker', 5.0), (8, 'Toaster Oven', 3.0), 
            (9, 'Action Camera', 4.0), (10, 'Board Game Collection', 1.0), 
            (11, 'Yoga Mat', 5.0), (12, 'Skincare Set', 4.0), 
            (13, 'Vitamin C Supplement', 2.0), (14, 'Weighted Blanket', 3.0), 
            (15, 'Mountain Bike', 5.0), (16, 'Tennis Racket', 4.0)
        ]
        self.assertEqual(result3, expected_result3, "Problem 3: Query output doesn't match expected result.")

        # Problem 4
        self.cur.execute(sql_commands[3])
        result4 = self.cur.fetchall()
        # Define expected outcome for Problem 4 and compare
        expected_result4 = [
            (12, 'jasonrodriguez', 160), (4, 'robertbrown', 155),
            (8, 'chrisharris', 150), (24, 'jamesrogers', 150), 
            (17, 'olivialopez', 145)
        ]
        self.assertEqual(result4, expected_result4, "Problem 4: Query output doesn't match expected result.")


    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('sql/task2.sql', 'r') as file:
            sql_script = file.read()
        sql_commands = sql_script_to_commands(sql_script)

        # Problem 5
        self.cur.execute(sql_commands[0])
        result5 = self.cur.fetchall()
        # Define expected outcome for Problem 5 and compare
        expected_result5 = [
            (1, 'Smartphone X', 5.0), (4, 'Smart TV', 5.0), 
            (7, 'Coffee Maker', 5.0), (11, 'Yoga Mat', 5.0), 
            (15, 'Mountain Bike', 5.0)
        ]
        self.assertEqual(result5, expected_result5, "Problem 5: Query output doesn't match expected result.")

        # Problem 6
        self.cur.execute(sql_commands[1])
        result6 = self.cur.fetchall()
        # Define expected outcome for Problem 6 and compare
        expected_result6 = [
        ]
        self.assertEqual(result6, expected_result6, "Problem 6: Query output doesn't match expected result.")

        # Problem 7
        self.cur.execute(sql_commands[2])
        result7 = self.cur.fetchall()
        # Define expected outcome for Problem 7 and compare
        expected_result7 = [
        ]
        self.assertEqual(result7, expected_result7, "Problem 7: Query output doesn't match expected result.")

        # Problem 8
        self.cur.execute(sql_commands[3])
        result8 = self.cur.fetchall()
        # Define expected outcome for Problem 8 and compare
        expected_result8 = [
        ]
        self.assertEqual(result8, expected_result8, "Problem 8: Query output doesn't match expected result.")


    def test_task3(self):
        # Task 3: Example SQL query in task2.sql
        with open('sql/task3.sql', 'r') as file:
            sql_script = file.read()
        sql_commands = sql_script_to_commands(sql_script)

        # Problem 9
        self.cur.execute(sql_commands[0])
        result9 = self.cur.fetchall()
        # Define expected outcome for Problem 9 and compare
        expected_result9 = [
            (1, 'Electronics', 75),
            (4, 'Home & Kitchen', 75),
            (8, 'Sports & Outdoors', 75)
        ]
        self.assertEqual(result9, expected_result9, "Problem 9: Query output doesn't match expected result.")


        # Problem 10
        self.cur.execute(sql_commands[1])
        result10 = self.cur.fetchall()
        # Define expected outcome for Problem 10 and compare
        expected_result10 = [
            (5, 'sarahwilson')
        ]
        self.assertEqual(result10, expected_result10, "Problem 10: Query output doesn't match expected result.")

        # Problem 11
        self.cur.execute(sql_commands[2])
        result11 = self.cur.fetchall()
        # Define expected outcome for Problem 11 and compare
        expected_result11 = [
            (1, 'Smartphone X', 1, 500), (3, 'Laptop Pro', 2, 1200),
            (6, 'Designer Dress', 3, 300), (7, 'Coffee Maker', 4, 80),
            (9, 'Action Camera', 5, 200), (12, 'Skincare Set', 6, 150), 
            (14, 'Weighted Blanket', 7, 100), (15, 'Mountain Bike', 8, 1000)
        ]
        self.assertEqual(result11, expected_result11, "Problem 11: Query output doesn't match expected result.")

        # Problem 12
        self.cur.execute(sql_commands[3])
        result12 = self.cur.fetchall()
        # Define expected outcome for Problem 12 and compare
        expected_result12 = [
        ]
        self.assertEqual(result12, expected_result12, "Problem 12: Query output doesn't match expected result.")


def sql_script_to_commands(script):
    """
    Split an SQL script into individual commands, to test each command.
    Split into lines, then re-merge lines until a semicolon is reached.
    """
    lines = script.split("\n")
    commands = []
    curr_command = []
    for line in lines:
        curr_command.append(line)
        # Stop the current command
        if line.endswith(";"):
            commands.append("\n".join(curr_command))
            curr_command = []
    return commands


if __name__ == '__main__':
    unittest.main()