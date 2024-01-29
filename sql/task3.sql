-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT DISTINCT
    u.user_id,
    u.username
FROM
    users u,
    orders o,
    order_items oi,
    products p,
    categories c
WHERE
    u.user_id = o.user_id
    AND o.order_id = oi.order_id
    AND oi.product_id = p.product_id
    AND p.category_id = c.category_id
    AND c.category_name = 'Toys & Games';

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
    Products p
    JOIN (
        SELECT
            category_id,
            MAX(price) AS max_price
        FROM
            Products
        GROUP BY
            category_id
    ) AS max_prices ON p.category_id = max_prices.category_id
    AND p.price = max_prices.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.