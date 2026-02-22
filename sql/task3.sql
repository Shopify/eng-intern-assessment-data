-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- Problem 9 Solution:

WITH category_sales_data AS (
    SELECT category_.category_id, category_data.category_name, SUM(order_data.total_amount) AS total_sales
    FROM category_data
    LEFT JOIN product_data ON category_data.category_id = product_data.category_id
    LEFT JOIN order_items_data ON product_data.product_id = order_items_data.product_id
    LEFT JOIN order_data ON order_items_data.order_id = order_data.order_id
    GROUP BY category_data.category_id, category_data.category_name
)

SELECT TOP 3 category_id, category_name, total_sales
FROM category_sales_data
ORDER BY total_sales DESC;

-- Problem 10 Solution:

SELECT user_data.user_id, user_data.username
FROM user_data
WHERE NOT EXISTS (
    SELECT product_data.product_id
    FROM product_data
    WHERE product_data.category_id = (
            SELECT category_id
            FROM category_data
            WHERE category_name = 'Toys & Games'
        )
    EXCEPT 
    SELECT product_data.product_id
    FROM product_data
    INNER JOIN order_items_data ON product_data.product_id = order_items.product_id
    INNER JOIN order_data ON order_items_data.order_id = order_data.order_id
    WHERE order_data.user_id = user_data.user_id
);

-- Problem 11 Solution:

WITH max_price_per_category AS (
    SELECT
        product_data.product_id, product_data.product_name, product_data.category_id, product_data.price,
        ROW_NUMBER() OVER (PARTITION BY product_data.category_id ORDER BY product_data.price DESC) AS row_num
    FROM product_data
)

SELECT product_id, product_name, category_id, price
FROM max_price_per_category
WHERE row_num = 1;


-- Problem 12 Solution:

WITH user_consecutive_orders_data AS (
    SELECT user_id, order_date,
        LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
        LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_next_order_date
    FROM order_data
)

SELECT DISTINCT user_data.user_id, user_data.username
FROM user_data u
JOIN user_consecutive_orders_data ON user_data.user_id = user_consecutive_orders_data.user_id
WHERE user_consecutive_orders_data.next_order_date = DATEADD(day, 1, user_consecutive_orders_data.order_date)
    AND user_consecutive_orders_data.next_next_order_date = DATEADD(day, 2, user_consecutive_orders_data.order_date);
