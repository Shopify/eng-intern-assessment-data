-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
with 
avg_ratings as (
    SELECT p.product_id, p.product_name, AVG(rating) over (PARTITION BY p.product_id) avg_rating FROM Products p
        JOIN Reviews r
            ON p.product_id=r.product_id
)
SELECT * FROM avg_ratings
    WHERE avg_rating = (SELECT MAX(avg_rating) FROM avg_ratings)

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
with
tmp AS (
    SELECT COUNT(DISTINCT c.category_id) dist_cat_n, u.user_id, u.username FROM Users u
        JOIN Orders o 
            ON u.user_id=o.user_id
        JOIN Order_Items oi
            ON o.order_id=oi.order_id
        JOIN Products p
            ON p.product_id=oi.product_id
        JOIN Categories c
            ON p.category_id=c.category_id
        GROUP BY 2,3
)
SELECT user_id, username FROM tmp
WHERE dist_cat_n = (SELECT COUNT(DISTINCT category_id) FROM Categories)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT product_id, product_name FROM Products
WHERE product_id not in (SELECT DISTINCT product_id FROM Reviews)

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
with orders_with_prev AS (
    SELECT 
        o.user_id, 
        u.username, 
        o.order_date, 
        LAG(o.order_date,1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) previous_order_date 
    FROM Orders o
        JOIN Users u
            ON o.user_id=u.user_id
        ORDER BY 1,3
    )
    SELECT 
        user_id, 
        username
    FROM orders_with_prev
    WHERE Cast((JulianDay(order_date) - JulianDay(previous_order_date)) As Integer) = 1
