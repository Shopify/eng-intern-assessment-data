-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT p.product_id, p.product_name, AVG(r.rating) as average_rating
FROM product_data p
JOIN review_data r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) = (
  SELECT MAX(average_rating) 
  FROM (
    SELECT r.product_id, AVG(r.rating) as average_rating
    FROM review_data r
    GROUP BY r.product_id
    )
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o ON u.user_id = o.user_id
JOIN order_items_data oi ON o.order_id = oi.order_id
JOIN product_data p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (
  SELECT COUNT(DISTINCT c.category_id) 
  FROM category_data c
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM product_data p
JOIN review_data r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT u.user_id, u.username
FROM user_data u
JOIN order_data o1 ON u.user_id = o1.user_id 
JOIN order_data o2 ON o1.user_id = o2.user_id AND o2.order_date - o1.order_date = 1;