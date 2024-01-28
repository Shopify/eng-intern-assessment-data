-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.


-- Note
-- Approach: re using problem 3 solution as a CTE here 
-- Assumption: resulting a table with avergae ratings sorted descendingly 
-- Alternative: if we want, the top N, we could include LIMIT N

WITH avergae_product_ratings AS (
    SELECT
       Products.product_id,
       product_name,
       AVG(rating) AS avergage_rating
    FROM Products
    LEFT JOIN Reviews USING(product_id)
)

SELECT *
FROM average_product_ratings 
ORDER BY avergae_rating DESC

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Note
-- Approach: setting up a CTE at the user-category grain
-- This is favorable as it can be modified easily if the criteria changes for more than one order.

-- Getting total orders at the user - category grain
WITH user_category_orders AS (
    SELECT
      Users.user_id,
      user_name,
      category_id,
      COUNT(order_id) AS total_orders
    FROM Users
    INNER JOIN Order_Items USING(order_id)
    INNER JOIN Products USING(product_id)
    INNER JOIN Categories USING(category_id)
    GROUP BY 1, 2, 3
)

-- Getting users that have at least one order in all categories
SELECT
  user_id,
  user_name
FROM user_category_orders
WHERE total_orders > 0
GROUP BY 1, 2
HAVING COUNT(category_id) = (SELECT COUNT(category_id) FROM Categories)


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Note
-- Approach: Using a left join and keeping products that are not in the reviews table.

SELECT
    Products.product_id,
    product_name
FROM Products
LEFT JOIN Reviews USING(product_id)
WHERE Reviews.product_id IS NULL


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Note
-- Assumption: Looking for users with orders on consecutive days 
-- Approach: We start by looking for a user's order data and next order date
-- We collect users where the minimum difference between and order and next order is 1 day

-- Computing next order date for each order 
WITH user_order_dates AS (
    SELECT
      user_id,
      order_id,
      order_date,
      LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM Orders
),

-- Getting users that placed an order the next day
next_day_order_users AS (
    SELECT user_id
    FROM user_order_dates
    WHERE
      next_order_date IS NOT NULL
      AND DATEDIFF(DAY, order_date, next_order_date) = 1
    GROUP BY 1
)

-- Joining with the users table to get the username
SELECT 
  next_day_order_users.user_id,
  username
FROM next_day_order_users
JOIN Users USING(user_id)