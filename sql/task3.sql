-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.unit_price * oi.quantity) AS total_sales_amount FROM categories AS c
JOIN products AS p ON p.category_id = c.category_id
JOIN order_items AS oi ON oi.product_id = p.product_id
GROUP BY c.category_id, c.category_name 
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username FROM Users AS u
JOIN Orders o ON u.user_id = o.user_id 
WHERE NOT EXISTS (
    SELECT p.product_id FROM Products AS p
    WHERE p.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games') 
	  AND p.product_id NOT IN (
        SELECT oi.product_id FROM order_items oi
        WHERE oi.order_id = o.order_id
      )
  )
GROUP BY u.user_id, u.username;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH price_rankings AS (
	SELECT
		p.product_id, 
		p.product_name,
		c.category_id,
		p.price,
		DENSE_RANK() OVER (PARTITION BY c.category_id ORDER BY p.price DESC) AS ranking
		FROM products AS p
		JOIN categories AS c ON c.category_id = p.category_id
)
SELECT product_id, product_name, category_id, price FROM price_rankings
WHERE ranking = 1;
 

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH date_groups AS ( 
	SELECT 
		u.user_id, 
		u.username, 
		o.order_date,
		LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) as previous_order_date
		FROM users AS u
		JOIN orders AS o ON o.user_id = u.user_id
)
SELECT dg1.user_id, dg1.username FROM date_groups AS dg1
JOIN date_groups AS dg2 ON dg1.order_date = dg2.previous_order_date
WHERE dg1.previous_order_date = dg1.order_date - INTERVAL'1 day' 
AND dg2.previous_order_date = dg2.order_date - INTERVAL'1 day'
GROUP BY dg1.user_id, dg1.username;
