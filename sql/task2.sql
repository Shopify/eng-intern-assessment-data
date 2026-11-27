-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH product_average_ratings AS ( -- CTE to calculate average ratings for each product based on product_id
    SELECT 
        p.product_id, 
        p.product_name, 
        AVG(Reviews.rating) AS average_rating
    FROM Products p 
        LEFT JOIN Reviews r ON p.product_id = r.product_id -- LEFT JOIN includes products with no reviews
    GROUP BY
        p.product_id
)
SELECT
    ar.product_id,
    ar.product_name,
    ar.average_rating
FROM
    product_average_ratings ar
WHERE
    ar.average_rating = (
        SELECT MAX(average_rating)
        FROM product_average_ratings
    ); -- returns NULL if each product has no reviews

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
    u.user_id, 
    u.username
FROM Users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
GROUP BY
    u.user_id
HAVING
    COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT category_id) FROM categories); -- user's number of distinct categories ordered from must equal total number of categories


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    p.product_id,
    p.product_name
FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE
    r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT 
    u.user_id, 
    u.username
FROM 
    (SELECT 
        o.user_id,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date, -- Getting the previous order date for each order
        o.order_date
     FROM 
        Orders o) AS order_dates
    JOIN Users u ON order_dates.user_id = u.user_id
WHERE 
    order_dates.order_date = order_dates.prev_order_date + INTERVAL '1 day'; -- Checking if the order date is exactly one day after the previous order date