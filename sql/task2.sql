-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT P.product_id, P.product_name, AVG(R.rating) AS average_rating
FROM Products P
JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id, P.product_name
HAVING AVG(R.rating) = (
    SELECT MAX(avg_rating)
    FROM (
        SELECT AVG(rating) AS avg_rating
        FROM Reviews
        GROUP BY product_id
    )
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
-- Was a little confused as testing was returning 0 rows but after iterating over the question 
-- several times and looking at the data again, it seems to be asking for users who have made 
-- at least one order in all 50 categories and the result for that is indeed none.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT P.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
-- After going over the data again this one should also return no rows since
-- the first 16 products have a review
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
-- Tested this by adding an order to a user for a consecutive day and it worked otherwise returns no rows.
SELECT DISTINCT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN (
    SELECT user_id, order_date,
           LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_order_date
    FROM Orders
) AS SubO ON U.user_id = SubO.user_id
WHERE DATE(SubO.order_date) = DATE(SubO.previous_order_date, '+1 day');
