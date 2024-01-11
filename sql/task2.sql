-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Create a subtable to get cleanly get the highest rated orders
WITH ProductRatings AS (
    SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating 
    FROM Products p JOIN Reviews r ON p.product_id = r.product_id 
    GROUP BY p.product_id, p.product_name
) 
SELECT * FROM ProductRatings ORDER BY average_rating DESCs;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Use subquery to get the users who ordered from each category, then retrieve from there
SELECT u.user_id, u.username 
FROM Users u JOIN orders o ON u.user_id = o.user_id 
JOIN Products p ON o.product_id = p.product_id 
JOIN Categories c ON p.category_id = c.category_id
WHERE u.user_id IN (
    SELECT u.user_id
    FROM Users u JOIN Orders o ON u.user_id = o.user_id JOIN Products p ON o.product_id = p.product_id
    GROUP BY u.user_id, p.category_id
    HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Get the count of reviews from specific products and find when they're equal to 0
SELECT p.product_id, p.product_name FROM Products p 
WHERE (SELECT COUNT(*) FROM Reviews r WHERE p.product_id = r.product_id) = 0;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Use a subtable to get the dates and use lag to get consecutive dates.
-- DateDiff finds the difference in days
WITH UserConsecutiveOrders AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) 
    AS prev_order_date FROM orders
)
SELECT DISTINCT u.user_id, u.username FROM Users u JOIN UserConsecutiveOrders o ON u.user_id = o.user_id 
WHERE DATEDIFF(order_date, prev_order_date) = 1;