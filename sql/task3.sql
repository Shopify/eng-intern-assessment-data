-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
-- Selecting the category ID, category name, and the total sales amount for the top 3 categories
SELECT c.category_id, c.category_name, SUM(oi.total_price) AS total_sales_amount
FROM Categories c
-- Joining the 'Products' table to get product details
JOIN Products p ON c.category_id = p.category_id
-- Joining the 'Order_Items' table to get order item details
JOIN Order_Items oi ON p.product_id = oi.product_id
-- Grouping the results by category_id to calculate the total sales amount per category
GROUP BY c.category_id, c.category_name
-- Ordering the results by total_sales_amount in descending order to get the highest sales at the top
ORDER BY total_sales_amount DESC
-- Limiting the results to the top 3 categories
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Selecting the user ID and username for users who have placed orders for all products in 'Toys & Games'
SELECT u.user_id, u.username
FROM Users u
-- Joining the Orders table to get order details
JOIN Orders o ON u.user_id = o.user_id
-- Joining the 'Order_Items' table to get order item details
JOIN Order_Items oi ON o.order_id = oi.order_id
-- Joining the Products table to get product details for Toys & Games
JOIN Products p ON oi.product_id = p.product_id AND p.category_id = 'Toys & Games'
-- Grouping the results by user_id to count unique products ordered by each user
GROUP BY u.user_id, u.username
-- Having count of distinct products equal to the total number of products in 'Toys & Games'
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = 'Toys & Games');


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Selecting the product ID, product name, category ID, and price for products with the highest price in each category
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p
-- Using RANK to assign ranks to products based on price within each category
-- PARTITION BY is used to restart the ranking for each category
-- The outer query then filters for products with rank 1 (highest price) within each category
WHERE RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Selecting the user ID and username for users who have placed orders on consecutive days for at least 3 days
SELECT DISTINCT u.user_id, u.username
FROM Users u
-- Join the 'Orders' table to get order details
JOIN Orders o ON u.user_id = o.user_id
-- Using LAG to compare each order date to the previous one per user
-- PARTITION BY is used to restart the comparison for each user
-- The outer query then filters for consecutive orders (difference in days = 1) for at least 3 days
WHERE DATEDIFF(o.order_date, LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date)) = 1
  AND DATEDIFF(o.order_date, LAG(o.order_date, 2) OVER (PARTITION BY u.user_id ORDER BY o.order_date)) = 2;


