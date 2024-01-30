-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Define a Common Table Expression (CTE) named 'AverageRatings'
WITH AverageRatings AS (
  SELECT product_id, AVG(rating) as avg_rating
  FROM Reviews
  GROUP BY product_id -- Group the results by product_id to ensure average is calculated per product
)
SELECT p.product_id, p.product_name, ar.avg_rating
FROM Products p
JOIN AverageRatings ar ON p.product_id = ar.product_id
WHERE ar.avg_rating = (SELECT MAX(avg_rating) FROM AverageRatings);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM Users u
-- Check for users who have made at least one order in every category
WHERE NOT EXISTS (
  -- For each category, check if the user has made an order
  SELECT c.category_id
  FROM Categories c
  WHERE NOT EXISTS (
    -- For each order, check if it includes a product from the current category
    SELECT o.order_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE p.category_id = c.category_id AND o.user_id = u.user_id
  )
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

-- Define a Common Table Expression (CTE) named 'OrderedUsers'
WITH OrderedUsers AS (
    -- Use the LAG() window function to get the previous order date for each user
    SELECT o.user_id, o.order_date, 
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
    FROM Orders o
)
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN OrderedUsers ou ON u.user_id = ou.user_id
WHERE ou.order_date = DATE_ADD(ou.prev_order_date, INTERVAL 1 DAY); -- Filter for orders that are one day apart


