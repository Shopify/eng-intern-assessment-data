-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductRatings AS (
    SELECT P.product_id, P.product_name, AVG(R.rating) AS average_rating
    FROM Products P
    LEFT JOIN Reviews R ON P.product_id = R.product_id
    GROUP BY P.product_id, P.product_name
)
SELECT product_id, product_name, average_rating
FROM ProductRatings
ORDER BY average_rating DESC
LIMIT 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH UserOrdersPerCategory AS (
    SELECT U.user_id, U.username, C.category_id
    FROM Users U
    JOIN Orders O ON U.user_id = O.user_id
    JOIN Order_Items OI ON O.order_id = OI.order_id
    JOIN Products P ON OI.product_id = P.product_id
    JOIN Categories C ON P.category_id = C.category_id
    GROUP BY U.user_id, U.username, C.category_id
    HAVING COUNT(DISTINCT C.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories)
)
SELECT DISTINCT user_id, username
FROM UserOrdersPerCategory;


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT user_id, MIN(order_date) AS start_date, MAX(order_date) AS end_date
    FROM Orders
    GROUP BY user_id
    HAVING COUNT(DISTINCT order_date) = COUNT(DISTINCT DATE_ADD(order_date, INTERVAL 1 DAY))
)
SELECT U.user_id, U.username
FROM Users U
JOIN UserConsecutiveOrders UCO ON U.user_id = UCO.user_id;
