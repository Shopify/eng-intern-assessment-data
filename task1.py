#Task 1 in python format
#Code by Shaun Meric Menezes
import sqlite3

#Connecting to the Sqlitedatabase
try:
    conn = sqlite3.connect('webstore.db')
    c = conn.cursor()
except:
    print("Database not found!")

#Problem 1: Retrieve all products in the Sports category
#Write an SQL query to retrieve all products in a specific category.
try:
    c.execute("""
    SELECT p.product_id, p.product_name FROM Products p JOIN Categories c ON p.category_id = c.category_id WHERE c.category_name = 'Sports & Outdoors'
    """)
    products_in_sports = c.fetchall()
    print("Products in Sports category:", products_in_sports)
except:
    print("Unable to run Query!")



#Problem 2: Retrieve the total number of orders for each user
#Write an SQL query to retrieve the total number of orders for each user.
#The result should include the user ID, username, and the total number of orders.
try:
    c.execute("""
    SELECT u.user_id, u.username, COUNT(o.order_id) as TotalOrders FROM Users u JOIN Orders o ON u.user_id = o.user_id GROUP BY u.user_id
    """)
    user_orders = c.fetchall()
    print("Total number of orders for each user:", user_orders)
except:
    print("Unable to run Query!")


#Problem 3: Retrieve the average rating for each product
#Write an SQL query to retrieve the average rating for each product.
#The result should include the product ID, product name, and the average rating.
try:
    c.execute("""
    SELECT p.product_id, p.product_name, AVG(r.rating) as AverageRating FROM Products p JOIN Reviews r ON p.product_id = r.product_id GROUP BY p.product_id
    """)
    product_ratings = c.fetchall()
    print("Average rating for each product:", product_ratings)
except:
    print("Unable to run Query!")


#Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
#Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
#The result should include the user ID, username, and the total amount spent.
try:
    c.execute("""
    SELECT u.user_id, u.username, SUM(o.total_amount) as TotalSpent FROM Users u JOIN Orders o ON u.user_id = o.user_id GROUP BY u.user_id ORDER BY TotalSpent DESC LIMIT 5
    """)
    top_spenders = c.fetchall()
    print("Top 5 users with the highest total amount spent on orders:", top_spenders)
except:
    print("Unable to run Query!")


#closeing the connection
conn.close()