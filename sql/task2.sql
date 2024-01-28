-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- get the average rating for each product
WITH Average_ratings AS (
 SELECT P.product_id, P.product_name, ROUND(AVG(R.rating), 2) AS avg_rating
 FROM Products P
 JOIN Reviews R ON P.product_id = R.product_id
 GROUP BY P.product_id
)
-- get the top 5 products with the highest average rating
SELECT *
FROM Average_ratings
ORDER BY avg_rating DESC
LIMIT 5;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT U.user_id, U.username
FROM Users U
WHERE U.user_id IN (
    SELECT O.user_id
    FROM Orders O
    -- link up the user_id with category_id
    INNER JOIN Order_Items OI ON O.order_id = OI.order_id
    INNER JOIN Products P ON OI.product_id = P.product_id
    GROUP BY O.user_id, P.category_id

    -- get the users that have all categories_id's
    HAVING COUNT(DISTINCT P.category_id) = (
        SELECT COUNT(*) FROM Categories
    )
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT P.product_id, P.product_name
FROM Products P
JOIN Reviews R ON P.product_id = R.product_id
WHERE R.rating IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT U.user_id, U.username
FROM Users U
WHERE EXISTS (
 SELECT *
 FROM Orders O
 WHERE O.user_id = U.user_id
 AND EXISTS (
    SELECT *
    FROM Orders O_consecutive
    -- check if same user and if 2 consecutive orders exists
    WHERE O_consecutive.user_id = O.user_id    
    AND O_consecutive.order_date = O.order_date + INTERVAL '1 day'
 )
);