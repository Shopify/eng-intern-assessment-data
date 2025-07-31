-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH CategorySales AS (
    SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM Categories c
    JOIN Products p ON c.category_id = p.category_id
    JOIN Order_Items oi ON p.product_id = oi.product_id
    GROUP BY c.category_id, c.category_name
)
SELECT category_id, category_name, total_sales
FROM CategorySales
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
    WHERE c.category_name = 'Toys & Games'
    AND NOT EXISTS (
        SELECT oi.order_id
        FROM Orders o
        JOIN Order_Items oi ON o.order_id = oi.order_id
        WHERE o.user_id = u.user_id
        AND oi.product_id = p.product_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH MaxPrices AS (
    SELECT category_id, MAX(price) AS max_price
    FROM Products
    GROUP BY category_id
)
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p
JOIN MaxPrices mp ON p.category_id = mp.category_id AND p.price = mp.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH ConsecutiveOrders AS (
    SELECT user_id, order_date,
           LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
           LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_prev_order_date
    FROM Orders
),
ConsecutiveDays AS (
    SELECT user_id
    FROM ConsecutiveOrders
    WHERE DATEDIFF(order_date, prev_order_date) = 1
    AND DATEDIFF(prev_order_date, prev_prev_order_date) = 1
)
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN ConsecutiveDays cd ON u.user_id = cd.user_id;
