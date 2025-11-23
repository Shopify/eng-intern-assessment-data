-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sale_amt
FROM
    categories c
JOIN
    products p ON c.category_id = p.category_id
JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY
    c.category_id, c.category_name
ORDER BY
    total_sale_amt DESC
LIMIT 3;





-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH toys_games_products AS (
    SELECT *
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE LOWER(c.category_name) LIKE 'toys & games'
)

SELECT u.user_id, u.username
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM toys_games_products);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.price
FROM
    products p
WHERE
    p.price = (
        SELECT
            MAX(price)
        FROM
            products
        WHERE
            category_id = p.category_id
    );


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT
    u.user_id,
    u.username
FROM
    orders o1
JOIN
    users u ON o1.user_id = u.user_id
JOIN
    orders o2 ON o1.user_id = o2.user_id AND o1.order_date = o2.order_date - INTERVAL '1 day'
JOIN
    orders o3 ON o1.user_id = o3.user_id AND o1.order_date = o3.order_date - INTERVAL '2 days';
