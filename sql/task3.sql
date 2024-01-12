-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
-- Here used the quantity multiplied with unit price for total sales of an order item
SELECT C.category_id, C.category_name, SUM(OI.quantity * OI.unit_price) AS total_sales
FROM Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
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
    AND NOT EXISTS (
        SELECT OI.order_id
        FROM Order_Items OI
        JOIN Orders O ON OI.order_id = O.order_id
        WHERE O.user_id = U.user_id AND OI.product_id = P.product_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT P.product_id, P.product_name, P.category_id, P.price
FROM Products P
JOIN (
    SELECT category_id, MAX(price) AS max_price
    FROM Products
    GROUP BY category_id
) AS MaxPrice ON P.category_id = MaxPrice.category_id AND P.price = MaxPrice.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
-- Sorry it's a little long lol, think it's still pretty readable
WITH OrderedDates AS (
    SELECT 
        user_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM Orders
),
ConsecutiveOrders AS (
    SELECT 
        user_id, 
        order_date,
        CASE 
            WHEN DATE(order_date) = DATE(prev_order_date, '+1 day') OR
                 DATE(order_date) = DATE(next_order_date, '-1 day') THEN 1
            ELSE 0 
        END AS is_consecutive
    FROM OrderedDates
)
SELECT U.user_id, U.username
FROM Users U
JOIN ConsecutiveOrders CO ON U.user_id = CO.user_id
GROUP BY U.user_id, U.username
HAVING SUM(CO.is_consecutive) >= 2;