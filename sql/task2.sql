-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Sub-query block that calculates average rating for each reviewed product
WITH AvgRatings AS (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
) 

SELECT p.product_id, p.product_name
FROM Products p
-- Inner join to only look at products with name and ratings
-- 4 products that have ratings but are not in the Products table are excluded
INNER JOIN AvgRatings a ON p.product_id = a.product_id 
WHERE a.avg_rating = (SELECT MAX(avg_rating) FROM AvgRatings); 

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM Order_Items oi 
-- Multiple left joins to pull in all required data
LEFT JOIN Orders o ON oi.order_id = o.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id
LEFT JOIN Users u ON o.user_id = u.user_id
GROUP BY u.user_id, u.username
-- Filter for those with number of distinct categories ordered equal to possible total
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Sub-query block to create new column for date of previous order
WITH OrderedOrders AS ( 
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date 
    FROM Orders 
)

-- Distinct to avoid duplicate entries in cases where users make consecutive day orders on different occasions 
SELECT DISTINCT u.user_id, u.username 
FROM Users u JOIN OrderedOrders oo ON u.user_id = oo.user_id 
-- Filter for consecutive day orders, where the previous order date is exactly one day before the current order date 
WHERE DATEDIFF(oo.order_date, oo.prev_order_date) = 1;