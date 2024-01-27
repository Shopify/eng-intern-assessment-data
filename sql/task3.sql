-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    TOP 3
    C.category_id,
    C.category_name,
    COALESCE(SUM(O.total_amount), 0) AS total_sales_amount
FROM
    Categories C
LEFT JOIN
    Products P ON C.category_id = P.category_id
LEFT JOIN
    Order_Items OI ON P.product_id = OI.product_id
LEFT JOIN
    Orders O ON OI.order_id = O.order_id
GROUP BY
    C.category_id, C.category_name
ORDER BY
    total_sales_amount DESC;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH ToysAndGamesProducts AS (
    SELECT P.product_id
    FROM  Products P
    JOIN Categories C ON P.category_id = C.category_id
    WHERE C.category_name = 'Toys & Games'
)

SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN ToysAndGamesProducts TG ON OI.product_id = TG.product_id
GROUP BY  U.user_id, U.username
HAVING COUNT(DISTINCT OI.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH MaxPricePerCategory AS (
    SELECT
        category_id,
        MAX(price) AS max_price
    FROM
        Products
    GROUP BY
        category_id
)

SELECT
    P.product_id,
    P.product_name,
    P.category_id,
    P.price
FROM
    Products P
JOIN
    MaxPricePerCategory MPPC ON P.category_id = MPPC.category_id AND P.price = MPPC.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrdersWithDistinctDate AS (
    SELECT
        DISTINCT
        user_id,
        order_date
    FROM Orders
) -- some users may make more than one order per day, this CTE only get distinct date per order
    SELECT DISTINCT U.user_id, U.username
    from (SELECT
        user_id,
        order_date,
        DATEDIFF(day, order_date , LEAD(order_date,2) OVER (PARTITION BY user_id ORDER BY order_date)) AS next_order_date
        FROM OrdersWithDistinctDate) as T, Users AS U
    WHERE T.next_order_date >=2 AND U.user_id =T.user_id; 