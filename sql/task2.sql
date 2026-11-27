-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- same as solution in P3, but limiting to top 1 with ties
SELECT TOP 1 WITH TIES 
    R.product_id, 
    product_name, 
    AVG(rating) as average_rating
FROM Reviews R
LEFT JOIN Products P on R.product_id = P.product_id
GROUP BY R.product_id, product_name
ORDER BY average_rating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Join all tables needed to get total categories bought from and group on user_id/username
SELECT O.user_id, username
FROM Orders O
LEFT JOIN Order_items OI ON O.order_id = OI.order_id
LEFT JOIN Products P ON OI.product_id = P.product_id
LEFT JOIN Users U ON O.user_id = U.user_id
GROUP BY O.user_id, username
-- use subquery to filter on if categories bought by user matches total categories
Having COUNT(DISTINCT(category_id)) =
    (SELECT COUNT(category_name)
     FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- group on product_id in order to use the having function to check if the avg rating is null
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id, P.product_name
HAVING AVG(rating) IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- CTE with previous order date and previous date of current order
WITH order_updated AS (
SELECT
    O.user_id,
    order_date,
    LAG(order_date,1) OVER(PARTITION BY O.user_id ORDER BY order_date) AS prev_order,
    DATEADD(day,-1,order_date) as prev_date
FROM Orders O)

-- return all users that have a order within consecutive days
SELECT DISTINCT
	OU.user_id,
    username
FROM order_updated OU
LEFT JOIN Users U ON OU.user_id = U.user_id 
WHERE prev_order = prev_date 


