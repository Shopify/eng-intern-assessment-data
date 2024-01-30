-- Problem 5:
-- Question: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
--
-- avg_rating CTE Calculates the average ratings for each product using the AVG() function
-- The PARTITION BY p.product_id ensures that the average is calculated for each product individually.
WITH
avg_rating AS (
    -- Results to display product ID, product name, and the average rating
    SELECT p.product_id, p.product_name, AVG(rating) over (PARTITION BY p.product_id) avg_rating FROM Products p
        JOIN Reviews r
            ON p.product_id=r.product_id
)
--Selects all columns from the AvgRating CTE.
SELECT * FROM avg_rating
    WHERE avg_rating = (SELECT MAX(avg_rating) FROM avg_rating) --include only rows where the avg_rating is equal to the maximum average rating

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
-- CTE DistinctCategories Calculates the count of distinct categories each user has ordered from.
WITH
DistinctCategories AS (
    SELECT COUNT(DISTINCT c.category_id) dist_cat_n, u.user_id, u.username FROM Users u
        JOIN Orders o  --Joins the Users, Orders, Order_Items, Products, and Categories tables
            ON u.user_id=o.user_id
        JOIN Order_Items oi
            ON o.order_id=oi.order_id
        JOIN Products p
            ON p.product_id=oi.product_id
        JOIN Categories c
            ON p.category_id=c.category_id
        GROUP BY 2,3     -- group the results by user_id and username
)
SELECT user_id, username FROM DistinctCategories
WHERE dist_cat_n = (SELECT COUNT(DISTINCT category_id) FROM Categories) --filters the results to include only users who have ordered from all distinct categories

-- Problem 7:
-- Question: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
--
-- The Main Query Selects product_id and product_name from the Products table.
-- The WHERE clause filters the results to include only products whose product_id is not present in the subquery.
--
-- Main query to select products that have no reviews
SELECT product_id, product_name FROM Products
WHERE product_id not in (SELECT DISTINCT product_id FROM Reviews) -- Subquery to get distinct product IDs from the Reviews table

-- Problem 8:
-- Question: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
--
-- CTE orders_with_prev:
-- Calculates the previous order date for each order of each user.
-- The LAG window function is used to obtain the previous order date based on the order date for each user.
-- Main Query:
-- Selects user_id and username from the orders_with_prev CTE.
-- The WHERE clause filters the results to include only users whose orders are on consecutive days,
-- The CAST function is used to convert the Julian day differences to integers.
--
-- CTE named 'orders_with_prev' to calculate the previous order date for each order
WITH orders_with_prev AS (
    SELECT 
        o.user_id, 
        u.username, 
        o.order_date, 
        LAG(o.order_date,1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) previous_order_date 
    FROM Orders o
        JOIN Users u
            ON o.user_id=u.user_id
        ORDER BY 1,3  -- Order by user_id and order_date
    )
-- Main query to select user_id and username from the 'orders_with_prev' CTE
    SELECT 
        user_id, 
        username
    FROM orders_with_prev
    WHERE Cast((JulianDay(order_date) - JulianDay(previous_order_date)) As Integer) = 1 -- Filter users with consecutive orders