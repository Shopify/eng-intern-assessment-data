-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH CategorySales AS (
    SELECT
        p.category_id,
        c.category_name,
        SUM(od.total_amount) AS total_sales
    FROM
        order_details od
    JOIN
        products p ON od.product_id = p.product_id
    JOIN
        categories c ON p.category_id = c.category_id
    GROUP BY
        p.category_id, c.category_name
)

SELECT
    category_id,
    category_name,
    total_sales
FROM
    CategorySales
ORDER BY
    total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    u.user_id,
    u.username
FROM
    users u
WHERE
    NOT EXISTS (
        SELECT
            p.product_id
        FROM
            products p
        WHERE
            NOT EXISTS (
                SELECT
                    od.product_id
                FROM
                    order_details od
                JOIN
                    orders o ON od.order_id = o.order_id
                WHERE
                    u.user_id = o.user_id AND p.product_id = od.product_id
            )
            AND p.category = 'Toys & Games'
    );


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH MaxPriceProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM
        products
)

SELECT
    product_id,
    product_name,
    category_id,
    price
FROM
    MaxPriceProducts
WHERE
    rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderedUserDates AS (
    SELECT
        u.user_id,
        o.order_date,
        LEAD(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS next_order_date
    FROM
        users u
    JOIN
        orders o ON u.user_id = o.user_id
)

SELECT
    user_id,
    MIN(order_date) AS start_date,
    MAX(next_order_date) AS end_date
FROM
    OrderedUserDates
GROUP BY
    user_id
HAVING
    COUNT(DISTINCT DATE(order_date)) >= 3;
