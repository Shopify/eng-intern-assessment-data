-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories AS c
JOIN Products AS p ON c.category_id = p.category_id
JOIN Order_Items AS oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users AS u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products AS p
    JOIN Categories AS c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games' AND NOT EXISTS (
        SELECT 1
        FROM Orders AS o
        JOIN Order_Items AS oi ON o.order_id = oi.order_id
        WHERE oi.product_id = p.product_id AND o.user_id = u.user_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH MaxPriceProducts AS (
    SELECT product_id, category_id, MAX(price) OVER (PARTITION BY category_id) AS max_price
    FROM Products
)
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products AS p
JOIN MaxPriceProducts AS mpp ON p.product_id = mpp.product_id AND p.price = mpp.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id
JOIN Orders o3 ON u.user_id = o3.user_id
WHERE ABS(DATEDIFF(o1.order_date, o2.order_date)) = 1
AND ABS(DATEDIFF(o2.order_date, o3.order_date)) = 1
AND o1.order_id <> o2.order_id
AND o2.order_id <> o3.order_id;
