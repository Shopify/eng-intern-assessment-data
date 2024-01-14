-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductAvgRatingTable AS ( -- CTE to get average rating for each product
  SELECT product_id, AVG(rating) AS avg_rating
  FROM Reviews
  GROUP BY product_id
)
SELECT p.product_id, p.product_name, ProductAvgRatingTable.avg_rating
FROM Products p
LEFT JOIN ProductAvgRatingTable
ON p.product_id = ProductAvgRatingTable.product_id
WHERE ProductAvgRatingTable.avg_rating = (  -- Get the max average rating
  SELECT MAX(avg_rating)
  FROM ProductAvgRatingTable
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Join all tables together and group by user_id and username
SELECT u.user_id, u.username
FROM Users u
INNER JOIN Orders o
ON u.user_id = o.user_id
INNER JOIN Order_Items oi
ON o.order_id = oi.order_id
INNER JOIN Products p
ON oi.product_id = p.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = ( -- check if the user has made at least one order in each category
  SELECT COUNT(DISTINCT category_id)
  FROM Categories
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Use a subquery to get the product_ids that have received reviews
SELECT p.product_id, p.product_name
FROM Products p
WHERE p.product_id NOT IN (
  SELECT product_id
  FROM Reviews
);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem. 

WITH cte AS ( -- CTE to get the previous order date for each order
  SELECT u.user_id, u.username, o.order_date,  
         LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_order_date  -- use window function to get the previous order date
  FROM Users u
  JOIN Orders o ON u.user_id = o.user_id
)
SELECT DISTINCT user_id, username
FROM cte
WHERE order_date = prev_order_date + INTERVAL '1 day'