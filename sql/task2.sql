-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH AverageRatings AS (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT P.product_id, P.product_name, AR.avg_rating
FROM Products P
JOIN AverageRatings AR ON P.product_id = AR.product_id
WHERE AR.avg_rating = (SELECT MAX(avg_rating) FROM AverageRatings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
GROUP BY U.user_id
HAVING COUNT(DISTINCT P.category_id) = (SELECT COUNT(*) FROM Categories);

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
WITH NextOrderDates AS (
	SELECT user_id, order_date, LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS following_order_date
	FROM Orders
)
SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN NextOrderDates ON Users.user_id = NextOrderDates.user_id
WHERE JULIANDAY(following_order_date) - JULIANDAY(order_date) = 1;

