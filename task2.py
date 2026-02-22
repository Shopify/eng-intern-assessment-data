#Task 2 in python format
#Code by Shaun Meric Menezes
import sqlite3

#Connecting to the Sqlitedatabase
try:
    conn = sqlite3.connect('webstore.db')
    c = conn.cursor()
except:
    print("Database not found!")


#Problem 5: Retrieve the products with the highest average rating
#Write an SQL query to retrieve the products with the highest average rating.
#The result should include the product ID, product name, and the average rating.
#Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
try:
    c.execute("""
    SELECT p.product_id, p.product_name, r.AverageRating 
    FROM Products p 
    JOIN (
        SELECT product_id, AVG(rating) as AverageRating 
        FROM Reviews 
        GROUP BY product_id
    ) r ON p.product_id = r.product_id 
    WHERE r.AverageRating = (
        SELECT MAX(AverageRating) 
        FROM (
            SELECT AVG(rating) as AverageRating 
            FROM Reviews 
            GROUP BY product_id
        )
    )
    """)
    highest_rated_products = c.fetchall()
    print("Products with the highest average rating:", highest_rated_products)
except:
    print("Unable to run Query!")

#Problem 6: Retrieve the users who have made at least one order in each category
#Write an SQL query to retrieve the users who have made at least one order in each category.
#The result should include the user ID and username.
#Hint: You may need to use subqueries or joins to solve this problem.
try:
    c.execute("""
    SELECT u.user_id, u.username 
    FROM Users u 
    WHERE NOT EXISTS (
        SELECT c.category_id 
        FROM Categories c 
        WHERE NOT EXISTS (
            SELECT o.order_id 
            FROM Orders o 
            JOIN Order_Items oi ON o.order_id = oi.order_id 
            JOIN Products p ON oi.product_id = p.product_id 
            WHERE o.user_id = u.user_id AND p.category_id = c.category_id
        )
    )
    """)
    users_ordered_all_categories = c.fetchall()
    print("Users who have made at least one order in each category:", users_ordered_all_categories)
except:
    print("Unable to run Query!")

#Problem 7: Retrieve the products that have not received any reviews
#Write an SQL query to retrieve the products that have not received any reviews.
#The result should include the product ID and product name.
#Hint: You may need to use subqueries or left joins to solve this problem.
try:
    c.execute("""
    SELECT p.product_id, p.product_name 
    FROM Products p 
    LEFT JOIN Reviews r ON p.product_id = r.product_id 
    WHERE r.review_id IS NULL
    """)
    unreviewed_products = c.fetchall()
    print("Products that have not received any reviews:", unreviewed_products)
except:
    print("Unable to run Query!")

#Problem 8: Retrieve the users who have made consecutive orders on consecutive days
#Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
#The result should include the user ID and username.
#Hint: You may need to use subqueries or window functions to solve this problem.
try:
    c.execute("""
    SELECT u.user_id, u.username 
    FROM Users u 
    JOIN (
        SELECT o1.user_id 
        FROM Orders o1 
        JOIN Orders o2 ON o1.user_id = o2.user_id 
        WHERE julianday(o2.order_date) - julianday(o1.order_date) = 1
    ) o ON u.user_id = o.user_id
    """)
    consecutive_orders_users = c.fetchall()
    print("Users who have made consecutive orders on consecutive days:", consecutive_orders_users)
except:
    print("Unable to run Query!")


#closeing the connection
conn.close()