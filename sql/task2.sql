-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Query built upon the answer for Problem 3
-- Created a Common Table Expression (CTE) named AVG_RATINGS
-- Calculated the average rating for each product by joining Reviews and Products tables in the Common table
-- LIMIT 1 isn't used because there can be multiple items with highest ratings.
WITH AVG_RATINGS AS (
    SELECT R.product_id, AVG(rating) AS avg_rating
	FROM Reviews R
	JOIN Products P ON R.product_id = P.product_id
	GROUP BY R.product_id
)
SELECT P.product_id, P.product_name, AR.avg_rating
FROM Products P
JOIN AVG_RATINGS AR ON P.product_id = AR.product_id
WHERE AR.avg_rating = (
    SELECT MAX(avg_rating)
    FROM AVG_RATINGS
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Inner join is applied on User, Order, OrderItems, and products table to finally get a connection between
-- user_id and category _id of the products ordered by the user. The result is grouped by user_id and filtered,
-- ie, having clause, filters users by those who have ordered items from all categories.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
GROUP BY U.user_id
HAVING COUNT(DISTINCT P.category_id) =
	(SELECT COUNT(DISTINCT category_id)
	FROM Categories
	);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Here, I've used LEFT JOIN to get all the products and joined with Reviews table. When joined, the products without
-- reviews will have NULL values in the columns derived from Review table. Hence, the check in WHERE clause works.
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Common Table Expression (CTE) named 'Dates' is created to store user_id, order_date, and the previous order_date
-- Main query selects distinct user_id and username from Users table, joined with the 'Dates' CTE using user_id
-- and filter users where the difference between order_date and previous_date is equal to 1 day
WITH Dates AS (
    SELECT user_id, order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date
    FROM Orders
)
SELECT DISTINCT U.user_id, U.username
FROM Users U
JOIN Dates OD ON U.user_id = OD.user_id
WHERE (order_date - previous_date) = 1;
