-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT CAST(p.product_id AS INT) AS 'product ID', p.product_name AS 'product name', r.rating AS 'average rating' 
FROM product_data p 
JOIN review_data r ON p.product_id = r.product_id 
WHERE r.rating = (SELECT MAX(rating) FROM review_data)

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT CAST(u.user_id AS INT) AS 'user ID', u.username AS 'username'
FROM user_data u 
JOIN order_items_data o ON u.user_id = o.order_id 
JOIN product_data p ON o.product_id = p.product_id 
GROUP BY u.user_id, u.username 
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT category_id) FROM product_data)


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT CAST(p.product_id AS INT) AS 'product ID', p.product_name AS 'product name' 
FROM product_data p 
LEFT JOIN review_data r ON p.product_id = r.product_id 
WHERE r.review_id IS NULL

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT CAST(u.user_id AS INT) AS 'user ID', u.username AS 'username' 
FROM user_data u 
JOIN order_data o1 ON u.user_id = o1.user_id 
JOIN order_data o2 ON u.user_id = o2.user_id 
WHERE DATE(o1.order_date) = DATE(julianday(o2.order_date) + 1) 
OR DATE(o1.order_date) = DATE(julianday(o2.order_date) - 1)