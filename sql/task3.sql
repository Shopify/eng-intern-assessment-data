-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Categories.category_id, category_name, SUM(unit_price * quantity)
FROM Categories JOIN Products ON Categories.category_id = Products.category_id
JOIN Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY Categories.category_id
ORDER BY SUM(unit_price * quantity) DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Users.user_id, username
FROM Users JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Products ON Order_Items.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
WHERE category_name = 'Toys & Games'
GROUP BY Users.user_id
HAVING COUNT(DISTINCT Products.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH ProductWithinCategoryRanking AS (
  SELECT product_id, product_name, category_id, price, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS product_rank
  FROM Products
)
SELECT product_id, product_name, category_id, price
FROM ProductWithinCategoryRanking
WHERE product_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT Users.user_id, username 
FROM Users JOIN Orders O1 ON Users.user_id = O1.user_id
JOIN Orders O2 ON Users.user_id = O2.user_id AND O1.order_date = O2.order_date + 1
JOIN Orders O3 ON Users.user_id = O3.user_id AND O2.order_date = O3.order_date + 1;