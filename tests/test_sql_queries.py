import unittest, os
import pandas as pd
import sqlite3  # Importing sqlite3 instead of psycopg2

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # delete existing db
        if os.path.exists("my_database.db"):
            os.remove("my_database.db")

        # connect to db
        self.conn = sqlite3.connect('my_database.db')
        self.cur = self.conn.cursor()

        # create tables
        with open('sql/schema.sql', 'r') as file:
            schema_sql = file.read()
        self.cur.executescript(schema_sql)

        # fill tables with actual data
        data_folder = 'data/'
        csv_files = {
            'category_data.csv': "Categories",
            'cart_data.csv': "Cart",
            'cart_item_data.csv': "Cart_Items",
            'order_data.csv': "Orders",
            'order_items_data.csv': "Order_Items",
            'payment_data.csv': "Payments",
            'product_data.csv': "Products",
            'review_data.csv': "Reviews",
            'shipping_data.csv': "Shipping",
            'user_data.csv': "Users" 
        }
        for csv_file, tab_name in csv_files.items():
            csv_file_path = data_folder + csv_file
            table_name = tab_name

            # Read the CSV file into a pandas DataFrame
            df = pd.read_csv(csv_file_path)

            # Write the data from the DataFrame into the SQL table
            df.to_sql(table_name, self.conn, if_exists='append', index=False)

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sq
        with open('sql/task1.sql', 'r') as file:
            sql_query = file.read()
        
        # task 1 - problem 1
        self.cur.execute('''
SELECT 
    P.product_id,
    P.product_name,
    P.description,
    P.price
FROM 
    Products P
JOIN 
    Categories C ON P.category_id = C.category_id
WHERE 
    C.category_name = 'Sports & Outdoors';
''')
        result = self.cur.fetchall()
        
        # TO-DO
        # task 1 - problem 2
        # task 1 - problem 3
        # task 1 - problem 4

        # Define expected outcome for Task 1 and compare
        expected_result = [
            (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000), 
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54)
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    # TO-DO
    def test_task2(self):
        pass

    # Add more test methods for additional SQL tasks

if __name__ == '__main__':
    unittest.main()
