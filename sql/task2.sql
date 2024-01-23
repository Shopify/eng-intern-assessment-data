-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AveragProductRating AS (
    SELECT
        Products.product_id,
        Products.product_name,
        AVG(Reviews.rating) AS average_rating
    FROM Products
    LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
    GROUP BY Products.product_id, Products.product_name
)

SELECT
    product_id,
    product_name,
    average_rating
FROM ProductAverageRating
ORDER BY average_rating DESC
LIMIT 5;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    Users.user_id,
    Users.username
FROM Users
WHERE Users.user_id IN (
    SELECT DISTINCT Users.user_id
    FROM Users U
    JOIN Orders O ON U.user_id = O.user_id
    JOIN Order_Items OI ON O.order_id = OI.order_id
    JOIN Products P ON OI.product_id = P.product_id
    JOIN Categories C ON P.category_id = C.category_id
    GROUP BY U.user_id, C.category_id
    HAVING
        COUNT(DISTINCT C.category_id) = (
            SELECT COUNT(*) AS category_count
            FROM Categories
        )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT 
    Products.product_id,
    Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH OrdersByDate AS(
    SELECT
        user_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS row_num
    FROM Orders
)

SELECT
    OBD.user_id,
    U.username
FROM OrdersByDate OBD
JOIN Users U on OBD.user_id = U.user_id
JOIN OrdersByDate OBD2 On OBD.user_id = OBD2.user_id AND OBD.row_num = OBD2.row_num - 1
WHERE DATEDIFF(OBD2.order_date, OBD.order_date) = 1;