-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.unit_price * oi.quantity) AS c_total_amount
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c_total_amount DESC
LIMIT 3

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username, COUNT(DISTINCT p.product_id)
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN users u ON u.user_id = o.user_id
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(DISTINCT pp.product_id) FROM products pp JOIN categories cc ON pp.category_id = cc.category_id WHERE cc.category_name = 'Toys & Games')

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH partitioned_products AS (
  SELECT 
    pp.product_id,
    pp.product_name,
    pp.price,
    cc.category_name,
    cc.category_id,
    ROW_NUMBER() OVER (PARTITION BY pp.category_id ORDER BY pp.price DESC) AS row_num 
  FROM products pp 
  JOIN categories cc 
  ON pp.category_id = cc.category_id
)
SELECT *
FROM partitioned_products
WHERE row_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH orders_over_3_days AS (
  SELECT
    user_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
    LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
  FROM
    orders
)
SELECT DISTINCT user_id
FROM orders_over_3_days
WHERE order_date - prev_order_date = 1 AND next_order_date - order_date = 1
