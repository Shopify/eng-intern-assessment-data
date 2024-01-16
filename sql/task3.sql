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

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.