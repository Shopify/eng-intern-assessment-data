-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    C.category_id,
    C.category_name,
    COALESCE(SUM(O.total_amount), 0) AS total_sales_amount
FROM
    shopify.category_data C
LEFT JOIN
    shopify.product_data P ON C.category_id = P.category_id
LEFT JOIN
    shopify.order_items_data OI ON P.product_id = OI.product_id
LEFT JOIN
    shopify.order_data O ON OI.order_id = O.order_id
GROUP BY
    C.category_id, C.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    U.user_id,
    U.username
FROM
    shopify.user_data U
JOIN
    shopify.order_data O ON U.user_id = O.user_id
JOIN
    shopify.order_items_data OI ON O.order_id = OI.order_id
JOIN
    shopify.product_data P ON OI.product_id = P.product_id
JOIN
    shopify.category_data C ON P.category_id = C.category_id
WHERE
    C.category_name = 'Toys & Games'
GROUP BY
    U.user_id, U.username
HAVING
    COUNT(DISTINCT P.product_id) = (SELECT COUNT(*) FROM shopify.product_data WHERE category_id = 
    (SELECT category_id FROM shopify.category_data WHERE category_name = 'Toys & Games'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT * FROM shopify.product_data

WITH RankedProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM
        shopify.product_data
)
SELECT
    product_id,
    product_name,
    category_id,
    price
FROM
    RankedProducts
WHERE
    rn = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM
        shopify.order_data
)
SELECT DISTINCT
    U.user_id,
    U.username
FROM
    shopify.user_data U
JOIN
    UserConsecutiveOrders UCO ON U.user_id = UCO.user_id
WHERE
    (
        (UCO.order_date = UCO.prev_order_date + INTERVAL 1 DAY AND UCO.order_date = UCO.next_order_date - INTERVAL 1 DAY) OR
        (UCO.order_date = UCO.prev_order_date + INTERVAL 1 DAY AND UCO.next_order_date IS NULL) OR
        (UCO.prev_order_date IS NULL AND UCO.order_date = UCO.next_order_date - INTERVAL 1 DAY)
    )
GROUP BY
    U.user_id, U.username
HAVING
    COUNT(DISTINCT UCO.order_date) >= 3;
