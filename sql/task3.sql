-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, sum(o.total_amount) FROM categories c
INNER JOIN products p on c.category_id = p.category_id
INNER JOIN order_items oi on p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
GROUP BY c.category_id, c.category_name
ORDER BY sum(o.total_amount) DESC LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username FROM users u
INNER JOIN orders o on u.user_id = o.user_id
INNER JOIN order_items oi on oi.order_id=o.order_id
INNER JOIN products p on p.product_id=oi.product_id
INNER JOIN categories c on p.category_id = c.category_id
WHERE c.category_name='Toys & Games'
GROUP BY u.user_id, u.username
HAVING (SELECT count( DISTINCT p.product_id)) = (SELECT COUNT(DISTINCT p1.product_id) FROM products p1
    INNER JOIN categories c2 on c2.category_id = p1.category_id);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--  ???

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--- ???