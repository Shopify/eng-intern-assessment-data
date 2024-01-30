-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Categories.category_id, Categories.category_name, SUM(Orders.total_amount) AS total_sales_amount
FROM Categories
INNER JOIN Products ON Categories.category_id = Products.category_id
INNER JOIN Order_Items ON Products.product_id = Order_Items.product_id
INNER JOIN Orders ON Order_Items.order_id = Orders.order_id
GROUP BY Categories.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Users.user_id, Users.username
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
INNER JOIN Products ON Order_Items.product_id = Products.product_id
INNER JOIN Categories ON Products.category_id = Categories.category_id
WHERE Categories.category_name LIKE '%Toys & Games%'
GROUP BY Users.user_id


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT Products.product_id, Products.product_name, Products.category_id, Products.price
FROM Products
INNER JOIN Categories ON Products.category_id = Categories.category_id
WHERE Products.price = (SELECT MAX(Products.price) FROM Products WHERE Products.category_id = Categories.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT Users.user_id, Users.username
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
WHERE Orders.order_date BETWEEN CURRENT_DATE - INTERVAL '3 DAYS' AND CURRENT_DATE - INTERVAL '1 DAY';


