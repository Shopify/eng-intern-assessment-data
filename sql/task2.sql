-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductRatings AS(
    SELECT product_id, AVG(rating) AS Average_Rating
    FROM Reviews
    GROUP BY product_id
)

SELECT p.product_id, p.product_name, pr.Average_Rating
FROM Products p
JOIN ProductRatings pr ON p.product_id = pr.product_id
WHERE pr.Average_Rating = (
    SELECT MAX(Average_Rating) FROM ProductRatings
)
ORDER BY pr.Average_Rating DESC;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.


WITH UserCategoryCounts AS (
    SELECT u.user_id, u.username, COUNT(DISTINCT p.category_id) AS category_count
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON p.product_id = oi.product_id
    GROUP BY u.user_id, u.username

)

SELECT ucc.user_id, uss.username
FROM UserCategoryCounts ucc
WHERE ucc.category_count = (SELECT COUNT(*) FROM Categories);



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


WITH OrderedOrders AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)

SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN OrderedOrders oo ON u.user_id = oo.user_id
WHERE oo.order_date = DATEADD(day, 1, oo.prev_order_date);