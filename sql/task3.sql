-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Purpose: Retrieve the top 3 categories with the highest total sales amount
-- This query uses CTE to design a table with aggregated sales based on products.
-- then the products are grouped by category and total sales are summed up upon aggregation.
WITH `CategorySales` AS (
    SELECT
		`products`.`product_id`,
		`categories`.`category_name`,
		`categories`.`category_id`,
		SUM(`order_items`.`quantity` * `order_items`.`unit_price`) AS `product_total_sale`
	FROM `categories`
	JOIN `products` ON `categories`.`category_id` = `products`.`category_id`
	JOIN `order_items` ON `order_items`.`product_id` = `products`.`product_id`
	GROUP BY `product_id`
)
SELECT
	`category_id`,
	`category_name`,
    SUM(`product_total_sale`) AS `category_total_sale`
FROM `CategorySales`
GROUP BY `category_id`
ORDER BY`category_total_sale` DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Purpose: Retrieve users who ordered every product in Toys & Games category
-- This query joins users and orders based on user_id, then joins orders and order_items on order_id,
-- then joins order_items and products on product_id, conditioned on only orders in 'Toys & Games'.
-- This will leave us with a table that connects users with their order only in 'Toys & Games' ategory.
-- Next all the distinct user order in 'Toys & Games' is considered and compared to the total number of
-- products in this category. This is enabled by aggregating based on user_id.
SELECT `users`.`user_id`, `users`.`username` FROM `orders`
JOIN `users` ON `orders`.`user_id` = `users`.`user_id`
JOIN `order_items` ON `orders`.`order_id` = `order_items`.`order_id`
JOIN `products` ON `order_items`.`product_id` = `products`.`product_id`
WHERE `products`.`category_id` = (
	SELECT `category_id` FROM `categories`
	WHERE `category_name` = 'Toys & Games'
)
GROUP BY `orders`.`user_id`
HAVING COUNT(DISTINCT `products`.`product_id`) = (
	SELECT COUNT(*) FROM `products`
    WHERE `category_id` = (
		SELECT `category_id` FROM `categories`
		WHERE `category_name` = 'Toys & Games'
	)
);



-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.