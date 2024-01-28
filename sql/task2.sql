-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH avg_ratings AS (
    SELECT product_id, product_name, avg(rating) as avg_rating
    FROM Reviews NATURAL JOIN Products
    GROUP BY product_id, product_name
)

SELECT product_id, product_name, avg_rating
FROM avg_ratings
WHERE avg_rating >= ALL (
    SELECT avg_rating
    FROM avg_ratings
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT user_id, username, COUNT(DISTINCT category_id)
FROM Users NATURAL JOIN Orders NATURAL JOIN Order_Items NATURAL JOIN Products p
GROUP BY user_id, username
HAVING COUNT(DISTINCT p.category_id) = (
    SELECT COUNT(DISTINCT c.category_id)
    FROM Categories c
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.