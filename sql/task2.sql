-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH AverageRatings AS (
    SELECT product_id, AVG(rating) AS avg_rating -- Calculate the average rating
    FROM Reviews
    GROUP BY product_id
)

SELECT p.product_id, p.product_name, AR.avg_rating -- Main query starts here
FROM Products p
JOIN AverageRatings AR
ON p.product_id = AR.product_id
WHERE AR.avg_rating = ( -- Filter to include only products with the highest average rating
    SELECT MAX(avg_rating)
    FROM AverageRatings
)

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH TotalCategories AS ( -- CTE to count the total number of categories
    SELECT COUNT(*) as total_categories
    FROM Categories
),

UserCategoryCounts AS ( -- CTE to count distinct categories per user
    SELECT 
        u.user_id, 
        u.username, 
        COUNT(DISTINCT p.category_id) as user_category_count -- COUNT(DISTINCT ...) for unique categories per user,
    FROM Users u -- from the Users table, aliased as u,
    JOIN Orders o ON o.user_id = o.user_id -- then join with Orders to link users to their orders,
    JOIN Order_Items oi ON o.order_id = oi.order_id -- and Order_Items to get details about ordered products, 
    JOIN Products p ON oi.product_id = p.product_id -- and Products to relate ordered items to their categories.
    GROUP BY u.user_id -- Finally, group by user_id to aggregate data at the user level
)

SELECT uc.user_id, uc.username -- Main query starts here
FROM UserCategoryCounts uc, TotalCategories tc -- Join the CTEs to compare user category counts with total categories,
WHERE uc.user_category_count = tc.total_categories -- then select users whose category count matches the total number of categories

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r
ON p.product_id = r.product_id -- First, LEFT JOIN to include all products, including those without reviews,
WHERE r.review_id IS NULL -- then WHERE clause to filter for products with no matching reviews.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH OrderDates AS (
    SELECT 
        o.user_id,
        u.username,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
        -- LAG function to get the previous order date for each user
    FROM 
        Orders o
    JOIN 
        Users u ON o.user_id = u.user_id -- Join with Users to get the username
)

SELECT DISTINCT od.user_id, od.username -- Main query starts here
FROM OrderDates od
WHERE od.order_date = od.prev_order_date + INTERVAL '1 day' -- WHERE clause to check for consecutive days
