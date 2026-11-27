-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
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
    JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games' AND NOT EXISTS (
        SELECT o.order_id
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
    SELECT p.product_id, p.product_name, p.category_id, p.price,
           RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS price_rank
    FROM Products p
)
SELECT rp.product_id, rp.product_name, rp.category_id, rp.price
FROM RankedProducts rp
WHERE rp.price_rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderedDates AS (
    SELECT o.user_id, o.order_date,
           LEAD(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_order_date,
           LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
    FROM Orders o
),
ConsecutiveOrders AS (
    SELECT od.user_id,
           CASE 
               WHEN od.order_date = od.prev_order_date + INTERVAL '1 day' AND 
                    od.order_date = od.next_order_date - INTERVAL '1 day' THEN 1
               ELSE 0
           END AS is_consecutive
    FROM OrderedDates od
)
SELECT u.user_id, u.username
FROM Users u
JOIN ConsecutiveOrders co ON u.user_id = co.user_id
GROUP BY u.user_id, u.username
HAVING SUM(co.is_consecutive) >= 2;

