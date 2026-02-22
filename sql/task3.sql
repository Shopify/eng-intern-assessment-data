-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) as total_sales_amount
FROM
    order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category c ON p.category_id = c.category_id
GROUP BY
    c.category_id, c.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM
users u
INNER JOIN orders o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category c ON p.category_id = c.category_id
WHERE p.category_id = (
    SELECT category_id FROM category WHERE category_name = 'Toys & Games'
)
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT oi.product_id) = (
    SELECT COUNT(product_id) FROM products WHERE category_id = (
        SELECT category_id FROM category WHERE category_name = 'Toys & Games'
    )
)

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    product_id, product_name, category_id, price 
FROM (
    SELECT 
        category_id, price, product_id, product_name,
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM
        products
)
WHERE rank = 1

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM users u
INNER JOIN
(
    SELECT
        user_id,
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS one_order_back,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS two_order_back
    FROM
        orders
) o ON u.user_id = o.user_id
WHERE JULIANDAY(o.order_date) - JULIANDAY(o.one_order_back) = 1
AND JULIANDAY(o.one_order_back) - JULIANDAY(o.two_order_back) = 1
