import unittest
import mysql.connector
import os
import csv
import configparser


class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.config = configparser.ConfigParser()
        self.config.read('config.ini')
        self.config.read('config.ini')
        self.conn = mysql.connector.connect(
            host=self.config['database']['host'],
            port=self.config['database']['port'],
            user=self.config['database']['username'],
            password=self.config['database']['password'],
            database=self.config['database']['database'],
        )
        self.cur = self.conn.cursor()
        self.create_tables()
        self.insert_data_into_tables()

    def create_tables(self):
        with open(os.path.join(self.config['paths']['sql_dir'], 'schema.sql'), 'r') as file:
            sql_query = file.read()
            sql_queries = sql_query.split(';')[:10]
            for sql_query in sql_queries:
                self.cur.execute(sql_query)
            self.conn.commit()

    def insert_data_into_tables(self):
        table_names = [
            "categories",
            "products",
            "users",
            "orders",
            "order_items",
            "reviews",
            "cart",
            "cart_items",
            "payments",
            "shipping"
        ]

        filenames = [
            "category_data.csv",
            "product_data.csv",
            "user_data.csv",
            "order_data.csv",
            "order_items_data.csv",
            "review_data.csv",
            "cart_data.csv",
            "cart_item_data.csv",
            "payment_data.csv",
            "shipping_data.csv"
        ]

        for index, table in enumerate(table_names):
            with open(os.path.join(self.config['paths']['data_dir'], filenames[index]), 'r') as file:
                csv_data = csv.reader(file)
                next(csv_data)
                for row in csv_data:
                    sql_query = f"INSERT INTO {table} VALUES ({', '.join(['%s'] * len(row))})"
                    self.cur.execute(sql_query, tuple(row))
                self.conn.commit()

    def tearDown(self):
        # Drop the tables from the test database
        self.cur.execute(
            "DROP TABLE `cart`, `cart_items`, `categories`, `order_items`, `orders`, `payments`, `products`, `reviews`, `shipping`, `users`;")
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open(os.path.join(self.config['paths']['sql_dir'], 'task1.sql'), 'r') as file:
            sql_query = file.read()
            sql_queries = sql_query.split(';')[:3]

        # Define expected outcome for Task 1 and compare
        expected_result = [
            [(1, 'Smartphone X', 'The Smartphone X is a powerful and feature-rich device that offers a seamless user experience. It comes with a high-resolution display', float('500.00'), 1),
             (2, 'Wireless Headphones', 'Experience the freedom of wireless audio with these high-quality headphones. They offer crystal-clear sound and a comfortable fit', float('150.00'), 1)
             ],
            [(1, 'johndoe', 1),
             (2, 'janesmith', 1),
             (3, 'maryjones', 1),
             (4, 'robertbrown', 1),
             (5, 'sarahwilson', 1),
             (6, 'michaellee', 1),
             (7, 'lisawilliams', 1),
             (8, 'chrisharris', 1),
             (9, 'emilythompson', 1),
             (10, 'davidmartinez', 1),
             (11, 'amandajohnson', 1),
             (12, 'jasonrodriguez', 1),
             (13, 'ashleytaylor', 1),
             (14, 'matthewthomas', 1),
             (15, 'sophiawalker', 1),
             (16, 'jacobanderson', 1),
             (17, 'olivialopez', 1),
             (18, 'ethanmiller', 1),
             (19, 'emilygonzalez', 1),
             (20, 'williamhernandez', 1),
             (21, 'sophiawright', 1), (22, 'alexanderhill', 1),
             (23, 'madisonmoore', 1),
             (24, 'jamesrogers', 1),
             (25, 'emilyward', 1),
             (26, 'benjamincarter', 1),
             (27, 'gracestewart', 1),
             (28, 'danielturner', 1),
             (29, 'elliecollins', 1),
             (30, 'williamwood', 4)],
            [(1, 'Smartphone X', 5.0),
             (2, 'Wireless Headphones', 4.0),
             (3, 'Laptop Pro', 3.0),
             (4, 'Smart TV', 5.0),
             (5, 'Running Shoes', 2.0),
             (6, 'Designer Dress', 4.0),
             (7, 'Coffee Maker', 5.0),
             (8, 'Toaster Oven', 3.0),
             (9, 'Action Camera', 4.0),
             (10, 'Board Game Collection', 1.0),
             (11, 'Yoga Mat', 5.0),
             (12, 'Skincare Set', 4.0),
             (13, 'Vitamin C Supplement', 2.0),
             (14, 'Weighted Blanket', 3.0),
             (15, 'Mountain Bike', 5.0),
             (16, 'Tennis Racket', 4.0),
             (17, 'Backpack', 3.0),
             (18, 'Travel Bag', 5.0),
             (19, 'Bluetooth Speaker', 2.0),
             (20, 'Wireless Earbuds', 4.0),
             (21, 'Smartwatch', 5.0),
             (22, 'Wireless Mouse', 3.0),
             (23, 'Wireless Keyboard', 4.0),
             (24, 'External Hard Drive', 1.0),
             (25, 'Portable Monitor', 5.0),
             (26, 'External SSD', 4.0),
             (27, 'Wireless Charger', 2.0),
             (28, 'Power Bank', 3.0),
             (29, 'Wireless Router', 5.0),
             (30, 'Mesh Wi-Fi System', 4.0)
             ],
            [
                (30, 'williamwood', 410.00),
                (12, 'jasonrodriguez', 160.00),
                (4, 'robertbrown', 155.00),
                (24, 'jamesrogers', 150.00),
                (8, 'chrisharris', 150.00),
                (17, 'olivialopez', 145.00)
            ],
        ]
        for index, sql_query in enumerate(sql_queries):
            self.cur.execute(sql_query)
            result = self.cur.fetchall()

            self.assertEqual(result, expected_result[index],
                             "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open(os.path.join(self.config['paths']['sql_dir'], 'task2.sql'), 'r') as file:
            sql_query = file.read()
            sqk_queries = sql_query.split(';')[:3]

        expected_result = [
            [
                (1, 'Smartphone X', 5.0),
                (4, 'Smart TV', 5.0),
                (7, 'Coffee Maker', 5.0),
                (11, 'Yoga Mat', 5.0),
                (15, 'Mountain Bike', 5.0),
                (18, 'Travel Bag', 5.0),
                (21, 'Smartwatch', 5.0),
                (25, 'Portable Monitor', 5.0),
                (29, 'Wireless Router', 5.0)
            ],
            [],
            [
                (31, 'Smart Thermostat'),
                (32, 'Smart Light Bulb'),
                (33, 'Smart Plug'),
                (34, 'Smart Doorbell'),
                (35, 'Robot Vacuum'),
                (36, 'Smart Vacuum'),
                (37, 'Smart Microwave'),
                (38, 'Smart Fridge'),
                (39, 'Smart Oven'),
                (40, 'Smart Dishwasher')
            ],
            [
                (30, 'williamwood'),
            ]
        ]

        for index, sql_query in enumerate(sqk_queries):
            self.cur.execute(sql_query)
            result = self.cur.fetchall()

            self.assertEqual(result, expected_result[index],
                             "Task 2: Query output doesn't match expected result.")

    # Add more test methods for additional SQL tasks

    def test_task3(self):

        with open(os.path.join(self.config['paths']['sql_dir'], 'task3.sql'), 'r') as file:
            sql_query = file.read()
            sql_quries = sql_query.split(';')[:3]

        expected_result = [
            [   (15, 'Movies & TV', 355),
                (8, 'Sports & Outdoors', 155),
                (4, 'Home & Kitchen', 145),
            ],
            [
                (5, 'sarahwilson')
            ],
            [
                (1, 'Smartphone X', 1, 500.00),
                (3, 'Laptop Pro', 2, 1200.00),
                (6, 'Designer Dress', 3, 300.00),
                (7, 'Coffee Maker', 4, 80.00),
                (9, 'Action Camera', 5, 200.00),
                (12, 'Skincare Set', 6, 150.00),
                (14, 'Weighted Blanket', 7, 100.00),
                (15, 'Mountain Bike', 8, 1000.00),
                (18, 'Travel Bag', 9, 60.00),
                (20, 'Wireless Earbuds', 10, 100.00),
                (21, 'Smartwatch', 11, 200.00),
                (24, 'External Hard Drive', 12, 100.00),
                (25, 'Portable Monitor', 13, 200.00),
                (28, 'Power Bank', 14, 50.00),
                (30, 'Mesh Wi-Fi System', 15, 200.00),
                (31, 'Smart Thermostat', 16, 100.00),
                (34, 'Smart Doorbell', 17, 100.00),
                (36, 'Smart Vacuum', 18, 300.00),
                (38, 'Smart Fridge', 19, 200.00),
                (40, 'Smart Dishwasher', 20, 400.00)
            ],
            [
                (30, 'williamwood'),
            ]
        ]

        for index, sql_query in enumerate(sql_quries):
            self.cur.execute(sql_query)
            result = self.cur.fetchall()

            self.assertEqual(result, expected_result[index],
                             "Task 3: Query output doesn't match expected result.")


if __name__ == '__main__':
    unittest.main()
