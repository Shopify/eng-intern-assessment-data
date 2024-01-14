-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Select category ID, category name, and the total sales amount (aggregate function 'SUM') 
-- as columns from a joined table between 'Categories', 'Products', and 'Order_Items' matched on 
-- category_id and product_id columns. Groupby is then performed to aggregate the data by category_id and category_name, 
-- followed by ordering the results in descending order based on total sales amount. 
-- The LIMIT clause is applied to retrieve the top three categories with the highest sales.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amt
FROM Categories c
JOIN Products p ON c.category_id = p.category_id 
JOIN Order_Items oi ON p.product_id = oi.product_id 
GROUP BY c.category_id, c.category_name 
ORDER BY total_sales_amt DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Select user ID and username from a joined table of Users, Orders, Order_Items, Products, and Categories,
-- filtered to include only users who purchased products in the "Toys & Games" category.
-- Groups by user ID and username, and applies a HAVING clause to retain users with the same
-- number of distinct product IDs as the total number of distinct products in the "Toys & Games" category.

SELECT u.user_id, u.username
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
WHERE LOWER(c.category_name) = LOWER("Toys & Games")
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
	SELECT COUNT(DISTINCT p.product_id)
	FROM Products p
	WHERE p.category_id = (
		SELECT c.category_id
		FROM Categories c
		WHERE LOWER(c.category_name) = LOWER("Toys & Games")));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Select product ID, product name, category ID, and price from the Products table,
-- filtering products where the combination of category ID and price matches the maximum price
-- within each category, as determined by the inner subquery.

SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p 
WHERE (p.category_id, p.price) IN (
	SELECT pr.category_id, MAX(pr.price)
	FROM Products pr
	GROUP BY pr.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Select distinct user ID and username from a subquery combining user information and order details,
-- including the order date and two lagged order dates.
-- Filters the results to retain users with consecutive order dates (for at least 3 days)

SELECT DISTINCT dt.user_id, dt.username
FROM (
    SELECT u.user_id, u.username, o.order_date,
	LAG(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS day_minus_1,
	LAG(o.order_date, 2) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS day_minus_2
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
) AS dt
WHERE ABS(DATEDIFF(day, dt.order_date, dt.day_minus_1)) = 1 AND ABS(DATEDIFF(day, dt.day_minus_1, dt.day_minus_2)) = 1;