-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT Categories.category_id, Categories.category_name, SUM(Order_Items.unit_price * Order_Items.quantity) as total_sales
FROM Categories
  JOIN Products ON Categories.category_id = Products.category_id
  JOIN Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY Categories.category_id
ORDER BY total_sales DESC 
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT Users.user_id, Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_items on Orders.order_id = Order_items.order_id
JOIN Products on Order_items.product_id = Products.product_id
JOIN (SELECT * 
      FROM Categories
      WHERE category_name = "Toys & Games") toys
      on Products.category_id = toys.category_id
GROUP BY Users.user_id
HAVING COUNT(Products.product_id = (SELECT COUNT(Products.product_id)
                                    FROM Products
                                    JOIN (SELECT * FROM Categories WHERE category_name = "Toys & Games") toy_products on Products.category_id = toy_products.category_id); 


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p
WHERE p.price = (
  SELECT MAX(p2.price)
  FROM Products p2
  WHERE p2.category_id = p.category_id
)
ORDER BY p.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT DISTINCT Users.user_id, Users.username
FROM Users 
JOIN Orders o1 ON Users.user_id = o1.user_id
JOIN Orders o2 ON Users.user_id = o2.user_id AND o1.order_date = DATE(o2.order_date, '+1 day')
JOIN Orders o3 ON Users.user_id = o2.user_id AND o2.order_date = DATE(o3.order_date, '+1 day');
