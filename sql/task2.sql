-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- NOTE FROM THE POTENTIAL INTERN:
-- The CTE ProductRatings computes the average rating for each product
-- The main query then joins the Products table with the ProductRatings CTE.
-- The WHERE clause in the main query filters out the prodcuts to only include those 
-- with the highest average rating.

WITH ProductRatings AS (
    SELECT 
        product_id, 
        AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT P.product_id, P.product_name, PR.average_rating
FROM Products P
JOIN ProductRatings PR ON P.product_id = PR.product_id
WHERE PR.average_rating = (
    SELECT MAX(average_rating)
    FROM ProductRatings
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- NOTE FROM THE POTENTIAL INTERN:
-- There's not a user who has made at least one order in each category.
-- There's at least 49 cateogries, 
-- and the max users that has made an order is up to only two categories.

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

SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- NOTE FROM THE POTENTIAL INTERN:
-- There's no consecutive orders from looking at the data.

SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username
HAVING COUNT(O.order_id) > 1;
