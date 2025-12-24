-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

--Utilized CTEs, inner join, and Average/Max Functions to write this query.
WITH ProductRatings AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT P.product_id, P.product_name, PR.average_rating
FROM Products P
JOIN ProductRatings PR ON P.product_id = PR.product_id
WHERE PR.average_rating = (SELECT MAX(average_rating) FROM ProductRatings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

--Utlized inner join, the Count Function and the Distinct Keyword to write this query.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id 
JOIN Order_Items OI ON O.order_id = OI.order_id 
JOIN Products P ON OI.product_id = P.product_id
JOIN Categories C ON P.category_id = C.category_id
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT C.category_id) = (SELECT COUNT(*) FROM Categories)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

--Utilized left join and the IS NULL Keyword to write this query.
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN REVIEWS R ON P.product_id = R.product_id
WHERE R.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

--Utilized subqueries, inner join, and the DATEDIFF Function to write this query.
SELECT DISTINCT U.user_id, U.username
FROM (
    SELECT O.user_id, O.order_date, LAG(O.order_date) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS last_order_date
    FROM Orders O
) AS SubQuery
JOIN Users U ON SubQuery.user_id = U.user_id
WHERE DATEDIFF(SubQuery.order_date, SubQuery.last_order_date) = 1;