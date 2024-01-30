-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount -- Calculating total sales amount
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products p
    WHERE p.category_id = 5 -- toys & games
        AND NOT EXISTS (
            SELECT oi.product_id
            FROM Orders o
            JOIN Order_Items oi ON o.order_id = oi.order_id
            WHERE oi.product_id = p.product_id AND o.user_id = u.user_id
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT p.product_id,p.product_name,p.category_id,p.price,
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS price_rank -- Ranking products by price within each category
    FROM Products p
)
SELECT rp.product_id,rp.product_name,rp.category_id,rp.price
FROM RankedProducts rp
WHERE rp.price_rank = 1;



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- CTE to calculate previous order dates for each user
WITH OrderedDates AS (
    SELECT user_id, order_date,
        LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date2
    FROM Orders
)
SELECT DISTINCTu.user_id, u.username
FROM OrderedDates od
JOIN Users u ON od.user_id = u.user_id
WHERE od.order_date = DATE_ADD(od.prev_date, INTERVAL 1 DAY)
    AND od.prev_date = DATE_ADD(od.prev_date2, INTERVAL 1 DAY);


