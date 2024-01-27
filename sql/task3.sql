-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(o.amount) AS total_sales
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN orders o ON p.product_id = o.product_id
GROUP BY c.category_id
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
WHERE p.category = 'Toys & Games'
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(product_id) FROM products WHERE category = 'Toys & Games');

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT product_id, product_name, category_id, price,
           RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as rank
    FROM products
)
SELECT product_id, product_name, category_id, price
FROM RankedProducts
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderedDates AS (
    SELECT user_id, order_date,
           LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date,
           LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date_2
    FROM orders
)
SELECT DISTINCT u.user_id, u.username
FROM users u
JOIN OrderedDates od ON u.user_id = od.user_id
WHERE od.order_date = od.prev_date + INTERVAL '1 day'
AND od.prev_date = od.prev_date_2 + INTERVAL '1 day';
