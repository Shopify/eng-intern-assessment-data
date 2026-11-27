-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT TOP 1 p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p, Reviews r
WHERE p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username
FROM Users u, Orders o, Order_Items i, Products p
WHERE u.user_id = o.user_id
AND o.order_id = i.order_id
AND i.product_id = p.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories);
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_name = r.product_name
WHERE r.product_id IS NULL;
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT u.user_id, u.username
FROM Users u, Orders o1, Orders o2
WHERE u.user_id = o1.user_id
AND u.user_id = o2.user_id
AND DAY(o1.order_date) - DAY(o2.order_date) = 1
GROUP BY u.user_id, u.username;