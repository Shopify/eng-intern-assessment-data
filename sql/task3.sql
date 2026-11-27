-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT TOP 3 c.category_id, c.category_name, SUM(p.price) AS total_sales_amount
FROM Categories c, Products p, Orders o, Order_Items i
WHERE o.order_id = i.order_id
AND p.product_id = i.product_id
AND c.category_id = p.category_id
GROUP BY category_id, category_name
ORDER BY total_sales_amount DESC;
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM Products p, Users u, Categories c, Order_Items i, Orders o
WHERE p.category_id = c.category_id
AND u.user_id = o.user_id
AND p.product_id = i.product_id
AND o.order_id = i.order_id
AND c.category_name = "Toys & Games"
GROUP BY u.user_id, u.username
HAVING (COUNT(DISTINCT product_id) = (SELECT COUNT(*) FROM Products WHERE category_name="Toys & Games"))
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p,
(SELECT p1.category_id, MAX(p1.price) AS max_price FROM Products p1 GROUP BY p1.category_id) s
WHERE p.category_id = s.category_id
AND p.price = s.max_price;
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT u.user_id, u.username
FROM Username u, Orders o1, Orders o2, Orders o3
WHERE u.user_id = o1.user_id
AND u.user_id = o2.user_id
AND u.user_id = o3.user_id
AND o1.order_id != o2.order_id
AND o2.order_id != o3.order_id
AND o1.order_id != o3.order_id
AND (DAY(o1.order_date) - DAY(o2.order_date)) = 1
AND (DAY(o2.order_date) - DAY(o3.order_date)) = 1
GROUP BY u.user_id, u.username