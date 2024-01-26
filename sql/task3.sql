-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id,  c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount 
FROM category_data AS c
JOIN product_data AS p ON c.category_id = p.category_id
JOIN order_items_data AS oi ON p.product_id = oi.product_id
GROUP BY c.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH total_products AS (
    SELECT COUNT(DISTINCT product_id) as total_products
    FROM product_data
    WHERE category_id = (SELECT category_id FROM category_data WHERE category_name = 'Toys & Games')
),

user_product_count AS (
    SELECT u.user_id, u.username, COUNT(DISTINCT p.product_id) AS user_product_count
    FROM user_data AS u
    JOIN order_data AS o ON u.user_id = o.user_id
    JOIN order_items_data AS oi ON o.order_id = oi.order_id
    JOIN product_data AS p ON oi.product_id = p.product_id
    WHERE p.category_id = (SELECT category_id FROM category_data WHERE category_name = 'Toys & Games')
    GROUP BY u.user_id
)
SELECT upc.user_id, upc.username
FROM user_product_count AS upc
JOIN total_products AS tp ON upc.user_product_count = tp.total_products

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH products_rank AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        p.price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as price_rank
    FROM 
        product_data AS p
)

SELECT
    product_id,
    product_name,
    category_id,
    price
FROM products_rank
WHERE price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH user_orders AS (
    SELECT
        u.user_id,
        u.username,
        o.order_date,
        DATE(o.order_date, '-1 day') AS prev_date,
        DATE(o.order_date, '+1 day') AS next_date,
        LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS lag_date,
        LEAD(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS lead_date
    FROM
        user_data AS u
    JOIN
        order_data AS o ON u.user_id = o.user_id
),		

consecutive_orders AS (
    SELECT
        user_id,
        username,
        order_date,
        order_date,
        CASE
            WHEN prev_date = lag_date OR next_date = lead_date THEN 0
            ELSE 1
        END AS new_group
    FROM
        user_orders
),

orders_grouped AS (
    SELECT
        *,
        SUM(new_group) OVER (PARTITION BY user_id ORDER BY order_date) AS group_id
    FROM
        consecutive_orders
),

consecutive_counts AS (
    SELECT
        user_id,
        username,
        group_id,
        COUNT(*) AS consecutive_days
    FROM
        orders_grouped
    GROUP BY
        user_id, group_id
)

SELECT DISTINCT
    user_id,
    username
FROM
    consecutive_counts
WHERE
    consecutive_days >= 3;