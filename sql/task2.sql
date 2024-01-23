-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT
    ranked_products.product_id,
    ranked_products.product_name,
    ranked_products.avg_rating
FROM (
    SELECT 
        p.product_id,
        p.product_name,
        -- To deal with edge cases where no products have a rating (need to set average_rating to 0)
        AVG(COALESCE(r.rating, 0)) AS avg_rating,
        -- Ranking the average rating to determine the largest average rating
        RANK() OVER (ORDER BY AVG(COALESCE(r.rating, 0)) DESC) AS rating_rank
    FROM Products p
    -- Left join to ensure that only reviews to a non-existing product are not included
    LEFT JOIN Reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id, p.product_name
) AS ranked_products
-- Only select the products with the highest average rating (ie: rank = 1)
WHERE ranked_products.rating_rank = 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT 
    u.user_id,
    u.username
FROM Users u
-- Combining All Necessary Tables
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id, u.username
-- Counting the number of distinct categories for each user and checking if it equals to the number of distinct categories in Categories
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    p.product_id,
    p.product_name
FROM Products p
-- Left join to ensure that only actual products that exist are included and filtering for no reviews
LEFT JOIN Reviews r ON p.product_id = r.product_id
-- Only showing products that have no review (ie: IS NULL)
WHERE r.product_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT
    u.user_id,
    u.username
FROM (
    -- Subquery to get the previous order date for each user
    SELECT
        o.user_id,
        o.order_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
    FROM
        Orders o
) AS prev_dates
-- Joining subquery to Users table
JOIN Users u ON u.user_id = prev_dates.user_id

-- Only displaying the users whose previous date differ by 1 day
WHERE
    DATEDIFF(prev_dates.order_date, prev_dates.prev_order_date) = 1
ORDER BY u.user_id;

