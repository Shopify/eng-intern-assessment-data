-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Average rating for each product
WITH average_product_ratings AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(r.rating) AS average_rating
    FROM Products p
    LEFT JOIN Reviews r
    USING (product_id)
    GROUP BY 1
)

SELECT 
    product_id, 
    product_name, 
    average_rating
FROM average_product_ratings
WHERE average_rating = (SELECT MAX(average_rating) FROM average_product_ratings)


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
    u.user_id,
    u.username
FROM Users u
    INNER JOIN Orders o
        USING (user_id)
    INNER JOIN Order_Items oi
        USING (order_id)
    RIGHT JOIN Products p
        USING (product_id)
GROUP BY u.user_id
-- Check if the number of categories in the user's orders equals the total number of available categories
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(category_id) FROM Categories)
    
    
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT 
    p.product_id,
    p.product_name
FROM Products p
    LEFT JOIN Reviews r
        USING (product_id)
WHERE r.review_id IS NULL

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT
    user_id,
    username
FROM (
    SELECT 
        u.user_id,
        u.username,
        -- get number of days between two consecutive orders
        EXTRACT(DAY FROM o.order_date - LAG(o.order_date, 1) OVER(PARTITION BY u.user_id ORDER BY o.order_date)) AS day_difference
    FROM Users u
        INNER JOIN Orders o 
            USING (user_id)
)
-- checks if two consecutive orders are made within a day (consecutive days)
WHERE day_difference = 1



