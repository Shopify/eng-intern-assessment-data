-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT categories.category_id, categories.category_name, SUM(order_items.quantity * order_items.unit_price) AS total_sales_amount 
FROM categories
JOIN products ON categories.category_id = products.category_id
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
GROUP BY categories.category_id, categories.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT users.user_id, users.username 
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id
WHERE products.category_id = (SELECT category_id FROM categories WHERE category_name = 'Toys & Games')
GROUP BY users.user_id, users.username
-- The logic here is that if the number of distinct products that the user has ordered from is equal to the total number of products in the Toys & Games category,
-- then the user has placed orders for all products in the Toys & Games category
HAVING COUNT(DISTINCT products.product_id) = (SELECT COUNT(*) FROM products WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Toys & Games'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT products.product_id, products.product_name, products.category_id, products.price 
FROM products
JOIN categories ON products.category_id = categories.category_id
-- The subquery selects the highest price for each category
WHERE products.price = (SELECT MAX(price) FROM products WHERE category_id = categories.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem

WITH cte AS (
    SELECT users.user_id, users.username, orders.order_date, 
    LAG(orders.order_date) OVER (PARTITION BY users.user_id ORDER BY orders.order_date) AS previous_order_date
    FROM users
    JOIN orders ON users.user_id = orders.user_id
)

SELECT DISTINCT user_id, username
FROM cte
-- If the previous order date is one and two days before the current order date, 
-- then the user has made consecutive orders on at three days.
WHERE order_date BETWEEN DATE_ADD(previous_order_date, INTERVAL 1 DAY) 
AND DATE_ADD(previous_order_date, INTERVAL 2 DAY);
