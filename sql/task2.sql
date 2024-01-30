-- TASK 2

-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING avg_rating = (SELECT MAX(avg_rating1) 
                     FROM (SELECT AVG(rating) AS avg_rating1 
                           FROM Reviews 
                           GROUP BY product_id) AS product_avg_ratings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT Users.user_id, Users.username
FROM Users
WHERE Users.user_id IN (SELECT DISTINCT u.user_id 
                        FROM Users u
                        JOIN Orders o ON u.user_id = o.user_id
                        JOIN Order_Items oi ON o.order_id = oi.order_id
                        JOIN Products p ON oi.product_id = p.product_id
                        GROUP BY u.user_id, p.category_id
                        HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

With ConsecutiveOrders AS (
SELECT user_id,
       order_date,
       LEAD(order_date, 1) OVER (ORDER BY order_id) as next_order_date,
       LEAD(user_id, 1) OVER (ORDER BY order_id) as next_user_id 
FROM Orders
)
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN ConsecutiveOrders co ON u.user_id = co.user_id
WHERE co.user_id = co.next_user_id AND co.next_order_date = DATE_ADD(co.order_date, INTERVAL 1 DAY);