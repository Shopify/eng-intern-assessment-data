import unittest
import mysql.connector # Replace with appropriate database connector based on your database
from decimal import Decimal
class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        print("in here")
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            database='task',
            user='root',
            password='shirin23',
            host='127.0.0.1',
            port='3306'
        )
        self.cur = self.conn.cursor()
        print("Done here")

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Retrieve all products in the Sports & Outdoors category
        query = """
        SELECT p.product_id, p.product_name, p.description, p.price
        FROM Products p
        INNER JOIN Categories c ON p.category_id = c.category_id
        WHERE c.category_name = 'Sports & Outdoors';
        """
        self.cur.execute(query)
        result = self.cur.fetchall()
        expected_result = [
            (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.0),
            (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.0),
        ]
        self.assertEqual(result, expected_result, "Task 1.1: Query output doesn't match expected result.")

        query = """
        SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
        FROM Users u
        LEFT JOIN Orders o ON u.user_id = o.user_id
        GROUP BY u.user_id;
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
        
        query = """
                
        WITH RatedProducts AS (
        SELECT
            product_id,
            AVG(rating) AS average_rating
        FROM Reviews
        GROUP BY product_id
        )
        SELECT p.product_id, p.product_name, rp.average_rating
        FROM Products p
        JOIN RatedProducts rp ON p.product_id = rp.product_id
        WHERE rp.average_rating = (SELECT MAX(average_rating) FROM RatedProducts);


        """
        self.cur.execute(query)
        result = self.cur.fetchall()

        
        expected_result = [
            (1, 'Smartphone X', Decimal('5.0000')),
            (4, 'Smart TV', Decimal('5.0000')),
            (7, 'Coffee Maker', Decimal('5.0000')),
            (11, 'Yoga Mat', Decimal('5.0000')),
            (15, 'Mountain Bike', Decimal('5.0000')),
            
        ]

        
        result.sort(key=lambda x: x[0])
        expected_result.sort(key=lambda x: x[0])

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        
        sql_query = """
        SELECT C.category_id, C.category_name, SUM(P.price * OI.quantity) AS total_sales
        FROM Categories C
        JOIN Products P ON C.category_id = P.category_id
        JOIN Order_Items OI ON P.product_id = OI.product_id
        GROUP BY C.category_id, C.category_name
        ORDER BY total_sales DESC
        LIMIT 3;
        """
        self.cur.execute(sql_query)
        result = self.cur.fetchall()

      
        expected_result = [
            (2, 'Books', 4400.00),
            (8, 'Sports & Outdoors', 3000.00),
            (1, 'Electronics', 1150.00)
        ]

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")


if __name__ == '__main__':
    unittest.main()