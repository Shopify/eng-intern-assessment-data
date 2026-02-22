-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- The query used for problem 3 mostly solves this problem.
-- The only adjustments that are made are to use an inner join to exclude products without ratings
-- and to select the products with the highest avg_rating value.
WITH Average_Ratings AS (
    SELECT product_id, AVG(rating) AS avg_rating FROM Reviews GROUP BY product_id
)
SELECT p.product_id, p.product_name, ar.avg_rating FROM Average_Ratings ar JOIN Products p ON ar.product_id=p.product_id
WHERE ar.avg_rating = (SELECT MAX(avg_rating) FROM Average_Ratings)
ORDER BY p.product_id;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Collect corresponding product, category, and user data, then check if the number of distinct
-- categories within a each user's items ordered matches the total number of categories.
SELECT u.user_id, u.username FROM
Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Users u ON o.user_id = u.user_id
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Do a left join to include all products, then filter for reviews that are null
-- Deduplication is not required since 1) product ids are unique and 2) all repeated product ids
-- in the result of the join are a result of matching with multiple reviews, guaranteeing nonnull review_id values
SELECT p.product_id, p.product_name FROM
Products p LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Get gap between each order and the temporally previous order by that user
WITH Order_Gap AS (
    SELECT user_id,
           order_date - LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS gap
    FROM Orders
)
-- Choose users that have an order with a gap of 1 day. DISTINCT ensures each user is counted once
-- even if there are multiple consecutive orders
SELECT DISTINCT og.user_id, u.username FROM
Order_Gap og JOIN Users u ON og.user_id = u.user_id
WHERE og.gap = 1;