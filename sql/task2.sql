-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH RatingAverages AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, ra.average_rating
FROM Products AS p
JOIN RatingAverages AS ra ON p.product_id = ra.product_id
WHERE ra.average_rating = (SELECT MAX(average_rating) FROM RatingAverages);
-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username
FROM Users AS u
WHERE NOT EXISTS (
    SELECT category_id
    FROM Categories
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders AS o
        JOIN Order_Items AS oi ON o.order_id = oi.order_id
        JOIN Products AS p ON oi.product_id = p.product_id
        WHERE p.category_id = Categories.category_id AND o.user_id = u.user_id
    )
);
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM Products AS p
LEFT JOIN Reviews AS r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id
WHERE ABS(DATEDIFF(o1.order_date, o2.order_date)) = 1;