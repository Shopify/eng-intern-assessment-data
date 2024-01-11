-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT CAST(c.category_id AS INT) AS 'category ID', c.category_name AS 'category name', SUM(o.quantity * o.unit_price) AS total_sales_amount 
FROM order_items_data o
JOIN product_data p ON o.product_id = p.product_id 
JOIN category_data c ON p.category_id = c.category_id 
GROUP BY c.category_id, c.category_name 
ORDER BY total_sales_amount DESC
LIMIT 3

-- Problem 10: Retrieve the users who have placed orders for all products in a specific category
-- Write an SQL query to retrieve the users who have placed orders for all products in a specific category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

----------------------------------------------------------------------------
-- Replace category_id to search for the specific category, default is 1. --
----------------------------------------------------------------------------

SELECT CAST(u.user_id AS INT) AS 'user ID', u.username AS 'username'
FROM user_data u
JOIN order_items_data o ON u.user_id = o.order_id
JOIN product_data p ON o.product_id = p.product_id
WHERE p.category_id = 1
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(DISTINCT product_id) 
    FROM product_data 
    WHERE category_id = 1
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT CAST(p.product_id AS INT) AS 'product ID', p.product_name AS 'product name', p.category_id AS 'category ID', p.price AS 'price'
FROM product_data p
JOIN (
    SELECT category_id, MAX(price) AS max_price
    FROM product_data
    GROUP BY category_id
) AS max_prices ON p.category_id = max_prices.category_id AND p.price = max_prices.max_price

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT DISTINCT CAST(u.user_id AS INT) , u.username AS 'username'
FROM user_data u
JOIN order_data o1 ON u.user_id = o1.user_id
JOIN order_data o2 ON u.user_id = o2.user_id AND julianday(o2.order_date) = julianday(o1.order_date) + 1
JOIN order_data o3 ON u.user_id = o3.user_id AND julianday(o3.order_date) = julianday(o1.order_date) + 2
