-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT
    P.product_id,
    P.product_name,
    AVG(R.rating) AS avg_rating
FROM 
    Products P
    JOIN Reviews R ON P.product_id = R.product_id
GROUP BY
    P.product_id
ORDER BY
    avg_rating DESC 
LIMIT 5; -- change to select how many of the top n you would like


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    U.user_id,
    U.username
FROM
    Orders O,
    Users U
WHERE
    U.user_id IN (SELECT O.user_id) -- select users where their user ID is present in the orders table, ie they have made at least 1 order
GROUP BY
    U.user_id;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    P.product_id,
    P.product_name
FROM
    Products P
    INNER JOIN Reviews R ON R.product_id = P.product_id
WHERE P.product_id NOT IN (
    SELECT R.user_id FROM Reviews
)
GROUP BY
    P.product_id;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT
    U.user_id,
    U.username
FROM
    Users U
    JOIN Orders O1 ON U.user_id = O1.user_id
    JOIN Orders O2 ON U.user_id = O2.user_id AND O1.order_date = DATE_ADD(O2.order_date, INTERVAL 1 DAY)


