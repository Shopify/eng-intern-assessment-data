-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT * 
FROM (SELECT pr.category_id,
		cat.category_name,
		SUM(oi.quantity*pr.price) AS sales
	FROM orders AS o
	LEFT JOIN order_items as oi
		ON o.order_id = oi.order_id
	LEFT JOIN products as pr
		ON pr.product_id = oi.product_id
	LEFT JOIN categories as cat
		ON pr.category_id = cat.category_id
	GROUP BY pr.category_id, cat.category_name
	)
WHERE sales IS NOT NULL
ORDER BY sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT *
FROM (
	SELECT u.user_id, COUNT (DISTINCT pr.product_id) AS unique_toy_prod
	FROM orders AS o
	LEFT JOIN users AS u
		ON u.user_id = o.user_id
	LEFT JOIN order_items AS oi
		ON o.order_id = oi.order_id
	LEFT JOIN products AS pr
		ON pr.product_id = oi.product_id
	LEFT JOIN categories AS cat
		ON pr.category_id = cat.category_id
	WHERE cat.category_name='Toys & Games'
	GROUP BY u.user_id
	)
WHERE unique_toy_prod = (
	SELECT COUNT(DISTINCT pr.product_id)
	FROM products AS pr
	LEFT JOIN categories AS cat
		ON cat.category_id = pr.category_id
	WHERE cat.category_name = 'Toys & Games'
	);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT product_id, product_name, category_id, price
FROM (
	SELECT pr.product_id,
		pr.product_name,
		pr.category_id,
		pr.price, 
		MAX(pr.price) OVER (PARTITION BY pr.category_id) AS cat_max_price
	FROM products AS pr
	LEFT JOIN categories AS cat
		ON pr.category_id = cat.category_id
	ORDER BY pr.category_id
	)
WHERE price = cat_max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT user_id, username
FROM (
	SELECT u.user_id, u.username, (order_date-lag_1)+(order_date-lag_2) AS days
	FROM (
		SELECT *,
			LAG(order_date, 1)
				OVER (
					PARTITION BY user_id
					ORDER BY order_date
				) AS lag_1,
			LAG(order_date, 2)
				OVER (
					PARTITION BY user_id
					ORDER BY order_date
				) AS lag_2
		FROM orders AS o
		) AS date_data
	LEFT JOIN users AS u
		ON date_data.user_id = u.user_id
	)
WHERE days = 3;