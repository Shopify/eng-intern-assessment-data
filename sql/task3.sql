-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- retrieves the category id, category name, and total sales amount for the top 3 categories with the highest total sales amount
SELECT
	c.category_id,
	c.category_name,
    -- SUM aggregate function to calculate the total sale amount for each category
	SUM(oi.quantity * oi.unit_price) AS total_sale_amt
FROM
	categories c
	JOIN products p ON c.category_id = p.category_id
	JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY
	c.category_id
-- order by total_sale_amt DESC and limit to top 3
ORDER BY
	total_sale_amt DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- retrieves the user ids and usernames of the users who have placed orders for all products in the Toys & Games category

-- defines a toys_games_products CTE that contains all toys & games products
WITH toys_games_products AS (
	SELECT
		*
	FROM
		products p
		JOIN categories c ON p.category_id = c.category_id
	WHERE
		LOWER(c.category_name) LIKE 'toys & games'
)
SELECT
	u.user_id, u.username
FROM
	users u
	JOIN orders o ON u.user_id = o.user_id
	JOIN order_items oi ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
	JOIN categories c ON p.category_id = c.category_id
-- retrieves all Toys & Games products each user has bought
WHERE
	c.category_name = 'Toys & Games'
-- group by user ids
GROUP BY
	u.user_id
-- filters for the users where the number of Toys & Games products 
    -- they have bought is equal to the total number of Toys & Games products
HAVING
	COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM toys_games_products);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- retrieves the product ids, product name, category id, and prices of the products that 
-- have the highest price within each category
SELECT
	p.product_id,
	p.product_name,
	p.category_id,
	p.price
FROM
	products p
-- keeps the products whose price is equal to the max price in its category
WHERE
	p.price = (
        -- subquery to get the max price within each category
		SELECT
			MAX(price)
		FROM
			products
		WHERE
			category_id = p.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- retrieves the user ids and usernames of the users who have placed orders on consecutive days for at least 3 days

-- SELECT DISTINCT to avoid having the same user twice in the result
-- needed since for example, a 4 day span will include two 3 consecutive day spans
SELECT DISTINCT
	u.user_id,
	u.username
FROM (
    -- subquery to retrieve user_id, order_date, the next_order_date, and the next_next_order_date
    -- NOTE: it is enough to only check for 3 days because anything > 3 days will be included in this query still
	SELECT
		o.user_id,
		o.order_date,
        -- LEAD window function to get the next_order_date and next_next_order_date
		LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
        LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_next_order_date
	FROM
		orders o) AS sub
	JOIN users u ON sub.user_id = u.user_id
    -- Filtering the results to include only the users who have made consecutive orders on 3 consecutive days
WHERE
    sub.order_date = sub.next_order_date - INTERVAL '1 day'
    AND sub.order_date = sub.next_next_order_date - INTERVAL '2 days';