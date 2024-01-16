-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT categories.category_id, category_name, SUM(unit_price * quantity) as total_sales_amount
FROM categories
JOIN products
ON products.category_id = categories.category_id
JOIN order_items
ON order_items.product_id = products.product_id
GROUP BY categories.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT user_id, username
FROM users
WHERE (
    SELECT COUNT(Distinct order_item.product_id) 
    FROM orders_items
    JOIN orders
    ON orders.order_id = order_items.order_id 
    JOIN products 
    ON products.product_id = order_items.product_id
    JOIN categories
    ON products.category_id = categories.category_id
    WHERE orders.user_id = users.user_id and category_name = 'Toys & Games') 
    = 
    (SELECT COUNT(Distinct product_id) 
     FROM products
     JOIN categories
     ON products.category_id = categories.category_id
     WHERE category_name = 'Toys & Games');

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH MaxPrice AS (
    SELECT category_id, MAX(price) as max_price
    FROM products
    GROUP BY category_id
)

SELECT product_id, product_name, products.category_id, max_price
FROM products
JOIN MaxPrice
ON products.category_id = MaxPrice.category_id
WHERE price = max_price

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsDays AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as prev_order_date
    FROM orders
),
ConsCount AS(
    SELECT users.user_id, username, COUNT(order_date) as num_consecutive_date
    FROM users
    JOIN ConsDays
    ON users.user_id = ConsDays.user_id
    WHERE order_date = prev_order_date + 1
    GROUP BY users.user_id, username
)

SELECT user_id, username
FROM ConsCount
WHERE num_consecutive_date >= 3;