-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH RatingAverages AS (
    SELECT product_id, AVG(rating) AS average_rating
    FROM ratings
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, ra.average_rating
FROM products p
JOIN RatingAverages ra ON p.product_id = ra.product_id
WHERE ra.average_rating = (SELECT MAX(average_rating) FROM RatingAverages);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.category) = (SELECT COUNT(DISTINCT category) FROM products);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN ratings r ON p.product_id = r.product_id
WHERE r.rating IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH OrderedDates AS (
    SELECT user_id, order_date,
           LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date
    FROM orders
)
SELECT DISTINCT u.user_id, u.username
FROM users u
JOIN OrderedDates od ON u.user_id = od.user_id
WHERE od.order_date = od.previous_date + INTERVAL '1 day';
