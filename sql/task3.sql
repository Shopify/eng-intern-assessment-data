-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT TOP 3 c.category_id, c.category_name, COALESCE(SUM(o.total_amount), 0) AS "Total Sales"
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
LEFT JOIN Orders o ON oi.order_id = o.order_id
GROUP BY c.category_id, c.category_name
ORDER BY [Total Sales] DESC;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT DISTINCT u.user_id, u.username, c.category_id
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name LIKE '%Toys & Games%';

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedPrices AS (
	SELECT p.product_id, p.product_name, p.price,c.category_id,
	ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY p.price DESC) AS PriceRank
	FROM Categories c
	LEFT JOIN Products p on c.category_id = p.category_id
	)

SELECT product_id, product_name, price,category_id
FROM RankedPrices
WHERE PriceRank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH PreviousOrders as (
	SELECT *, 
		LAG(order_date) OVER( PARTITION BY user_id ORDER BY order_date) as "Previous Order" 
	FROM Orders
	),

ConsecutiveOrders as (
	SELECT po.user_id, u.username, COUNT(*) as "Number of Consecutive Orders"FROM PreviousOrders po
	JOIN  Users u ON po.user_id = u.user_id
	WHERE DATEDIFF(day, [Previous Order], order_date) = 1
	GROUP BY po.user_id, u.username 
)

SELECT user_id, username FROM ConsecutiveOrders
WHERE [Number of Consecutive Orders] >2