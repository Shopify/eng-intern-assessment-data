import unittest
import mysql.connector  # Replace with appropriate database connector based on your database

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            dbname='assessment',
            user='root',
            password='nam123',
            host='127.0.0.1',
            port='3306'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        query = """
        SELECT pd
        FROM Products AS pd JOIN Category AS cd
        ON pd.category_id = cd.category_id
        WHERE cd.category_name LIKE '%Sports%';
        """

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.0, 8),
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.0, 8)
        ]

        self.assertEqual(result, expected_result, "Task 1.1: Query output doesn't match expected result.")

        query = """
        SELECT ud.user_id, ud.username, COUNT(od.order_id) AS order_count
        FROM Users AS ud LEFT JOIN Orders AS od 
        ON ud.user_id = od.user_id
        """
        self.cur.execute(query)
        result = self.cur.fetchall()
        expected_result = [
        (1, 'johndoe', 1),
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
        (21, 'sophiawright', 1),
        (22, 'alexanderhill', 1),
        (23, 'madisonmoore', 1),
        (24, 'jamesrogers', 1),
        (25, 'emilyward', 1),
        (26, 'benjamincarter', 1),
        (27, 'gracestewart', 1),
        (28, 'danielturner', 1),
        (29, 'elliecollins', 1),
        (30, 'williamwood', 1)
        ]

        self.assertEqual(result, expected_result, "Task 1.2: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        query = """
        SELECT pd.product_id, pd.product_name, AVG(rd.rating) AS avg_rating
        FROM Products AS pd JOIN Reviews AS rd
        ON pd.product_id = rd.product_id
        GROUP BY pd.product_id, pd.product_name
        ORDER BY avg_rating DESC
        LIMIT 1;
        """

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            (1, 'Smartphone X', 5.0),
            (4, 'Smart TV', 5.0),
            (7, 'Coffee Maker', 5.0),
            (11, 'Yoga Mat', 5.0),
            (15, 'Mountain Bike', 5.0),
        ]

        self.assertEqual(result, expected_result, "Task 2.1: Query output doesn't match expected result.")

    def test_task3(self):
        
        sql_query = """
        SELECT cd.category_id, cd.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
        FROM Categories AS cd
        JOIN Products AS pd ON cd.category_id = pd.category_id
        JOIN Order_Items AS oi ON pd.product_id = oi.product_id
        GROUP BY cd.category_id, cd.category_name
        ORDER BY total_sales DESC
        LIMIT 3;   
        """
        self.cur.execute(sql_query)
        result = self.cur.fetchall()

      
        expected_result = [
            (8, 'Sports & Outdoors', 155.0),
            (4, 'Home & Kitchen', 145.0)
            (1, 'Electronics', 125.0) 
        ]

        self.assertEqual(result, expected_result, "Task 3.1: Query output doesn't match expected result.")

        sql_query = """
        SELECT product_id, product_name, category_id, price
        FROM (
            SELECT 
            product_id, 
            product_name, 
            category_id, 
            price, 
            ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) 
            AS row_num
        FROM Products
        ) AS pd
        WHERE row_num = 1;   
        """
        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        expected_result = [
            (1, 'Smartphone X', 1, 500.0),
            (3, 'Laptop Pro', 2, 1200.0),
            (6, 'Designer Dress', 3, 300.0),
            (7, 'Coffee Maker', 4, 80.0),
            (9, 'Action Camera', 5, 200.0),
            (12, 'Skincare Set', 6, 150.0),
            (14, 'Weighted Blanker', 7, 100.0),
            (15, 'Mountain Bike', 8, 1000.0)
        ]

        self.assertEqual(result, expected_result, "Task 3.2: Query output doesn't match expected result.")

if __name__ == '__main__':
    unittest.main()
