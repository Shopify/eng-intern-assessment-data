-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- find the sales amount in each product in the subquery
-- join tables from categories to order_items
-- Then group by categories with the sum of the each sales_amt get from the subquery
SELECT c.category_id, c.category_name, SUM(sales_amt) AS total_sales_amt
FROM Categories c 
JOIN Products p ON c.category_id = p.category_id
JOIN(
	SELECT oi.product_id, SUM(oi.quantity * oi.unit_price) AS sales_amt
	FROM Order_Items oi
	GROUP BY oi.product_id) AS sq
ON p.product_id = sq.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amt DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- first count the rows in Toys & Games
SELECT u.user_id, u.username
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
WHERE LOWER(c.category_name) = LOWER("Toys & Games")
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
	SELECT COUNT(*)
	FROM Products p
	WHERE p.category_id = (
		SELECT c.category_id
		FROM Categories c
		WHERE LOWER(c.category_name) = LOWER("Toys & Games"))
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- first find the maximum price in each category,
-- then use IN to check whether the category_id and the price is match in the Products table
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p 
WHERE (p.category_id, p.price) IN (
	SELECT p2.category_id, MAX(p2.price)
	FROM Products p2
	GROUP BY p2.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- use window functions to find the users previous date(before order date) and previous date 2 (before previous date)
-- set WHERE to find if these 3 days are consecutive.
SELECT DISTINCT sq.user_id, sq.username
FROM (
    SELECT u.user_id, u.username, o.order_date,
	LAG(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_date,
	LAG(o.order_date, 2) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_date_2
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
) AS sq
WHERE DATEDIFF(sq.order_date, sq.prev_date) = 1 AND DATEDIFF(sq.prev_date, sq.prev_date_2) = 1;