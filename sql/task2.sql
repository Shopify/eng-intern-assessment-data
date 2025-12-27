-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH R AS
    (SELECT product_id, AVG(rating) as average_rating
    FROM Reviews
    GROUP BY product_id)
SELECT
    P.product_id, P.product_name, R.average_rating
FROM 
    Products as P
JOIN 
    R
ON 
    P.product_id = R.product_id
WHERE
    R.average_rating = (select max(average_rating) from R);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
WITH UserOrderCategories AS (
    SELECT U.user_id, C.category_id
    FROM Users U
    JOIN Orders O ON U.user_id = O.user_id
    JOIN Order_Items OI ON O.order_id = OI.order_id
    JOIN Products P ON OI.product_id = P.product_id
    JOIN Categories C ON P.category_id = C.category_id
    GROUP BY U.user_id, C.category_id
)

SELECT 
    UOC.user_id, U.username
FROM
    Users U
JOIN 
    UserOrderCategories UOC ON U.user_id = UOC.user_id
GROUP BY 
    UOC.user_id, U.username
HAVING 
    COUNT(DISTINCT UOC.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL OR R.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH UserOrderDates AS (
    SELECT
        user_id,
        order_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)

SELECT DISTINCT UOD.user_id, U.username
FROM UserOrderDates UOD
JOIN Users U ON UOD.user_id = U.user_id
WHERE UOD.prev_order_date = DATE_ADD(UOD.order_date, INTERVAL -1 DAY);
