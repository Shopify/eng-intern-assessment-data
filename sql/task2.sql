-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Problem 5 Solution
SELECT DISTINCT T1.product_id, T1.product_name, T1.avg_rating
FROM 
(SELECT P.product_id, P.product_name, AVG(rating) AS avg_rating         -- get the rating of each product
FROM Products P LEFT JOIN Reviews R 
ON P.product_id = R.product_id
GROUP BY P.product_id) AS T1
LEFT JOIN
(SELECT TOP 1 AVG(rating) AS highest_avg                                -- get the highest avg rating
FROM Products P LEFT JOIN Reviews R 
ON P.product_id = R.product_id
GROUP BY P.product_id
ORDER BY AVG(rating) DESC) AS T2
ON T1.avg_rating = T2.highest_avg;                                      -- get product id with highest avg

-- Problem 6 Solution
SELECT DISTINCT T3.user_id, U.username                                  -- Select user that has non-NULL entry after LEFT JOINs
FROM
(SELECT T2.category_id, T2.product_id, T2.order_id, O2.user_id          -- Join below relation with Orders relation
FROM
(SELECT T1.category_id, T1.product_id, O.order_id                       -- Join below relation with Order Items relation
FROM
(SELECT C.category_id, P.product_id                                     -- Join Categories and Products relations
FROM Categories C LEFT JOIN Products P
ON C.category_id = P.category_id) AS T1
LEFT JOIN Order_Items O 
ON T1.product_id = O.product_id) AS T2
LEFT JOIN Orders O2
ON T2.order_id = O2.order_id) AS T3 
LEFT JOIN Users U 
ON T3.user_id = U.user_id
WHERE U.user_id IS NOT NULL;

-- Problem 7 Solution
SELECT DISTINCT P.product_id, P.product_name                            
FROM Products P LEFT JOIN Reviews R 
ON P.product_id = R.product_id
WHERE R.review_id IS NULL;

-- Problem 8
SELECT DISTINCT T2.user_id, T2.user_name                                                                            -- Select users that have existing entries with date diff of 1
FROM
(SELECT T1.user_id, T1.user_name, DATEDIFF(day, T1.prev_date, T1.order_date) AS diff                                -- Calculate the date difference between curr date and prev date
FROM
(SELECT T.user_id, T.user_name, T.order_date, LAG(T.order_date) OVER (ORDER BY T.order_date ASC) AS prev_date       -- Get previous date and set as new column
FROM 
(SELECT U.user_id, U.username, O.order_date                                                                         -- Join by user id
FROM Users U INNER JOIN Orders O
ON U.user_id = O.user_id 
ORDER BY O.order_date ASC) AS T) AS T1) AS T2
WHERE T2.diff = 1;

