-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AvgRatings AS (
  SELECT
    p.product_id,
    p.product_name,
    AVG(r.rating) AS average_rating,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rating_rank
  FROM
    Products p
  LEFT JOIN
    Reviews r ON p.product_id = r.product_id
  GROUP BY
    p.product_id, p.product_name
)

SELECT product_id, product_name, average_rating
FROM AvgRatings
WHERE rating_rank = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username
FROM Users u
WHERE NOT EXISTS (
  SELECT DISTINCT category_id
  FROM Categories
  EXCEPT
  SELECT DISTINCT p.category_id
  FROM Products p
  JOIN Order_Items oi ON p.product_id = oi.product_id
  JOIN Orders o ON oi.order_id = o.order_id
  WHERE u.user_id = o.user_id
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
WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN UserConsecutiveOrders uco ON u.user_id = uco.user_id
WHERE DATEDIFF(day, uco.prev_order_date, uco.order_date) = 1
ORDER BY u.user_id;