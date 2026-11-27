-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT p.product_id, p.product_name, avg(r.rating) FROM products p
INNER JOIN reviews r on p.product_id = r.product_id
GROUP BY p.product_id, p.product_name ORDER BY avg(r.rating) DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username FROM users u
INNER JOIN orders o on u.user_id = o.user_id
INNER JOIN order_items oi on oi.order_id=o.order_id
INNER JOIN products p on p.product_id=oi.product_id
WHERE oi.quantity>0
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT c.category_id) FROM categories c);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name FROM products p
LEFT JOIN reviews r on p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING count(r.review_id) = 0;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

--?????