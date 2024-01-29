-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM Categories c 
JOIN Order_Items oi ON p.product_id = oi.product_id
JOIN Orders o ON o.order_id = oi.order_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON p.product_id = oi.product_id
JOIN (
    SELECT p.product_id
    FROM Products p
    JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = "Toys & Games"
) AS toys_games_products ON p.product_id = toys_games_products.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM toys_games_products);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT product_id, product_name, category_id, price, 
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_in_category
    FROM Products
)

SELECT product_id, product_name, category_id, price
FROM RankedProducts
WHERE rank_in_category =1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsecutiveOrders AS (
    SELECT o.user_id, o.order_date, 
    LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
    FROM Orders o 
)

SELECT co.user_id, u.username
FROM ConsecutiveOrders co
JOIN Users u ON co.user_id = u.user_id
WHERE DATEDIFF(co.order_date, co.prev_order_date) = 1 OR co.prev_order_date IS NULL
GROUP BY co.user_id, u.username
HAVING COUNT(DISTINCT co.order_date) >= 3;
