-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    category_data.category_id,
    category_data.category_name,
    SUM(order_items_data.quantity * product_data.price) AS total_sales_amount
FROM
    category_data
INNER JOIN
    product_data ON category_data.category_id = product_data.category_id
INNER JOIN
    order_items_data ON product_data.product_id = order_items_data.product_id
GROUP BY
    category_data.category_id, category_data.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    user_data.user_id,
    user_data.username
FROM 
    user_data
INNER JOIN 
    order_data ON user_data.user_id = order_data.user_id
INNER JOIN 
    order_items_data ON order_data.order_id = order_items_data.order_id
INNER JOIN 
    product_data ON order_items_data.product_id = product_data.product_id
INNER JOIN 
    category_data ON product_data.category_id = category_data.category_id
WHERE 
    category_data.category_name = 'Toys & Games'
GROUP BY 
    user_data.user_id, user_data.username
HAVING 
    COUNT(DISTINCT product_data.product_id) = (
        SELECT 
            COUNT(*) 
        FROM 
            product_data 
        WHERE 
            category_id = (
                SELECT 
                    category_id 
                FROM 
                    category_data 
                WHERE 
                    category_name = 'Toys & Games'
            )
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM
        product_data
)
SELECT
    product_id,
    product_name,
    category_id,
    price
FROM
    RankedProducts
WHERE
    rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT
        user_data.user_id,
        user_data.username,
        order_data.order_date,
        LAG(order_data.order_date) OVER (PARTITION BY user_data.user_id ORDER BY order_data.order_date) AS prev_order_date
    FROM
        user_data
    INNER JOIN
        order_data ON user_data.user_id = order_data.user_id
)
SELECT DISTINCT
    uco1.user_id,
    uco1.username
FROM
    UserConsecutiveOrders uco1
JOIN
    UserConsecutiveOrders uco2 ON uco1.user_id = uco2.user_id
                            AND uco1.order_date - uco2.prev_order_date = 1
JOIN
    UserConsecutiveOrders uco3 ON uco2.user_id = uco3.user_id
                            AND uco2.order_date - uco3.prev_order_date = 1
WHERE
    uco1.order_date - uco1.prev_order_date = 1
    AND uco2.order_date - uco2.prev_order_date = 1
    AND uco3.order_date - uco3.prev_order_date = 1;