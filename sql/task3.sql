-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT category_id, category_name, sum(quantity*unit_price) AS total_sales_amount
FROM order_items
JOIN products USING (product_id)
JOIN categories USING (category_id)
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM users u
JOIN orders o USING (user_id)
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
JOIN categories c USING (category_id)
WHERE p.product_id IN (
        SELECT product_id
        FROM products
        JOIN categories USING (category_id)
        WHERE category_name = 'Toys & Games'
    )
GROUP BY u.user_id, u.username
HAVING
    COUNT(DISTINCT p.product_id) = (
        SELECT COUNT(DISTINCT p2.product_id)
        FROM products p2
        JOIN categories c2 USING (category_id)
        WHERE c2.category_name = 'Toys & Games'
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ranked_products AS (
    SELECT product_id, product_name, category_id,price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM products
)

SELECT product_id, product_name, category_id, price
FROM ranked_products
WHERE rn = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT
    user_id,
    MIN(order_date) AS startdate,
    MAX(order_date) AS enddate,
    COUNT(*) AS cnt
FROM (
    SELECT
        user_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn
    FROM orders
    JOIN users USING (user_id)
) t
GROUP BY user_id, DATE_ADD(order_date, INTERVAL -rn DAY)
HAVING COUNT(*) >= 3;
