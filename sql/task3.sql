-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Limit 3 of the descending table ordered by total sales amount
SELECT c.category_id, c.category_name, SUM(o.amount) AS total_sales_amount 
FROM Categories c JOIN Products p ON c.category_id = p.category_id JOIN Orders o ON p.product_id = o.product_id
GROUP BY c.category_name ORDER BY total_sales_amount DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in a specific category
-- Write an SQL query to retrieve the users who have placed orders for all products in a specific category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Use a subtable to count the products with specific category %CategoryName%
SELECT u.user_id, u.username FROM Users u JOIN Orders o ON u.user_id = o.user_id 
JOIN Products p ON o.product_id = p.product_id JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_id LIKE '%CategoryName%' GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*)
    FROM products
    WHERE category_id = c.category_id
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Get a subtable of the ranked products by price, then select the first rank
WITH RankedProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_within_category
    FROM Products
)
SELECT product_id, product_name, category_id, price FROM RankedProducts WHERE rank_within_category = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Use datediff and lag to get the consecutive days
WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT DISTINCT u.user_id, u.username FROM Users u JOIN UserConsecutiveOrders o ON u.user_id = o.user_id 
WHERE DATEDIFF(order_date, prev_order_date) = 1 OR DATEDIFF(order_date, prev_order_date) = 2
ORDER BY u.user_id;