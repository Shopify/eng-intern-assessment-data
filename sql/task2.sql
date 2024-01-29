-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT r.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Reviews AS r
  INNER JOIN Products AS p
  ON r.product_id = p.product_id
GROUP BY r.product_id, p.product_name
ORDER BY average_rating DESC
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id
INNER JOIN Order_Items oi ON oi.order_id = o.order_id
INNER JOIN Products p ON p.product_id = oi.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (
  SELECT COUNT(*) FROM Categories
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON r.product_id = p.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH OrderedUsers AS (
  SELECT 
    u.user_id, 
    u.username,
    o.order_date,
    LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS previous_order_date
  FROM 
    Users u
  JOIN 
    Orders o ON u.user_id = o.user_id
)
SELECT DISTINCT
  user_id, 
  username
FROM 
  OrderedUsers
WHERE 
  order_date = previous_order_date + INTERVAL '1 day';
