-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Order_Items oi 
-- Multiple joins to pull in all required data
LEFT JOIN Products p ON oi.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Sub-query block to retrieve all products in the Toys & Games category
WITH ToysAndGamesProducts AS (
    SELECT p.product_id
    FROM Products p
    LEFT JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
)

SELECT u.user_id, u.username
FROM Order_Items oi 
-- Multiple left joins to pull in all required data
LEFT JOIN Orders o ON oi.order_id = o.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id
LEFT JOIN Users u ON o.user_id = u.user_id
GROUP BY u.user_id, u.username
-- Filter for those with number of distinct product ordered equal to possible total
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Sub-query block to create new column for category price rank
WITH RankedProducts AS (
    SELECT product_id, product_name, category_id, price, RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS product_rank
    FROM Products
)

SELECT product_id, product_name, category_id, price
FROM RankedProducts
WHERE product_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Sub-query block to create new columns for dates of previous two orders
WITH OrderedOrders AS ( 
    SELECT 
        user_id, 
        order_date, 
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date, 
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev2_order_date 
    FROM Orders 
)

-- Distinct to avoid duplicate entries in cases where users make consecutive day orders on different occasions 
SELECT DISTINCT u.user_id, u.username 
FROM Users u JOIN OrderedOrders oo ON u.user_id = oo.user_id 
-- Filter for orders placed on three consecutive days by checking the time difference with the previous and second previous order dates
WHERE oo.order_date - oo.prev_order_date = 1 AND oo.prev_order_date - oo.prev2_order_date = 1;