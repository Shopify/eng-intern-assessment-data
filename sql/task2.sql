-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH AvgRatings AS (
    SELECT r.product_id, AVG(r.rating) AS average_rating
    FROM Reviews r
    GROUP BY r.product_id
)

SELECT p.product_id, p.product_name, ar.average_rating
FROM Products p
JOIN AvgRatings ar ON p.product_id = ar.product_id
ORDER BY ar.average_rating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM Users u
WHERE u.user_id IN (
    SELECT o.user_id
    FROM Orders o
    GROUP BY o.user_id
    HAVING COUNT(DISTINCT o.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH ConsecutiveOrders AS (
    SELECT o.user_id, o.order_date, 
    LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
    FROM Orders o
)

SELECT co.user_id, u.username
FROM ConsecutiveOrders co
JOIN Users u ON co.user_id = u.user_id
WHERE DATEDIFF(co.order_date, co.prev_order_date) = 1 OR co.prev_order_date IS NULL;
