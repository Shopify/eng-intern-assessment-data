-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductAvgRating AS (
  SELECT 
    p.product_id, 
    p.product_name, 
    AVG(r.rating) AS avg_rating
  FROM Products p
  LEFT JOIN Reviews r ON p.product_id = r.product_id
  GROUP BY p.product_id, p.product_name
)
SELECT 
  product_id, 
  product_name, 
  avg_rating
FROM ProductAvgRating
ORDER BY avg_rating DESC
LIMIT 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
  u.user_id,
  u.username
FROM Users u
WHERE NOT EXISTS (
  SELECT c.category_id
  FROM Categories c
  WHERE NOT EXISTS (
    SELECT o.order_id
    FROM Orders o
    WHERE o.user_id = u.user_id AND EXISTS (
      SELECT oi.product_id
      FROM Order_Items oi
      JOIN Products p ON oi.product_id = p.product_id
      WHERE p.category_id = c.category_id
    )
  )
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT 
  p.product_id, 
  p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH ConsecutiveOrders AS (
  SELECT 
    user_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM Orders
)
SELECT DISTINCT
  user_id,
  username
FROM ConsecutiveOrders co
JOIN Users u ON co.user_id = u.user_id
WHERE prev_order_date = DATEADD(day, -1, order_date);
