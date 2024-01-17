-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Will return no results if there are no orders
SELECT
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM
    Categories AS c
    INNER JOIN Products AS p ON c.category_id = p.category_id
    INNER JOIN Order_Items AS oi ON p.product_id = oi.product_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    total_sales_amount DESC
LIMIT
    3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Toys & Games category has category_id = 5
-- Will return no results if there are no products in the Toys & Games category
WITH
    ToysAndGamesProductCount AS (
        SELECT
            COUNT(*) AS product_count
        FROM
            Products
        WHERE
            category_id = 5
    ),
    UsersToysAndGamesProductCount AS (
        SELECT
            u.user_id,
            u.username,
            COUNT(DISTINCT p.product_id) AS toys_and_games_count
        FROM
            Users AS u
            INNER JOIN Orders AS o ON u.user_id = o.user_id
            INNER JOIN Order_Items AS oi ON o.order_id = oi.order_id
            INNER JOIN Products AS p ON oi.product_id = p.product_id
        WHERE
            p.category_id = 5
        GROUP BY
            u.user_id,
            u.username
    )

-- Find the users who have placed orders for all products in the Toys & Games category
SELECT
    user_id,
    username
FROM
    UsersToysAndGamesProductCount AS utgpc
    INNER JOIN ToysAndGamesProductCount AS tgpc ON utgpc.toys_and_games_count = tgpc.product_count;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Will return no results if there are no products
-- Will not return results for categories that have no products
WITH
    HighestPricePerCategory AS (
        SELECT
            category_id,
            MAX(price) AS highest_price
        FROM
            Products
        GROUP BY
            category_id
    )

-- Find the products that have the highest price within each category
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.price
FROM
    Products AS p
    INNER JOIN HighestPricePerCategory AS hppc ON p.category_id = hppc.category_id
    AND p.price = hppc.highest_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH
    UserOrdersByDate AS (
        SELECT DISTINCT
            u.user_id,
            u.username,
            o.order_date
        FROM
            Users AS u
            INNER JOIN Orders AS o ON u.user_id = o.user_id
    ),
    UserOrdersByDateLagAndLead AS (
        SELECT
            user_id,
            username,
            order_date,
            LAG (order_date) OVER (
                PARTITION BY
                    user_id
                ORDER BY
                    order_date
            ) AS previous_order_date,
            LEAD (order_date) OVER (
                PARTITION BY
                    user_id
                ORDER BY
                    order_date
            ) AS next_order_date
        FROM
            UserOrdersByDate
    )

-- Find the users who have placed orders for at least 3 consecutive days
SELECT DISTINCT
    user_id,
    username
FROM
    UserOrdersByDateLagAndLead
WHERE
    order_date = previous_order_date + INTERVAL '1 day'
    AND order_date = next_order_date - INTERVAL '1 day';
