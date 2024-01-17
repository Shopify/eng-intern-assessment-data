-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    Categories.category_id,
    Categories.category_name,
    SUM(Order_Items.quantity * Order_Items.unit_price) AS total_sales_amount
FROM
    Categories
    INNER JOIN Products ON Categories.category_id = Products.category_id
    INNER JOIN Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY
    Categories.category_id,
    Categories.category_name
ORDER BY
    total_sales_amount DESC
LIMIT
    3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH
    ToysAndGamesProductCount AS (
        SELECT
            COUNT(*) AS product_count
        FROM
            Products
        WHERE
            Products.category_id = 5
    ),
    UserToysAndGamesProducts AS (
        SELECT DISTINCT
            Users.user_id,
            Users.username,
            Products.product_id
        FROM
            Users
            INNER JOIN Orders ON Users.user_id = Orders.user_id
            INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
            INNER JOIN Products ON Order_Items.product_id = Products.product_id
        WHERE
            Products.category_id = 5
    ),
    UsersByToysAndGamesProductCount AS (
        SELECT
            user_id,
            username,
            COUNT(*) AS toys_and_games_count
        FROM
            UserToysAndGamesProducts
        GROUP BY
            user_id,
            username
    )

-- Find the users who have placed orders for all products in the Toys & Games category
SELECT
    user_id,
    username
FROM
    UsersByToysAndGamesProductCount
    INNER JOIN ToysAndGamesProductCount ON UsersByToysAndGamesProductCount.toys_and_games_count = ToysAndGamesProductCount.product_count;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

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
    Products.product_id,
    Products.product_name,
    Products.category_id,
    Products.price
FROM
    Products
    INNER JOIN HighestPricePerCategory ON Products.category_id = HighestPricePerCategory.category_id
    AND Products.price = HighestPricePerCategory.highest_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH
    UserOrdersByDate AS (
        SELECT DISTINCT
            Users.user_id,
            Users.username,
            Orders.order_date
        FROM
            Users
            INNER JOIN Orders ON Users.user_id = Orders.user_id
    ),
    UserOrdersByDateLag AS (
        SELECT
            user_id,
            username,
            order_date,
            LAG (order_date) OVER (
                PARTITION BY
                    user_id
                ORDER BY
                    order_date
            ) AS previous_order_date
        FROM
            UserOrdersByDate
    ),
    ConsecutiveUserOrdersCount AS (
        SELECT
            user_id,
            username,
            COUNT(*) AS consecutive_orders_count
        FROM
            UserOrdersByDateLag
        WHERE
            order_date = previous_order_date + INTERVAL '1 day'
        GROUP BY
            user_id,
            username
    )

-- Find the users who have placed orders on consecutive days for at least 3 days
SELECT
    user_id,
    username
FROM
    ConsecutiveUserOrdersCount
WHERE
    consecutive_orders_count >= 3;
