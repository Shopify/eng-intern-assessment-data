#Task 3 in python format
#Code by Shaun Meric Menezes
import sqlite3

#Connecting to the Sqlitedatabase
try:
  conn = sqlite3.connect('webstore.db')
  cur = conn.cursor()
except:
  print("Database not found!")

#Problem 9: Retrieve the top 3 categories with the highest total sales amount
#Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
#The result should include the category ID, category name, and the total sales amount.
#Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
try:
  cur.execute("""
  SELECT c.category_id, c.category_name, SUM(oi.unit_price * oi.quantity) AS total_sales_amount
  FROM Categories c
  JOIN Products p ON c.category_id = p.category_id
  JOIN Order_Items oi ON p.product_id = oi.product_id
  GROUP BY c.category_id, c.category_name
  ORDER BY total_sales_amount DESC
  LIMIT 3;
  """)
  print(cur.fetchall())
except:
  print("Unable to run Query!")


#Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
#Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
#The result should include the user ID and username.
#Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
try:
  cur.execute("""
  SELECT u.user_id, u.username
  FROM Users u
  WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products p
    WHERE p.category_id = (SELECT c.category_id FROM Categories c WHERE c.category_name = 'Toys & Games')
    AND p.product_id NOT IN (
      SELECT oi.product_id
      FROM Order_Items oi
      JOIN Orders o ON oi.order_id = o.order_id
      WHERE o.user_id = u.user_id
    )
  );
  """)
  print(cur.fetchall())
except:
  print("Unable to run Query!")


#Problem 11: Retrieve the products that have the highest price within each category
#Write an SQL query to retrieve the products that have the highest price within each category.
#The result should include the product ID, product name, category ID, and price.
#Hint: You may need to use subqueries, joins, and window functions to solve this problem.
try:
  cur.execute("""
  SELECT p.product_id, p.product_name, p.category_id, p.price
  FROM Products p
  JOIN (
    SELECT category_id, MAX(price) AS max_price
    FROM Products
    GROUP BY category_id
  ) subq ON p.category_id = subq.category_id AND p.price = subq.max_price;
  """)
  print(cur.fetchall())
except:
  print("Unable to run Query!")


#Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
#Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
#The result should include the user ID and username.
#Hint: You may need to use subqueries, joins, and window functions to solve this problem.
try:
  cur.execute("""
  SELECT u.user_id, u.username
  FROM Users u
  JOIN (
    SELECT o.user_id
    FROM Orders o
    WHERE EXISTS (
      SELECT 1
      FROM Orders o2
      WHERE o.user_id = o2.user_id AND ABS(julianday(o.order_date) - julianday(o2.order_date)) BETWEEN 1 AND 2
      GROUP BY o2.user_id
      HAVING COUNT(DISTINCT DATE(o2.order_date)) >= 3
    )
  ) subq ON u.user_id = subq.user_id;
  """)
  print(cur.fetchall())
except:
  print("Unable to run Query!")

#closeing the connection
conn.close()