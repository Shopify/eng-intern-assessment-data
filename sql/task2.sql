-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- The approach here was to create a temporary table (average_rating),
-- And perform a inner join with the products table, and sort that to find the temporary hold.

-- CTE
WITH average_rating AS( -- From problem 3
    SELECT 
        product_id, 
        AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
)
-- Selecting the maximum value from the list of products
-- Main query
SELECT 
    p.product_id, 
    p.product_name, 
    a.avg_rating
FROM average_rating a
JOIN Products p ON p.product_id = a.product_id
WHERE a.avg_rating = (SELECT MAX(avg_rating) FROM average_rating); -- Selecting the maximum row from the average ratings and comparing

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Need to go from Users -> Order_Items -> Orders -> Products through a series of INNER JOINS
-- TIES CASE: In order to address the case where there is a user that has Orders with the same
-- product ID's, we include the DISTINCT attribute

SELECT 
    u.user_id, 
    u.username
FROM Users u
JOIN Orders o ON o.user_id = u.user_id
JOIN Order_Items oi ON oi.order_id = o.order_id
JOIN Products p ON p.product_id = oi.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories);  -- Comparing the sum of the Users product categories and the total categories sum

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Performing a LEFT JOIN excluding INNER JOIN
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Reviews r ON r.product_id = p.product_id
WHERE r.rating IS NULL; -- Used to exclude INNER JOIN

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
-- Retrieve the users who have made consecutive orders on consecutive days
-- LAG is used to show previous days, partitioned by user ID (to consider order dates seperately for each user)

-- CTE (Used to determine previous day orders)
WITH lagged_orders AS (
    SELECT 
        user_id, 
        order_id, 
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as previous_date
    FROM Orders
)
-- Main Query
SELECT DISTINCT 
        u.user_id, 
        u.username
FROM Users u
JOIN lagged_orders l ON u.user_id = l.user_id 
JOIN Orders o ON o.user_id = u.user_id
WHERE o.order_date - l.previous_date = 1; -- Comparing current and previous date to ensure there is only a 1 day difference