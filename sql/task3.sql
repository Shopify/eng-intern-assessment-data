-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    c.category_id,
    c.category_name,
    SUM(o.quantity * o.unit_price) AS total_sales_amount
FROM Categories c
    INNER JOIN Products p
        USING (category_id)
    INNER JOIN Order_Items o
        USING (product_id)
GROUP BY 1, 2
ORDER BY SUM(o.quantity * o.unit_price) DESC
LIMIT 3

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- category_id of toys & games, cte for reusability
WITH toys_and_games_category AS (
    SELECT category_id 
    FROM Categories 
    WHERE category_name = 'Toys & Games'
),
-- number of toys & games products, cte for readability
num_tg_products AS (
    SELECT COUNT(product_id) AS total_tg_products
    FROM Products
    WHERE category_id = (SELECT category_id FROM toys_and_games_category)
)

SELECT
    u.user_id,
    u.username
FROM toys_and_games_category tg
    -- isolate orders with toys & games products - massively reduce search space
    INNER JOIN Products p
        ON p.category_id = tg.category_id
    INNER JOIN Order_Items oi
        ON p.product_id = oi.product_id
    INNER JOIN Orders o
        ON oi.order_id = o.order_id
    INNER JOIN Users u
        ON u.user_id = o.user_id
GROUP BY 1, 2
-- check if the number of unique products bought equals the total number of toys & games products
HAVING COUNT(DISTINCT oi.product_id) = (SELECT total_tg_products FROM num_tg_products)


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT 
    product_id,
    product_name,
    category_id,
    price
FROM
    (SELECT
        product_id,
        product_name,
        category_id,
        price,
        -- we want same rank for ties, not only the first most expensive product per category
        RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS price_rank
    FROM Products)
WHERE price_rank = 1

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT
    user_id,
    username
FROM (
    SELECT 
        u.user_id,
        u.username,
        -- get number of days between two consecutive orders
        EXTRACT(DAY FROM o.order_date - LAG(o.order_date, 1) OVER(PARTITION BY u.user_id ORDER BY o.order_date)) AS day_difference
    FROM Users u
        INNER JOIN Orders o 
            USING (user_id)
)
-- only keep the consecutive-day orders
WHERE day_difference = 1
GROUP BY 1, 2
-- Since we want at least 3 days, we must have at least 2 consecutive-day pairs
HAVING COUNT(day_difference) >= 2