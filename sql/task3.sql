-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM
    Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY
    c.category_id
ORDER BY
    total_sales_amount DESC
LIMIT 3;
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH ToysAndGamesProducts AS (
    SELECT product_id
    FROM Products
    WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
), UsersWithOrders AS (
    SELECT DISTINCT
        u.user_id,
        u.username,
        oi.product_id
    FROM
        Users u
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN ToysAndGamesProducts tgp ON oi.product_id = tgp.product_id
)

SELECT
    u.user_id,
    u.username
FROM
    UsersWithOrders u
GROUP BY
    u.user_id,
    u.username
HAVING
    COUNT(DISTINCT u.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts);
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        p.price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS price_rank
    FROM
        Products p
)

SELECT
    rp.product_id,
    rp.product_name,
    rp.category_id,
    rp.price
FROM
    RankedProducts rp
WHERE
    rp.price_rank = 1;
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsecutiveOrders AS (
  SELECT
    user_id,
    order_date,
    LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
    LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_next_order_date
  FROM
    Orders
)

SELECT DISTINCT
  u.user_id,
  u.username
FROM
  Users u
JOIN
  ConsecutiveOrders co ON u.user_id = co.user_id
WHERE
  co.next_order_date = co.order_date + INTERVAL '1 day'
  AND co.next_next_order_date = co.order_date + INTERVAL '2 days';
