-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AvgRatings AS (
    SELECT product_id, AVG(rating) as avg_rating
    FROM review_data
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, ar.avg_rating
FROM product_data p
JOIN AvgRatings ar ON p.product_id = ar.product_id
ORDER BY ar.avg_rating DESC
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
JOIN order_items_data oi ON o.order_id = oi.order_id
JOIN product_data p ON oi.product_id = p.product_id
JOIN category_data c ON p.category_id = c.category_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM category_data);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM product_data p
LEFT JOIN review_data r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT ud.user_id, ud.username
FROM order_data o1
JOIN order_data o2 ON o1.user_id = o2.user_id AND o1.order_id <> o2.order_id
JOIN user_data ud ON o1.user_id = ud.user_id
WHERE ABS(julianday(o1.order_date) - julianday(o2.order_date)) = 1;
