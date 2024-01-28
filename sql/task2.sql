-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

--Canidate's note:
--CTES is used to retrieve the table with the average rating for each product
WITH rating_by_avg AS
(
    SELECT P.product_id, P.product_name, Round(avg(R.rating),1) AS avg_rating
    From Products P
    LEFT JOIN Reviews R ON P.product_id = R.product_id
    GROUP BY P.product_id
)
--then the table is filtered to retrieve the products with the highest average rating
SELECT product_id, product_name, avg_rating
FROM rating_by_avg
WHERE avg_rating = (SELECT MAX(avg_rating) FROM rating_by_avg);



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT U.user_id, U.username
From Users U
INNER JOIN Orders O ON U.user_id = O.user_id
INNER JOIN Order_Items OI ON O.order_id = OI.order_id
INNER JOIN Products P ON OI.product_id = P.product_id
GROUP BY U.user_id
HAVING COUNT(DISTINCT P.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

--Canidate's note:
--LEFT JOIN is used to retrieve all the products even if they have no reviews
--if the product has no reviews, the review_id will be NULL
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NOT NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


--Canidate's note:
--window functions is used to retrieve the previous order date for each order
--LEFT JOIN is used to only get user data for the users who made order
--DISTINCT is used to remove duplicate users

SELECT DISTINCT O_with_previous.user_id AS user_id, U.username AS username
FROM 
(
    SELECT O.user_id, O.order_date,  
    LAG(O.order_date, 1) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS previous_order_date
    FROM Orders O
)  O_with_previous
LEFT JOIN Users U ON O_with_previous.user_id = U.user_id
WHERE O_with_previous.order_date = (O_with_previous.previous_order_date + INTERVAL '1 DAY');