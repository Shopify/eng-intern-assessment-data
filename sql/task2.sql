-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH average_ratings AS (
  SELECT p.product_id, p.product_name, AVG(r.rating)
  FROM reviews r
  LEFT JOIN products p
  ON p.product_id = r.product_id
  GROUP BY p.product_id, p.product_name
  ORDER BY p.product_id
)
SELECT product_id, product_name, avg
FROM average_ratings
ORDER BY avg DESC
LIMIT 5

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN users u ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(distinct p.category_id) = (SELECT COUNT(*) FROM categories)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH orders_with_next_order AS (
  SELECT user_id, order_id, order_date, LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order
  FROM orders
)
SELECT DISTINCT o.user_id, u.username
FROM orders_with_next_order o
LEFT JOIN users u
ON u.user_id = o.user_id
WHERE next_order - order_date = 1