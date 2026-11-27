-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH CategorySales AS (
    SELECT C.category_id, C.category_name, SUM(O.total_amount) AS total_sales
    FROM Categories C
    LEFT JOIN Products P ON C.category_id = P.category_id
    LEFT JOIN Order_Items OI ON P.product_id = OI.product_id
    LEFT JOIN Orders O ON OI.order_id = O.order_id
    GROUP BY C.category_id, C.category_name
)
SELECT category_id, category_name, total_sales
FROM CategorySales
ORDER BY total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT U.user_id, U.username
FROM Users U
WHERE NOT EXISTS (
    SELECT P.product_id
    FROM Products P
    WHERE P.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
    EXCEPT
    SELECT OI.product_id
    FROM Order_Items OI
    JOIN Orders O ON OI.order_id = O.order_id
    WHERE O.user_id = U.user_id
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT 
        product_id, product_name, category_id, price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_within_category
    FROM Products
)
SELECT product_id, product_name, category_id, price
FROM RankedProducts
WHERE rank_within_category = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsecutiveOrderDays AS (
    SELECT user_id, order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM Orders
)
SELECT DISTINCT user_id, username
FROM Users U
JOIN ConsecutiveOrderDays COD ON U.user_id = COD.user_id
WHERE DATEDIFF(next_order_date, order_date) = 1
AND (LEAD(next_order_date) OVER (PARTITION BY user_id ORDER BY order_date) = order_date + INTERVAL 2 DAY
    OR LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) = order_date - INTERVAL 2 DAY);

